Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5691547F3;
	Mon, 14 Oct 2024 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915968; cv=none; b=fffdCTxrUxejZeBmND89WFWcxqi5P7M2/6QAD9Av1Hc7Q8F5nvDxHVkcSnSYxelGggsLavf9P1Mu7VFMILrh3P90eA+2gl0RSK98lSJXHbyF9LVSMij8xbhvRidLQ3cN9O+/q8GMV2HopIFWgJvwHDLvi0wel6f4PRWNn3LnrYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915968; c=relaxed/simple;
	bh=2jSMSYfioVcn/ozjFOhaZ0afPESGDe+Urt+0bW5/lMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxVQ9TXJgvIRGyX67qeGWITvi4ue243H9c9GVy/aIFKy3xZVPsVYJYR661mTTDJVlsYbe4rGorDke7uSIPzy6sMhfP2nlPPDgjIHA4FLeKwrNalz1MnbGeO7mgn/ApCUV1y6OKaGkCSb1XR+3qswAZlkYWNkriv7mM5rs3V9kEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVETFkHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVETFkHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ABAC4CEC3;
	Mon, 14 Oct 2024 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915967;
	bh=2jSMSYfioVcn/ozjFOhaZ0afPESGDe+Urt+0bW5/lMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVETFkHXxzwaut70EwkVTALU8zn+ZQO30KMRoYdjHjePJOrsbxa1WK/Ho1WK6j5RZ
	 H8sbWx9ehVcz60WugTZWl4XWTb5F4InalvallohmGpxX7HSfh0P9VOYT2Te5NBY1M7
	 ih0D1DS/X9jWtlA+uEtkdESfKsnELomZFXW2GMhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 049/214] soundwire: cadence: re-check Peripheral status with delayed_work
Date: Mon, 14 Oct 2024 16:18:32 +0200
Message-ID: <20241014141046.905132391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f8c35d61ba01afa76846905c67862cdace7f66b0 ]

The SoundWire peripheral enumeration is entirely based on interrupts,
more specifically sticky bits tracking state changes.

This patch adds a defensive programming check on the actual status
reported in PING frames. If for some reason an interrupt was lost or
delayed, the delayed work would detect a peripheral change of status
after the bus starts.

The 100ms defined for the delay is not completely arbitrary, if a
Peripheral didn't join the bus within that delay then probably the
hardware link is broken, and conversely if the detection didn't happen
because of software issues the 100ms is still acceptable in terms of
user experience.

The overhead of the one-shot workqueue is minimal, and the mutual
exclusion ensures that the interrupt and delayed work cannot update
the status concurrently.

Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20240805114921.88007-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c   | 39 ++++++++++++++++++++++++++--
 drivers/soundwire/cadence_master.h   |  5 ++++
 drivers/soundwire/intel.h            |  2 ++
 drivers/soundwire/intel_auxdevice.c  |  1 +
 drivers/soundwire/intel_bus_common.c | 11 ++++++++
 5 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index e0683a5975d10..05652e983539b 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -890,8 +890,14 @@ static int cdns_update_slave_status(struct sdw_cdns *cdns,
 		}
 	}
 
-	if (is_slave)
-		return sdw_handle_slave_status(&cdns->bus, status);
+	if (is_slave) {
+		int ret;
+
+		mutex_lock(&cdns->status_update_lock);
+		ret = sdw_handle_slave_status(&cdns->bus, status);
+		mutex_unlock(&cdns->status_update_lock);
+		return ret;
+	}
 
 	return 0;
 }
@@ -988,6 +994,31 @@ irqreturn_t sdw_cdns_irq(int irq, void *dev_id)
 }
 EXPORT_SYMBOL(sdw_cdns_irq);
 
