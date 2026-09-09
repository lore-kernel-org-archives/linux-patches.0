Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EF94C6803;
	Wed,  9 Sep 2026 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961615; cv=none; b=qQUul1MrfJWIxNtQk2zHJkvBFO3WnwEGzb+ypJi9VOsS96vkVL5qIftj9fxggkiYsqXjkE2+LZes1IjA+BONslKJyJjAy10oPEBeyvf62KW7dI4aFMMCNxKuY9m2Ie7WVqFniBfB/Je1xWfpaTsZfM6LltPgXVJn/r0KiyMVLmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961615; c=relaxed/simple;
	bh=JQ/4SV5iTh8t0Rmqdt5/QZywSC4Hm5NPc0M3hx1qLMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8atXSFmOjDHit2LiujMzR5wk8/cz/lZT9i2v+8mfPaZ8ghO2Qoih9aSL6rvoSjF1Y7IVAVrIYY+LFu8yUSjVYrWtf6eYRpiBJbWdD9xiqqHIKNWJyl1V6d49V2iSAjL4iJkHTcW5XaRZidx522mqxcFtTqzeELtv+RQfvsUPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXfLby60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXfLby60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C339C1F00A3D;
	Wed,  9 Sep 2026 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961613;
	bh=zeiye++gG26rCgBuzHKYxdRgHAECZqqI5pj0MWaPxCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXfLby60CCjo5XfH03vUriPLuFb52RL64ymswx95zKXK+K81qlqgRaeazGSh0fXNl
	 S1Lp0qKkTmYS56ivN9OdBHmDvfv+RlouTrsqm23ke6pXfN24piCvBqBKeRuiHGVg/K
	 X5k4EdBBCdU7ynJfmSOOxNUwoYoBfnpNZUm7tVJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosalie Wanders <rosalie@mailbox.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 010/556] HID: sony: use guard() and scoped_guard()
Date: Wed,  9 Sep 2026 15:34:50 +0200
Message-ID: <20260909134230.833688371@linuxfoundation.org>
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

From: Rosalie Wanders <rosalie@mailbox.org>

[ Upstream commit da4f817ad273bca9aefd8636d347a8c101069111 ]

This replaces the spin_lock_irqsave() and spin_unlock_irqrestore() calls
with the RAII guard() and scoped_guard().

