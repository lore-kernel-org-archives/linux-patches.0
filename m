Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704946;
	b=gw1PLyNXxhOuzVR144WcDkDSKPX6h/hVJu95KL1eSFYfEi+RGvwonwinfgB9ZenO5RZt
	 qR6SRTPiOJRNWpOiq/ufs4p/3gmK1xu5j+JnGwBPWyERT9BrY9wUorpAYBVU0322zvmEy
	 J6C689HlrAK0SXaG2Odoxo8+oODgvvjFD+zqLQWoyqEfxyM6EsAcT3yoUEGHJVQFcUI/K
	 816GZmAqE3FI+9/+g9c3zYe19l/TrXMspjGXrsIL1bioO65myEobF6I14nFqCvmW3rvIr
	 liaeyEQE1uYj7fPBsm5D3Yn0tn5MZrY/rHfIsJwGCkLR+BTiRd5SwHsBPrGpk/CA/KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SuKoWDHJ+QGd20VQRHqeGMUk46orFb9Vzn+5mjdoE7w=;
	b=499WHAzm42YmFzXPbmdM1T3XnItoGtk5tGXVPkoAIHJFzmkgxXeL/dz4+Hp3TJudEFj2
	 wn1/FBEqh3uSbHR6FaVsjkwQ4mRAFtyV+6NDqfvsH5+dO6XWUX8uZF7qoNeFU7vzI6+Z0
	 YpXm9RoCwtkxJuQDhQvSe5ctI7eYEgTs54EcAiZF10FwFvn1qV+F8rWs6OSSzWfkgDp9Z
	 QEAp85KSdXSNfdJB/3E5GKRG2vElKHGfw0FZgE3/E5auDQ+jbx0rrcDbUtzBEAU9D9EwC
	 aK5jzlUmCbOXkUnaUz3eLT6Cw3VcBy9dBhFEo3fG17R6ajup/jty1YicGdb8yjnk4xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOjZ4LTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2DC606A32E;
	Thu, 26 Nov 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOjZ4LTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8F31F000D1;
	Thu, 26 Nov 2026 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704946;
	bh=SuKoWDHJ+QGd20VQRHqeGMUk46orFb9Vzn+5mjdoE7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOjZ4LTr/L40iUYSHIayeEXJfB+yh//9GhkvmIoBsLLFdzvXcosE8QGQ2pcB9csac
	 gGDNcO9k5zr9Tuza5ahdvj816CGK9Jm+HT1RSAHJQYyr463/HQ+kWM+W7CWfuftARF
	 MHZDOf2mZkLFPO407Jn+7qfqT3W2pNS0tly6HITE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/319] i3c: master: Fix recursive locking during device registration
Date: Thu, 26 Nov 2026 15:36:15 +0100
Message-ID: <20261126144006.907127975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 456f832e5fc26fbfd3b8200fd4553eee520cc377 upstream.

i3c_master_register_new_i3c_devs() registers newly discovered devices
while holding i3c_bus_normaluse_lock(), a down_read().  device_register()
can immediately probe the device, and probe callbacks typically invoke
I3C helpers that take i3c_bus_normaluse_lock() again, leading to a
recursive acquisition of the same rwsem.  rwsems do not support recursive
read locking and can deadlock when a writer is waiting.  See the
"Recursive read locks" section of Documentation/locking/lockdep-design.rst.

For example, with Intel LPSS I3C, LOCKDEP generates a WARNING like:
  # echo intel-lpss-i3c.0 > /sys/bus/platform/drivers/mipi-i3c-hci/unbind
  # echo intel-lpss-i3c.0 > /sys/bus/platform/drivers/mipi-i3c-hci/bind
  WARNING: possible recursive locking detected
  kworker/5:1/94 is trying to acquire lock:
  ffff88811c810d78 (&i3cbus->lock){++++}-{4:4}, at: i3c_device_match_id+0x45/0x370
  but task is already holding lock:
  ffff88811c810d78 (&i3cbus->lock){++++}-{4:4}, at: i3c_master_reg_work_fn+0x21/0x5f0

Fix this by separating device creation from device registration.
Populate desc->dev under the maintenance lock, collect the devices that
still need registration into a local list, then release the lock before
calling device_register().  Finally retake the lock and clean up any
devices that failed to register.

