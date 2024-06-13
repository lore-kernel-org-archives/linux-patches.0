Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BB20ED;
	Thu, 13 Jun 2024 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282675; cv=none; b=eUVZtOkgAxJGY6SY7LRQIip5TsXMJFybGBCwQnSrEcEDLijLP1tMEQWRHh4aPew+wbdZQvE8VgbqFFgTnhBU01Rj2CN1mPWG6kk+oqstmgRseIVQ0ZKVYwiRm8pLc32lw7uR9P0JKawCjJbnMJEvve16GAVmCs0/5/NFBosyeh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282675; c=relaxed/simple;
	bh=dM2dGtJI8dYuGjl0bpPMy6YPrPbRzjX7Iz7aaYDsrm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTp9WX+nf65WeVfeFNjEiRNGH5s8rlWxxSEDA053VMJwxyxPL7ypQ3SBEy/WVwxOIKvRcOCBH3ym3cpituUO/lNtGMxc60XfSwggnx3Jg0rERRvSoW1QTMzYz89Krgh9gBa/9CVcZI6dGePzTcyAiuYyuVMdjTbxJ+L5N0dXAyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3rzzn+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3rzzn+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12926C2BBFC;
	Thu, 13 Jun 2024 12:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282675;
	bh=dM2dGtJI8dYuGjl0bpPMy6YPrPbRzjX7Iz7aaYDsrm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3rzzn+Nbe6/pDc9bYN+N4ZpsJwQG4B3sO0RsAgmRZTK1fh+X549vOaSD0St/YGaJ
	 0lYjq5h6SvxL6+hKezVmcr5HHIelhxgyR/FQzNK5cA7phu53uZVhFDOSYbMPrQy73G
	 utodQLODbjS3eACtUoCFmnKeondkVcSVyPOMVCks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Maulik Shah <quic_mkshah@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [PATCH 5.15 358/402] soc: qcom: rpmh-rsc: Enhance check for VRM in-flight request
Date: Thu, 13 Jun 2024 13:35:15 +0200
Message-ID: <20240613113316.099003851@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <quic_mkshah@quicinc.com>

commit f592cc5794747b81e53b53dd6e80219ee25f0611 upstream.

Each RPMh VRM accelerator resource has 3 or 4 contiguous 4-byte aligned
addresses associated with it. These control voltage, enable state, mode,
and in legacy targets, voltage headroom. The current in-flight request
checking logic looks for exact address matches. Requests for different
addresses of the same RPMh resource as thus not detected as in-flight.

Add new cmd-db API cmd_db_match_resource_addr() to enhance the in-flight
request check for VRM requests by ignoring the address offset.

This ensures that only one request is allowed to be in-flight for a given
VRM resource. This is needed to avoid scenarios where request commands are
carried out by RPMh hardware out-of-order leading to LDO regulator
over-current protection triggering.

Fixes: 658628e7ef78 ("drivers: qcom: rpmh-rsc: add RPMH controller for QCOM SoCs")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Elliot Berman <quic_eberman@quicinc.com> # sm8650-qrd
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Link: https://lore.kernel.org/r/20240215-rpmh-rsc-fixes-v4-1-9cbddfcba05b@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/cmd-db.c   |   32 +++++++++++++++++++++++++++++++-
 drivers/soc/qcom/rpmh-rsc.c |    3 ++-
 include/soc/qcom/cmd-db.h   |   10 +++++++++-
 3 files changed, 42 insertions(+), 3 deletions(-)

--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2016-2018, 2020, The Linux Foundation. All rights reserved. */
+/*
+ * Copyright (c) 2016-2018, 2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2024, Qualcomm Innovation Center, Inc. All rights reserved.
+ */
 
+#include <linux/bitfield.h>
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -17,6 +21,8 @@
 #define MAX_SLV_ID		8
 #define SLAVE_ID_MASK		0x7
 #define SLAVE_ID_SHIFT		16
+#define SLAVE_ID(addr)		FIELD_GET(GENMASK(19, 16), addr)
+#define VRM_ADDR(addr)		FIELD_GET(GENMASK(19, 4), addr)
 
 /**
  * struct entry_header: header for each entry in cmddb
@@ -217,6 +223,30 @@ const void *cmd_db_read_aux_data(const c
 EXPORT_SYMBOL(cmd_db_read_aux_data);
 
 /**
+ * cmd_db_match_resource_addr() - Compare if both Resource addresses are same
+ *
+ * @addr1: Resource address to compare
+ * @addr2: Resource address to compare
+ *
+ * Return: true if two addresses refer to the same resource, false otherwise
+ */
+bool cmd_db_match_resource_addr(u32 addr1, u32 addr2)
+{
+	/*
+	 * Each RPMh VRM accelerator resource has 3 or 4 contiguous 4-byte
+	 * aligned addresses associated with it. Ignore the offset to check
+	 * for VRM requests.
+	 */
+	if (addr1 == addr2)
+		return true;
+	else if (SLAVE_ID(addr1) == CMD_DB_HW_VRM && VRM_ADDR(addr1) == VRM_ADDR(addr2))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(cmd_db_match_resource_addr);
+
+/**
  * cmd_db_read_slave_id - Get the slave ID for a given resource address
  *
  * @id: Resource id to query the DB for version
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2016-2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2023-2024, Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #define pr_fmt(fmt) "%s " fmt, KBUILD_MODNAME
@@ -519,7 +520,7 @@ static int check_for_req_inflight(struct
 		for_each_set_bit(j, &curr_enabled, MAX_CMDS_PER_TCS) {
 			addr = read_tcs_cmd(drv, RSC_DRV_CMD_ADDR, i, j);
 			for (k = 0; k < msg->num_cmds; k++) {
-				if (addr == msg->cmds[k].addr)
+				if (cmd_db_match_resource_addr(msg->cmds[k].addr, addr))
 					return -EBUSY;
 			}
 		}
--- a/include/soc/qcom/cmd-db.h
+++ b/include/soc/qcom/cmd-db.h
@@ -1,5 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2016-2018, The Linux Foundation. All rights reserved. */
+/*
+ * Copyright (c) 2016-2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2024, Qualcomm Innovation Center, Inc. All rights reserved.
+ */
 
 #ifndef __QCOM_COMMAND_DB_H__
 #define __QCOM_COMMAND_DB_H__
@@ -21,6 +24,8 @@ u32 cmd_db_read_addr(const char *resourc
 
 const void *cmd_db_read_aux_data(const char *resource_id, size_t *len);
 
+bool cmd_db_match_resource_addr(u32 addr1, u32 addr2);
+
 enum cmd_db_hw_type cmd_db_read_slave_id(const char *resource_id);
 
 int cmd_db_ready(void);
@@ -31,6 +36,9 @@ static inline u32 cmd_db_read_addr(const
 static inline const void *cmd_db_read_aux_data(const char *resource_id, size_t *len)
 { return ERR_PTR(-ENODEV); }
 
+static inline bool cmd_db_match_resource_addr(u32 addr1, u32 addr2)
+{ return false; }
+
 static inline enum cmd_db_hw_type cmd_db_read_slave_id(const char *resource_id)
 { return -ENODEV; }
 


