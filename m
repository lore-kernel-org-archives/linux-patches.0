Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AF0188A0C;
	Fri, 15 Nov 2024 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652930; cv=none; b=VXCJkJ8CtNjk/9lVeTGGgJOk8Czi9pVqlloK5HvwbyeWisEdEsf++1tZaJpTg5cyxbJDHa8N/2ySNR6uBDCXZT1SOyjI7uXU8wZqNcZ+wXEqPtiSCRGDUTfHjBQJBGPa40EWbsMyNwBppVewpDlL5D7qpfrPMXlf/12o1LCU9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652930; c=relaxed/simple;
	bh=xtvLaWnpE2XOaCWOHrIRKYSPR8L7vis9DV6sUSvEr4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzDIytkOMn9sz4wituxbEzVHmLIICWgQBIFCM6TfScrbiMdPPsBbYsMu/vDkZdL2jlp/PmGkfH9fMenkeNLLHT12AOE3xLVM/7A7dZfO41A+KPEQrkTV59FOwsh2+yNNBBMHyIhKvyMlAl+3BCFmSPJc+Yk1ZCFlA+jl7eAbokA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cn4TM/+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cn4TM/+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81276C4CECF;
	Fri, 15 Nov 2024 06:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652930;
	bh=xtvLaWnpE2XOaCWOHrIRKYSPR8L7vis9DV6sUSvEr4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cn4TM/+x5Osw5Zs82wLrUfuJRofBM1z+jYfqbyLexJ6S6dFw5WmHZty08Jgz+i/OP
	 lvs2xFdpCzzOICVI9+z+naVylsg+MBw+g88nyifv4JDXudkq6ja989r93SoP0QQc/w
	 AZ9B/YiaB9UWiA6u3cdqtN1Ba/FnOfSu5rDMpnO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Biehl Pasquali <pasqualirb@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/52] ALSA: pcm: Return 0 when size < start_threshold in capture
Date: Fri, 15 Nov 2024 07:37:51 +0100
Message-ID: <20241115063724.232898702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Biehl Pasquali <pasqualirb@gmail.com>

[ Upstream commit 62ba568f7aef4beb0eda945a2b2a91b7a2b8f215 ]

In __snd_pcm_lib_xfer(), when capture, if state is PREPARED
and size is less than start_threshold nothing can be done.
As there is no error, 0 is returned.

Signed-off-by: Ricardo Biehl Pasquali <pasqualirb@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4413665dd6c5 ("ALSA: usb-audio: Add quirks for Dell WD19 dock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index c376471cf760f..463c04e82558b 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2178,11 +2178,16 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 		goto _end_unlock;
 
 	if (!is_playback &&
-	    runtime->status->state == SNDRV_PCM_STATE_PREPARED &&
-	    size >= runtime->start_threshold) {
-		err = snd_pcm_start(substream);
-		if (err < 0)
+	    runtime->status->state == SNDRV_PCM_STATE_PREPARED) {
+		if (size >= runtime->start_threshold) {
+			err = snd_pcm_start(substream);
+			if (err < 0)
+				goto _end_unlock;
+		} else {
+			/* nothing to do */
+			err = 0;
 			goto _end_unlock;
+		}
 	}
 
 	runtime->twake = runtime->control->avail_min ? : 1;
-- 
2.43.0



