Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CACF146D53;
	Wed, 28 Jan 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615895; cv=none; b=AIRtv4l+IgyvtexK4Kf/8bzCTB2cOHuE0jByhp4cebEzCoQ+nQwDWsoV/xp53Ea3jv0GCOG9krcn5IrRjg73B2hjLiXCpzvW3QcHKRFSVBLXahnBNEA4KRE2yPsAs0Xh085RuxfeRAyXuCadMJE09eRiJPbgTWSI782zMy50WAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615895; c=relaxed/simple;
	bh=PzGJxdZS05MHU366gbiqvgRULcrtQJGkzSNzz7XvYjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw8y2PhiGDj7ygyrT0euPlla0x4U1mNFZ9g9g/mbvJnrBqvsSsy7ExleqRnjLh4uoFRFl8E6zW7Dak29gKuhsfYQCZ/rLxJwGqWofUX3JurWN/JozSzKum696JkyPN/xRzT9xiqH1Kya7eAaJu9lYvlxeCUEp6w+9YskyK2mz8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWc3Mowc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWc3Mowc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94ECC4CEF1;
	Wed, 28 Jan 2026 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615895;
	bh=PzGJxdZS05MHU366gbiqvgRULcrtQJGkzSNzz7XvYjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWc3Mowc67XwYoHkj7ENPSc6TQ/45dE7f8ijHOeR4wAjPuNVNCU2FjVOwH30ncGPr
	 dt86IiHEKHUnYaiUdX8ckJaUgTF5jgBey7q0I2i0HQFqpITbtxnCAGeF+D0sx5F7ec
	 F5YLWhCe2BrHsrT5x0YCC+/KZbkGLm8uMD+axEl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yikai <zhuyikai1@h-partners.com>,
	Fan Gong <gongfan1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/227] hinic3: Fix netif_queue_set_napi queue_index input parameter error
Date: Wed, 28 Jan 2026 16:23:11 +0100
Message-ID: <20260128145349.711949061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Fan Gong <gongfan1@huawei.com>

[ Upstream commit fb2bb2a1ebf7b9514c32b03bb5c3be5d518d437b ]

Incorrectly transmitted interrupt number instead of queue number
when using netif_queue_set_napi. Besides, move this to appropriate
code location to set napi.

Remove redundant netif_stop_subqueue beacuase it is not part of the
hinic3_send_one_skb process.

Fixes: 17fcb3dc12bb ("hinic3: module initialization and tx/rx logic")
Co-developed-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Fan Gong <gongfan1@huawei.com>
Link: https://patch.msgid.link/7b8e4eb5c53cbd873ee9aaefeb3d9dbbaff52deb.1769070766.git.zhuyikai1@h-partners.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic3/hinic3_irq.c   | 22 +++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c b/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
index a69b361225e90..84bee5d6e638e 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
@@ -43,21 +43,12 @@ static void qp_add_napi(struct hinic3_irq_cfg *irq_cfg)
 	struct hinic3_nic_dev *nic_dev = netdev_priv(irq_cfg->netdev);
 
 	netif_napi_add(nic_dev->netdev, &irq_cfg->napi, hinic3_poll);
-	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
-			     NETDEV_QUEUE_TYPE_RX, &irq_cfg->napi);
-	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
-			     NETDEV_QUEUE_TYPE_TX, &irq_cfg->napi);
 	napi_enable(&irq_cfg->napi);
 }
 
 static void qp_del_napi(struct hinic3_irq_cfg *irq_cfg)
 {
 	napi_disable(&irq_cfg->napi);
-	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
-			     NETDEV_QUEUE_TYPE_RX, NULL);
-	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
-			     NETDEV_QUEUE_TYPE_TX, NULL);
-	netif_stop_subqueue(irq_cfg->netdev, irq_cfg->irq_id);
 	netif_napi_del(&irq_cfg->napi);
 }
 
@@ -150,6 +141,11 @@ int hinic3_qps_irq_init(struct net_device *netdev)
 			goto err_release_irqs;
 		}
 
+		netif_queue_set_napi(irq_cfg->netdev, q_id,
+				     NETDEV_QUEUE_TYPE_RX, &irq_cfg->napi);
+		netif_queue_set_napi(irq_cfg->netdev, q_id,
+				     NETDEV_QUEUE_TYPE_TX, &irq_cfg->napi);
+
 		hinic3_set_msix_auto_mask_state(nic_dev->hwdev,
 						irq_cfg->msix_entry_idx,
 						HINIC3_SET_MSIX_AUTO_MASK);
@@ -164,6 +160,10 @@ int hinic3_qps_irq_init(struct net_device *netdev)
 		q_id--;
 		irq_cfg = &nic_dev->q_params.irq_cfg[q_id];
 		qp_del_napi(irq_cfg);
+		netif_queue_set_napi(irq_cfg->netdev, q_id,
+				     NETDEV_QUEUE_TYPE_RX, NULL);
+		netif_queue_set_napi(irq_cfg->netdev, q_id,
+				     NETDEV_QUEUE_TYPE_TX, NULL);
 		hinic3_set_msix_state(nic_dev->hwdev, irq_cfg->msix_entry_idx,
 				      HINIC3_MSIX_DISABLE);
 		hinic3_set_msix_auto_mask_state(nic_dev->hwdev,
@@ -184,6 +184,10 @@ void hinic3_qps_irq_uninit(struct net_device *netdev)
 	for (q_id = 0; q_id < nic_dev->q_params.num_qps; q_id++) {
 		irq_cfg = &nic_dev->q_params.irq_cfg[q_id];
 		qp_del_napi(irq_cfg);
+		netif_queue_set_napi(irq_cfg->netdev, q_id,
+				     NETDEV_QUEUE_TYPE_RX, NULL);
+		netif_queue_set_napi(irq_cfg->netdev, q_id,
+				     NETDEV_QUEUE_TYPE_TX, NULL);
 		hinic3_set_msix_state(nic_dev->hwdev, irq_cfg->msix_entry_idx,
 				      HINIC3_MSIX_DISABLE);
 		hinic3_set_msix_auto_mask_state(nic_dev->hwdev,
-- 
2.51.0



