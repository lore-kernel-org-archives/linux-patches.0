Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC0BE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD9BC4339E;
	Thu,  1 Jun 2023 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625818;
	bh=6buz5UZK3whBTQE1CHIHhLx8/M4ktO98hSQspIxTSh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs4xyQQhT1snYVgScaEL+nntlJeUwDmvewy700mY5pVcxZ9AKACqUP0V5GXtTqYrR
	 xI2uQsRY4xapp5khkXLbO8QrCLZtRbAKHOoYeV2MNzMEPIVYqIHeTGnMYfwNdq3/kD
	 +dpN4JGWTGisX0xPL10z9vtEXqgOvO4bnhNkyi6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/22] power: supply: bq27xxx: Ensure power_supply_changed() is called on current sign changes
Date: Thu,  1 Jun 2023 14:21:07 +0100
Message-Id: <20230601131934.167894989@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 939a116142012926e25de0ea6b7e2f8d86a5f1b6 ]

On gauges where the current register is signed, there is no charging
flag in the flags register. So only checking flags will not result
in power_supply_changed() getting called when e.g. a charger is plugged
in and the current sign changes from negative (discharging) to
positive (charging).

This causes userspace's notion of the status to lag until userspace
does a poll.

And when a power_supply_leds.c LED trigger is used to indicate charging
status with a LED, this LED will lag until the capacity percentage
changes, which may take many minutes (because the LED trigger only is
updated on power_supply_changed() calls).

Fix this by calling bq27xxx_battery_current_and_status() on gauges with
a signed current register and checking if the status has changed.

Fixes: 297a533b3e62 ("bq27x00: Cache battery registers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 13 ++++++++++++-
 include/linux/power/bq27xxx_battery.h  |  3 +++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 160ab53065f8e..8984f66bd2bc3 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1762,6 +1762,7 @@ static int bq27xxx_battery_current_and_status(
 
 static void bq27xxx_battery_update_unlocked(struct bq27xxx_device_info *di)
 {
+	union power_supply_propval status = di->last_status;
 	struct bq27xxx_reg_cache cache = {0, };
 	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
 
@@ -1786,14 +1787,24 @@ static void bq27xxx_battery_update_unlocked(struct bq27xxx_device_info *di)
 		if (di->regs[BQ27XXX_REG_CYCT] != INVALID_REG_ADDR)
 			cache.cycle_count = bq27xxx_battery_read_cyct(di);
 
+		/*
+		 * On gauges with signed current reporting the current must be
+		 * checked to detect charging <-> discharging status changes.
+		 */
+		if (!(di->opts & BQ27XXX_O_ZERO))
+			bq27xxx_battery_current_and_status(di, NULL, &status, &cache);
+
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
 			di->charge_design_full = bq27xxx_battery_read_dcap(di);
 	}
 
 	if ((di->cache.capacity != cache.capacity) ||
-	    (di->cache.flags != cache.flags))
+	    (di->cache.flags != cache.flags) ||
+	    (di->last_status.intval != status.intval)) {
+		di->last_status.intval = status.intval;
 		power_supply_changed(di->bat);
+	}
 
 	if (memcmp(&di->cache, &cache, sizeof(cache)) != 0)
 		di->cache = cache;
diff --git a/include/linux/power/bq27xxx_battery.h b/include/linux/power/bq27xxx_battery.h
index 705b94bd091e3..63964196a436e 100644
--- a/include/linux/power/bq27xxx_battery.h
+++ b/include/linux/power/bq27xxx_battery.h
@@ -2,6 +2,8 @@
 #ifndef __LINUX_BQ27X00_BATTERY_H__
 #define __LINUX_BQ27X00_BATTERY_H__
 
+#include <linux/power_supply.h>
+
 enum bq27xxx_chip {
 	BQ27000 = 1, /* bq27000, bq27200 */
 	BQ27010, /* bq27010, bq27210 */
@@ -69,6 +71,7 @@ struct bq27xxx_device_info {
 	int charge_design_full;
 	bool removed;
 	unsigned long last_update;
+	union power_supply_propval last_status;
 	struct delayed_work work;
 	struct power_supply *bat;
 	struct list_head list;
-- 
2.39.2



