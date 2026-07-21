Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FE46D0A6;
	Tue, 21 Jul 2026 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657422; cv=none; b=Li4fCgScYyMLi+kjfRBiXPVxUvGO/M4JTTsZ90Mj+eCA0Rmo+OCZ0HD2fz/36Wjxcegmn0z043WT8HbH4W1OvtSQ3+CfgVsQ0aiICWlrdI3u2O0dh3fqC9Ra5lhmDLat/v7C7ZQu2dGco16Wjh3zje+pfEojOve+9JCVUGh6JTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657422; c=relaxed/simple;
	bh=d5P2c7U5SdRR3pAwGSJyJN2ND5g/bJ6IbWzRkXps6bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0/di08me7tWLLvlhgDWWyXllR7dOV06ZW0a13f0HVhAXbUyXNPrgVAvovjf5e6XgOQtZebdTtKt0hcMs05kLCOwj4tqDNFFf9DxicUeZBSTvHqhCqjik1jtYu3z9VlIezqyLRjW0rsORpCrbG/vwX6V476GvGukjGyoV8c2CIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXrKjYcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXrKjYcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A887B1F00A3D;
	Tue, 21 Jul 2026 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657420;
	bh=fDGkKhhVYoUqxH7lzjCQUp8bx4wVZw7i6DmfWsoCcHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXrKjYcZj69UECf8nN2CCnua8uyqV3gGRIJTJyPoeBRn+9au9BZ/hx125yDsoO2oy
	 uVM4qastt5vV36IgesjGx8Xc5G+7nHvrorZHuuSYnojDux9zvdTXuzLSDBR5i91BuO
	 3YB/GIvkKTZ8AkvupLsm5lBX3WNgJtPXf8zQOvqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0759/1611] i3c: master: Add i3c_master_do_daa_ext() for post-hibernation address recovery
Date: Tue, 21 Jul 2026 17:14:35 +0200
Message-ID: <20260721152532.450037377@linuxfoundation.org>
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

[ Upstream commit c481ef12e713fb7c292d04f53b3532ac0804ab3d ]

After system hibernation, I3C Dynamic Addresses may be reassigned at boot
and no longer match the values recorded before suspend. Introduce
i3c_master_do_daa_ext() to handle this situation.

The restore procedure is straightforward: issue a Reset Dynamic Address
Assignment (RSTDAA), then run the standard DAA sequence. The existing DAA
logic already supports detecting and updating devices whose dynamic
addresses differ from previously known values.

Refactor the DAA path by introducing a shared helper used by both the
normal i3c_master_do_daa() path and the new extended restore function,
and correct the kernel-doc in the process.

Export i3c_master_do_daa_ext() so that master drivers can invoke it from
their PM restore callbacks.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260123063325.8210-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 3f79dac3ea1c ("i3c: master: Defer new-device registration out of DAA caller context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 49 +++++++++++++++++++++++++++++---------
 include/linux/i3c/master.h |  1 +
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index f426c4bcb271e1..0430e5898dae42 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1770,22 +1770,24 @@ i3c_master_register_new_i3c_devs(struct i3c_master_controller *master)
 }
 
 /**
- * i3c_master_do_daa() - do a DAA (Dynamic Address Assignment)
- * @master: master doing the DAA
+ * i3c_master_do_daa_ext() - Dynamic Address Assignment (extended version)
+ * @master: controller
+ * @rstdaa: whether to first perform Reset of Dynamic Addresses (RSTDAA)
  *
- * This function is instantiating an I3C device object and adding it to the
- * I3C device list. All device information are automatically retrieved using
- * standard CCC commands.
- *
- * The I3C device object is returned in case the master wants to attach
- * private data to it using i3c_dev_set_master_data().
+ * Perform Dynamic Address Assignment with optional support for System
+ * Hibernation (@rstdaa is true).
  *
- * This function must be called with the bus lock held in write mode.
+ * After System Hibernation, Dynamic Addresses can have been reassigned at boot
+ * time to different values. A simple strategy is followed to handle that.
+ * Perform a Reset of Dynamic Addresses (RSTDAA) followed by the normal DAA
+ * procedure which has provision for reassigning addresses that differ from the
+ * previously recorded addresses.
  *
  * Return: a 0 in case of success, an negative error code otherwise.
  */
-int i3c_master_do_daa(struct i3c_master_controller *master)
+int i3c_master_do_daa_ext(struct i3c_master_controller *master, bool rstdaa)
 {
+	int rstret = 0;
 	int ret;
 
 	ret = i3c_master_rpm_get(master);
@@ -1793,7 +1795,15 @@ int i3c_master_do_daa(struct i3c_master_controller *master)
 		return ret;
 
 	i3c_bus_maintenance_lock(&master->bus);
+
+	if (rstdaa) {
+		rstret = i3c_master_rstdaa_locked(master, I3C_BROADCAST_ADDR);
+		if (rstret == I3C_ERROR_M2)
+			rstret = 0;
+	}
+
 	ret = master->ops->do_daa(master);
+
 	i3c_bus_maintenance_unlock(&master->bus);
 
 	if (ret)
@@ -1804,7 +1814,24 @@ int i3c_master_do_daa(struct i3c_master_controller *master)
 	i3c_bus_normaluse_unlock(&master->bus);
 out:
 	i3c_master_rpm_put(master);
-	return ret;
+
+	return rstret ?: ret;
+}
+EXPORT_SYMBOL_GPL(i3c_master_do_daa_ext);
+
+/**
+ * i3c_master_do_daa() - do a DAA (Dynamic Address Assignment)
+ * @master: master doing the DAA
+ *
+ * This function instantiates I3C device objects and adds them to the
+ * I3C device list. All device information is automatically retrieved using
+ * standard CCC commands.
+ *
+ * Return: a 0 in case of success, an negative error code otherwise.
+ */
+int i3c_master_do_daa(struct i3c_master_controller *master)
+{
+	return i3c_master_do_daa_ext(master, false);
 }
 EXPORT_SYMBOL_GPL(i3c_master_do_daa);
 
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index bff98590eb2a7c..2e39a0d443a1e9 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -605,6 +605,7 @@ int i3c_master_get_free_addr(struct i3c_master_controller *master,
 int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 				  u8 addr);
 int i3c_master_do_daa(struct i3c_master_controller *master);
+int i3c_master_do_daa_ext(struct i3c_master_controller *master, bool rstdaa);
 struct i3c_dma *i3c_master_dma_map_single(struct device *dev, void *ptr,
 					  size_t len, bool force_bounce,
 					  enum dma_data_direction dir);
-- 
2.53.0



