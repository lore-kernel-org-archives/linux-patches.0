Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07C337524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302573; cv=none; b=rVmISId80ipRHsx9gYqaXh/C4yGnmLO+x7epf2QKYaO/SkcvZEGyx1Qa2VU2bG7c1H/czHHP0+KXaOFExcKS0UfIqJ3R8z0ewfPsK9SDEuFuwH5X4YoRcFD7hN0XiDHW8cnf5YsI2rJTIZ+oG8IJjKvDdfrUWNtoodWNxgFKQjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302573; c=relaxed/simple;
	bh=2ysli+wQeW2Nd6JamXTdq+he3E97k49b+KljnQJoI+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/UN4iRujsZi2JuOOAooJrDNDLQmqA+ZX+H7hrEqI3eTx+qPMUBOGYcJzeV6v/oW9DmSOjGLKI6ug2gD3nKwHCRgwi9DJkXgReScmsGvGttqeW+k1Di4daGkWfCabFXPu9RvWlqezfUKbQ45gfHFkvDdaKJHrNafhYh6Jph4Wys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9bUXHmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9bUXHmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B396C116D0;
	Sat, 28 Feb 2026 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302573;
	bh=2ysli+wQeW2Nd6JamXTdq+he3E97k49b+KljnQJoI+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9bUXHmgGShO2hUmFVjiv+SJpRgawJOIu3EN/MCFi7im/jg/iWImbm+dw/3DQ8A5W
	 32Dh1DCN3a9WR+UoMvgMBDsf2qpyJ9R3sc3bRjSS0IkRgcLdO1Ub6zdNbPuODmFgB2
	 D0YfeiVW5DtqNXCIyWC7eyCSu2IOSSLS4HiKFuAYHqaLFYSOCbYfKZU480YZmU+l18
	 VzmW03muxGBWHQpeVQnoLy6LmErq5rUlhLpXO8gvEn+3BU/NOmKvsQdtqexe6kENmV
	 B1jcdnVd9Osr+bE1CB9Qdk7bl5VLZkGHGzflcBa+3aSGSzVBQY+/aOm79TVZgEwVgy
	 bEye8qGmA3OlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hao Chen <chenhao288@hisilicon.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/164] net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver
Date: Sat, 28 Feb 2026 13:13:40 -0500
Message-ID: <20260228181505.1600663-81-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit e445f08af2b15035474439fbbb8649f466ad2501 ]

Tx copybreak buf size is used for tx copybreak feature, the feature is
used for small size packet or frag. It adds a queue based tx shared
bounce buffer to memcpy the small packet when the len of xmitted skb is
below tx_copybreak(value to distinguish small size and normal size),
and reduce the overhead of dma map and unmap when IOMMU is on.

Support setting it via ethtool --set-tunable parameter and getting
it via ethtool --get-tunable parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6d2f142b1e4b ("net: hns3: fix double free issue for tx spare buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 56 +++++++++++++++++++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index adc2f1e34e32a..84c724df2e405 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5535,8 +5535,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 	return 0;
 }
 
-static int hns3_reset_notify(struct hnae3_handle *handle,
-			     enum hnae3_reset_notify_type type)
+int hns3_reset_notify(struct hnae3_handle *handle,
+		      enum hnae3_reset_notify_type type)
 {
 	int ret = 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index f3f7f370807f0..83c4b9856e171 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -713,6 +713,8 @@ void hns3_set_vector_coalesce_tx_ql(struct hns3_enet_tqp_vector *tqp_vector,
 				    u32 ql_value);
 
 void hns3_request_update_promisc_mode(struct hnae3_handle *handle);
+int hns3_reset_notify(struct hnae3_handle *handle,
+		      enum hnae3_reset_notify_type type);
 
 #ifdef CONFIG_HNS3_DCB
 void hns3_dcbnl_setup(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index b01ce4fd6bc43..53f6cb3b43664 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1726,6 +1726,7 @@ static int hns3_get_tunable(struct net_device *netdev,
 			    void *data)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
 	int ret = 0;
 
 	switch (tuna->id) {
@@ -1736,6 +1737,9 @@ static int hns3_get_tunable(struct net_device *netdev,
 	case ETHTOOL_RX_COPYBREAK:
 		*(u32 *)data = priv->rx_copybreak;
 		break;
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
+		*(u32 *)data = h->kinfo.tx_spare_buf_size;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1744,11 +1748,43 @@ static int hns3_get_tunable(struct net_device *netdev,
 	return ret;
 }
 
+static int hns3_set_tx_spare_buf_size(struct net_device *netdev,
+				      u32 data)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int ret;
+
+	if (hns3_nic_resetting(netdev))
+		return -EBUSY;
+
+	h->kinfo.tx_spare_buf_size = data;
+
+	ret = hns3_reset_notify(h, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hns3_reset_notify(h, HNAE3_UNINIT_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hns3_reset_notify(h, HNAE3_INIT_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hns3_reset_notify(h, HNAE3_UP_CLIENT);
+	if (ret)
+		hns3_reset_notify(h, HNAE3_UNINIT_CLIENT);
+
+	return ret;
+}
+
 static int hns3_set_tunable(struct net_device *netdev,
 			    const struct ethtool_tunable *tuna,
 			    const void *data)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	u32 old_tx_spare_buf_size, new_tx_spare_buf_size;
 	struct hnae3_handle *h = priv->ae_handle;
 	int i, ret = 0;
 
@@ -1766,6 +1802,26 @@ static int hns3_set_tunable(struct net_device *netdev,
 		for (i = h->kinfo.num_tqps; i < h->kinfo.num_tqps * 2; i++)
 			priv->ring[i].rx_copybreak = priv->rx_copybreak;
 
+		break;
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
+		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
+		new_tx_spare_buf_size = *(u32 *)data;
+		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
+		if (ret) {
+			int ret1;
+
+			netdev_warn(netdev,
+				    "change tx spare buf size fail, revert to old value\n");
+			ret1 = hns3_set_tx_spare_buf_size(netdev,
+							  old_tx_spare_buf_size);
+			if (ret1) {
+				netdev_err(netdev,
+					   "revert to old tx spare buf size fail\n");
+				return ret1;
+			}
+
+			return ret;
+		}
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.51.0

