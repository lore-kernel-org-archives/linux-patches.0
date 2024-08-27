Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE01CFEC6;
	Tue, 27 Aug 2024 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772667; cv=none; b=YHuPGQeWWgjNtCuzqPE9HT3kqnc1nmebIMnxwA3WSZiMGTmJA/rKC1GuDZe2vzl57sB3xSgrg4Gk5xd9/cB+347ZpzbLmODPWLNYZxWNX6DAwVzI4vKyDT0faUbzDh7cQ0/+B0/TqlKEDNlTYnJXlbxXdjQpG+T2Wx8NQFdlKYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772667; c=relaxed/simple;
	bh=4gxgVft50Ex2eviS12QxHOIg2mZUN0+X3vfu7DORWS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sE3ysgpTk17mjXY0eoAUDEhfEob+ghJLNQaad7aGUM9V7xpW19WHIDacfUm53f1cBwyemVkEclHQGxMaFJ7+zz1cSqBUoxA9ug+Y4kKi3SRq3tcn1JhxNTsIrSZHUSrq5oYIzZel8jDUp/PDCZXcU1Lj8rIvWU0yqhKsuexdDWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyBZZrkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyBZZrkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DFFC4DDE9;
	Tue, 27 Aug 2024 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772667;
	bh=4gxgVft50Ex2eviS12QxHOIg2mZUN0+X3vfu7DORWS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyBZZrkFKVlxKMxcPInEXr8H+T8MV3nDkznMDnTwyaEcSkbojX1sq7g7R3BvOijQF
	 b8h6r83wJ4p5Kr3Mgr4DoEaPqi1djI827iItAfMP1xTgWHnDZ7dzOvi6XgfzFMBDWR
	 gd1+pY/Q6nxvOzWb84Edl/rXvBonNkS7fatWz5/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 284/321] ALSA: timer: Relax start tick time check for slave timer elements
Date: Tue, 27 Aug 2024 16:39:52 +0200
Message-ID: <20240827143849.059514139@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
@@ -556,7 +556,7 @@ static int snd_timer_start1(struct snd_t
 	/* check the actual time for the start tick;
 	 * bail out as error if it's way too low (< 100us)
 	 */
-	if (start) {
+	if (start && !(timer->hw.flags & SNDRV_TIMER_HW_SLAVE)) {
 		if ((u64)snd_timer_hw_resolution(timer) * ticks < 100000) {
 			result = -EINVAL;
 			goto unlock;


