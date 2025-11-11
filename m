Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7DA1F5F6;
	Tue, 11 Nov 2025 01:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822951; cv=none; b=IvTbKnWB7BMF0P/77lIPQKr1Hso1Oul5bnek39bF5h0Och/Cdpbn/XxfrZbJHH2zzo2TyxGL9n5NDyHRvVjrsCMwAQpWeGZhl0qAh5QXgAabrRrcNKjjAVFCWTrUQRwLl81EqjjxZojTCkyZfq9YD/8VbW9ECDrpZ/8wESH4+RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822951; c=relaxed/simple;
	bh=Unj/YnesyoOWGbTcmT5YKWoVcfHWuh5mKxIptjBXRio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tU/YbRPO9P8F2JCIH5uvP5qU3XcIbVj3hzR08oK88EStxAcZyIx8GUhZ5K+TdTyx/8auenupyx6tX7VHwMTY8XDAUJao2qbuEPx31Ahd6cjvPzVpn8MornxcIkHghfeHGqx+cu7zwoDxKk2xWyM9+/MqimvDDRc2yv7XSkqViEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJIMx2hV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJIMx2hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B34CC116B1;
	Tue, 11 Nov 2025 01:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822950;
	bh=Unj/YnesyoOWGbTcmT5YKWoVcfHWuh5mKxIptjBXRio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJIMx2hVfZ6vxmtF8yq3trpgvN6EfaF+oqd92GmuxacIEbdfqalUddSWINLCXuKCo
	 8ZsuHBgNN412d9xrQLiKkfWnTUTNObPzEFxgOUeXcLuBLYjG4ZEpnlKGMTnLoOIkv9
	 o09VnQVtvp5UEMQvqucpMktNkwEIoK3TbOkjU4Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Stephen Howell <howels@allthatwemight.be>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 202/849] clocksource/drivers/timer-rtl-otto: Do not interfere with interrupts
Date: Tue, 11 Nov 2025 09:36:12 +0900
Message-ID: <20251111004541.322323586@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



