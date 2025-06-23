Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524D71E521E;
	Mon, 23 Jun 2025 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713896; cv=none; b=mRHgIlyrzow9GhU2n5QdqbecT2zIYD7DRHhISQ/EP2m83SysF8mhBKHG46+FUY7ovZEdATQxjXhveAd7hyivbnAv5i3wTDGEvjnz4EwOjkfdE83Hz8cEWpHJtAiCCfVFvPD4xP4tZDes7k5E5BiPOzGb5A3zLqggl4cW25gtG2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713896; c=relaxed/simple;
	bh=KGH8AWtwmKH2fME4sBH6BqEDeA8ukpaOhNYp4oJZcz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgJVvMO3Olx/44yAGq6+4Qbn5YGjL1ZSoLimEGWQVO8z+Q1KQeiQScZ7zwiTx0vHn3d15lL/FfgvoCzigg8tKkugxFqmSp5joTe2E3hj3YB1q2QUlp+jTd7JEyE23pYdfhxSfpxBlpsH7A0Wyl9jLnZj0/zriyoRKvHbao0pRPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHQ+BUvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHQ+BUvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA81C4CEEA;
	Mon, 23 Jun 2025 21:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713896;
	bh=KGH8AWtwmKH2fME4sBH6BqEDeA8ukpaOhNYp4oJZcz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHQ+BUvEjHHmwv/zLRaHJF9wVEbtlYM3aQYfedoHt02fkLIB3YXA018VWRnUTftQj
	 GKzR3Fea0L3aq3H2T1UlT0AwKDDII+dVOSs2Qx3JmX8ARBbTEDeUMd7N6LFF5hikM9
	 bMf8IACzNZu6cDxmehrOKI4g3lKu9XuWP60FXHQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cassio Neri <cassio.neri@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=83=C2=B6nig?= <u.kleine-koenig@baylibre.com>
Subject: [PATCH 5.4 215/222] rtc: Improve performance of rtc_time64_to_tm(). Add tests.
Date: Mon, 23 Jun 2025 15:09:10 +0200
Message-ID: <20250623130618.761791686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cassio Neri <cassio.neri@gmail.com>

commit 1d1bb12a8b1805ddeef9793ebeb920179fb0fa38 upstream.

The current implementation of rtc_time64_to_tm() contains unnecessary
loops, branches and look-up tables. The new one uses an arithmetic-based
algorithm appeared in [1] and is approximately 4.3 times faster (YMMV).

The drawback is that the new code isn't intuitive and contains many 'magic
numbers' (not unusual for this type of algorithm). However, [1] justifies
all those numbers and, given this function's history, the code is unlikely
to need much maintenance, if any at all.

Add a KUnit test case that checks every day in a 160,000 years interval
starting on 1970-01-01 against the expected result. Add a new config
RTC_LIB_KUNIT_TEST symbol to give the option to run this test suite.

[1] Neri, Schneider, "Euclidean Affine Functions and Applications to
Calendar Algorithms". https://arxiv.org/abs/2102.06959

Signed-off-by: Cassio Neri <cassio.neri@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210624201343.85441-1-cassio.neri@gmail.com
Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/Kconfig    |   10 ++++
 drivers/rtc/Makefile   |    1 
 drivers/rtc/lib.c      |  107 ++++++++++++++++++++++++++++++++++++-------------
 drivers/rtc/lib_test.c |   79 ++++++++++++++++++++++++++++++++++++
 4 files changed, 170 insertions(+), 27 deletions(-)
 create mode 100644 drivers/rtc/lib_test.c

--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -10,6 +10,16 @@ config RTC_MC146818_LIB
 	bool
 	select RTC_LIB
 
+config RTC_LIB_KUNIT_TEST
+	tristate "KUnit test for RTC lib functions" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	select RTC_LIB
+	help
+	  Enable this option to test RTC library functions.
+
+	  If unsure, say N.
+
 menuconfig RTC_CLASS
 	bool "Real Time Clock"
 	default n
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -186,3 +186,4 @@ obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm83
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_XGENE)	+= rtc-xgene.o
 obj-$(CONFIG_RTC_DRV_ZYNQMP)	+= rtc-zynqmp.o