+static void cdns_check_attached_status_dwork(struct work_struct *work)
+{
+	struct sdw_cdns *cdns =
+		container_of(work, struct sdw_cdns, attach_dwork.work);
+	enum sdw_slave_status status[SDW_MAX_DEVICES + 1];
+	u32 val;
+	int ret;
+	int i;
+
+	val = cdns_readl(cdns, CDNS_MCP_SLAVE_STAT);
+
+	for (i = 0; i <= SDW_MAX_DEVICES; i++) {
+		status[i] = val & 0x3;
+		if (status[i])
+			dev_dbg(cdns->dev, "Peripheral %d status: %d\n", i, status[i]);
+		val >>= 2;
+	}
+
+	mutex_lock(&cdns->status_update_lock);
+	ret = sdw_handle_slave_status(&cdns->bus, status);
+	mutex_unlock(&cdns->status_update_lock);
+	if (ret < 0)
+		dev_err(cdns->dev, "%s: sdw_handle_slave_status failed: %d\n", __func__, ret);
+}
+
 /**
  * cdns_update_slave_status_work - update slave status in a work since we will need to handle
  * other interrupts eg. CDNS_MCP_INT_RX_WL during the update slave
@@ -1740,7 +1771,11 @@ int sdw_cdns_probe(struct sdw_cdns *cdns)
 	init_completion(&cdns->tx_complete);
 	cdns->bus.port_ops = &cdns_port_ops;
 
+	mutex_init(&cdns->status_update_lock);
+
 	INIT_WORK(&cdns->work, cdns_update_slave_status_work);
+	INIT_DELAYED_WORK(&cdns->attach_dwork, cdns_check_attached_status_dwork);
+
 	return 0;
 }
 EXPORT_SYMBOL(sdw_cdns_probe);
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index bc84435e420f5..e1d7969ba48ae 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -117,6 +117,8 @@ struct sdw_cdns_dai_runtime {
  * @link_up: Link status
  * @msg_count: Messages sent on bus
  * @dai_runtime_array: runtime context for each allocated DAI.
+ * @status_update_lock: protect concurrency between interrupt-based and delayed work
+ * status update
  */
 struct sdw_cdns {
 	struct device *dev;
@@ -148,10 +150,13 @@ struct sdw_cdns {
 	bool interrupt_enabled;
 
 	struct work_struct work;
+	struct delayed_work attach_dwork;
 
 	struct list_head list;
 
 	struct sdw_cdns_dai_runtime **dai_runtime_array;
+
+	struct mutex status_update_lock; /* add mutual exclusion to sdw_handle_slave_status() */
 };
 
 #define bus_to_cdns(_bus) container_of(_bus, struct sdw_cdns, bus)
diff --git a/drivers/soundwire/intel.h b/drivers/soundwire/intel.h
index 68838e843b543..f4235f5991c37 100644
--- a/drivers/soundwire/intel.h
+++ b/drivers/soundwire/intel.h
@@ -103,6 +103,8 @@ static inline void intel_writew(void __iomem *base, int offset, u16 value)
 
 #define INTEL_MASTER_RESET_ITERATIONS	10
 
+#define SDW_INTEL_DELAYED_ENUMERATION_MS	100
+
 #define SDW_INTEL_CHECK_OPS(sdw, cb)	((sdw) && (sdw)->link_res && (sdw)->link_res->hw_ops && \
 					 (sdw)->link_res->hw_ops->cb)
 #define SDW_INTEL_OPS(sdw, cb)		((sdw)->link_res->hw_ops->cb)
diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 8807e01cbf7c7..dff49c5ce5b30 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -475,6 +475,7 @@ static void intel_link_remove(struct auxiliary_device *auxdev)
 	 */
 	if (!bus->prop.hw_disabled) {
 		sdw_intel_debugfs_exit(sdw);
+		cancel_delayed_work_sync(&cdns->attach_dwork);
 		sdw_cdns_enable_interrupt(cdns, false);
 	}
 	sdw_bus_master_delete(bus);
diff --git a/drivers/soundwire/intel_bus_common.c b/drivers/soundwire/intel_bus_common.c
index a75e5d7d87154..d3ff6c65b64c3 100644
--- a/drivers/soundwire/intel_bus_common.c
+++ b/drivers/soundwire/intel_bus_common.c
@@ -60,6 +60,9 @@ int intel_start_bus(struct sdw_intel *sdw)
 	sdw_cdns_check_self_clearing_bits(cdns, __func__,
 					  true, INTEL_MASTER_RESET_ITERATIONS);
 
+	schedule_delayed_work(&cdns->attach_dwork,
+			      msecs_to_jiffies(SDW_INTEL_DELAYED_ENUMERATION_MS));
+
 	return 0;
 }
 
@@ -151,6 +154,9 @@ int intel_start_bus_after_reset(struct sdw_intel *sdw)
 	}
 	sdw_cdns_check_self_clearing_bits(cdns, __func__, true, INTEL_MASTER_RESET_ITERATIONS);
 
+	schedule_delayed_work(&cdns->attach_dwork,
+			      msecs_to_jiffies(SDW_INTEL_DELAYED_ENUMERATION_MS));
+
 	return 0;
 }
 
@@ -184,6 +190,9 @@ int intel_start_bus_after_clock_stop(struct sdw_intel *sdw)
 
 	sdw_cdns_check_self_clearing_bits(cdns, __func__, true, INTEL_MASTER_RESET_ITERATIONS);
 
+	schedule_delayed_work(&cdns->attach_dwork,
+			      msecs_to_jiffies(SDW_INTEL_DELAYED_ENUMERATION_MS));
+
 	return 0;
 }
 
@@ -194,6 +203,8 @@ int intel_stop_bus(struct sdw_intel *sdw, bool clock_stop)
 	bool wake_enable = false;
 	int ret;
 
+	cancel_delayed_work_sync(&cdns->attach_dwork);
+
 	if (clock_stop) {
 		ret = sdw_cdns_clock_stop(cdns, true);
 		if (ret < 0)
-- 
2.43.0



