Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED12C36124;
	Wed, 30 Jul 2025 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868404; cv=none; b=futIK1zNtk8p+7VYIQX0EST5kV3PoV62cI4afL91xLjKsVOjq14d+AXiH1BXOEgCUtyss82BjHnhI8U+1q1BB1yJNJ4AMb0Q7OxDDyTNjQNmbzmqpFZQvXvvGJ8o1PQbh9QOXeo0VtsxNhw1lEBc5XAbfezZkkEAAV6gSSo9Xf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868404; c=relaxed/simple;
	bh=xBvIb0I0Pklhm3WLSKDJrOMGSltesO42yF5XDRQvflQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrBv04g6GKH5pqk5vmIZjfxVr/4d3CeMUe+cnq1cIpl0AB5g8cJ85VUOGRag7DhLMGIwL5dfOn1KjBLJyVaCtqc74KMotoAgKbOGhpfzQ5wiN/8MGVFTaWcHRY0/XDx86L29S8gPOKe0AIVuf75/p/S26kiYZByDH/6WSW3zrhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g48Z9+y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g48Z9+y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F4DC4CEE7;
	Wed, 30 Jul 2025 09:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868403;
	bh=xBvIb0I0Pklhm3WLSKDJrOMGSltesO42yF5XDRQvflQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g48Z9+y7qUOD6q5vSMWjDpsjic9saFodkEzqNLJcf606ecdBrTdNjGUsnJ/IEx6up
	 /+Ekrs0KsoGNENWtH6EH4/QdPBzm6mkgBRrxoZkA9oi4R41dwyTnFw2M707nJy4jsm
	 2OENcKYNX6BFzXqkKMEHfVdr1UhCm3nvgm/R5eRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/76] net: hns3: default enable tx bounce buffer when smmu enabled
Date: Wed, 30 Jul 2025 11:35:20 +0200
Message-ID: <20250730093227.894837130@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit e6ab19443b36a45ebfb392775cb17d6a78dd07ea ]

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
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 49ade8630f36 ("net: hns3: default enable tx bounce buffer when smmu enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 31 +++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0ed01f4d68061..dbf44a17987eb 100644
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
@@ -4879,6 +4883,30 @@ static void hns3_nic_dealloc_vector_data(struct hns3_nic_priv *priv)
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
@@ -5113,6 +5141,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 	int i, j;
 	int ret;
 
+	hns3_update_tx_spare_buf_config(priv);
 	for (i = 0; i < ring_num; i++) {
 		ret = hns3_alloc_ring_memory(&priv->ring[i]);
 		if (ret) {
@@ -5317,6 +5346,8 @@ static int hns3_client_init(struct hnae3_handle *handle)
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



