Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E520C012;
	Wed, 25 Feb 2026 01:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983203; cv=none; b=LUT0c5GGKQBuOwBb94SP/oxyq2zjIBgLNfxH73mzQBA3wBFvqzq9aQhntZkh2fL0qyrFoFSkmZgCackbyJ1WqYbDl0rO5K9rSH7a2E12u1GaI4KYbiFZhdk1LdH0erVX3RlGKwPlyYgJGAgnfM1/3FZXC+2h/qazhWpsQUnJVKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983203; c=relaxed/simple;
	bh=bRtmrOf6otwwBF/UuMwrQ1+Aciv1wA9WYyDTUcIVYFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4L/gyoT7NbQFQyWMopPUfqNvxwnqMPMnazcGFTf6EwDs7v7BZ/1BwvqDEa1UwsGdoopslMj8343uCLNd/vS1dGkiLqajRRIoJYR5ZSQTWi1/7G8LjNIq/uWdEnbThcntaWVRi5rsTlmIaqPLuVYpv+gZ8IzmtMO6pFlJHpfOhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsTwCCae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsTwCCae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CFDC19423;
	Wed, 25 Feb 2026 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983203;
	bh=bRtmrOf6otwwBF/UuMwrQ1+Aciv1wA9WYyDTUcIVYFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsTwCCaey7DeefpCyJ1wOTc86pkHnHMciayhnxZDiO8SQl58GcSrNxospTY9vLRwr
	 g+YFuM6xD7yceFOiBpojYjQ2qR7gcZEEej8f2ctI+pT81bqhmXkol+EmQxl3cb8EIL
	 H3KSaGcekqCnhEpE7HqNuTkoMoYDsluFHvYbpnJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 299/781] accel/amdxdna: Enable temporal sharing only mode
Date: Tue, 24 Feb 2026 17:16:48 -0800
Message-ID: <20260225012407.040281904@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 7818618a09a06320f409571bf28801ccfe7e0a30 ]

Newer firmware versions prefer temporal sharing only mode. In this mode,
the driver no longer needs to manage AIE array column allocation. Instead,
a new field, num_unused_col, is added to the hardware context creation
request to specify how many columns will not be used by this hardware
context.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251217191150.2145937-1-lizhi.hou@amd.com
Stable-dep-of: b853007fdcdd ("accel/amdxdna: Remove hardware context status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c      | 18 +++++++++++++++---
 drivers/accel/amdxdna/aie2_message.c  |  1 +
 drivers/accel/amdxdna/aie2_msg_priv.h |  3 ++-
 drivers/accel/amdxdna/aie2_pci.h      |  1 +
 drivers/accel/amdxdna/amdxdna_ctx.h   |  1 +
 drivers/accel/amdxdna/npu4_regs.c     |  1 +
 6 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 2c36ed7e9639c..c4a58c00e442a 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -471,6 +471,12 @@ static int aie2_alloc_resource(struct amdxdna_hwctx *hwctx)
 	struct alloc_requests *xrs_req;
 	int ret;
 
+	if (AIE2_FEATURE_ON(xdna->dev_handle, AIE2_TEMPORAL_ONLY)) {
+		hwctx->num_unused_col = xdna->dev_handle->total_col - hwctx->num_col;
+		hwctx->num_col = xdna->dev_handle->total_col;
+		return aie2_create_context(xdna->dev_handle, hwctx);
+	}
+
 	xrs_req = kzalloc(sizeof(*xrs_req), GFP_KERNEL);
 	if (!xrs_req)
 		return -ENOMEM;
@@ -502,9 +508,15 @@ static void aie2_release_resource(struct amdxdna_hwctx *hwctx)
 	struct amdxdna_dev *xdna = hwctx->client->xdna;
 	int ret;
 
-	ret = xrs_release_resource(xdna->xrs_hdl, (uintptr_t)hwctx);
-	if (ret)
-		XDNA_ERR(xdna, "Release AIE resource failed, ret %d", ret);
+	if (AIE2_FEATURE_ON(xdna->dev_handle, AIE2_TEMPORAL_ONLY)) {
+		ret = aie2_destroy_context(xdna->dev_handle, hwctx);
+		if (ret)
+			XDNA_ERR(xdna, "Destroy temporal only context failed, ret %d", ret);
+	} else {
+		ret = xrs_release_resource(xdna->xrs_hdl, (uintptr_t)hwctx);
+		if (ret)
+			XDNA_ERR(xdna, "Release AIE resource failed, ret %d", ret);
+	}
 }
 
 static int aie2_ctx_syncobj_create(struct amdxdna_hwctx *hwctx)
diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index 9e55e66830ead..273d6af9f6f52 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -211,6 +211,7 @@ int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwct
 	req.aie_type = 1;
 	req.start_col = hwctx->start_col;
 	req.num_col = hwctx->num_col;
+	req.num_unused_col = hwctx->num_unused_col;
 	req.num_cq_pairs_requested = 1;
 	req.pasid = hwctx->client->pasid;
 	req.context_priority = 2;
diff --git a/drivers/accel/amdxdna/aie2_msg_priv.h b/drivers/accel/amdxdna/aie2_msg_priv.h
index 1c957a6298d39..cc912b7899ce5 100644
--- a/drivers/accel/amdxdna/aie2_msg_priv.h
+++ b/drivers/accel/amdxdna/aie2_msg_priv.h
@@ -112,7 +112,8 @@ struct create_ctx_req {
 	__u32	aie_type;
 	__u8	start_col;
 	__u8	num_col;
-	__u16	reserved;
+	__u8    num_unused_col;
+	__u8	reserved;
 	__u8	num_cq_pairs_requested;
 	__u8	reserved1;
 	__u16	pasid;
diff --git a/drivers/accel/amdxdna/aie2_pci.h b/drivers/accel/amdxdna/aie2_pci.h
index e08ec2fd44daa..4fdc032bc171b 100644
--- a/drivers/accel/amdxdna/aie2_pci.h
+++ b/drivers/accel/amdxdna/aie2_pci.h
@@ -231,6 +231,7 @@ struct aie2_hw_ops {
 enum aie2_fw_feature {
 	AIE2_NPU_COMMAND,
 	AIE2_PREEMPT,
+	AIE2_TEMPORAL_ONLY,
 	AIE2_FEATURE_MAX
 };
 
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index b6151244d64fe..b29449a92f607 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -98,6 +98,7 @@ struct amdxdna_hwctx {
 	u32				*col_list;
 	u32				start_col;
 	u32				num_col;
+	u32				num_unused_col;
 #define HWCTX_STAT_INIT  0
 #define HWCTX_STAT_READY 1
 #define HWCTX_STAT_STOP  2
diff --git a/drivers/accel/amdxdna/npu4_regs.c b/drivers/accel/amdxdna/npu4_regs.c
index 986a5f28ba245..2ceedfe583a8c 100644
--- a/drivers/accel/amdxdna/npu4_regs.c
+++ b/drivers/accel/amdxdna/npu4_regs.c
@@ -89,6 +89,7 @@ const struct dpm_clk_freq npu4_dpm_clk_table[] = {
 const struct aie2_fw_feature_tbl npu4_fw_feature_table[] = {
 	{ .feature = AIE2_NPU_COMMAND, .min_minor = 15 },
 	{ .feature = AIE2_PREEMPT, .min_minor = 12 },
+	{ .feature = AIE2_TEMPORAL_ONLY, .min_minor = 12 },
 	{ 0 }
 };
 
-- 
2.51.0



