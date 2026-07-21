Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B39347125D;
	Tue, 21 Jul 2026 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657432; cv=none; b=uR5C6bdg2BKccKA4tNcFkZu8POJ/EY6VoCkocnZ5cQl0FWXEoCZMXmVENNLPMCh5HseNwzozzpIL/e0LWHuxDeUKjtYoTQUIHYBudh8i969i4RXAmCWX/JA/XfjJTnBnBO8ZC6vNX4mEc0n9Vf+TwZiPPD9YsQSQjkMBVQvZVOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657432; c=relaxed/simple;
	bh=XunErslkIXyEm0ZgpiOac94yg6/OW3vHRZnbrZs1ru4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX/SN6JyzSJI8UQDsDk7Z5WhXhbyLf+UuzPA6746KvjLgCGi2Oe8yKWSUPLHND27OjvQbA4GVWMdC5xcH/GsaVhJwuHMuVhzn1tQY78Xo0zSqXv3TENq6mfjn7jABpaT1PQfV54NMDz5DkcLjZjKuBs8VABIFpsGxCUy8JjuLS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOKz/sB/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOKz/sB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6466B1F000E9;
	Tue, 21 Jul 2026 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657430;
	bh=M7jJZwyP7jBWbrCx8mPqF//uyLTRWbTORhE/RS/WRgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOKz/sB/OT+kFNTRygXa15Yod+r73ptwVDxaeGrKCFfDHWEIYRC/A16kXC4R236fX
	 ipWQZ1KqNEMsS9I76pglMDDkb2A46F8egZlbxK55qT+RgQkzsHLNX+nedOld1H2faO
	 zVPBC/CfTZlgjhbRgUQZFQXO2DZ83xGmQl4IE3NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0762/1611] i3c: master: Ensure Hot-Join operations are stopped on shutdown
Date: Tue, 21 Jul 2026 17:14:38 +0200
Message-ID: <20260721152532.517619930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 8323e783dc3904839e64cb08cfcc7571ef9212c4 ]

System shutdown invokes each device's bus shutdown callback to quiesce
hardware, but the I3C bus type does not currently implement one.  As a
result, on shutdown the controller's Hot-Join work and any in-flight
i3c_master_do_daa() can keep running (or be newly triggered) while the
rest of the system is being torn down.

A similar window exists at i3c_master_unregister() time: cancel_work_sync()
on hj_work prevents queued work from completing, but does not stop a
fresh Hot-Join IBI from re-queueing the worker, nor a concurrent sysfs
writer from toggling Hot-Join via i3c_set_hotjoin().

Introduce a single "shutting down" gate in the I3C core, set under the
bus maintenance lock so it is observed by any in-progress DAA path
before pending work is cancelled.  Install an i3c_bus_type shutdown
callback that engages this gate for master devices during system
shutdown, and use the same gate in i3c_master_unregister() so both
paths get identical guarantees.

Once the gate is engaged, the Hot-Join worker, i3c_master_do_daa_ext()
and i3c_set_hotjoin() all bail out cleanly, so Hot-Join IBIs that race
with shutdown become no-ops, direct DAA callers see -ENODEV, and sysfs
writers can no longer re-enable Hot-Join through ops->enable_hotjoin()
while the controller is going away.

No functional change for the steady-state runtime path; the new checks
only take effect once the controller has been marked as shutting down.

Note, this patch depends on patch "i3c: master: Consolidate Hot-Join DAA
work in the core".

Fixes: 3a379bbcea0af ("i3c: Add core I3C infrastructure")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260608054312.10604-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 3f79dac3ea1c ("i3c: master: Defer new-device registration out of DAA caller context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 52 +++++++++++++++++++++++++++-----------
 include/linux/i3c/master.h |  2 ++
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 4ca2d77fb552b3..e537e89ffc2dbb 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -370,14 +370,6 @@ static void i3c_device_remove(struct device *dev)
 	i3c_device_free_ibi(i3cdev);
 }
 
