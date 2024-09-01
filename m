Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE8B1DFD1;
	Sun,  1 Sep 2024 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209503; cv=none; b=uPzRuKffqcp2SGAUILUgtduIiF7GuWAaPVBUe1FZaVn3TbxvLLDWRiGKVz/7uFbJgC1/1sxbthkmAWAqP1xiqWTpEd+4dBshC3u9dRkCO76R0r8wmq9tpK6t9iyoqlxTDQLeiut5WpsewbknMaUltbuQ0JJsEyRCNo5y3w/2lJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209503; c=relaxed/simple;
	bh=+eF7xwkzoanMMMGzg8/iNDMYNFLNIkkgQhKF62OgSuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNbNhfAkvtyVuMN+iJOdFhcrW/r32n+hlslZYBL+Q5MPGoWTTdk4iOXcBRZtvxP8QCeEns32R5ypfseuQyFqQB7FSSBm66fnJ0btjEbUxnNj8aXyAjytlnMsRfVebOdrjfeDGibhKySa9PUVzLTDgIHsamANRd3q8lvUVbNLUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyGQx1T/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyGQx1T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD2BC4CEC3;
	Sun,  1 Sep 2024 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209502;
	bh=+eF7xwkzoanMMMGzg8/iNDMYNFLNIkkgQhKF62OgSuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyGQx1T/Rfe/b60/ucAUPM5i1M4a9fheMkDaJrhCQfdvrk/JS0RPlLOqU0LhBF8pf
	 c09uamIEvUgZhTZaO/44AEsuWmYpeqzoLZz6e+hvUJnbS5qvMzrvZkFDl/ncYuYQ00
	 xdBHPrXajjL8gw5QpPo8wwpQiwL7TVygCiJjmNnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/151] net: hns3: fix a deadlock problem when config TC during resetting
Date: Sun,  1 Sep 2024 18:16:29 +0200
Message-ID: <20240901160815.192945421@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f8275534205a7..9ff5179b4d879 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4536,6 +4536,9 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	int ret;
 
+	if (!test_bit(HNS3_NIC_STATE_DOWN, &priv->state))
+		hns3_nic_net_stop(netdev);
+
 	if (!test_and_clear_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
 		netdev_warn(netdev, "already uninitialized\n");
 		return 0;
-- 
2.43.0



