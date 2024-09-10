Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC191885A6;
	Tue, 10 Sep 2024 09:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962058; cv=none; b=gcHGOezdlUCIVJfsqye7wnXmsqX5hcSGU6FDmY34A4R+E29Kj6jzRR+6vGXfzKTzBN6+0mSGFGUEzRfyC8udR+QEbupx7A6xn43R5FTbxuFOayAuwIPzgHNTQDAN58F6QUj+bPDqbLQ2g2+E9Py47t14tKuJATJhwg2Rqn5oqFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962058; c=relaxed/simple;
	bh=QZSk8L0OVbuKpb7COSVYaSghHmOyFheJTPlksjFkLfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvxTDP5dlH3FuhQVEj8DUTRCigwVRVx2hS3ZMxwAUsEHq2e61Z4IfIdKjionM+anQdzrgtUFDBJBo3x+F/dzbf0fH2tZRm6CUUjiybdrH4imwaL+fG8QZnTGUxVxSwFqA4e8VCRFXO+x3Llqq10QDTHp1Iw5dFcxEiEKxOokfcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DclTbkXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DclTbkXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E34DC4CEC3;
	Tue, 10 Sep 2024 09:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962057;
	bh=QZSk8L0OVbuKpb7COSVYaSghHmOyFheJTPlksjFkLfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DclTbkXGeyDR0fRfhM208NCMa+2Lfj/Ka7siT1/sBMuGZ6QfPlJzJjO/krrSYv2+n
	 RjwljHrNy/3UZOOHysPeg+dxnntVrghphzEaGJTj4Jv9vupC6dPCkX97KDB2OMK7yi
	 VN8vLuL9FIzzPSCc9YpxtxQEXVNZg5BqBnVbR1N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 253/375] drm/amdgpu: add mutex to protect ras shared memory
Date: Tue, 10 Sep 2024 11:30:50 +0200
Message-ID: <20240910092631.048788711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit b3fb79cda5688a44a423c27b791f5456d801e49c ]

Add mutex to protect ras shared memory.

v2:
  Add TA_RAS_COMMAND__TRIGGER_ERROR command call
  status check.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c    | 123 ++++++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h    |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c |   2 +
 3 files changed, 86 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index b3df27ce7663..ee19af2d20fb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1584,6 +1584,68 @@ static void psp_ras_ta_check_status(struct psp_context *psp)
 	}
 }
 
