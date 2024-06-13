Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D674023A0;
	Thu, 13 Jun 2024 12:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282604; cv=none; b=YDN6aP/KQqt/ay6luTTN6g3bD1eElW2YE70BTXusNcZMJDpzh/y42HIglZnki4L1fUgJ88a/pAOJXDvtl4Cyxx49WUmwVEiqyjFBje8TcsQzDVteZcng4l1ppdwsKS3G6vjvPwwVEw60xGFfj595M6u5qMvWticLXjIhyciZ3EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282604; c=relaxed/simple;
	bh=kVSqC49f0UVNALcQxZnoxcFgNDl3noUriRgJ8EUIH4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDZZb7gBMEPQc+v7XH69/ITDSdjQjKJsCZE60XImMFLCT9rPWI03jHTbAKQRlNaZKR/f6CaFjzd0ST4Bo1cbmftan+c/Ll52hDdejGcM1Vph4z2x7Zfmg4F44k51eJmrQxiOlv3Oj7Svv3bWU4YCf9a/IuDejGg+SbspFjZLnPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXin0gFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXin0gFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D893C2BBFC;
	Thu, 13 Jun 2024 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282604;
	bh=kVSqC49f0UVNALcQxZnoxcFgNDl3noUriRgJ8EUIH4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXin0gFHNnZ/8j/jk7ZBphxIKJgZh9aqn2dCKqnRzkEC2DkerCE4A36Kfv6HCuhpO
	 gEe2slMOlo1mP/N8zflHlvKk5B7QIrbQNDlv3v5FIo+TimJ1ECG2eSQzBdh+ED4CCG
	 uTymcOUYqeHjGHHgc/bT+CXf0T3tkKbBZ9977SXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+43120c2af6ca2938cc38@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 334/402] ALSA: timer: Set lower bound of start tick time
Date: Thu, 13 Jun 2024 13:34:51 +0200
Message-ID: <20240613113315.165696147@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4a63bd179fa8d3fcc44a0d9d71d941ddd62f0c4e upstream.

Currently ALSA timer doesn't have the lower limit of the start tick
time, and it allows a very small size, e.g. 1 tick with 1ns resolution
for hrtimer.  Such a situation may lead to an unexpected RCU stall,
where  the callback repeatedly queuing the expire update, as reported
by fuzzer.

This patch introduces a sanity check of the timer start tick time, so
that the system returns an error when a too small start size is set.
As of this patch, the lower limit is hard-coded to 100us, which is
small enough but can still work somehow.

Reported-by: syzbot+43120c2af6ca2938cc38@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/000000000000fa00a1061740ab6d@google.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240514182745.4015-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ backport note: the error handling is changed, as the original commit
  is based on the recent cleanup with guard() in commit beb45974dd49
  -- tiwai ]
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -553,6 +553,16 @@ static int snd_timer_start1(struct snd_t
 		goto unlock;
 	}
 
+	/* check the actual time for the start tick;
+	 * bail out as error if it's way too low (< 100us)
+	 */
+	if (start) {
+		if ((u64)snd_timer_hw_resolution(timer) * ticks < 100000) {
+			result = -EINVAL;
+			goto unlock;
+		}
+	}
+
 	if (start)
 		timeri->ticks = timeri->cticks = ticks;
 	else if (!timeri->cticks)


