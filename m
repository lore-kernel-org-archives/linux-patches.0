Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43EA2FB2;
	Tue, 27 Aug 2024 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770883; cv=none; b=X55QABQURl15PuORei0klCGAoxnOU/7tUcf+nQo/T+iBGp84Y0ZD2xQjWvyqC7l+RMgBmzVda0AyFNSIoGTvDTMNEBww2bTbCthlZPIEu9HqskAns5PIxZ7qsH9IZrzzC8pJ3pUIy4kz4+Ivh33OncfhuKl4uPuizxsgi70hf3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770883; c=relaxed/simple;
	bh=QYDQY3t21NfF099hwcsGk9Xmm0artxKpH1J5cqFiBGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiCYuLITFN+tlIc7eR5L8b0Ab9nx5kjGO6hiHIU2fEAGUN7ED9IEaRPRNYZ1qCgQxXQHx6cMrDJ+YdctHMEZQXkfHEKMPaxfZzDGc90ONR07ua83IzAeWbtR0babETGVWwb8JM8d0wE1KaMa0L2YmQxoHeVjPcB466qtmf7gCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgiuXlEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgiuXlEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BAAC4AF1C;
	Tue, 27 Aug 2024 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770883;
	bh=QYDQY3t21NfF099hwcsGk9Xmm0artxKpH1J5cqFiBGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgiuXlEl2FMxNZCbEF30lp7ontZizAoprkrTxQsjDPdBsUGFfjJYQQdfW27CLUHdA
	 2ELQNvTflTlZRVNX1hB3vAyAEtRVMUPGMoxwr18uTqDky2taz3XxXcfLyzUnSRhB+z
	 ox6D1giFU9CEzY6evAuQLFVB79nQbVXOYnSUzHAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 021/273] ALSA: timer: Relax start tick time check for slave timer elements
Date: Tue, 27 Aug 2024 16:35:45 +0200
Message-ID: <20240827143834.195026824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ccbfcac05866ebe6eb3bc6d07b51d4ed4fcde436 upstream.

The recent addition of a sanity check for a too low start tick time
seems breaking some applications that uses aloop with a certain slave
timer setup.  They may have the initial resolution 0, hence it's
treated as if it were a too low value.

Relax and skip the check for the slave timer instance for addressing
the regression.

Fixes: 4a63bd179fa8 ("ALSA: timer: Set lower bound of start tick time")
Cc: <stable@vger.kernel.org>
Link: https://github.com/raspberrypi/linux/issues/6294
Link: https://patch.msgid.link/20240810084833.10939-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -547,7 +547,7 @@ static int snd_timer_start1(struct snd_t
 	/* check the actual time for the start tick;
 	 * bail out as error if it's way too low (< 100us)
 	 */
-	if (start) {
+	if (start && !(timer->hw.flags & SNDRV_TIMER_HW_SLAVE)) {
 		if ((u64)snd_timer_hw_resolution(timer) * ticks < 100000)
 			return -EINVAL;
 	}


