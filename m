Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFDA53FD2B;
	Wed,  9 Sep 2026 13:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961976; cv=none; b=n2YYJ2O8BscxkfWqFQCL9iJey8zSv0x+gXbDsK7zVhas7aeZ4hPlAJnN9z//ysy+bcIx0hISsRFTLbl9ufOEkjyKFW12rqfrLsPJvcSrmtpc6DeyTz1Wv4cmGkYiIvL50yFlMwYItdoCyTjDizstFdDN6FYqByIX0qlqV+q99f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961976; c=relaxed/simple;
	bh=hS03r2q5Yu4DmKrPvllRjjpqUDXQTG5btqgZKKy9p3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHjcF/iAnfORpK/qDIA1kENadScXFL5jsyBVH72bbJUUNfqqBDt9c8btPnnXSIZhfz04PaS3zgyZUF4Kv90/rGUPnM4IkImkl5XNbT7NMdQIg04qETmHOHo7l+DOIBkrFM19SrKiFnEUSouwkB80kqd93kadSy+tpIJLSGXHnJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaitjHUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaitjHUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943891F00A3A;
	Wed,  9 Sep 2026 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961975;
	bh=ZD8Zqk63ajXmCwYEkQXk0oRkfHbSiXODQJ3qXVIjmF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaitjHUD+XVyz1a+J+I6wKp4dQGthtA+Zrs6OfwHQ5U6upvKR5DnemRTzJKhPvSeV
	 3DukkJdxKPA33NLhuVfvQjLRVmIL2Q6wtvmPr0keEm2wicZkunkWUcHgpCmVE9CvE+
	 3QSehxKmxQnvui6Tz9eSjRP7eIdiJ4AdSiSSHGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 131/556] rtc: rzn1: Fix weekday underflow when alarm crosses month boundary
Date: Wed,  9 Sep 2026 15:36:51 +0200
Message-ID: <20260909134235.064612417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 022a2839a52006531804a8db55d3228084400b48 upstream.

rzn1_rtc_set_alarm() calculates the alarm weekday from the difference
between the alarm day and the current day of the month. When the alarm
crosses a month boundary, this difference can become negative. Since
days_ahead is unsigned, it underflows and results in an incorrect
weekday being programmed into RZN1_RTC_ALW.

The RTC core already provides a fully populated struct rtc_time for
the alarm, including the correct tm_wday. Use tm->tm_wday directly
instead of recalculating the weekday from the day-of-month.

This avoids the underflow and ensures alarms scheduled across a month
boundary use the correct weekday.

Fixes: b5ad1bf00d2c4 ("rtc: rzn1: Add alarm support")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Suggested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260821211032.13554-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-rzn1.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -260,7 +260,6 @@ static int rzn1_rtc_set_alarm(struct dev
 	struct rzn1_rtc *rtc = dev_get_drvdata(dev);
 	struct rtc_time *tm = &alrm->time, tm_now;
 	unsigned long alarm, farest;
-	unsigned int days_ahead, wday;
 	int ret;
 
 	ret = rzn1_rtc_read_time(dev, &tm_now);
@@ -273,13 +272,9 @@ static int rzn1_rtc_set_alarm(struct dev
 	if (time_after(alarm, farest))
 		return -ERANGE;
 
-	/* Convert alarm day into week day */
-	days_ahead = tm->tm_mday - tm_now.tm_mday;
-	wday = (tm_now.tm_wday + days_ahead) % 7;
-
 	writel(bin2bcd(tm->tm_min), rtc->base + RZN1_RTC_ALM);
 	writel(bin2bcd(tm->tm_hour), rtc->base + RZN1_RTC_ALH);
-	writel(BIT(wday), rtc->base + RZN1_RTC_ALW);
+	writel(BIT(tm->tm_wday), rtc->base + RZN1_RTC_ALW);
 
 	rtc->tm_alarm = alrm->time;
 


