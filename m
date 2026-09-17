Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F2649738A;
	Thu, 17 Sep 2026 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661266; cv=none; b=CpRiccO3NLGspNKEHJROjy84uDcxaAO1HZuQGTwua/dSBDtQH/JTzWcFrXFeLoXxxlR7ZiFxg5OuRgFeBnQ6Ep/qI2Ts5aEGuPpO5JTHbc299Ao5GlDApnPxENA03vmWGFbxsyxdhzaNrEqjXuh5sDJS39AeuIQadIQIkb+gY90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661266; c=relaxed/simple;
	bh=MFf3cAOnnivZtKSUBJOTP+Rli3DbLo+MyISpd2j0Lb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+1Sh3rKqQjXqei9Y4gltWNe70m0nrKpcoRFqjECJPAhrf0x7Z6ULMZRypwIfzOXX6AqGPFoV+zCI4eqQTyHIYW+Btkj56KNEnE2oX4KeyKBSPyGb+bcGVQRWjrbXfRsBMJ1S6c6hlHWArKSjsRZNyQnUQGfOBbfZe6awIHx3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdguydfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdguydfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5453C1F000FF;
	Thu, 17 Sep 2026 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661264;
	bh=OlwfRvqv0l1H6nbcl1l7JCVicywcYUZ0E+Md0b5w4B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdguydfOE9AzI71Ad7CYbihSBGIAfvtIJiV79Jl3N3edfy4yYta/Uf2Mc4OD19LLu
	 cQ4i5nEeGnrpRO7e+J+uiHEpZ8aa9W3ve0BhDWJg+3wfNIDJp/wJbRbPdjolOnclNY
	 4TTd/hQRPFir6RU8YVclqUHLfPQcyMDpvK6zKOss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0138/1250] ALSA: ice1724: Fix blocking open for independent surround PCMs
Date: Thu, 17 Sep 2026 15:58:53 +0100
Message-ID: <20260917151555.790650826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 1ab8e422dc779a91acba2d0aafc47b0db6680b4b ]

The independent surround playback open path rejects a substream when the
matching PDMA channel is reserved by the multi-channel PDMA0 stream. It
currently returns -EBUSY for that case, although the driver has carried a
FIXME noting that blocking mode is not handled properly.

ALSA PCM open waits and retries only when the low-level open callback
returns -EAGAIN. Returning -EBUSY therefore makes blocking opens fail
immediately, the same as nonblocking opens.

Return -EAGAIN for the temporary PDMA0 reservation conflict. The PCM core
continues to report -EBUSY for O_NONBLOCK callers, while blocking callers
sleep and retry.

Also wake the independent surround PCM wait queue when hw_free releases a
PDMA reservation. The reservation can be released by the pro PCM, while
waiters are sleeping on the independent surround PCM, so waking the current
substream PCM is not sufficient for this cross-PCM reservation.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260518-ice1724-blocking-open-v1-1-1bfa3e5aa7cf@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ice1712/ice1724.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 7efb0bbcea550..851e7afb58142 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -730,13 +730,22 @@ static int snd_vt1724_pcm_hw_params(struct snd_pcm_substream *substream,
 static int snd_vt1724_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
+	bool released = false;
 	int i;
 
-	guard(mutex)(&ice->open_mutex);
-	/* unmark surround channels */
-	for (i = 0; i < 3; i++)
-		if (ice->pcm_reserved[i] == substream)
+	scoped_guard(mutex, &ice->open_mutex) {
+		/* unmark surround channels */
+		for (i = 0; i < 3; i++) {
+			if (ice->pcm_reserved[i] != substream)
+				continue;
 			ice->pcm_reserved[i] = NULL;
+			released = true;
+		}
+	}
+
+	if (released && ice->pcm_ds)
+		wake_up(&ice->pcm_ds->open_wait);
+
 	return 0;
 }
 
@@ -1364,7 +1373,7 @@ static int snd_vt1724_playback_indep_open(struct snd_pcm_substream *substream)
 	scoped_guard(mutex, &ice->open_mutex) {
 		/* already used by PDMA0? */
 		if (ice->pcm_reserved[substream->number])
-			return -EBUSY; /* FIXME: should handle blocking mode properly */
+			return -EAGAIN;
 	}
 	runtime->private_data = (void *)&vt1724_playback_dma_regs[substream->number];
 	ice->playback_con_substream_ds[substream->number] = substream;
-- 
2.53.0



