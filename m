Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC2D1FC0EA;
	Sat, 30 May 2026 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166733; cv=none; b=Q54gMiOVgRxbtye5jGBzLEHtYvFTR9BLqslQNa3nFos7uhD8Qe+5LeCw/RL3dALcWc9rPxui+4YJue7KCQ93eUeSeZGoDASaCBIpQWUWl8UIBV0o/PQ/VYR0CEolBfvwFvtGRiqgAr3K3ds4wA1vTCwWZ1+kGhqf7cH5FCYz3Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166733; c=relaxed/simple;
	bh=mFjG4dY3jlKPWJRtxeLyvTxfk1Na2j7Jhxoj8N75XRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mokyr9xw6TtNj5/ZjuXVp3sjM5kThi/a8EXBwCQGvyx5QrgKmHGSW6BRUzzgEuaRaLofDc3YcR576YlRDx9SgTOYq9tUUWiXWIaTdvcGZJQuaVd1CZFZ0Sn4Ly1/3gJw+WSvfqsfVKYpN9aH07tIw8HRBkYwkE/V7/86A9mt7T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fx8Rh25i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fx8Rh25i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576E01F00893;
	Sat, 30 May 2026 18:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166731;
	bh=xE8epL5VyK6Zo8nMeJRWJYq/o8kdW7V8EaAuJ10BLoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fx8Rh25iTchlDBgL4WjSgagcU0o/qL3E4q9oqsZ6SJ6S31eKmeAC4p3ZdKF0ePGPn
	 V+haiz5mVO+nr9vVNoaqoesuwlrVedgYWkrOGhHr7gxHG8BTQwcLeuOTbSw/H/nug5
	 uT2m1BzH6mLOPnjNxEqG7jIoQfqDWZKtJs7Jb3e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 454/589] rtc: introduce features bitfield
Date: Sat, 30 May 2026 18:05:35 +0200
Message-ID: <20260530160236.618105823@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 7ae41220ef5831674f446baef19bfe1b31358260 ]

Introduce a bitfield to allow the drivers to announce the available
features for an RTC.

The main use case would be to better handle alarms, that could be present
or not or have a minute resolution or may need a correct week day to be set.

Use the newly introduced RTC_FEATURE_ALARM bit to then test whether alarms
are available instead of relying on the presence of ops->set_alarm.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210110231752.1418816-2-alexandre.belloni@bootlin.com
Stable-dep-of: 0fedce7244e4 ("rtc: abx80x: Disable alarm feature if no interrupt attached")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/class.c      |  5 +++++
 drivers/rtc/interface.c  | 12 ++++++------
 include/linux/rtc.h      |  2 ++
 include/uapi/linux/rtc.h |  5 +++++
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index b1ce3bd724b2c..81aeb7a191b5f 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -234,6 +234,8 @@ static struct rtc_device *rtc_allocate_device(void)
 	rtc->pie_timer.function = rtc_pie_update_irq;
 	rtc->pie_enabled = 0;
 
+	set_bit(RTC_FEATURE_ALARM, rtc->features);
+
 	return rtc;
 }
 
@@ -404,6 +406,9 @@ int __rtc_register_device(struct module *owner, struct rtc_device *rtc)
 		return -EINVAL;
 	}
 
+	if (!rtc->ops->set_alarm)
+		clear_bit(RTC_FEATURE_ALARM, rtc->features);
+
 	rtc->owner = owner;
 	rtc_device_get_offset(rtc);
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 7c9487050b25b..7df7457d7dc13 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -186,7 +186,7 @@ static int rtc_read_alarm_internal(struct rtc_device *rtc,
 
 	if (!rtc->ops) {
 		err = -ENODEV;
-	} else if (!rtc->ops->read_alarm) {
+	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->read_alarm) {
 		err = -EINVAL;
 	} else {
 		alarm->enabled = 0;
@@ -393,7 +393,7 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		return err;
 	if (!rtc->ops) {
 		err = -ENODEV;
-	} else if (!rtc->ops->read_alarm) {
+	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->read_alarm) {
 		err = -EINVAL;
 	} else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
@@ -437,7 +437,7 @@ static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 
 	if (!rtc->ops)
 		err = -ENODEV;
-	else if (!rtc->ops->set_alarm)
+	else if (!test_bit(RTC_FEATURE_ALARM, rtc->features))
 		err = -EINVAL;
 	else
 		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
@@ -475,7 +475,7 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 
 	if (!rtc->ops)
 		return -ENODEV;
-	else if (!rtc->ops->set_alarm)
+	else if (!test_bit(RTC_FEATURE_ALARM, rtc->features))
 		return -EINVAL;
 
 	err = rtc_valid_tm(&alarm->time);
@@ -555,7 +555,7 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 		/* nothing */;
 	else if (!rtc->ops)
 		err = -ENODEV;
-	else if (!rtc->ops->alarm_irq_enable)
+	else if (!test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->alarm_irq_enable)
 		err = -EINVAL;
 	else
 		err = rtc->ops->alarm_irq_enable(rtc->dev.parent, enabled);
@@ -874,7 +874,7 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 
 static void rtc_alarm_disable(struct rtc_device *rtc)
 {
-	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
+	if (!rtc->ops || !test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->alarm_irq_enable)
 		return;
 
 	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 22d1575e4991b..5037bda2f5b08 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -124,6 +124,8 @@ struct rtc_device {
 	bool nvram_old_abi;
 	struct bin_attribute *nvram;
 
+	unsigned long features[BITS_TO_LONGS(RTC_FEATURE_CNT)];
+
 	time64_t range_min;
 	timeu64_t range_max;
 	time64_t start_secs;
diff --git a/include/uapi/linux/rtc.h b/include/uapi/linux/rtc.h
index fa9aff91cbf27..f950bff75e97e 100644
--- a/include/uapi/linux/rtc.h
+++ b/include/uapi/linux/rtc.h
@@ -110,6 +110,11 @@ struct rtc_pll_info {
 #define RTC_AF 0x20	/* Alarm interrupt */
 #define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
+/* feature list */
+#define RTC_FEATURE_ALARM		0
+#define RTC_FEATURE_ALARM_RES_MINUTE	1
+#define RTC_FEATURE_NEED_WEEK_DAY	2
+#define RTC_FEATURE_CNT			3
 
 #define RTC_MAX_FREQ	8192
 
-- 
2.53.0



