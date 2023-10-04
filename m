Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B31D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZ+RXXOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3041CC433C7;
	Wed,  4 Oct 2023 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443970;
	bh=MQ6whh0BML+60GRE9fE0HcZaNM0LfjERTy99hczOhNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZ+RXXOyUBaH2ioxpjDBjePQQ1OEL8HzkR5PVN7f3tiCuR5/G77D8+EKK7Fiqs2yB
	 PXk+66YG5rdLdkYrLul03sRlcC4uXQBiN5G7xBLnz/R4Ov0SYy9NIgbPSEOXrIOvYL
	 gLNrORWwgZ/eJrhMytNumjFQDEE9qa1MwUdGqBAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 083/321] net: hns3: fix GRE checksum offload issue
Date: Wed,  4 Oct 2023 19:53:48 +0200
Message-ID: <20231004175233.052965922@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit f9f651261130cdcb7adc9a3e365b356bc2749ab3 ]

The device_version V3 hardware can't offload the checksum for IP in GRE
packets, but can do it for NvGRE. So default to disable the checksum and
GSO offload for GRE, but keep the ability to enable it when only using
NvGRE.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 613d0a779cef2..71a2ec03f2b38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3352,6 +3352,15 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		  NETIF_F_HW_TC);
 
 	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+
+	/* The device_version V3 hardware can't offload the checksum for IP in
+	 * GRE packets, but can do it for NvGRE. So default to disable the
+	 * checksum and GSO offload for GRE.
+	 */
+	if (ae_dev->dev_version > HNAE3_DEVICE_VERSION_V2) {
+		netdev->features &= ~NETIF_F_GSO_GRE;
+		netdev->features &= ~NETIF_F_GSO_GRE_CSUM;
+	}
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
-- 
2.40.1



