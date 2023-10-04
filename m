Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C521DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBX9K8tW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F92FC433C8;
	Wed,  4 Oct 2023 18:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444117;
	bh=qx6TAtZxdjPbZ6QCTfPtL2vLXFN7exg96rE0XBgZIUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBX9K8tWgBWVclqBheo3SmobTX4E37c/XmaRuIQ73YloW9vanEqe3dUKwgBTGe6XQ
	 FH/Gj3bMaRgHRSbiWC9VXKo1KN+ep3KWoPIaqkkLfy/02+b9sn+gBPLz6TCWpjhhTk
	 yeWbFh6AsLSjVAjmDAeSu8u3tFWdH9tehOfnjXP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 136/321] power: supply: core: fix use after free in uevent
Date: Wed,  4 Oct 2023 19:54:41 +0200
Message-ID: <20231004175235.544938527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 3dc0bab23dba53f315c9a7b4a679e0a6d46f7c6e ]

power_supply_uevent() which is called to emit a udev event on device
deletion attempts to use the power_supply_battery_info structure,
which is device-managed and has been freed before this point.

Fix this by not generating all battery/charger properties when the
device is about to be removed. This also avoids generating errors
when trying to access the hardware in hot-unplug scenarios.

==================================================================
 BUG: KASAN: slab-use-after-free in power_supply_battery_info_has_prop (power_supply_core.c:872)
 Read of size 4 at addr 0000000062e59028 by task python3/27

 Call Trace:
  power_supply_battery_info_has_prop (power_supply_core.c:872)
  power_supply_uevent (power_supply_sysfs.c:504)
  dev_uevent (drivers/base/core.c:2590)
  kobject_uevent_env (lib/kobject_uevent.c:558)
  kobject_uevent (lib/kobject_uevent.c:643)
  device_del (drivers/base/core.c:3266 drivers/base/core.c:3831)
  device_unregister (drivers/base/core.c:3730 drivers/base/core.c:3854)
  power_supply_unregister (power_supply_core.c:1608)
  devm_power_supply_release (power_supply_core.c:1515)
  release_nodes (drivers/base/devres.c:506)
  devres_release_group (drivers/base/devres.c:669)
  i2c_device_remove (drivers/i2c/i2c-core-base.c:629)
  device_remove (drivers/base/dd.c:570)
  device_release_driver_internal (drivers/base/dd.c:1274 drivers/base/dd.c:1295)
  device_driver_detach (drivers/base/dd.c:1332)
  unbind_store (drivers/base/bus.c:247)
  ...

 Allocated by task 27:
  devm_kmalloc (drivers/base/devres.c:119 drivers/base/devres.c:829)
  power_supply_get_battery_info (include/linux/device.h:316 power_supply_core.c:626)
  __power_supply_register (power_supply_core.c:1408)
  devm_power_supply_register (power_supply_core.c:1544)
  bq256xx_probe (bq256xx_charger.c:1539 bq256xx_charger.c:1727) bq256xx_charger
  i2c_device_probe (drivers/i2c/i2c-core-base.c:584)
  really_probe (drivers/base/dd.c:579 drivers/base/dd.c:658)
  __driver_probe_device (drivers/base/dd.c:800)
  device_driver_attach (drivers/base/dd.c:1128)
  bind_store (drivers/base/bus.c:273)
  ...

 Freed by task 27:
  kfree (mm/slab_common.c:1073)
  release_nodes (drivers/base/devres.c:503)
  devres_release_all (drivers/base/devres.c:536)
  device_del (drivers/base/core.c:3829)
  device_unregister (drivers/base/core.c:3730 drivers/base/core.c:3854)
  power_supply_unregister (power_supply_core.c:1608)
  devm_power_supply_release (power_supply_core.c:1515)
  release_nodes (drivers/base/devres.c:506)
  devres_release_group (drivers/base/devres.c:669)
  i2c_device_remove (drivers/i2c/i2c-core-base.c:629)
  device_remove (drivers/base/dd.c:570)
  device_release_driver_internal (drivers/base/dd.c:1274 drivers/base/dd.c:1295)
  device_driver_detach (drivers/base/dd.c:1332)
  unbind_store (drivers/base/bus.c:247)
  ...
 ==================================================================

Reported-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Fixes: 27a2195efa8d ("power: supply: core: auto-exposure of simple-battery data")
Tested-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index 06e5b6b0e255c..d483a81560ab0 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -482,6 +482,13 @@ int power_supply_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	if (ret)
 		return ret;
 
+	/*
+	 * Kernel generates KOBJ_REMOVE uevent in device removal path, after
+	 * resources have been freed. Exit early to avoid use-after-free.
+	 */
+	if (psy->removing)
+		return 0;
+
 	prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!prop_buf)
 		return -ENOMEM;
-- 
2.40.1



