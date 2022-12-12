Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A1A28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71512C433D2;
	Mon, 12 Dec 2022 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852813;
	bh=28A9aXTqdeI0yQmARiaBRORW/ztIrUyXmih2nzNuaBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOQl3J2NMAhY662Ti7ue6vlAjT8eoWSFgedq9Kzn9AjBIJrOl+iKEomiVPlvE8ovc
	 RKQjU0b2vWqHaBVs5QnwvjiFEQM+pBh2nejEAGmV0EzdWuZM5efNkwB+XXgtmZFkQ8
	 r1nO66sBgwHUXEjd3+O9gi7sfS+dCddL0BpzRrjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 147/157] dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()
Date: Mon, 12 Dec 2022 14:18:15 +0100
Message-Id: <20221212130941.092517258@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 4fad22a1281c500f15b172c9d261eff347ca634b ]

The cmd_buff needs to be freed when error happened in
dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove().

Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221205061515.115012-1-yuancan@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..c39b866e2582 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
@@ -172,6 +174,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -182,6 +185,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
-- 
2.35.1