+static int psp_ras_send_cmd(struct psp_context *psp,
+		enum ras_command cmd_id, void *in, void *out)
+{
+	struct ta_ras_shared_memory *ras_cmd;
+	uint32_t cmd = cmd_id;
+	int ret = 0;
+
+	if (!in)
+		return -EINVAL;
+
+	mutex_lock(&psp->ras_context.mutex);
+	ras_cmd = (struct ta_ras_shared_memory *)psp->ras_context.context.mem_context.shared_buf;
+	memset(ras_cmd, 0, sizeof(struct ta_ras_shared_memory));
+
+	switch (cmd) {
+	case TA_RAS_COMMAND__ENABLE_FEATURES:
+	case TA_RAS_COMMAND__DISABLE_FEATURES:
+		memcpy(&ras_cmd->ras_in_message,
+			in, sizeof(ras_cmd->ras_in_message));
+		break;
+	case TA_RAS_COMMAND__TRIGGER_ERROR:
+		memcpy(&ras_cmd->ras_in_message.trigger_error,
+			in, sizeof(ras_cmd->ras_in_message.trigger_error));
+		break;
+	case TA_RAS_COMMAND__QUERY_ADDRESS:
+		memcpy(&ras_cmd->ras_in_message.address,
+			in, sizeof(ras_cmd->ras_in_message.address));
+		break;
+	default:
+		dev_err(psp->adev->dev, "Invalid ras cmd id: %u\n", cmd);
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	ras_cmd->cmd_id = cmd;
+	ret = psp_ras_invoke(psp, ras_cmd->cmd_id);
+
+	switch (cmd) {
+	case TA_RAS_COMMAND__TRIGGER_ERROR:
+		if (ret || psp->cmd_buf_mem->resp.status)
+			ret = -EINVAL;
+		else if (out)
+			memcpy(out, &ras_cmd->ras_status, sizeof(ras_cmd->ras_status));
+		break;
+	case TA_RAS_COMMAND__QUERY_ADDRESS:
+		if (ret || ras_cmd->ras_status || psp->cmd_buf_mem->resp.status)
+			ret = -EINVAL;
+		else if (out)
+			memcpy(out,
+				&ras_cmd->ras_out_message.address,
+				sizeof(ras_cmd->ras_out_message.address));
+		break;
+	default:
+		break;
+	}
+
+err_out:
+	mutex_unlock(&psp->ras_context.mutex);
+
+	return ret;
+}
+
 int psp_ras_invoke(struct psp_context *psp, uint32_t ta_cmd_id)
 {
 	struct ta_ras_shared_memory *ras_cmd;
@@ -1625,23 +1687,15 @@ int psp_ras_invoke(struct psp_context *psp, uint32_t ta_cmd_id)
 int psp_ras_enable_features(struct psp_context *psp,
 		union ta_ras_cmd_input *info, bool enable)
 {
-	struct ta_ras_shared_memory *ras_cmd;
+	enum ras_command cmd_id;
 	int ret;
 
-	if (!psp->ras_context.context.initialized)
+	if (!psp->ras_context.context.initialized || !info)
 		return -EINVAL;
 
-	ras_cmd = (struct ta_ras_shared_memory *)psp->ras_context.context.mem_context.shared_buf;
-	memset(ras_cmd, 0, sizeof(struct ta_ras_shared_memory));
-
-	if (enable)
-		ras_cmd->cmd_id = TA_RAS_COMMAND__ENABLE_FEATURES;
-	else
-		ras_cmd->cmd_id = TA_RAS_COMMAND__DISABLE_FEATURES;
-
-	ras_cmd->ras_in_message = *info;
-
-	ret = psp_ras_invoke(psp, ras_cmd->cmd_id);
+	cmd_id = enable ?
+		TA_RAS_COMMAND__ENABLE_FEATURES : TA_RAS_COMMAND__DISABLE_FEATURES;
+	ret = psp_ras_send_cmd(psp, cmd_id, info, NULL);
 	if (ret)
 		return -EINVAL;
 
@@ -1665,6 +1719,8 @@ int psp_ras_terminate(struct psp_context *psp)
 
 	psp->ras_context.context.initialized = false;
 
+	mutex_destroy(&psp->ras_context.mutex);
+
 	return ret;
 }
 
@@ -1749,9 +1805,10 @@ int psp_ras_initialize(struct psp_context *psp)
 
 	ret = psp_ta_load(psp, &psp->ras_context.context);
 
-	if (!ret && !ras_cmd->ras_status)
+	if (!ret && !ras_cmd->ras_status) {
 		psp->ras_context.context.initialized = true;
-	else {
+		mutex_init(&psp->ras_context.mutex);
+	} else {
 		if (ras_cmd->ras_status)
 			dev_warn(adev->dev, "RAS Init Status: 0x%X\n", ras_cmd->ras_status);
 
@@ -1765,12 +1822,12 @@ int psp_ras_initialize(struct psp_context *psp)
 int psp_ras_trigger_error(struct psp_context *psp,
 			  struct ta_ras_trigger_error_input *info, uint32_t instance_mask)
 {
-	struct ta_ras_shared_memory *ras_cmd;
 	struct amdgpu_device *adev = psp->adev;
 	int ret;
 	uint32_t dev_mask;
+	uint32_t ras_status = 0;
 
-	if (!psp->ras_context.context.initialized)
+	if (!psp->ras_context.context.initialized || !info)
 		return -EINVAL;
 
 	switch (info->block_id) {
@@ -1794,13 +1851,8 @@ int psp_ras_trigger_error(struct psp_context *psp,
 	dev_mask &= AMDGPU_RAS_INST_MASK;
 	info->sub_block_index |= dev_mask;
 
-	ras_cmd = (struct ta_ras_shared_memory *)psp->ras_context.context.mem_context.shared_buf;
-	memset(ras_cmd, 0, sizeof(struct ta_ras_shared_memory));
-
-	ras_cmd->cmd_id = TA_RAS_COMMAND__TRIGGER_ERROR;
-	ras_cmd->ras_in_message.trigger_error = *info;
-
-	ret = psp_ras_invoke(psp, ras_cmd->cmd_id);
+	ret = psp_ras_send_cmd(psp,
+			TA_RAS_COMMAND__TRIGGER_ERROR, info, &ras_status);
 	if (ret)
 		return -EINVAL;
 
@@ -1810,9 +1862,9 @@ int psp_ras_trigger_error(struct psp_context *psp,
 	if (amdgpu_ras_intr_triggered())
 		return 0;
 
-	if (ras_cmd->ras_status == TA_RAS_STATUS__TEE_ERROR_ACCESS_DENIED)
+	if (ras_status == TA_RAS_STATUS__TEE_ERROR_ACCESS_DENIED)
 		return -EACCES;
-	else if (ras_cmd->ras_status)
+	else if (ras_status)
 		return -EINVAL;
 
 	return 0;
@@ -1822,25 +1874,16 @@ int psp_ras_query_address(struct psp_context *psp,
 			  struct ta_ras_query_address_input *addr_in,
 			  struct ta_ras_query_address_output *addr_out)
 {
-	struct ta_ras_shared_memory *ras_cmd;
 	int ret;
 
-	if (!psp->ras_context.context.initialized)
-		return -EINVAL;
-
-	ras_cmd = (struct ta_ras_shared_memory *)psp->ras_context.context.mem_context.shared_buf;
-	memset(ras_cmd, 0, sizeof(struct ta_ras_shared_memory));
-
-	ras_cmd->cmd_id = TA_RAS_COMMAND__QUERY_ADDRESS;
-	ras_cmd->ras_in_message.address = *addr_in;
-
-	ret = psp_ras_invoke(psp, ras_cmd->cmd_id);
-	if (ret || ras_cmd->ras_status || psp->cmd_buf_mem->resp.status)
+	if (!psp->ras_context.context.initialized ||
+		!addr_in || !addr_out)
 		return -EINVAL;
 
-	*addr_out = ras_cmd->ras_out_message.address;
+	ret = psp_ras_send_cmd(psp,
+			TA_RAS_COMMAND__QUERY_ADDRESS, addr_in, addr_out);
 
-	return 0;
+	return ret;
 }
 // ras end
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index 3635303e6548..74a96516c913 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -200,6 +200,7 @@ struct psp_xgmi_context {
 struct psp_ras_context {
 	struct ta_context		context;
 	struct amdgpu_ras		*ras;
+	struct mutex			mutex;
 };
 
 #define MEM_TRAIN_SYSTEM_SIGNATURE		0x54534942
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index 9aff579c6abf..38face981c3e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -351,6 +351,7 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 
 	context->session_id = ta_id;
 
+	mutex_lock(&psp->ras_context.mutex);
 	ret = prep_ta_mem_context(&context->mem_context, shared_buf, shared_buf_len);
 	if (ret)
 		goto err_free_shared_buf;
@@ -369,6 +370,7 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 		ret = -EFAULT;
 
 err_free_shared_buf:
+	mutex_unlock(&psp->ras_context.mutex);
 	kfree(shared_buf);
 
 	return ret;
-- 
2.43.0