+obj-$(CONFIG_RTC_LIB_KUNIT_TEST)	+= lib_test.o
--- a/drivers/rtc/lib.c
+++ b/drivers/rtc/lib.c
@@ -6,6 +6,8 @@
  * Author: Alessandro Zummo <a.zummo@towertech.it>
  *
  * based on arch/arm/common/rtctime.c and other bits
+ *
+ * Author: Cassio Neri <cassio.neri@gmail.com> (rtc_time64_to_tm)
  */
 
 #include <linux/export.h>
@@ -22,8 +24,6 @@ static const unsigned short rtc_ydays[2]
 	{ 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
 };
 
-#define LEAPS_THRU_END_OF(y) ((y) / 4 - (y) / 100 + (y) / 400)
-
 /*
  * The number of days in the month.
  */
@@ -42,42 +42,95 @@ int rtc_year_days(unsigned int day, unsi
 }
 EXPORT_SYMBOL(rtc_year_days);
 
-/*
- * rtc_time64_to_tm - Converts time64_t to rtc_time.
- * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
+/**
+ * rtc_time64_to_tm - converts time64_t to rtc_time.
+ *
+ * @time:	The number of seconds since 01-01-1970 00:00:00.
+ *		(Must be positive.)
+ * @tm:		Pointer to the struct rtc_time.
  */
 void rtc_time64_to_tm(time64_t time, struct rtc_time *tm)
 {
-	unsigned int month, year, secs;
+	unsigned int secs;
 	int days;
 
+	u64 u64tmp;
+	u32 u32tmp, udays, century, day_of_century, year_of_century, year,
+		day_of_year, month, day;
+	bool is_Jan_or_Feb, is_leap_year;
+
 	/* time must be positive */
 	days = div_s64_rem(time, 86400, &secs);
 
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;
 
-	year = 1970 + days / 365;
-	days -= (year - 1970) * 365
-		+ LEAPS_THRU_END_OF(year - 1)
-		- LEAPS_THRU_END_OF(1970 - 1);
-	while (days < 0) {
-		year -= 1;
-		days += 365 + is_leap_year(year);
-	}
-	tm->tm_year = year - 1900;
-	tm->tm_yday = days + 1;
-
-	for (month = 0; month < 11; month++) {
-		int newdays;
-
-		newdays = days - rtc_month_days(month, year);
-		if (newdays < 0)
-			break;
-		days = newdays;
-	}
-	tm->tm_mon = month;
-	tm->tm_mday = days + 1;
+	/*
+	 * The following algorithm is, basically, Proposition 6.3 of Neri
+	 * and Schneider [1]. In a few words: it works on the computational
+	 * (fictitious) calendar where the year starts in March, month = 2
+	 * (*), and finishes in February, month = 13. This calendar is
+	 * mathematically convenient because the day of the year does not
+	 * depend on whether the year is leap or not. For instance:
+	 *
+	 * March 1st		0-th day of the year;
+	 * ...
+	 * April 1st		31-st day of the year;
+	 * ...
+	 * January 1st		306-th day of the year; (Important!)
+	 * ...
+	 * February 28th	364-th day of the year;
+	 * February 29th	365-th day of the year (if it exists).
+	 *
+	 * After having worked out the date in the computational calendar
+	 * (using just arithmetics) it's easy to convert it to the
+	 * corresponding date in the Gregorian calendar.
+	 *
+	 * [1] "Euclidean Affine Functions and Applications to Calendar
+	 * Algorithms". https://arxiv.org/abs/2102.06959
+	 *
+	 * (*) The numbering of months follows rtc_time more closely and
+	 * thus, is slightly different from [1].
+	 */
+
+	udays		= ((u32) days) + 719468;
+
+	u32tmp		= 4 * udays + 3;
+	century		= u32tmp / 146097;
+	day_of_century	= u32tmp % 146097 / 4;
+
+	u32tmp		= 4 * day_of_century + 3;
+	u64tmp		= 2939745ULL * u32tmp;
+	year_of_century	= upper_32_bits(u64tmp);
+	day_of_year	= lower_32_bits(u64tmp) / 2939745 / 4;
+
+	year		= 100 * century + year_of_century;
+	is_leap_year	= year_of_century != 0 ?
+		year_of_century % 4 == 0 : century % 4 == 0;
+
+	u32tmp		= 2141 * day_of_year + 132377;
+	month		= u32tmp >> 16;
+	day		= ((u16) u32tmp) / 2141;
+
+	/*
+	 * Recall that January 01 is the 306-th day of the year in the
+	 * computational (not Gregorian) calendar.
+	 */
+	is_Jan_or_Feb	= day_of_year >= 306;
+
+	/* Converts to the Gregorian calendar. */
+	year		= year + is_Jan_or_Feb;
+	month		= is_Jan_or_Feb ? month - 12 : month;
+	day		= day + 1;
+
+	day_of_year	= is_Jan_or_Feb ?
+		day_of_year - 306 : day_of_year + 31 + 28 + is_leap_year;
+
+	/* Converts to rtc_time's format. */
+	tm->tm_year	= (int) (year - 1900);
+	tm->tm_mon	= (int) month;
+	tm->tm_mday	= (int) day;
+	tm->tm_yday	= (int) day_of_year + 1;
 
 	tm->tm_hour = secs / 3600;
 	secs -= tm->tm_hour * 3600;
--- /dev/null
+++ b/drivers/rtc/lib_test.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: LGPL-2.1+
+
+#include <kunit/test.h>
+#include <linux/rtc.h>
+
+/*
+ * Advance a date by one day.
+ */
+static void advance_date(int *year, int *month, int *mday, int *yday)
+{
+	if (*mday != rtc_month_days(*month - 1, *year)) {
+		++*mday;
+		++*yday;
+		return;
+	}
+
+	*mday = 1;
+	if (*month != 12) {
+		++*month;
+		++*yday;
+		return;
+	}
+
+	*month = 1;
+	*yday  = 1;
+	++*year;
+}
+
+/*
+ * Checks every day in a 160000 years interval starting on 1970-01-01
+ * against the expected result.
+ */
+static void rtc_time64_to_tm_test_date_range(struct kunit *test)
+{
+	/*
+	 * 160000 years	= (160000 / 400) * 400 years
+	 *		= (160000 / 400) * 146097 days
+	 *		= (160000 / 400) * 146097 * 86400 seconds
+	 */
+	time64_t total_secs = ((time64_t) 160000) / 400 * 146097 * 86400;
+
+	int year	= 1970;
+	int month	= 1;
+	int mday	= 1;
+	int yday	= 1;
+
+	struct rtc_time result;
+	time64_t secs;
+	s64 days;
+
+	for (secs = 0; secs <= total_secs; secs += 86400) {
+
+		rtc_time64_to_tm(secs, &result);
+
+		days = div_s64(secs, 86400);
+
+		#define FAIL_MSG "%d/%02d/%02d (%2d) : %ld", \
+			year, month, mday, yday, days
+
+		KUNIT_ASSERT_EQ_MSG(test, year - 1900, result.tm_year, FAIL_MSG);
+		KUNIT_ASSERT_EQ_MSG(test, month - 1, result.tm_mon, FAIL_MSG);
+		KUNIT_ASSERT_EQ_MSG(test, mday, result.tm_mday, FAIL_MSG);
+		KUNIT_ASSERT_EQ_MSG(test, yday, result.tm_yday, FAIL_MSG);
+
+		advance_date(&year, &month, &mday, &yday);
+	}
+}
+
+static struct kunit_case rtc_lib_test_cases[] = {
+	KUNIT_CASE(rtc_time64_to_tm_test_date_range),
+	{}
+};
+
+static struct kunit_suite rtc_lib_test_suite = {
+	.name = "rtc_lib_test_cases",
+	.test_cases = rtc_lib_test_cases,
+};
+
+kunit_test_suite(rtc_lib_test_suite);


