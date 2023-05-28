Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479CD611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AFFC433EF;
	Sun, 28 May 2023 19:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303365;
	bh=Pzpsfa7mHoRl3DvbwZJ9yBR/2KLOpnrAOk/UJsr5Gyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BTpMDiukcEJuPMzf6xDtD3DNW7pbROjj0uIc2ma/khJXzRs3pz+K5EQqbBLyR3hY
	 hJ3mAt1mK6gU/hhB/onZkJFoa8HIRcArJPuAsBYTjYegCCWE3LhQXdeQe8IzwFcsTF
	 vFJqOg5D6smV1MIEy4nykbJIJMN5nbZY/xmSrrWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 47/69] power: supply: bq27xxx: Add cache parameter to bq27xxx_battery_current_and_status()
Date: Sun, 28 May 2023 20:12:07 +0100
Message-Id: <20230528190830.128556857@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
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

commit 35092c5819f8c5acc7bafe3fdbb13d6307c4f5e1 upstream.

Add a cache parameter to bq27xxx_battery_current_and_status() so that
it can optionally use cached flags instead of re-reading them itself.

This is a preparation patch for making bq27xxx_battery_update() check
the status and have it call power_supply_changed() on status changes.

Fixes: 297a533b3e62 ("bq27x00: Cache battery registers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1846,7 +1846,8 @@ static bool bq27xxx_battery_is_full(stru
 static int bq27xxx_battery_current_and_status(
 	struct bq27xxx_device_info *di,
 	union power_supply_propval *val_curr,
-	union power_supply_propval *val_status)
+	union power_supply_propval *val_status,
+	struct bq27xxx_reg_cache *cache)
 {
 	bool single_flags = (di->opts & BQ27XXX_O_ZERO);
 	int curr;
@@ -1858,10 +1859,14 @@ static int bq27xxx_battery_current_and_s
 		return curr;
 	}
 
-	flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, single_flags);
-	if (flags < 0) {
-		dev_err(di->dev, "error reading flags\n");
-		return flags;
+	if (cache) {
+		flags = cache->flags;
+	} else {
+		flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, single_flags);
+		if (flags < 0) {
+			dev_err(di->dev, "error reading flags\n");
+			return flags;
+		}
 	}
 
 	if (di->opts & BQ27XXX_O_ZERO) {
@@ -2007,7 +2012,7 @@ static int bq27xxx_battery_get_property(
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
-		ret = bq27xxx_battery_current_and_status(di, NULL, val);
+		ret = bq27xxx_battery_current_and_status(di, NULL, val, NULL);
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 		ret = bq27xxx_battery_voltage(di, val);
@@ -2016,7 +2021,7 @@ static int bq27xxx_battery_get_property(
 		val->intval = di->cache.flags < 0 ? 0 : 1;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		ret = bq27xxx_battery_current_and_status(di, val, NULL);
+		ret = bq27xxx_battery_current_and_status(di, val, NULL, NULL);
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = bq27xxx_simple_value(di->cache.capacity, val);


