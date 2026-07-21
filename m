Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E12401A18;
	Tue, 21 Jul 2026 17:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654456; cv=none; b=Pu+MCb1yFvVS62BJCpg5bbGlPh33zdm7O4By7FydyU5uFF3t+6Cb2Q/YeU7CmHJvTV4wjqoyMf22cZEH0/3a8PyOJ0iH2nDMMAOA5iQcDliZ2MN1EG//5mcehSQnVIfAaUsGh6prOTAVZraHJBTcj9Z1PDmf1Q8fu//3olu2gA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654456; c=relaxed/simple;
	bh=3oNeDq9lUyhMuRSbGRjxtJWNUNkniyR06s8l9cI4j2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBk7+cmHgxLuOzaAE2xZPWjcKPczZGI3ZGQ1D7tA27JIzG/WAnxLoJA+LDdcDemaPSkIAJYIdDjf1Fycv4X3gcJYkFrafY11S0ADbpov6H2DYFND43qz11s2sD3/RUTvYORs8gvB2c1dWW1BDgKn4nJ7tgbTtZZ3eDx9Sjx3nzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBhWJ67P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBhWJ67P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1371F000E9;
	Tue, 21 Jul 2026 17:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654455;
	bh=/IW2/STDoCioKO98CaIuDZEdjJlLw3hGhh6wLVk2rPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBhWJ67P5ddf55wyAxv/2oNyFxtTdp/QFO5FUAWJ5RvJHb6SYw2g2Yb+kxBn4ubtl
	 bCZa3+k1MqkbqpiqdnIOVlywD7S2feVAq2OwYit4SvgXqqE8AqpyXq+3SrnfeWS89G
	 O79uTkxUkbUbE9T1+jBmllVzj6XNKa6VUnVIxIqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Michal Simek <michal.simek@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 7.1 1668/2077] remoteproc: xlnx: Check remote core state
Date: Tue, 21 Jul 2026 17:22:21 +0200
Message-ID: <20260721152632.086068843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanmay Shah <tanmay.shah@amd.com>

commit a48df51d23138388900995add2854cda4aa68e55 upstream.

The remote state is set to RPROC_DETACHED if the resource table is found
in the memory. However, this can be wrong if the remote is not started,
but firmware is still loaded in the memory. Use PM_GET_NODE_STATUS call
to the firmware to request the state of the RPU node. If the RPU is
actually out of reset and running, only then move the remote state to
RPROC_DETACHED, otherwise keep the remote state to RPROC_OFFLINE.

Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Fixes: bca4b02ef92e ("remoteproc: xlnx: Add attach detach support")
Reviewed-by: Beleswar Padhi <b-padhi@ti.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260428221855.313752-1-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/xilinx/zynqmp.c        |   28 +++++++++++++++++++
 drivers/remoteproc/xlnx_r5_remoteproc.c |   46 +++++++++++++++++++++++++-------
 include/linux/firmware/xlnx-zynqmp.h    |   21 ++++++++++++++
 3 files changed, 85 insertions(+), 10 deletions(-)

