Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0717E4236C;
	Mon, 18 Dec 2023 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBoOEIp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9E5C433C7;
	Mon, 18 Dec 2023 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908097;
	bh=MjEAl+zyHv05YTazkWyvYpA79JAYaR71Bg0h1nxgkCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBoOEIp/iX59tICXalD4B1/BiXOvG/PDfjZ0ZlqrHfee5EGhCU2ByPlPJPY2MorQw
	 9ieONs4sGj3kGCnrxfMjMV8fzy4c1Mp2uXKsPiZytx1NtNLq9zLgT64mTDTqTieoBV
	 DvSFEc1CEP+4EQz1EmotNo5hXTd44yHpWLqsz7iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/166] dpaa2-switch: fix size of the dma_unmap
Date: Mon, 18 Dec 2023 14:50:17 +0100
Message-ID: <20231218135107.297174795@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 2aad7d4189a923b24efa8ea6ad09059882b1bfe4 ]

The size of the DMA unmap was wrongly put as a sizeof of a pointer.
Change the value of the DMA unmap to be the actual macro used for the
allocation and the DMA map.

Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20231212164326.2753457-2-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index 4798fb7fe35d1..b6a534a3e0b12 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -139,7 +139,8 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 	err = dpsw_acl_add_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				 filter_block->acl_id, acl_entry_cfg);
 
-	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
+	dma_unmap_single(dev, acl_entry_cfg->key_iova,
+			 DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
@@ -181,8 +182,8 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 	err = dpsw_acl_remove_entry(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    block->acl_id, acl_entry_cfg);
 
-	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
-			 DMA_TO_DEVICE);
+	dma_unmap_single(dev, acl_entry_cfg->key_iova,
+			 DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE, DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
 		kfree(cmd_buff);
-- 
2.43.0



