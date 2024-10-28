Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C9B2C697;
	Mon, 28 Oct 2024 06:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097602; cv=none; b=mdgrMKrU6NhnPUGUyk9Bqpr9Bs1N3bPMMwN9wQtcuVJM5aG5CgijhlRIIHHwICKc68PbGocddPLyF0pSF20C0Du0NFSFDGARKPMZju1C7WOzcrmfKjC/IWL/0+wN6y0J1OVlUn5pdC9b9esxGgmPsPfcnF5Ulio7HZdjyLFFItA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097602; c=relaxed/simple;
	bh=aeY3IPcR0z6Wph4lKEeEfO43qylfJuzpT4R9RMizqEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ts6SXp0bsdSw/JJ21AlTRLQhGxyXXSJHlD55H4BRWbgzImRK5aBY7O+mwu3JIztDnRC7s2o7mr0UlIgE6wMmEIZcvrPcVz3ExSrSXo3BMdXpjIbBctbykiKao4c2VPBwVQ9bPqXwbigYVLaGWaeSou3y8HbEelvsBtBTuRx87rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LL076rHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LL076rHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F49C4CEC3;
	Mon, 28 Oct 2024 06:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097602;
	bh=aeY3IPcR0z6Wph4lKEeEfO43qylfJuzpT4R9RMizqEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LL076rHCAq83VSI280cMVUy42YTfAGvW/Xb4HiZMQElmTMRX/Ou0BelcQZbOUxzLu
	 yfVEdKJmgXgdMZSsnPCT/+XqmB4SwOcTL5NzIApQBECWs1/JUk3Lvtd8ILf/kQpoQD
	 I8kP5DoBHjurnZwhApY4ZE3MMRBLguThfBwV0GaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/208] RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP
Date: Mon, 28 Oct 2024 07:23:29 +0100
Message-ID: <20241028062307.375562049@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit c659b405b82ead335bee6eb33f9691bf718e21e8 ]

ip_dev_find() always returns real net_device address, whether traffic is
running on a vlan or real device, if traffic is over vlan, filling
endpoint struture with real ndev and an attempt to send a connect request
will results in RDMA_CM_EVENT_UNREACHABLE error.  This patch fixes the
issue by using vlan_dev_real_dev().

Fixes: 830662f6f032 ("RDMA/cxgb4: Add support for active and passive open connection with IPv6 address")
Link: https://patch.msgid.link/r/20241007132311.70593-1-anumula@chelsio.com
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b3757c6a0457a..8d753e6e0c719 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2086,7 +2086,7 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 	err = -ENOMEM;
 	if (n->dev->flags & IFF_LOOPBACK) {
 		if (iptype == 4)
-			pdev = ip_dev_find(&init_net, *(__be32 *)peer_ip);
+			pdev = __ip_dev_find(&init_net, *(__be32 *)peer_ip, false);
 		else if (IS_ENABLED(CONFIG_IPV6))
 			for_each_netdev(&init_net, pdev) {
 				if (ipv6_chk_addr(&init_net,
@@ -2101,12 +2101,12 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 			err = -ENODEV;
 			goto out;
 		}
+		if (is_vlan_dev(pdev))
+			pdev = vlan_dev_real_dev(pdev);
 		ep->l2t = cxgb4_l2t_get(cdev->rdev.lldi.l2t,
 					n, pdev, rt_tos2priority(tos));
-		if (!ep->l2t) {
-			dev_put(pdev);
+		if (!ep->l2t)
 			goto out;
-		}
 		ep->mtu = pdev->mtu;
 		ep->tx_chan = cxgb4_port_chan(pdev);
 		ep->smac_idx = ((struct port_info *)netdev_priv(pdev))->smt_idx;
@@ -2119,7 +2119,6 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 		ep->rss_qid = cdev->rdev.lldi.rxq_ids[
 			cxgb4_port_idx(pdev) * step];
 		set_tcp_window(ep, (struct port_info *)netdev_priv(pdev));
-		dev_put(pdev);
 	} else {
 		pdev = get_real_dev(n->dev);
 		ep->l2t = cxgb4_l2t_get(cdev->rdev.lldi.l2t,
-- 
2.43.0