-const struct bus_type i3c_bus_type = {
-	.name = "i3c",
-	.match = i3c_device_match,
-	.probe = i3c_device_probe,
-	.remove = i3c_device_remove,
-};
-EXPORT_SYMBOL_GPL(i3c_bus_type);
-
 static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status_mask(struct i3c_bus *bus, u16 addr, u32 mask)
 {
@@ -639,7 +631,8 @@ static void i3c_master_hj_work_fn(struct work_struct *work)
 {
 	struct i3c_master_controller *master = container_of(work, typeof(*master), hj_work);
 
-	i3c_master_do_daa(master);
+	if (!master->shutting_down)
+		i3c_master_do_daa(master);
 }
 
 static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
@@ -660,7 +653,9 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 
 	i3c_bus_normaluse_lock(&master->bus);
 
-	if (enable)
+	if (master->shutting_down)
+		ret = -ENODEV;
+	else if (enable)
 		ret = master->ops->enable_hotjoin(master);
 	else
 		ret = master->ops->disable_hotjoin(master);
@@ -812,6 +807,30 @@ static const struct device_type i3c_masterdev_type = {
 	.groups	= i3c_masterdev_groups,
 };
 
+static void i3c_master_shutdown(struct i3c_master_controller *master)
+{
+	i3c_bus_maintenance_lock(&master->bus);
+	master->shutting_down = true;
+	i3c_bus_maintenance_unlock(&master->bus);
+
+	cancel_work_sync(&master->hj_work);
+}
+
+static void i3c_device_shutdown(struct device *dev)
+{
+	if (dev->type == &i3c_masterdev_type)
+		i3c_master_shutdown(dev_to_i3cmaster(dev));
+}
+
+const struct bus_type i3c_bus_type = {
+	.name = "i3c",
+	.match = i3c_device_match,
+	.probe = i3c_device_probe,
+	.remove = i3c_device_remove,
+	.shutdown = i3c_device_shutdown,
+};
+EXPORT_SYMBOL_GPL(i3c_bus_type);
+
 static int i3c_bus_set_mode(struct i3c_bus *i3cbus, enum i3c_bus_mode mode,
 			    unsigned long max_i2c_scl_rate)
 {
@@ -1819,10 +1838,13 @@ int i3c_master_do_daa_ext(struct i3c_master_controller *master, bool rstdaa)
 
 	i3c_bus_maintenance_lock(&master->bus);
 
-	if (rstdaa)
-		rstret = i3c_master_rstdaa_locked(master, I3C_BROADCAST_ADDR);
-
-	ret = master->ops->do_daa(master);
+	if (master->shutting_down) {
+		ret = -ENODEV;
+	} else {
+		if (rstdaa)
+			rstret = i3c_master_rstdaa_locked(master, I3C_BROADCAST_ADDR);
+		ret = master->ops->do_daa(master);
+	}
 
 	i3c_bus_maintenance_unlock(&master->bus);
 
@@ -3146,7 +3168,7 @@ EXPORT_SYMBOL_GPL(i3c_master_register);
 void i3c_master_unregister(struct i3c_master_controller *master)
 {
 	i3c_bus_notify(&master->bus, I3C_NOTIFY_BUS_REMOVE);
-	cancel_work_sync(&master->hj_work);
+	i3c_master_shutdown(master);
 
 	if (master->ops->set_dev_nack_retry)
 		device_remove_file(&master->dev, &dev_attr_dev_nack_retry_count);
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index fc146bbb304fa0..056f4f25ccfbc5 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -511,6 +511,7 @@ struct i3c_master_controller_ops {
  * @hotjoin: true if the master support hotjoin
  * @rpm_allowed: true if Runtime PM allowed
  * @rpm_ibi_allowed: true if IBI and Hot-Join allowed while runtime suspended
+ * @shutting_down: set to true when master begins shutdown or unregister
  * @boardinfo.i3c: list of I3C  boardinfo objects
  * @boardinfo.i2c: list of I2C boardinfo objects
  * @boardinfo: board-level information attached to devices connected on the bus
@@ -539,6 +540,7 @@ struct i3c_master_controller {
 	unsigned int hotjoin: 1;
 	unsigned int rpm_allowed: 1;
 	unsigned int rpm_ibi_allowed: 1;
+	bool shutting_down;
 	struct {
 		struct list_head i3c;
 		struct list_head i2c;
-- 
2.53.0



