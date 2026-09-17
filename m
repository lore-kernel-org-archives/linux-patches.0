Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3D059B695;
	Thu, 17 Sep 2026 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660904; cv=none; b=QUge1X3D1eGzclZ3eAcKy+xatUbC8Nm6WF+JJO00KN6Yr/M6KtbtoFtCtNVW7/opeMBkLGqwNzBdMrpiHRiGHD7crN5hZ3Q00qmp6c4rC6Dzvf98xR5u/PLQljQCpZjD6jyu6mftUwzZgEaPcgL/eV1xaVoMRyCO2enWS9acroA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660904; c=relaxed/simple;
	bh=jXFS/x9JjnMZcCXbVfmU3TjwxB0iFarimMdMj//j6vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/q+2GUbU27JQqDJSmi1+fsCwLMIY/df9LBwfsnT2XEjFoxL3wLmYKeBxIeT6b21RTezeg7uUBNxYX7lzKq9Zq02zz4YR6KqqZuE18oJqkPDutraEXE7SbCORXSTljGBGvta5CrBKtOYMfC+Wfjep0Gi+jA7Zi24mweyOoLrbjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejQC6jN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejQC6jN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64781F000FF;
	Thu, 17 Sep 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660903;
	bh=/LJ9+wXwgxLXT9wa2gxAM/9K1q2nr44iT8Ga7UKGvPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejQC6jN3XHmQX3fDhEs1ntEiDicoRAcZGqnhdiNEV7PLGMpCNQoCoWUKMqTCb8Q6r
	 4CIABJbezRoGxpzBjq2E9YjQXfUDUxy3bw/Q5h699pL9iCHiIadMDqM7Dgv7l55fNO
	 Dp2vqo13/trAEyb2x7VyZ5XH224cj++E5Msa2CAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0017/1250] driver core: Replace dev->can_match with dev_can_match()
Date: Thu, 17 Sep 2026 15:56:52 +0100
Message-ID: <20260917151552.394033109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit f2648bb3150a71241a2254aa4ac10680d7f9fb16 ]

In C, bitfields are not necessarily safe to modify from multiple
threads without locking. Switch "can_match" over to the "flags" field
so modifications are safe.

Cc: Saravana Kannan <saravanak@kernel.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260406162231.v5.2.I54b3ae6311ff34ad30227659d91bb109911a4aea@changeid
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 10 +++++-----
 drivers/base/dd.c      | 10 +++++-----
 include/linux/device.h |  9 +++++----
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5034d9b103642..2b0179096c73d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1084,7 +1084,7 @@ static void device_links_missing_supplier(struct device *dev)
 
 static bool dev_is_best_effort(struct device *dev)
 {
-	return (fw_devlink_best_effort && dev->can_match) ||
+	return (fw_devlink_best_effort && dev_can_match(dev)) ||
 		(dev->fwnode && fwnode_test_flag(dev->fwnode, FWNODE_FLAG_BEST_EFFORT));
 }
 
@@ -1152,7 +1152,7 @@ int device_links_check_suppliers(struct device *dev)
 
 			if (dev_is_best_effort(dev) &&
 			    device_link_test(link, DL_FLAG_INFERRED) &&
-			    !link->supplier->can_match) {
+			    !dev_can_match(link->supplier)) {
 				ret = -EAGAIN;
 				continue;
 			}
