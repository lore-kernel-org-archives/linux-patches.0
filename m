Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD883590AE;
	Thu, 17 Sep 2026 19:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671684; cv=none; b=HpljKZ8Ew2+3IYFw6jxoooySrQqlAUTnUiNd7iIartb+jE3bCWbVoZTQarjJN5e//SAtWCd9aVy3UUld/z9cXW0SG+EG1fwIxUh1EaeH7QiWPldE+NGTyk78zNn/REAa7atHVHDKtN2OZOSMjNRvVbr3NlyAxXI9/95d/9cveJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671684; c=relaxed/simple;
	bh=NYfaCRqWxkGb/lIcPDN/rQyvq+os+3RUXKE9SJUhl5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3/3tl/nF/OQVlYaie0Ry7/oWfsnKaLshEhh4+FpRJW9OD+6QN+F/lrAei8N73t5tgv9mDrBjhDbr3b8HoBEq/ek1fer/Qb+f6aKpbi/FJAbpSpaEmJ96tMLR49w9JTPjzaRgYksE4OahIWewIcbTuLanoYPtjmpiNPcY7mE49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha0GMyi4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha0GMyi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432421F00893;
	Thu, 17 Sep 2026 19:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671675;
	bh=l9vNX6RbZxrQ28lVKbDwkzmwvuy/r9+Uiwn5mX5TBm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ha0GMyi4p+DfW0QyJxEX4BNQDp7d7U52YZY0ls4YgUwB+8yJHFyrlMQToL9JVO7HY
	 Zxw0Ivn+2zfbmFuo2Cuf/OopI9Mo4lZPbM+7GoqSHfnx8oSamgBDN1fGgowmLaTc56
	 epU6/slvr6Vh4yfH6kPuOjSC7cVCnhT+cum6+AXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosalie Wanders <rosalie@mailbox.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1055/1102] HID: sony: use guard() and scoped_guard()
Date: Thu, 17 Sep 2026 16:16:38 +0100
Message-ID: <20260917151607.296869106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/hid/hid-sony.c |   53 ++++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -27,6 +27,7 @@
  * There will be no PIN request from the device.
  */
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
@@ -520,14 +521,12 @@ static void sony_set_leds(struct sony_sc
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
@@ -796,7 +795,6 @@ static const u8 *sony_report_fixup(struc
 static void sixaxis_parse_report(struct sony_sc *sc, u8 *rd, int size)
 {
 	static const u8 sixaxis_battery_capacity[] = { 0, 1, 25, 50, 75, 100 };
-	unsigned long flags;
 	int offset;
 	u8 battery_capacity;
 	int battery_status;
@@ -818,10 +816,10 @@ static void sixaxis_parse_report(struct
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
@@ -1624,15 +1622,14 @@ static int sony_battery_get_property(str
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
@@ -1714,10 +1711,9 @@ static inline int sony_compare_connectio
 static int sony_check_add_dev_list(struct sony_sc *sc)
 {
 	struct sony_sc *entry;
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&sony_dev_list_lock, flags);
+	guard(spinlock_irqsave)(&sony_dev_list_lock);
 
 	list_for_each_entry(entry, &sony_device_list, list_node) {
 		ret = memcmp(sc->mac_address, entry->mac_address,
@@ -1731,26 +1727,23 @@ static int sony_check_add_dev_list(struc
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
 
@@ -1878,12 +1871,10 @@ static inline void sony_init_output_repo
 
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


