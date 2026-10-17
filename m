Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2D83AF665;
	Sat, 17 Oct 2026 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255982; cv=none; b=m7w0VUwUMVB2aQ/e4iU0kWz2NVxD5sEh+vGBjQJY2Q4CKnz08jT/8pjltE7Kpw4TogNQU7o7Us05EzaFck1izYGcHz6jW94b6UdZ7sHx/gCf47zmxTNJAsUWXVwrTmtZPgAgxmlrJWP/TPzlGKqsmVQM9Hih72GHUhVC5orJFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255982; c=relaxed/simple;
	bh=Ju4f6/zJo7nvstPziG+45QWu8+n6ZMhJIacztWDq2rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKdtjtfNO/3/uVWhxQgOvoYAJDG9flHGfHMYfUyiEPRCVnXeoWKo+oW9KoehpNVCUZ7FxFCemOAL0fU3IW68f+zwBIxiu7iUBtsEtNwrQP2VC2h+qzGZQGEM/hH5ahvEh4rqAiwadm1mAJPbwZHvwO2240sXh4xl2j4dcUyghW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5nlxWwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5nlxWwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589441F000C4;
	Sat, 17 Oct 2026 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255980;
	bh=6WhaBi5n5z9EIJKOe7G/n4g8vdrxTBG7Ic2BnLl4Yt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5nlxWwkKOf5mKr793fn536/ntaxiFmKlzKjFyH+WCamiabDr89YwBtGcjr8dhyTT
	 bwkBNEfg66lQUytilAyZ9L3/9y9lQ7S6kiS2gw4InN9C8/SagKIqcwpzD7BwAGBMiN
	 ihM8PtpLmbkxSlSOuTyOvkfM9RnUPqS6SnBKHPBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0086/1674] rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm
Date: Sat, 17 Oct 2026 17:39:18 +0200
Message-ID: <20261017160433.344026945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 457b5dbce31209e65e1184716ed3af59cb1c0372 ]

RZN1_RTC_ALW is a weekday bitmask where bit N represents weekday N.
When no alarm has been configured, the register has its power-on-reset
value of zero.

rzn1_rtc_read_alarm() uses fls() to convert the weekday bitmask into a
weekday number. When RZN1_RTC_ALW is zero, fls(0) returns zero and
fls(wday) - 1 evaluates to -1. This invalid weekday is then used to
calculate the alarm date and can either leave tm_wday set to -1 or
produce a fabricated alarm date.

Treat a zero RZN1_RTC_ALW value as an unset alarm weekday and return
without calculating the alarm date. Move reading RZN1_RTC_CTL1 before
this check so that alrm->enabled is updated for both configured and
unconfigured alarms.

Fixes: b5ad1bf00d2c4 ("rtc: rzn1: Add alarm support")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260821211032.13554-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ retained the ALME-only enable check because RZN1_RTC_CTL1_1SE is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rzn1.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-rzn1.c b/drivers/rtc/rtc-rzn1.c
index c64eaf50bb39a..668935dbcefec 100644
--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -193,13 +193,24 @@ static int rzn1_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret)
 		return ret;
 
+	ctl1 = readl(rtc->base + RZN1_RTC_CTL1);
+	alrm->enabled = !!(ctl1 & RZN1_RTC_CTL1_ALME);
+
 	min = readl(rtc->base + RZN1_RTC_ALM);
 	hour = readl(rtc->base + RZN1_RTC_ALH);
-	wday = readl(rtc->base + RZN1_RTC_ALW);
 
 	tm->tm_sec = 0;
 	tm->tm_min = bcd2bin(min);
 	tm->tm_hour = bcd2bin(hour);
+
+	/*
+	 * If wday is zero, no bit is set in RZN1_RTC_ALW. This is the
+	 * register's power-on reset value.
+	 */
+	wday = readl(rtc->base + RZN1_RTC_ALW);
+	if (!wday)
+		return 0;
+
 	delta_days = ((fls(wday) - 1) - tm->tm_wday + 7) % 7;
 	tm->tm_wday = fls(wday) - 1;
 
@@ -208,9 +219,6 @@ static int rzn1_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		rtc_time64_to_tm(alarm, tm);
 	}
 
-	ctl1 = readl(rtc->base + RZN1_RTC_CTL1);
-	alrm->enabled = !!(ctl1 & RZN1_RTC_CTL1_ALME);
-
 	return 0;
 }
 
-- 
2.53.0



