Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B319F485;
	Tue, 27 Aug 2024 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771194; cv=none; b=G/SYsUyUzlN0m1GB75m+Ra9FqdTkyA7BRaI3ciN9K7DUX8mesXsgOzLnHJa32bK9wbB/bUzeqC/R4gI7sqtiBm/KLMFZyLWXllFeXg+BJgai9yw0yUE8CmpNr2oD97FZuTfRMYJ05QMdZw5zj4G0Mf7rtqqAgw7V73PRG3+wH68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771194; c=relaxed/simple;
	bh=EKjHEYpmAAYft653YEN6BPIp7u1lQjFAdRNnZCMAIls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ml5ePxFCg5w/NWhRGASE+iNRV4fYCLh0zke2sL+L1/jwvyJx1LHVjzNJWPUcHCbaPGnPKAsuRAuuN6PRy2EivU/Yzn50rCe5TjbGaYQjdwOPk5p5lbuWl8SLdKXzfBQFxp8zIrB+7R3p3EamevvAbKNzcToDVtUVdUfYBlppnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWT1YGia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWT1YGia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00486C4AF55;
	Tue, 27 Aug 2024 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771194;
	bh=EKjHEYpmAAYft653YEN6BPIp7u1lQjFAdRNnZCMAIls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWT1YGiaYB9xAnQKq/ATarVPZBkHvBIkIWnN/JorXY71JMIqpd0mOGg6wTXwKTAkZ
	 SvdlRYB4YQlpVwNugwBtEMenYqm1I6d2WfFpwuE8SuXNyRUk97sPHhXNeGbEGuyc99
	 5vN8JiArFrBRJHBlG1kJlvrkfyv4owlbnCctASRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 115/273] net: hns3: fix a deadlock problem when config TC during resetting
Date: Tue, 27 Aug 2024 16:37:19 +0200
Message-ID: <20240827143837.785478856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a5fc0209d628e..4cbc4d069a1f3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5724,6 +5724,9 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
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