Use the maintenance lock rather than the normal-use lock while adding
device objects.  A write-side maintenance lock prevents readers from
observing a partially initialized desc->dev during initial device
population, or desc->dev disappearing if registration fails.

The local list requires a list node, so add a list node member to struct
i3c_device.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[claudiu.beznea:
 - drop the i3c_bus_normaluse_{lock,unlock}() around
   i3c_master_register_new_i3c_devs() calls from i3c_master_do_daa() and
   i3c_master_register()
 - drop master->shutting_down specific code since this is not available
   in v5.15]
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 39 ++++++++++++++++++++++++++------------
 include/linux/i3c/master.h |  3 +++
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 6e02c91060ab1..40aca5006b87c 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1481,12 +1481,16 @@ static int i3c_master_early_i3c_dev_add(struct i3c_master_controller *master,
 static void
 i3c_master_register_new_i3c_devs(struct i3c_master_controller *master)
 {
+	struct i3c_device *i3cdev, *tmp;
 	struct i3c_dev_desc *desc;
+	LIST_HEAD(i3c_unreg_devs);
 	int ret;
 
 	if (!master->init_done)
 		return;
 
+	i3c_bus_maintenance_lock(&master->bus);
+
 	i3c_bus_for_each_i3cdev(&master->bus, desc) {
 		if (desc->dev || !desc->info.dyn_addr || desc == master->this)
 			continue;
@@ -1507,15 +1511,30 @@ i3c_master_register_new_i3c_devs(struct i3c_master_controller *master)
 		if (desc->boardinfo)
 			desc->dev->dev.of_node = desc->boardinfo->of_node;
 
-		ret = device_register(&desc->dev->dev);
-		if (ret) {
-			dev_err(&master->dev,
-				"Failed to add I3C device (err = %d)\n", ret);
-			desc->dev->desc = NULL;
-			put_device(&desc->dev->dev);
-			desc->dev = NULL;
-		}
+		list_add_tail(&desc->dev->node, &i3c_unreg_devs);
+	}
+
+	i3c_bus_maintenance_unlock(&master->bus);
+
+	list_for_each_entry_safe(i3cdev, tmp, &i3c_unreg_devs, node) {
+		ret = device_register(&i3cdev->dev);
+		if (ret)
+			dev_err(&master->dev, "Failed to add I3C device (err = %d)\n", ret);
+		else
+			list_del_init(&i3cdev->node);
 	}
+
+	i3c_bus_maintenance_lock(&master->bus);
+
+	list_for_each_entry_safe(i3cdev, tmp, &i3c_unreg_devs, node) {
+		list_del(&i3cdev->node);
+		desc = i3cdev->desc;
+		i3cdev->desc = NULL;
+		put_device(&i3cdev->dev);
+		desc->dev = NULL;
+	}
+
+	i3c_bus_maintenance_unlock(&master->bus);
 }
 
 /**
@@ -1544,9 +1563,7 @@ int i3c_master_do_daa(struct i3c_master_controller *master)
 	if (ret)
 		return ret;
 
-	i3c_bus_normaluse_lock(&master->bus);
 	i3c_master_register_new_i3c_devs(master);
-	i3c_bus_normaluse_unlock(&master->bus);
 
 	return 0;
 }
@@ -2585,9 +2602,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 	 * register I3C devices discovered during the initial DAA.
 	 */
 	master->init_done = true;
-	i3c_bus_normaluse_lock(&master->bus);
 	i3c_master_register_new_i3c_devs(master);
-	i3c_bus_normaluse_unlock(&master->bus);
 
 	return 0;
 
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 604a126b78c83..d73770f5f69eb 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -219,6 +219,8 @@ struct i3c_dev_desc {
  *	  every time the I3C device is rediscovered with a different dynamic
  *	  address assigned
  * @bus: I3C bus this device is attached to
+ * @node: unregistered device list node, only for use by
+ *	  i3c_master_register_new_i3c_devs(), it is not protected by a lock
  *
  * I3C device object exposed to I3C device drivers. The takes care of linking
  * this object to the relevant &struct_i3c_dev_desc one.
@@ -229,6 +231,7 @@ struct i3c_device {
 	struct device dev;
 	struct i3c_dev_desc *desc;
 	struct i3c_bus *bus;
+	struct list_head node;
 };
 
 /*
-- 
2.53.0



