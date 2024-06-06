Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358E7197532;
	Thu,  6 Jun 2024 14:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683664; cv=none; b=hPOPKvsJcw0mMi+iUPWfFpZoZBKE5SnXcRzMdAg7+/wmRx/BSoELWiOLtGIjUOO4NU6WyUedQC8EsK8y8Z8QbO+uwVR0gX3o++Q1LWi4Luqij5fE53Ef3zeAb5tiOmZ+gT02JV+LeKQQiM1tbP6ETdje/m1tle68Peu0Jk2GHvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683664; c=relaxed/simple;
	bh=1hnuu5znUg7Jy9OwFfYYrwyGcDJ4BqJRBWZnxL2Jpvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+igVgy2pVzzIVwsTtYrV3Hk5U6M1H7fdIhIu/IhDHXc3wK3XDf3vG+EqR8RAl0bq2y0+I4859Nwz7bMcZ/aJI3BI4LDKme2xATy39RwTtzvT6ugPEehZ+d+le4T4KayM5UKXqTjDogR1KlUR0oYZToCLptDoiSuOJtt1W85xPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGFOvMa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGFOvMa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D9DC2BD10;
	Thu,  6 Jun 2024 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683664;
	bh=1hnuu5znUg7Jy9OwFfYYrwyGcDJ4BqJRBWZnxL2Jpvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGFOvMa67vYVWu0RvIRhtBlIBTx9drHoPMB8V1gpk3ESBONy7c+XnC71fQYcWL+Qy
	 SDPpidfMnQ7sWlLEiNMPWAaDxzLaOtfZUTun9LeHkwG4XMnlvD3EasC95gvabzV9Ka
	 B0gvxFsoqBjbgbj9P8+Wg6A9ucR6dQmn4vxvcaN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+43120c2af6ca2938cc38@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 473/473] ALSA: timer: Set lower bound of start tick time
Date: Thu,  6 Jun 2024 16:06:42 +0200
Message-ID: <20240606131715.316354845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


