Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B812242D9B;
	Wed, 25 Feb 2026 01:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983042; cv=none; b=h6Y8WR3JDRq1SiCKfH+HXQmRLF3KeDSzTyYpz5cot0PbzDYT1lVWoEuc5iHGQ8uC01Jj3wOXDt4uA6BsVT96SCMcP5j4ancZKPNxNVZD25QN1B+A1KuhnVJWUsjl5mc6ftNSsHLRwLKyVsFvREJ6gsqwRP6++MsNaZmiUP8UiK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983042; c=relaxed/simple;
	bh=RxRYDHC+F5Bf0FxwN6eoaBSsY/sOou2hCNYwrwP08+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOLiudXGNuDsG4Q0N5hqvhx2YQZDOt+c9fJ5TClqvfGVZboe9+vpGbqiSQL9Mhzvdu5LwvWpnhBXMMU+5q2nzMAIVuYnWJL8BSoOkI7NSPbX7ylb0BxWcUYW1p5cekKQxorkfUBNmxeNKy+Z1r6xpuDvH6PNbjiBH6qs99uEM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH5yJLHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH5yJLHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A6DC116D0;
	Wed, 25 Feb 2026 01:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983042;
	bh=RxRYDHC+F5Bf0FxwN6eoaBSsY/sOou2hCNYwrwP08+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH5yJLHRidZ+HVRO38VV4d7anN+7780GxRZZz0jLpk5n+2y/4XdG2tlrZwLINBqOC
	 vbWFeqNHpsp6WR2Jd+16jjM6+e8+QdWGuMOVMxxMI45vod1pHZLttrrC2jIEywcN9A
	 EdIG7jQRDVQUbdxxR9PCvb3v9nYzCgHgviNBfuZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 205/781] accel/amdxdna: Fix cu_idx being cleared by memset() during command setup
Date: Tue, 24 Feb 2026 17:15:14 -0800
Message-ID: <20260225012404.745719856@linuxfoundation.org>
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

[ Upstream commit 3d32eb7a5ecff92d83a5fd34c45c171c17d3d5d0 ]

For one command type, cu_idx is assigned before calling memset() on the
command structure. This results in cu_idx being overwritten, causing the
firmware to receive an incomplete or invalid command and leading to
unexpected command failures.

Fix this by moving the memset() call before initializing cu_idx so that
all fields are populated in the correct order.

Fixes: 71829d7f2f70 ("accel/amdxdna: Use MSG_OP_CHAIN_EXEC_NPU when supported")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251209211639.1636888-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_message.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index 18cf8e49ea94d..e64dc3152c884 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -645,6 +645,7 @@ aie2_cmdlist_fill_npu_cf(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t *siz
 	u32 cmd_len;
 	void *cmd;
 
+	memset(npu_slot, 0, sizeof(*npu_slot));
 	cmd = amdxdna_cmd_get_payload(cmd_bo, &cmd_len);
 	if (*size < sizeof(*npu_slot) + cmd_len)
 		return -EINVAL;
@@ -653,7 +654,6 @@ aie2_cmdlist_fill_npu_cf(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t *siz
 	if (npu_slot->cu_idx == INVALID_CU_IDX)
 		return -EINVAL;
 
-	memset(npu_slot, 0, sizeof(*npu_slot));
 	npu_slot->type = EXEC_NPU_TYPE_NON_ELF;
 	npu_slot->arg_cnt = cmd_len / sizeof(u32);
 	memcpy(npu_slot->args, cmd, cmd_len);
@@ -670,6 +670,7 @@ aie2_cmdlist_fill_npu_dpu(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t *si
 	u32 cmd_len;
 	u32 arg_sz;
 
+	memset(npu_slot, 0, sizeof(*npu_slot));
 	sn = amdxdna_cmd_get_payload(cmd_bo, &cmd_len);
 	arg_sz = cmd_len - sizeof(*sn);
 	if (cmd_len < sizeof(*sn) || arg_sz > MAX_NPU_ARGS_SIZE)
@@ -682,7 +683,6 @@ aie2_cmdlist_fill_npu_dpu(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t *si
 	if (npu_slot->cu_idx == INVALID_CU_IDX)
 		return -EINVAL;
 
-	memset(npu_slot, 0, sizeof(*npu_slot));
 	npu_slot->type = EXEC_NPU_TYPE_PARTIAL_ELF;
 	npu_slot->inst_buf_addr = sn->buffer;
 	npu_slot->inst_size = sn->buffer_size;
@@ -702,6 +702,7 @@ aie2_cmdlist_fill_npu_preempt(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t
 	u32 cmd_len;
 	u32 arg_sz;
 
+	memset(npu_slot, 0, sizeof(*npu_slot));
 	pd = amdxdna_cmd_get_payload(cmd_bo, &cmd_len);
 	arg_sz = cmd_len - sizeof(*pd);
 	if (cmd_len < sizeof(*pd) || arg_sz > MAX_NPU_ARGS_SIZE)
@@ -714,7 +715,6 @@ aie2_cmdlist_fill_npu_preempt(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t
 	if (npu_slot->cu_idx == INVALID_CU_IDX)
 		return -EINVAL;
 
-	memset(npu_slot, 0, sizeof(*npu_slot));
 	npu_slot->type = EXEC_NPU_TYPE_PREEMPT;
 	npu_slot->inst_buf_addr = pd->inst_buf;
 	npu_slot->save_buf_addr = pd->save_buf;
@@ -738,6 +738,7 @@ aie2_cmdlist_fill_npu_elf(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t *si
 	u32 cmd_len;
 	u32 arg_sz;
 
+	memset(npu_slot, 0, sizeof(*npu_slot));
 	pd = amdxdna_cmd_get_payload(cmd_bo, &cmd_len);
 	arg_sz = cmd_len - sizeof(*pd);
 	if (cmd_len < sizeof(*pd) || arg_sz > MAX_NPU_ARGS_SIZE)
@@ -746,7 +747,6 @@ aie2_cmdlist_fill_npu_elf(struct amdxdna_gem_obj *cmd_bo, void *slot, size_t *si
 	if (*size < sizeof(*npu_slot) + arg_sz)
 		return -EINVAL;
 
-	memset(npu_slot, 0, sizeof(*npu_slot));
 	npu_slot->type = EXEC_NPU_TYPE_ELF;
 	npu_slot->inst_buf_addr = pd->inst_buf;
 	npu_slot->save_buf_addr = pd->save_buf;
-- 
2.51.0