Signed-off-by: Rosalie Wanders <rosalie@mailbox.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 7c65699a3a31 ("HID: sony: clean up device list on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sony.c |   62 ++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -29,6 +29,7 @@
  * There will be no PIN request from the device.
  */
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
@@ -569,14 +570,12 @@ static void sony_set_leds(struct sony_sc
 static inline void sony_schedule_work(struct sony_sc *sc,
 				      enum sony_worker which)
 {
-	unsigned long flags;
-
 	switch (which) {
 	case SONY_WORKER_STATE:
-		spin_lock_irqsave(&sc->lock, flags);
-		if (!sc->defer_initialization && sc->state_worker_initialized)
-			schedule_work(&sc->state_worker);
-		spin_unlock_irqrestore(&sc->lock, flags);
+		scoped_guard(spinlock_irqsave, &sc->lock) {
+			if (!sc->defer_initialization && sc->state_worker_initialized)
+				schedule_work(&sc->state_worker);
+		}
 		break;
 	}
 }
@@ -949,7 +948,6 @@ static const u8 *sony_report_fixup(struc
 static void sixaxis_parse_report(struct sony_sc *sc, u8 *rd, int size)
 {
 	static const u8 sixaxis_battery_capacity[] = { 0, 1, 25, 50, 75, 100 };
-	unsigned long flags;
 	int offset;
 	u8 index;
 	u8 battery_capacity;
@@ -972,10 +970,10 @@ static void sixaxis_parse_report(struct
 		battery_status = POWER_SUPPLY_STATUS_DISCHARGING;
 	}
 
-	spin_lock_irqsave(&sc->lock, flags);
-	sc->battery_capacity = battery_capacity;
-	sc->battery_status = battery_status;
-	spin_unlock_irqrestore(&sc->lock, flags);
+	scoped_guard(spinlock_irqsave, &sc->lock) {
+		sc->battery_capacity = battery_capacity;
+		sc->battery_status = battery_status;
+	}
 
 	if (sc->quirks & SIXAXIS_CONTROLLER) {
 		int val;
@@ -1092,7 +1090,6 @@ static void rb4_ps5_guitar_parse_report(
 	u8 battery_data;
 	u8 battery_capacity;
 	u8 battery_status;
-	unsigned long flags;
 
 	/*
 	 * Rock Band 4 PS5 guitars have whammy and
@@ -1132,10 +1129,10 @@ static void rb4_ps5_guitar_parse_report(
 		break;
 	}
 
-	spin_lock_irqsave(&sc->lock, flags);
-	sc->battery_capacity = battery_capacity;
-	sc->battery_status = battery_status;
-	spin_unlock_irqrestore(&sc->lock, flags);
+	scoped_guard(spinlock_irqsave, &sc->lock) {
+		sc->battery_capacity = battery_capacity;
+		sc->battery_status = battery_status;
+	}
 
 	input_sync(sc->input_dev);
 }
@@ -1869,15 +1866,14 @@ static int sony_battery_get_property(str
 				     union power_supply_propval *val)
 {
 	struct sony_sc *sc = power_supply_get_drvdata(psy);
-	unsigned long flags;
 	int ret = 0;
 	u8 battery_capacity;
 	int battery_status;
 
-	spin_lock_irqsave(&sc->lock, flags);
-	battery_capacity = sc->battery_capacity;
-	battery_status = sc->battery_status;
-	spin_unlock_irqrestore(&sc->lock, flags);
+	scoped_guard(spinlock_irqsave, &sc->lock) {
+		battery_capacity = sc->battery_capacity;
+		battery_status = sc->battery_status;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
@@ -1959,10 +1955,9 @@ static inline int sony_compare_connectio
 static int sony_check_add_dev_list(struct sony_sc *sc)
 {
 	struct sony_sc *entry;
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&sony_dev_list_lock, flags);
+	guard(spinlock_irqsave)(&sony_dev_list_lock);
 
 	list_for_each_entry(entry, &sony_device_list, list_node) {
 		ret = memcmp(sc->mac_address, entry->mac_address,
@@ -1976,26 +1971,23 @@ static int sony_check_add_dev_list(struc
 				"controller with MAC address %pMR already connected\n",
 				sc->mac_address);
 			}
-			goto unlock;
+			goto out;
 		}
 	}
 
 	ret = 0;
 	list_add(&(sc->list_node), &sony_device_list);
 
-unlock:
-	spin_unlock_irqrestore(&sony_dev_list_lock, flags);
+out:
 	return ret;
 }
 
 static void sony_remove_dev_list(struct sony_sc *sc)
 {
-	unsigned long flags;
-
 	if (sc->list_node.next) {
-		spin_lock_irqsave(&sony_dev_list_lock, flags);
-		list_del(&(sc->list_node));
-		spin_unlock_irqrestore(&sony_dev_list_lock, flags);
+		scoped_guard(spinlock_irqsave, &sony_dev_list_lock) {
+			list_del(&(sc->list_node));
+		}
 	}
 }
 
@@ -2123,12 +2115,10 @@ static inline void sony_init_output_repo
 
 static inline void sony_cancel_work_sync(struct sony_sc *sc)
 {
-	unsigned long flags;
-
 	if (sc->state_worker_initialized) {
-		spin_lock_irqsave(&sc->lock, flags);
-		sc->state_worker_initialized = 0;
-		spin_unlock_irqrestore(&sc->lock, flags);
+		scoped_guard(spinlock_irqsave, &sc->lock) {
+			sc->state_worker_initialized = 0;
+		}
 		cancel_work_sync(&sc->state_worker);
 	}
 }


