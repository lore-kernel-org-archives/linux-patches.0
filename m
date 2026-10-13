Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E4350128E;
	Tue, 13 Oct 2026 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893224; cv=none; b=o6mJINsXbVeZBOAhkGhvOr2vwgWL/PBkE7F+UUbK/0ZNtpNQxCauteSIyVV0Jevqj5/ynfxu0g6S4loss/TDEUrpeIDyJhLEw3rPun3cbr0pp29OgjRAWTgXyPY3xTWBcB0gOaET1hitT4kAzHvAB4qEu8ITPOCIlhuQKKbHy+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893224; c=relaxed/simple;
	bh=5h0ACzodGo19U2/umggIQn/o1GAE6XopQJmC/e6Jhcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxgskcxDXjIg/zBznpXrvNHt7YksTZUPVKZQJJUJKfhb72NORHSkKcD6atw3Ag7eSjQa1/mtGIVqo44AaHt+KZFpvxu0Uyc9AFL3EdC1DW14O3T++uoT1gTUtNIKbBfz50xVGXBf88wA5f/8f3gBz6g/JR8myIHo2XSkTYuSPm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrnGMzD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrnGMzD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ACE1F0089B;
	Tue, 13 Oct 2026 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893222;
	bh=/7yD94JmxcHxP28Dc4DfJygdftY5rfRMG0VbOytL/HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrnGMzD0Doox7CXlQ7hLCULq/oYkL6iCxJhc3wS0d78aQs7ONbAVIw2AHgvhG0eJz
	 7KD7yLAaVdPlKijJnNRuidiE3CoKQ98Wl6eqwkveUCSAr/RDgC80Mhaa4C2kugOy1L
	 cVOFtVLk/o/X6yjKsuzsiBRXN8Btw4fkbHDHFZTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/621] accel/amdxdna: Fix potential NULL pointer dereference in context cleanup
Date: Tue, 13 Oct 2026 13:32:27 +0200
Message-ID: <20261013112924.461203277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 97f27573837ef96b4ba42af463cc800cab615c0e ]

aie_destroy_context() is invoked during error handling in
aie2_create_context(). However, aie_destroy_context() assumes that the
context's mailbox channel pointer is non-NULL. If mailbox channel
creation fails, the pointer remains NULL and calling aie_destroy_context()
can lead to a NULL pointer dereference.

In aie2_create_context(), replace aie_destroy_context() with a function
which request firmware to remove the context created previously.

Fixes: be462c97b7df ("accel/amdxdna: Add hardware context")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251212183244.1826318-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_message.c | 46 ++++++++++++++++------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index 4660e8297ed80..932d495230511 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -184,6 +184,19 @@ int aie2_query_firmware_version(struct amdxdna_dev_hdl *ndev,
 	return 0;
 }
 
+static int aie2_destroy_context_req(struct amdxdna_dev_hdl *ndev, u32 id)
+{
+	DECLARE_AIE2_MSG(destroy_ctx, MSG_OP_DESTROY_CONTEXT);
+	struct amdxdna_dev *xdna = ndev->xdna;
+	int ret;
+
+	req.context_id = id;
+	ret = aie2_send_mgmt_msg_wait(ndev, &msg);
+	if (ret)
+		XDNA_WARN(xdna, "Destroy context failed, ret %d", ret);
+
+	return ret;
+}
 int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwctx)
 {
 	DECLARE_AIE2_MSG(create_ctx, MSG_OP_CREATE_CONTEXT);
@@ -206,7 +219,8 @@ int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwct
 		return ret;
 
 	hwctx->fw_ctx_id = resp.context_id;
-	WARN_ONCE(hwctx->fw_ctx_id == -1, "Unexpected context id");
+	if (WARN_ON_ONCE(hwctx->fw_ctx_id == -1))
+		return -EINVAL;
 
 	cq_pair = &resp.cq_pair[0];
 	x2i.mb_head_ptr_reg = AIE2_MBOX_OFF(ndev, cq_pair->x2i_q.head_addr);
@@ -221,34 +235,32 @@ int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwct
 
 	ret = pci_irq_vector(to_pci_dev(xdna->ddev.dev), resp.msix_id);
 	if (ret == -EINVAL) {
-		XDNA_ERR(xdna, "not able to create channel");
-		goto out_destroy_context;
+		XDNA_ERR(xdna, "Alloc IRQ failed %d", ret);
+		goto del_ctx_req;
 	}
 
 	intr_reg = i2x.mb_head_ptr_reg + 4;
 	hwctx->priv->mbox_chann = xdna_mailbox_create_channel(ndev->mbox, &x2i, &i2x,
 							      intr_reg, ret);
 	if (!hwctx->priv->mbox_chann) {
-		XDNA_ERR(xdna, "not able to create channel");
+		XDNA_ERR(xdna, "Not able to create channel");
 		ret = -EINVAL;
-		goto out_destroy_context;
+		goto del_ctx_req;
 	}
 
-	XDNA_DBG(xdna, "%s mailbox channel irq: %d, msix_id: %d",
-		 hwctx->name, ret, resp.msix_id);
-	XDNA_DBG(xdna, "%s created fw ctx %d pasid %d", hwctx->name,
-		 hwctx->fw_ctx_id, hwctx->client->pasid);
+	XDNA_DBG(xdna, "Mailbox channel irq: %d, msix_id: %d", ret, resp.msix_id);
+	XDNA_DBG(xdna, "Created fw ctx %d pasid %d", hwctx->fw_ctx_id, hwctx->client->pasid);
 
 	return 0;
 
-out_destroy_context:
-	aie2_destroy_context(ndev, hwctx);
+del_ctx_req:
+	aie2_destroy_context_req(ndev, hwctx->fw_ctx_id);
+	hwctx->fw_ctx_id = -1;
 	return ret;
 }
 
 int aie2_destroy_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwctx)
 {
-	DECLARE_AIE2_MSG(destroy_ctx, MSG_OP_DESTROY_CONTEXT);
 	struct amdxdna_dev *xdna = ndev->xdna;
 	int ret;
 
@@ -256,15 +268,9 @@ int aie2_destroy_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwc
 		return 0;
 
 	xdna_mailbox_stop_channel(hwctx->priv->mbox_chann);
-
-	req.context_id = hwctx->fw_ctx_id;
-	ret = aie2_send_mgmt_msg_wait(ndev, &msg);
-	if (ret)
-		XDNA_WARN(xdna, "%s destroy context failed, ret %d", hwctx->name, ret);
-
+	ret = aie2_destroy_context_req(ndev, hwctx->fw_ctx_id);
 	xdna_mailbox_destroy_channel(hwctx->priv->mbox_chann);
-	XDNA_DBG(xdna, "%s destroyed fw ctx %d", hwctx->name,
-		 hwctx->fw_ctx_id);
+	XDNA_DBG(xdna, "Destroyed fw ctx %d", hwctx->fw_ctx_id);
 	hwctx->priv->mbox_chann = NULL;
 	hwctx->fw_ctx_id = -1;
 
-- 
2.53.0