@@ -1435,7 +1435,7 @@ void device_links_driver_bound(struct device *dev)
 		} else if (dev_is_best_effort(dev) &&
 			   device_link_test(link, DL_FLAG_INFERRED) &&
 			   link->status != DL_STATE_CONSUMER_PROBE &&
-			   !link->supplier->can_match) {
+			   !dev_can_match(link->supplier)) {
 			/*
 			 * When dev_is_best_effort() is true, we ignore device
 			 * links to suppliers that don't have a driver.  If the
@@ -1823,7 +1823,7 @@ static int fw_devlink_no_driver(struct device *dev, void *data)
 {
 	struct device_link *link = to_devlink(dev);
 
-	if (!link->supplier->can_match)
+	if (!dev_can_match(link->supplier))
 		fw_devlink_relax_link(link);
 
 	return 0;
@@ -3775,7 +3775,7 @@ int device_add(struct device *dev)
 	 * match with any driver, don't block its consumers from probing in
 	 * case the consumer device is able to operate without this supplier.
 	 */
-	if (dev->fwnode && fw_devlink_drv_reg_done && !dev->can_match)
+	if (dev->fwnode && fw_devlink_drv_reg_done && !dev_can_match(dev))
 		fw_devlink_unblock_consumers(dev);
 
 	if (parent)
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index dabdfc088f3f6..d019d0f98ad47 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -132,7 +132,7 @@ static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
 void driver_deferred_probe_add(struct device *dev)
 {
-	if (!dev->can_match)
+	if (!dev_can_match(dev))
 		return;
 
 	mutex_lock(&deferred_probe_mutex);
@@ -858,14 +858,14 @@ static int __driver_probe_device(const struct device_driver *drv, struct device
 		return dev_err_probe(dev, -EPROBE_DEFER, "Device not ready to probe\n");
 
 	/*
-	 * Set can_match = true after calling dev_ready_to_probe(), so
+	 * Call dev_set_can_match() after calling dev_ready_to_probe(), so
 	 * driver_deferred_probe_add() won't actually add the device to the
 	 * deferred probe list when dev_ready_to_probe() returns false.
 	 *
 	 * When dev_ready_to_probe() returns false, it means that device_add()
 	 * will do another probe() attempt for us.
 	 */
-	dev->can_match = true;
+	dev_set_can_match(dev);
 	dev_dbg(dev, "bus: '%s': %s: matched device with driver %s\n",
 		drv->bus->name, __func__, drv->name);
 
@@ -1011,7 +1011,7 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 		return 0;
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
-		dev->can_match = true;
+		dev_set_can_match(dev);
 		driver_deferred_probe_add(dev);
 		/*
 		 * Device can't match with a driver right now, so don't attempt
@@ -1255,7 +1255,7 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
-		dev->can_match = true;
+		dev_set_can_match(dev);
 		driver_deferred_probe_add(dev);
 		/*
 		 * Driver could not match with device, but may match with
diff --git a/include/linux/device.h b/include/linux/device.h
index dc1252a06480c..56e5a9314367d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -485,10 +485,14 @@ struct device_physical_location {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_CAN_MATCH: The device has matched with a driver at least once or it
+ *		is in a bus (like AMBA) which can't check for matching drivers
+ *		until other devices probe successfully.
  * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,
+	DEV_FLAG_CAN_MATCH = 1,
 
 	DEV_FLAG_COUNT
 };
@@ -575,9 +579,6 @@ enum struct_device_flags {
  * @state_synced: The hardware state of this device has been synced to match
  *		  the software state of this device by calling the driver/bus
  *		  sync_state() callback.
- * @can_match:	The device has matched with a driver at least once or it is in
- *		a bus (like AMBA) which can't check for matching drivers until
- *		other devices probe successfully.
  * @dma_coherent: this particular device is dma coherent, even if the
  *		architecture supports non-coherent devices.
  * @dma_ops_bypass: If set to %true then the dma_ops are bypassed for the
@@ -696,7 +697,6 @@ struct device {
 	bool			offline:1;
 	bool			of_node_reused:1;
 	bool			state_synced:1;
-	bool			can_match:1;
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
@@ -738,6 +738,7 @@ static inline bool dev_test_and_set_##accessor_name(struct device *dev) \
 }
 
 __create_dev_flag_accessors(ready_to_probe, DEV_FLAG_READY_TO_PROBE);
+__create_dev_flag_accessors(can_match, DEV_FLAG_CAN_MATCH);
 
 #undef __create_dev_flag_accessors
 
-- 
2.53.0



