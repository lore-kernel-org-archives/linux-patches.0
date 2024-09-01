Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6597C1EB5B;
	Sun,  1 Sep 2024 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210049; cv=none; b=PWpMC+XVn4NzHtdocKc/C8fXcYUmQxWb/uQ/q/yoBIMezGcB/hPix/muVpO+sZusg5r7Chrl5MsGB0pXr4254duJot7RxYsGIknItjQhfBZiZZmleOKjjdLfzeUn4diY5T9HkctVT7xNTKiofjmwt9Jxorx+cLL1tbtw3PbCato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210049; c=relaxed/simple;
	bh=JgFg6KicT0Ux16oQ2NVwQZN6psZTWHJxG2TeF9CvR7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VjXQYUdo21s9TKxfPKF1sWQ0Z+3gXwJiCoTg0MZH2NgqmeuRKEw9SDkObGe8w8tfHfo08uJoC6+LXVNm5+BPZDnziTX9fdIYT83PuXIhsy95s0liaVg5Setnp4soR+W000W6a0NgeO8ysDEvLOWypK/Jy5FlF/eLv54/egKR944=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUHcrEkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUHcrEkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B9BC4CEC3;
	Sun,  1 Sep 2024 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210049;
	bh=JgFg6KicT0Ux16oQ2NVwQZN6psZTWHJxG2TeF9CvR7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUHcrEkL8ZUrO/cDSoW35FBHMsDQwdkNobo9xm5Ut4X95rxLMLHxFnfn/c2bA6JZb
	 a3VeS9g0ozxBztNkwYHIgsXqd82+2qKN8NlnP8Y3YlEvy6FRC+qRRvTuwWt8kIhKaO
	 upAARcV1fmqXqfbwb9bnc5Ta9ZcRoEj6SJNn9u28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/215] net: hns3: fix a deadlock problem when config TC during resetting
Date: Sun,  1 Sep 2024 18:15:53 +0200
Message-ID: <20240901160824.898952908@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e48d33927c176..d6bdcd9f285b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5504,6 +5504,9 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
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



