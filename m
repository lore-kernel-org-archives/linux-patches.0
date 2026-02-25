Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7596F1D5ABA;
	Wed, 25 Feb 2026 01:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983093; cv=none; b=Bxbui9Q17qhNJXcZNdbxDGjJmkRmcUEEl3h8Ev+pbLol0LdFg3eJsNBjQWd18ynQ5wkFXwKqWEunQP12CrhsdpdAvZqaq7NDXfpxP/6II1c3EA/5ziAcGpMxoVroOniawpviL9pNHR/A5pccDjwafyHeIv68a9du7NduWj4As6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983093; c=relaxed/simple;
	bh=VxmaaNsuHMpPiT4UI0RiUZabBU1K6zGum6H8eYImgDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBfFQDHsdkub9ax44i1eaq7ox3pAmTWgfc9fbIOGp+hDPsv29GE2SgubeBs1TWM1SIdBysnatHfg5xPkpFuYg6j3vkScteZoKj4nJgmYTVUdZEZFdkQR1vQPbVceQjpuiYTDb0qUM8GLjFLFBxPQec9E5t+R3qVM8/Oz29HGJww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0jyZlje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0jyZlje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B616C116D0;
	Wed, 25 Feb 2026 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983093;
	bh=VxmaaNsuHMpPiT4UI0RiUZabBU1K6zGum6H8eYImgDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0jyZljeYoIzF4CeaRJmYsKAIwXfBaHaQW3nxHhXH80yzKHlCU32qG3WOOgsN1c4u
	 IkqZziqCvEFk1SIyCk54EBJc8Q/C6djAGH2scnbQAnvC30CiJqiKNFp/Y4hVK+nkXX
	 hNl65JSM4V1h97TDWeOqciVd01TBEczQJfVevTaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 211/781] accel/amdxdna: Fix potential NULL pointer dereference in context cleanup
Date: Tue, 24 Feb 2026 17:15:20 -0800
Message-ID: <20260225012404.889316985@linuxfoundation.org>
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
 drivers/accel/amdxdna/aie2_message.c | 50 +++++++++++++++-------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index e64dc3152c884..9e55e66830ead 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -185,6 +185,19 @@ int aie2_query_firmware_version(struct amdxdna_dev_hdl *ndev,
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
@@ -207,13 +220,14 @@ int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwct
 		return ret;
 
 	hwctx->fw_ctx_id = resp.context_id;
-	WARN_ONCE(hwctx->fw_ctx_id == -1, "Unexpected context id");
+	if (WARN_ON_ONCE(hwctx->fw_ctx_id == -1))
+		return -EINVAL;
 
 	if (ndev->force_preempt_enabled) {
 		ret = aie2_runtime_cfg(ndev, AIE2_RT_CFG_FORCE_PREEMPT, &hwctx->fw_ctx_id);
 		if (ret) {
 			XDNA_ERR(xdna, "failed to enable force preempt %d", ret);
-			return ret;
+			goto del_ctx_req;
 		}
 	}
 
@@ -230,51 +244,39 @@ int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwct
 
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
 	ndev->hwctx_num++;
 
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
 	return ret;
 }
 
 int aie2_destroy_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwctx)
 {
-	DECLARE_AIE2_MSG(destroy_ctx, MSG_OP_DESTROY_CONTEXT);
 	struct amdxdna_dev *xdna = ndev->xdna;
 	int ret;
 
-	if (hwctx->fw_ctx_id == -1)
-		return 0;
-
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
 	ndev->hwctx_num--;
-- 
2.51.0



