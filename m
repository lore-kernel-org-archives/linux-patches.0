Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42743594F;
	Wed, 30 Jul 2025 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869117; cv=none; b=nA5xEXcY00oex2gtXLnpkjC8sF4FolLgiUMN97sOav4D5NbrDlG0wmxd09DEkXl/v7tyeW3DixCB7K7cdob6qeRXSEFY7uWYKDsBgoRSTKjOkjN5Cjh0Hzcaj6MpkZdpkqXRDMxiMkJYlUSmQbRvfuU6d4eQQpbTHa6wu36LKM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869117; c=relaxed/simple;
	bh=b3zo+8HX/qYIRFVOICq64hU84oqQjRIW2dvRMqKHWw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSdN2bYgY7sOBWaJ5FyUOt9msnoNbIfkNN5+u0i1SIHRKshP2tH07MZNLj44tj7Mh5lyY/zQDAwNaAY6VFiUN2SrFoKimKxYsUBZQTw6xKVWXWbtfdsyDZPZEPP5jRaUNd1c2VT4kW7ZDJXD0m52WXGXQ2VXlnHRMitc6kor6xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8GzoJ6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8GzoJ6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FF0C4CEF5;
	Wed, 30 Jul 2025 09:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869117;
	bh=b3zo+8HX/qYIRFVOICq64hU84oqQjRIW2dvRMqKHWw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8GzoJ6dGh8Fp8Uf0Jf+XgN+wcMByO1Ad+wasHV2gt+BPrNOV/csPa5+SylN9cwCB
	 hjSYXzGbjHv84v6w/gqTOrAc9oESdtPjXu3QkWSZ45JrbOu+Xkq1k+STuL8EjvHohC
	 X1gacTH82dI17Dax4w9tUZDFMCTAqpnWfyQWZzbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 42/92] net: hns3: default enable tx bounce buffer when smmu enabled
Date: Wed, 30 Jul 2025 11:35:50 +0200
Message-ID: <20250730093232.394719378@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 49ade8630f36e9dca2395592cfb0b7deeb07e746 ]

The SMMU engine on HIP09 chip has a hardware issue.
SMMU pagetable prefetch features may prefetch and use a invalid PTE
even the PTE is valid at that time. This will cause the device trigger
fake pagefaults. The solution is to avoid prefetching by adding a
SYNC command when smmu mapping a iova. But the performance of nic has a
sharp drop. Then we do this workaround, always enable tx bounce buffer,
avoid mapping/unmapping on TX path.

This issue only affects HNS3, so we always enable
tx bounce buffer when smmu enabled to improve performance.

Fixes: 295ba232a8c3 ("net: hns3: add device version to replace pci revision")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722125423.1270673-5-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 31 +++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b03b8758c7774..aaa803563bd2e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/skbuff.h>
@@ -1039,6 +1040,8 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 {
 	u32 alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
+	struct net_device *netdev = ring_to_netdev(ring);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hns3_tx_spare *tx_spare;
 	struct page *page;
 	dma_addr_t dma;
@@ -1080,6 +1083,7 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	tx_spare->buf = page_address(page);
 	tx_spare->len = PAGE_SIZE << order;
 	ring->tx_spare = tx_spare;
+	ring->tx_copybreak = priv->tx_copybreak;
 	return;
 
 dma_mapping_error:
@@ -4874,6 +4878,30 @@ static void hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
 	devm_kfree(&pdev->dev, priv->tqp_vector);
 }
 
+static void hns3_update_tx_spare_buf_config(struct hns3_nic_priv *priv)
+{
+#define HNS3_MIN_SPARE_BUF_SIZE (2 * 1024 * 1024)
+#define HNS3_MAX_PACKET_SIZE (64 * 1024)
+
+	struct iommu_domain *domain = iommu_get_domain_for_dev(priv->dev);
+	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(priv->ae_handle);
+	struct hnae3_handle *handle = priv->ae_handle;
+
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3)
+		return;
+
+	if (!(domain && iommu_is_dma_domain(domain)))
+		return;
+
+	priv->min_tx_copybreak = HNS3_MAX_PACKET_SIZE;
+	priv->min_tx_spare_buf_size = HNS3_MIN_SPARE_BUF_SIZE;
+
+	if (priv->tx_copybreak < priv->min_tx_copybreak)
+		priv->tx_copybreak = priv->min_tx_copybreak;
+	if (handle->kinfo.tx_spare_buf_size < priv->min_tx_spare_buf_size)
+		handle->kinfo.tx_spare_buf_size = priv->min_tx_spare_buf_size;
+}
+
 static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 			      unsigned int ring_type)
 {
@@ -5107,6 +5135,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 	int i, j;
 	int ret;
 
+	hns3_update_tx_spare_buf_config(priv);
 	for (i = 0; i < ring_num; i++) {
 		ret = hns3_alloc_ring_memory(&priv->ring[i]);
 		if (ret) {
@@ -5311,6 +5340,8 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	priv->ae_handle = handle;
 	priv->tx_timeout_count = 0;
 	priv->max_non_tso_bd_num = ae_dev->dev_specs.max_non_tso_bd_num;
+	priv->min_tx_copybreak = 0;
+	priv->min_tx_spare_buf_size = 0;
 	set_bit(HNS3_NIC_STATE_DOWN, &priv->state);
 
 	handle->msg_enable = netif_msg_init(debug, DEFAULT_MSG_LEVEL);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index d36c4ed16d8dd..caf7a4df85852 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -596,6 +596,8 @@ struct hns3_nic_priv {
 	struct hns3_enet_coalesce rx_coal;
 	u32 tx_copybreak;
 	u32 rx_copybreak;
+	u32 min_tx_copybreak;
+	u32 min_tx_spare_buf_size;
 };
 
 union l3_hdr_info {
-- 
2.39.5



