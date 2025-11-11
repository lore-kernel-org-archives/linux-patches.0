Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2562E1F5F6;
	Tue, 11 Nov 2025 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823005; cv=none; b=eRKf30irIzX0GUdP4CsnrpAG5HeF+ytWbkDXIeIFyJBQrxx3ePDgm9ufZGYMTOgL9NQPTXB9781dkL6UBv3fy87vQj9VIjQoIQg23eO9xR1z6hbCf0ZKJf9gV4iamlrEYgQqjs/42j5vzG5PczEuCkJiH7HLphJ6KX7cOVSCnGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823005; c=relaxed/simple;
	bh=YvXiwM6FGBqPPbW/RQ3Bouz2gzRL9AU5xqbMu7SeSOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXtkH1lhz/o2c5/1mYG2FB4a9I2ukGH9y6NBPuVsZvJ80z+ZAz2nbpxRs862F2ZFDrdnPyjUP5vq66kMTO86rMnFbyVJElKzxyJ55z+ooeewJPVq9A7g6Is8oBOvrznHoE+vOMvWVigQfsPoDm4/7U/+82P9Z6iIDoGTqN2oNUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtGAfn7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtGAfn7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2613FC2BC87;
	Tue, 11 Nov 2025 01:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823004;
	bh=YvXiwM6FGBqPPbW/RQ3Bouz2gzRL9AU5xqbMu7SeSOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtGAfn7HWzG5yxrm90q2VzbFKMZKuZ0huefjvwwf82/XZ1ESNyVYWBdhrMUQDUV1d
	 kL2xeoiyj1nlHiGeYKe3bT5jt0+SDGJ9A2mkzy1XwATGPeKWHmIgB1VWZMT1YT/7EB
	 a3+Gc7pKUGH6YHPh8dTKiSsFo5z5T9P+VmeaScqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Stephen Howell <howels@allthatwemight.be>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/565] clocksource/drivers/timer-rtl-otto: Do not interfere with interrupts
Date: Tue, 11 Nov 2025 09:40:09 +0900
Message-ID: <20251111004530.381195347@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit c445bffbf28f721e05d0ce06895045fc62aaff7c ]

During normal operation the timers are reprogrammed including an
interrupt acknowledgement. This has no effect as the whole timer
is setup from scratch afterwards. Especially in an interrupt this
has already been done by rttm_timer_interrupt().

Change the behaviour as follows:

- Use rttm_disable_timer() during reprogramming
- Keep rttm_stop_timer() for all other use cases.

Downstream has already tested and confirmed a patch. See
https://github.com/openwrt/openwrt/pull/19468
https://forum.openwrt.org/t/support-for-rtl838x-based-managed-switches/57875/3788

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Stephen Howell <howels@allthatwemight.be>
Tested-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20250804080328.2609287-4-markus.stockhausen@gmx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-rtl-otto.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-rtl-otto.c b/drivers/clocksource/timer-rtl-otto.c
index 8be45a11fb8b6..24c4aa6a30131 100644
--- a/drivers/clocksource/timer-rtl-otto.c
+++ b/drivers/clocksource/timer-rtl-otto.c
@@ -147,7 +147,7 @@ static int rttm_next_event(unsigned long delta, struct clock_event_device *clkev
 
 	RTTM_DEBUG(to->of_base.base);
 	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_COUNTER);
-	rttm_stop_timer(to->of_base.base);
+	rttm_disable_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, delta);
 	rttm_start_timer(to, RTTM_CTRL_COUNTER);
 
@@ -160,7 +160,7 @@ static int rttm_state_oneshot(struct clock_event_device *clkevt)
 
 	RTTM_DEBUG(to->of_base.base);
 	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_COUNTER);
-	rttm_stop_timer(to->of_base.base);
+	rttm_disable_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, RTTM_TICKS_PER_SEC / HZ);
 	rttm_start_timer(to, RTTM_CTRL_COUNTER);
 
@@ -173,7 +173,7 @@ static int rttm_state_periodic(struct clock_event_device *clkevt)
 
 	RTTM_DEBUG(to->of_base.base);
 	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_TIMER);
-	rttm_stop_timer(to->of_base.base);
+	rttm_disable_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, RTTM_TICKS_PER_SEC / HZ);
 	rttm_start_timer(to, RTTM_CTRL_TIMER);
 
-- 
2.51.0



