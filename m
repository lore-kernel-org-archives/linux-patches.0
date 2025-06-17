Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FC42EF657;
	Tue, 17 Jun 2025 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175646; cv=none; b=jHkBLoW3hP2ey/GgOrUaGJ4IzFXbHVizfpOkg3pGFTykg+2gytpxhakKa+RUTL2ElkohPIQBpKBsh7xnwX18ul8O4JuC5RhDPrHJLm71elVlzj+lyePH0EDN2rCNSYeR9mwY9hHSYk6ZoTfbIT3cVkS4eL8opab2LJZuPzTCWIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175646; c=relaxed/simple;
	bh=cYOty/x+VNZHPTkVCQbrSmk7fAqIRDHS5xyZF8+fMSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IENIs41Hm5WBtgVScyVwiaE0JP2FELjDMDVqSgb5wc+53+qu7FZkKj8cYTpLunyLxdNDf0MJNK524LFR3DTalQ47KTRMFhs8uE4vMA7ff/W/eIZ4TD4K6naEuIuRQqy+hckzmrGthr3JKiBEpOPZ/UrYvyvJj7uAGoFXn0Ltp7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2O9btZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2O9btZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7845FC4CEE3;
	Tue, 17 Jun 2025 15:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175645;
	bh=cYOty/x+VNZHPTkVCQbrSmk7fAqIRDHS5xyZF8+fMSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2O9btZG/ThYfKBqHMO9x8OA31C8+6e8i0Y6tpjU0dHSLZJgfXC2/hs7nw2AnIAVS
	 I9hDWlC7lPZ48Q2jYFXwT+m/m90EVj8PbMgp4gmNbHuVl8XqUurIdYJbk7nWjRVOd8
	 fwqgBH+FE06h3E0l+HNsFJhtJ8+1mot9K5P97BQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 109/780] accel/amdxdna: Fix incorrect size of ERT_START_NPU commands
Date: Tue, 17 Jun 2025 17:16:57 +0200
Message-ID: <20250617152455.946817997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 6c161732ea6467c6dea0c35810ca8e8d1ae135f1 ]

When multiple ERT_START_NPU commands are combined in one buffer, the
buffer size calculation is incorrect. Also, the condition to make sure
the buffer size is not beyond 4K is also fixed.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250409210013.10854-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_message.c  |  6 +++---
 drivers/accel/amdxdna/aie2_msg_priv.h | 10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index bf4219e32cc19..82412eec9a4b8 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -525,7 +525,7 @@ aie2_cmdlist_fill_one_slot_cf(void *cmd_buf, u32 offset,
 	if (!payload)
 		return -EINVAL;
 
-	if (!slot_cf_has_space(offset, payload_len))
+	if (!slot_has_space(*buf, offset, payload_len))
 		return -ENOSPC;
 
 	buf->cu_idx = cu_idx;
@@ -558,7 +558,7 @@ aie2_cmdlist_fill_one_slot_dpu(void *cmd_buf, u32 offset,
 	if (payload_len < sizeof(*sn) || arg_sz > MAX_DPU_ARGS_SIZE)
 		return -EINVAL;
 
-	if (!slot_dpu_has_space(offset, arg_sz))
+	if (!slot_has_space(*buf, offset, arg_sz))
 		return -ENOSPC;
 
 	buf->inst_buf_addr = sn->buffer;
@@ -569,7 +569,7 @@ aie2_cmdlist_fill_one_slot_dpu(void *cmd_buf, u32 offset,
 	memcpy(buf->args, sn->prop_args, arg_sz);
 
 	/* Accurate buf size to hint firmware to do necessary copy */
-	*size += sizeof(*buf) + arg_sz;
+	*size = sizeof(*buf) + arg_sz;
 	return 0;
 }
 
diff --git a/drivers/accel/amdxdna/aie2_msg_priv.h b/drivers/accel/amdxdna/aie2_msg_priv.h
index 4e02e744b470e..6df9065b13f68 100644
--- a/drivers/accel/amdxdna/aie2_msg_priv.h
+++ b/drivers/accel/amdxdna/aie2_msg_priv.h
@@ -319,18 +319,16 @@ struct async_event_msg_resp {
 } __packed;
 
 #define MAX_CHAIN_CMDBUF_SIZE SZ_4K
-#define slot_cf_has_space(offset, payload_size) \
-	(MAX_CHAIN_CMDBUF_SIZE - ((offset) + (payload_size)) > \
-	 offsetof(struct cmd_chain_slot_execbuf_cf, args[0]))
+#define slot_has_space(slot, offset, payload_size)		\
+	(MAX_CHAIN_CMDBUF_SIZE >= (offset) + (payload_size) +	\
+	 sizeof(typeof(slot)))
+
 struct cmd_chain_slot_execbuf_cf {
 	__u32 cu_idx;
 	__u32 arg_cnt;
 	__u32 args[] __counted_by(arg_cnt);
 };
 
-#define slot_dpu_has_space(offset, payload_size) \
-	(MAX_CHAIN_CMDBUF_SIZE - ((offset) + (payload_size)) > \
-	 offsetof(struct cmd_chain_slot_dpu, args[0]))
 struct cmd_chain_slot_dpu {
 	__u64 inst_buf_addr;
 	__u32 inst_size;
-- 
2.39.5



