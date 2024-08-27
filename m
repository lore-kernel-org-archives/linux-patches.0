Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEDF1C68A1;
	Tue, 27 Aug 2024 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769947; cv=none; b=YsRf8pisV9y63XgRwSDHKMumlmziVkCUm6TTYtYQseVwYeGKwPbyepgZdfPRbtS1JuRjhVsyshLCZYCQgvpe8SDK8Ac+UgFcHWHr5GCxGJsyx0AMBKj3lbbRYOj/YJUeAi21ruBh+nUat+htcIDI5UaSrXpKCS/8W0UF4T452HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769947; c=relaxed/simple;
	bh=gpd57Lz4fGhPtPG+4Umrh/0toDLgYN3oTJKy7YXxtw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIvIhCElFNUmFyO49qjO2j/KW/OeMBglMgXioiHdofEOYFDftPkeHNCudDIJacRxZLKaraDnMxBKCOMpvLwZgnMD04XdGcBVqtg1mDR4SYUPWuru5BAYbdsAMzxA1LHvlaHMWIiS1dn5rgfhT8R61FUuHEL1IPFw9l9div00xHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO2mpZom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO2mpZom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EBEC61063;
	Tue, 27 Aug 2024 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769947;
	bh=gpd57Lz4fGhPtPG+4Umrh/0toDLgYN3oTJKy7YXxtw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OO2mpZomRbnF33oJpdcvKXgwu0RuoimqGiHNTbY7CDri7LNQaa1sPMLLwgI/kEUQZ
	 xcPecDJI2g9E077GIYd0PuXAlox/11LTOfG+lJ3giwNTATdDdT2+3K+wY/TUHUC/Hy
	 Xz5wYZ/Ma0N6k7iVzWXxR7y1OuKrcZy1L19nZAKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/341] net: hns3: fix a deadlock problem when config TC during resetting
Date: Tue, 27 Aug 2024 16:35:11 +0200
Message-ID: <20240827143846.455147646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit be5e816d00a506719e9dbb1a9c861c5ced30a109 ]

When config TC during the reset process, may cause a deadlock, the flow is
as below:
                             pf reset start
                                 │
                                 ▼
                              ......
setup tc                         │
    │                            ▼
    ▼                      DOWN: napi_disable()
napi_disable()(skip)             │
    │                            │
    ▼                            ▼
  ......                      ......
    │                            │
    ▼                            │
napi_enable()                    │
                                 ▼
                           UINIT: netif_napi_del()
                                 │
                                 ▼
                              ......
                                 │
                                 ▼
                           INIT: netif_napi_add()
                                 │
                                 ▼
                              ......                 global reset start
                                 │                      │
                                 ▼                      ▼
                           UP: napi_enable()(skip)    ......
                                 │                      │
                                 ▼                      ▼
                              ......                 napi_disable()

In reset process, the driver will DOWN the port and then UINIT, in this
case, the setup tc process will UP the port before UINIT, so cause the
problem. Adds a DOWN process in UINIT to fix it.

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index db9574e9fb7bc..14d086b535a2d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5729,6 +5729,9 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 	struct net_device *netdev = handle->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 
+	if (!test_bit(HNS3_NIC_STATE_DOWN, &priv->state))
+		hns3_nic_net_stop(netdev);
+
 	if (!test_and_clear_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
 		netdev_warn(netdev, "already uninitialized\n");
 		return 0;
-- 
2.43.0