--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1451,6 +1451,34 @@ int zynqmp_pm_get_node_status(const u32
 EXPORT_SYMBOL_GPL(zynqmp_pm_get_node_status);
 
 /**
+ * zynqmp_pm_get_rpu_node_status - PM call to request a RPU node's current power state
+ * @node:		ID of the RPU component or sub-system in question
+ * @status:		Current operating state of the requested RPU node.
+ * @requirements:	Current requirements asserted on the RPU node.
+ * @usage:		Usage information, used for RPU slave nodes only:
+ *			PM_USAGE_NO_MASTER	- No master is currently using
+ *						  the node
+ *			PM_USAGE_CURRENT_MASTER	- Only requesting master is
+ *						  currently using the node
+ *			PM_USAGE_OTHER_MASTER	- Only other masters are
+ *						  currently using the node
+ *			PM_USAGE_BOTH_MASTERS	- Both the current and at least
+ *						  one other master is currently
+ *						  using the node
+ *
+ * Return:		Returns status, either success or error+reason
+ */
+int zynqmp_pm_get_rpu_node_status(const u32 node, u32 *const status,
+				  u32 *const requirements, u32 *const usage)
+{
+	if (zynqmp_pm_feature(PM_GET_NODE_STATUS) < PM_API_VERSION_2)
+		return -EOPNOTSUPP;
+
+	return zynqmp_pm_get_node_status(node, status, requirements, usage);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_get_rpu_node_status);
+
+/**
  * zynqmp_pm_force_pwrdwn - PM call to request for another PU or subsystem to
  *             be powered down forcefully
  * @node:  Node ID of the targeted PU or subsystem
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -948,16 +948,6 @@ static struct zynqmp_r5_core *zynqmp_r5_
 		goto free_rproc;
 	}
 
-	/*
-	 * If firmware is already available in the memory then move rproc state
-	 * to DETACHED. Firmware can be preloaded via debugger or by any other
-	 * agent (processors) in the system.
-	 * If firmware isn't available in the memory and resource table isn't
-	 * found, then rproc state remains OFFLINE.
-	 */
-	if (!zynqmp_r5_get_rsc_table_va(r5_core))
-		r5_rproc->state = RPROC_DETACHED;
-
 	r5_core->rproc = r5_rproc;
 	return r5_core;
 
@@ -1210,6 +1200,7 @@ static int zynqmp_r5_core_init(struct zy
 {
 	struct device *dev = cluster->dev;
 	struct zynqmp_r5_core *r5_core;
+	u32 req, usage, status;
 	int ret = -EINVAL, i;
 
 	r5_core = cluster->r5_cores[0];
@@ -1255,6 +1246,41 @@ static int zynqmp_r5_core_init(struct zy
 		ret = zynqmp_r5_get_sram_banks(r5_core);
 		if (ret)
 			return ret;
+
+		/*
+		 * It is possible that firmware is loaded into the memory, but
+		 * RPU (remote) is not running. In such case, RPU state will be
+		 * moved to RPROC_DETACHED wrongfully. To avoid it first make
+		 * sure RPU is power-on and out of reset before parsing for the
+		 * resource table.
+		 */
+		ret = zynqmp_pm_get_rpu_node_status(r5_core->pm_domain_id,
+						    &status, &req, &usage);
+		if (ret) {
+			dev_warn(r5_core->dev,
+				 "failed to get rpu node status, err %d\n", ret);
+			continue;
+		}
+
+		/*
+		 * If RPU state is power on and out of reset i.e. running, then
+		 * assign RPROC_DETACHED state. If the RPU is not out of reset
+		 * then do not attempt to attach to the remote processor.
+		 */
+		if (status == PM_NODE_RUNNING) {
+			/*
+			 * Not all the firmware that is running on the remote
+			 * core is expected to have the resource table. The
+			 * firmware might not use RPMsg at all, and in that case
+			 * resource table becomes irrelevant. However, we still
+			 * need to make sure that running core is not reported
+			 * as offline. so do not decide remote core state based
+			 * on the resource table availability
+			 */
+			if (zynqmp_r5_get_rsc_table_va(r5_core))
+				dev_dbg(r5_core->dev, "rsc tbl not found\n");
+			r5_core->rproc->state = RPROC_DETACHED;
+		}
 	}
 
 	return 0;
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -543,6 +543,18 @@ enum pm_gem_config_type {
 };
 
 /**
+ * enum pm_node_status - Device node status provided by xilpm fw
+ * @PM_NODE_UNUSED: Device is not used
+ * @PM_NODE_RUNNING: Device is power-on and out of reset
+ * @PM_NODE_HALT: Device is power-on but in the reset state
+ */
+enum pm_node_status {
+	PM_NODE_UNUSED = 0,
+	PM_NODE_RUNNING = 1,
+	PM_NODE_HALT = 12,
+};
+
+/**
  * struct zynqmp_pm_query_data - PM query data
  * @qid:	query ID
  * @arg1:	Argument 1 of query data
@@ -630,6 +642,8 @@ int zynqmp_pm_set_rpu_mode(u32 node_id,
 int zynqmp_pm_set_tcm_config(u32 node_id, enum rpu_tcm_comb tcm_mode);
 int zynqmp_pm_get_node_status(const u32 node, u32 *const status,
 			      u32 *const requirements, u32 *const usage);
+int zynqmp_pm_get_rpu_node_status(const u32 node, u32 *const status,
+				  u32 *const requirements, u32 *const usage);
 int zynqmp_pm_set_sd_config(u32 node, enum pm_sd_config_type config, u32 value);
 int zynqmp_pm_set_gem_config(u32 node, enum pm_gem_config_type config,
 			     u32 value);
@@ -938,6 +952,13 @@ static inline int zynqmp_pm_get_node_sta
 {
 	return -ENODEV;
 }
+
+static inline int zynqmp_pm_get_rpu_node_status(const u32 node, u32 *const status,
+						u32 *const requirements,
+						u32 *const usage)
+{
+	return -ENODEV;
+}
 
 static inline int zynqmp_pm_set_sd_config(u32 node,
 					  enum pm_sd_config_type config,


