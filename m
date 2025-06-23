Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8E61A4F12;
	Mon, 23 Jun 2025 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716304; cv=none; b=juqIRs33Ul8Xw0XpG5+LH48OhQ47c14/szESeFejX2To5OtuO/gwUduoRBeihElRjVmHRt0z/pSW5V2KGfz/L/cA5+MEIHbq6A5OElBM/XSBezudowEdoEvx7QoEBUGoYUiP7ZCsn+l2lDBd1tjMS2F0ikEMjcVNxe5uMUj9KJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716304; c=relaxed/simple;
	bh=HH2IKuD4XjzEFlBF1ymLc0MwNyUPIcZ8oTeHEN9jczQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmruKo6uoF18rqMu1/XorYv314B1lJFBU9HX7KW4dw71CX4E+Ai+DKk7ilqdvCGaaRkvyHI48yjqTdZitF4g2wbbONjMRddsywR+EkMHeWotIZ0WwEcZrE40Myqo3Eohcr8aZf1kKqIGu8ANsSSF2nPgw6G5EVLEpgB9NqprqxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYrVwf70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYrVwf70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09D2C4CEEA;
	Mon, 23 Jun 2025 22:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716304;
	bh=HH2IKuD4XjzEFlBF1ymLc0MwNyUPIcZ8oTeHEN9jczQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYrVwf70XeFq1tcoXdjoD4A5HJuAGxC2NIOFW+p64GrIdmTYDgH1koqCMqFjeS8Vl
	 dPaqZjDfvUQZ5PLzdESzCwG+TutwjW1nDg8ajcfLPbJUXTKZ3wWtjPN+qgJYUH94lF
	 oOWe43yV0JZN8YJdXG4c/YHowjZvOaUNgF+aSnTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 340/355] rtc: Make rtc_time64_to_tm() support dates before 1970
Date: Mon, 23 Jun 2025 15:09:01 +0200
Message-ID: <20250623130636.951336632@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Mergnat <amergnat@baylibre.com>

commit 7df4cfef8b351fec3156160bedfc7d6d29de4cce upstream.

Conversion of dates before 1970 is still relevant today because these
dates are reused on some hardwares to store dates bigger than the
maximal date that is representable in the device's native format.
This prominently and very soon affects the hardware covered by the
rtc-mt6397 driver that can only natively store dates in the interval
1900-01-01 up to 2027-12-31. So to store the date 2028-01-01 00:00:00
to such a device, rtc_time64_to_tm() must do the right thing for
time=-2208988800.

Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250428-enable-rtc-v4-1-2b2f7e3f9349@baylibre.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/lib.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/rtc/lib.c
+++ b/drivers/rtc/lib.c
@@ -46,24 +46,38 @@ EXPORT_SYMBOL(rtc_year_days);
  * rtc_time64_to_tm - converts time64_t to rtc_time.
  *
  * @time:	The number of seconds since 01-01-1970 00:00:00.
- *		(Must be positive.)
+ *		Works for values since at least 1900
  * @tm:		Pointer to the struct rtc_time.
  */
 void rtc_time64_to_tm(time64_t time, struct rtc_time *tm)
 {
-	unsigned int secs;
-	int days;
+	int days, secs;
 
 	u64 u64tmp;
 	u32 u32tmp, udays, century, day_of_century, year_of_century, year,
 		day_of_year, month, day;
 	bool is_Jan_or_Feb, is_leap_year;
 
-	/* time must be positive */
+	/*
+	 * Get days and seconds while preserving the sign to
+	 * handle negative time values (dates before 1970-01-01)
+	 */
 	days = div_s64_rem(time, 86400, &secs);
 
+	/*
+	 * We need 0 <= secs < 86400 which isn't given for negative
+	 * values of time. Fixup accordingly.
+	 */
+	if (secs < 0) {
+		days -= 1;
+		secs += 86400;
+	}
+
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;
+	/* Ensure tm_wday is always positive */
+	if (tm->tm_wday < 0)
+		tm->tm_wday += 7;
 
 	/*
 	 * The following algorithm is, basically, Proposition 6.3 of Neri
@@ -93,7 +107,7 @@ void rtc_time64_to_tm(time64_t time, str
 	 * thus, is slightly different from [1].
 	 */
 
-	udays		= ((u32) days) + 719468;
+	udays		= days + 719468;
 
 	u32tmp		= 4 * udays + 3;
 	century		= u32tmp / 146097;


