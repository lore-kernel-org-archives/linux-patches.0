Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBB3611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC2BC4339B;
	Sun, 28 May 2023 19:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302623;
	bh=zpR3DFAGaY+CQn5iuwig5ydvQhhV7QLKxHeCoDg0+v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8KjEkv5CF8Trtxu2LGb9GiCTEOm8IpyCO1enLxYmfloT5rB7RtqvQDx9RR/yCxPK
	 eMvqwWiU1iE2ZMfLtbDcsgYo8hZ5YA2FFRm6CI9HIXBeO3li26iYzRzCurLR/CF6pm
	 G2SSDRR2fF1tPztDptO6NT/w1UY0KXkTyu5bZJX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 079/119] power: supply: bq27xxx: Move bq27xxx_battery_update() down
Date: Sun, 28 May 2023 20:11:19 +0100
Message-Id: <20230528190838.149765249@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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

commit ff4c4a2a4437a6d03787c7aafb2617f20c3ef45f upstream.

Move the bq27xxx_battery_update() functions to below
the bq27xxx_battery_current_and_status() function.

This is just moving a block of text, no functional changes.

This is a preparation patch for making bq27xxx_battery_update() check
the status and have it call power_supply_changed() on status changes.

Fixes: 297a533b3e62 ("bq27x00: Cache battery registers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |  122 ++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 61 deletions(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1761,67 +1761,6 @@ static int bq27xxx_battery_read_health(s
 	return POWER_SUPPLY_HEALTH_GOOD;
 }
 
-static void bq27xxx_battery_update_unlocked(struct bq27xxx_device_info *di)
-{
-	struct bq27xxx_reg_cache cache = {0, };
-	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
-
-	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
-	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -1; /* read error */
-	if (cache.flags >= 0) {
-		cache.temperature = bq27xxx_battery_read_temperature(di);
-		if (di->regs[BQ27XXX_REG_TTE] != INVALID_REG_ADDR)
-			cache.time_to_empty = bq27xxx_battery_read_time(di, BQ27XXX_REG_TTE);
-		if (di->regs[BQ27XXX_REG_TTECP] != INVALID_REG_ADDR)
-			cache.time_to_empty_avg = bq27xxx_battery_read_time(di, BQ27XXX_REG_TTECP);
-		if (di->regs[BQ27XXX_REG_TTF] != INVALID_REG_ADDR)
-			cache.time_to_full = bq27xxx_battery_read_time(di, BQ27XXX_REG_TTF);
-
-		cache.charge_full = bq27xxx_battery_read_fcc(di);
-		cache.capacity = bq27xxx_battery_read_soc(di);
-		if (di->regs[BQ27XXX_REG_AE] != INVALID_REG_ADDR)
-			cache.energy = bq27xxx_battery_read_energy(di);
-		di->cache.flags = cache.flags;
-		cache.health = bq27xxx_battery_read_health(di);
-		if (di->regs[BQ27XXX_REG_CYCT] != INVALID_REG_ADDR)
-			cache.cycle_count = bq27xxx_battery_read_cyct(di);
-
-		/* We only have to read charge design full once */
-		if (di->charge_design_full <= 0)
-			di->charge_design_full = bq27xxx_battery_read_dcap(di);
-	}
-
-	if ((di->cache.capacity != cache.capacity) ||
-	    (di->cache.flags != cache.flags))
-		power_supply_changed(di->bat);
-
-	if (memcmp(&di->cache, &cache, sizeof(cache)) != 0)
-		di->cache = cache;
-
-	di->last_update = jiffies;
-
-	if (!di->removed && poll_interval > 0)
-		mod_delayed_work(system_wq, &di->work, poll_interval * HZ);
-}
-
-void bq27xxx_battery_update(struct bq27xxx_device_info *di)
-{
-	mutex_lock(&di->lock);
-	bq27xxx_battery_update_unlocked(di);
-	mutex_unlock(&di->lock);
-}
-EXPORT_SYMBOL_GPL(bq27xxx_battery_update);
-
-static void bq27xxx_battery_poll(struct work_struct *work)
-{
-	struct bq27xxx_device_info *di =
-			container_of(work, struct bq27xxx_device_info,
-				     work.work);
-
-	bq27xxx_battery_update(di);
-}
-
 static bool bq27xxx_battery_is_full(struct bq27xxx_device_info *di, int flags)
 {
 	if (di->opts & BQ27XXX_O_ZERO)
@@ -1895,6 +1834,67 @@ static int bq27xxx_battery_current_and_s
 	return 0;
 }
 
+static void bq27xxx_battery_update_unlocked(struct bq27xxx_device_info *di)
+{
+	struct bq27xxx_reg_cache cache = {0, };
+	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
+
+	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
+	if ((cache.flags & 0xff) == 0xff)
+		cache.flags = -1; /* read error */
+	if (cache.flags >= 0) {
+		cache.temperature = bq27xxx_battery_read_temperature(di);
+		if (di->regs[BQ27XXX_REG_TTE] != INVALID_REG_ADDR)
+			cache.time_to_empty = bq27xxx_battery_read_time(di, BQ27XXX_REG_TTE);
+		if (di->regs[BQ27XXX_REG_TTECP] != INVALID_REG_ADDR)
+			cache.time_to_empty_avg = bq27xxx_battery_read_time(di, BQ27XXX_REG_TTECP);
+		if (di->regs[BQ27XXX_REG_TTF] != INVALID_REG_ADDR)
+			cache.time_to_full = bq27xxx_battery_read_time(di, BQ27XXX_REG_TTF);
+
+		cache.charge_full = bq27xxx_battery_read_fcc(di);
+		cache.capacity = bq27xxx_battery_read_soc(di);
+		if (di->regs[BQ27XXX_REG_AE] != INVALID_REG_ADDR)
+			cache.energy = bq27xxx_battery_read_energy(di);
+		di->cache.flags = cache.flags;
+		cache.health = bq27xxx_battery_read_health(di);
+		if (di->regs[BQ27XXX_REG_CYCT] != INVALID_REG_ADDR)
+			cache.cycle_count = bq27xxx_battery_read_cyct(di);
+
+		/* We only have to read charge design full once */
+		if (di->charge_design_full <= 0)
+			di->charge_design_full = bq27xxx_battery_read_dcap(di);
+	}
+
+	if ((di->cache.capacity != cache.capacity) ||
+	    (di->cache.flags != cache.flags))
+		power_supply_changed(di->bat);
+
+	if (memcmp(&di->cache, &cache, sizeof(cache)) != 0)
+		di->cache = cache;
+
+	di->last_update = jiffies;
+
+	if (!di->removed && poll_interval > 0)
+		mod_delayed_work(system_wq, &di->work, poll_interval * HZ);
+}
+
+void bq27xxx_battery_update(struct bq27xxx_device_info *di)
+{
+	mutex_lock(&di->lock);
+	bq27xxx_battery_update_unlocked(di);
+	mutex_unlock(&di->lock);
+}
+EXPORT_SYMBOL_GPL(bq27xxx_battery_update);
+
+static void bq27xxx_battery_poll(struct work_struct *work)
+{
+	struct bq27xxx_device_info *di =
+			container_of(work, struct bq27xxx_device_info,
+				     work.work);
+
+	bq27xxx_battery_update(di);
+}
+
 /*
  * Get the average power in µW
  * Return < 0 if something fails.


