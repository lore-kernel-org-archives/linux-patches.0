Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96B23B05A2;
	Thu, 30 Jul 2026 15:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425127; cv=none; b=aB1uLfRgxnJLDLOGdz95jPC59Yr7parZNWUtLpFV0p2UnwP6C6QxumM93wXvzQYuFDT+vnOO/KVIYY7gOwR3UzwrCy81OqSoLz/C4EDa4YjaelXAxdJThasWLSqLFmPE79IBRt/Foh82519IXm9soZiVEWrJoAnMOknj/lZLg+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425127; c=relaxed/simple;
	bh=os48SXcwdVPCWebP8WqdpCjqwjywWyXX50o8pBfqf0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q53nN4vBxFSUISe6X1g7e4g2gDdeeQL2fUIF9TIdrvGwkrOtytxsn2ErKdf3X7u3Uo84rdH5Tf9a96SufzFdl+9AUe46CH197hfO8yyd6WNdozTspLIE1S9+O9qLAzzFw2VLVL9j2OWMi6ybbbON3vnn+c8OtFYSMWSrRQfoVkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/ZUWfD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/ZUWfD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105831F000E9;
	Thu, 30 Jul 2026 15:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425126;
	bh=Q5IlBD8mvm5hSLCL09BbjQ8hYszhSiodsI3dRMIFnOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/ZUWfD5fgeyKgAl6YXwwWbzE8ODPceDn4y64AkXxRcJdh6vWr9KZu8JmlAJn7YfX
	 9RNxsCrnS2s6aXSb28wV/BEpzTSGKV/DaeDQUwOOxNqb0uBgHWm/nI+FHR7Mia0H0a
	 8aovDomqEAVNkQYBJMoaQRkwQWRCclBL5yTXgjp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Michal Simek <michal.simek@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 633/675] remoteproc: xlnx: Check remote core state
Date: Thu, 30 Jul 2026 16:16:03 +0200
Message-ID: <20260730141458.580298201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit a48df51d23138388900995add2854cda4aa68e55 ]

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
[ replaced the unavailable zynqmp_pm_get_node_status() helper with a direct zynqmp_pm_invoke_fn() call and exported it for modular builds. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/xilinx/zynqmp.c        |    1 
 drivers/remoteproc/xlnx_r5_remoteproc.c |   50 +++++++++++++++++++++++++-------
 include/linux/firmware/xlnx-zynqmp.h    |   13 ++++++++
 3 files changed, 54 insertions(+), 10 deletions(-)

--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -461,6 +461,7 @@ int zynqmp_pm_invoke_fn(u32 pm_api_id, u
 	return do_fw_call(ret_payload, 8, smc_arg[0], smc_arg[1], smc_arg[2], smc_arg[3],
 			  smc_arg[4], smc_arg[5], smc_arg[6], smc_arg[7]);
 }
+EXPORT_SYMBOL_GPL(zynqmp_pm_invoke_fn);
 
 static u32 pm_api_version;
 static u32 pm_tz_version;
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -959,16 +959,6 @@ static struct zynqmp_r5_core *zynqmp_r5_
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
 
@@ -1221,6 +1211,7 @@ static int zynqmp_r5_core_init(struct zy
 {
 	struct device *dev = cluster->dev;
 	struct zynqmp_r5_core *r5_core;
+	u32 payload[PAYLOAD_ARG_CNT];
 	int ret = -EINVAL, i;
 
 	r5_core = cluster->r5_cores[0];
@@ -1266,6 +1257,45 @@ static int zynqmp_r5_core_init(struct zy
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
+		ret = zynqmp_pm_feature(PM_GET_NODE_STATUS);
+		if (ret < PM_API_VERSION_2)
+			ret = -EOPNOTSUPP;
+		else
+			ret = zynqmp_pm_invoke_fn(PM_GET_NODE_STATUS, payload, 1,
+						  r5_core->pm_domain_id);
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
+		if (payload[1] == PM_NODE_RUNNING) {
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
@@ -164,6 +164,7 @@ enum pm_api_cb_id {
 enum pm_api_id {
 	PM_API_FEATURES = 0,
 	PM_GET_API_VERSION = 1,
+	PM_GET_NODE_STATUS = 3,
 	PM_REGISTER_NOTIFIER = 5,
 	PM_FORCE_POWERDOWN = 8,
 	PM_REQUEST_WAKEUP = 10,
@@ -545,6 +546,18 @@ enum pm_gem_config_type {
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


