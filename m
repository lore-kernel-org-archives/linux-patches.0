Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328854765;
	Wed,  6 Nov 2024 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898991; cv=none; b=npfsfwo0U3Ni5fS94IuSiMMbXgRtOEWjfmfeQl1mtJ4jyJvGiUIdDkA9KlsfWGwzE24zxPzdBGaa8y28mpLxn7irazOZPBp/8sN/rc2zNGqugfDID0lNwGzscNe8vUWn2xLJdRBQYlQy/MhC/ijx7JWxMt0DHBbgERSx3PhLiP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898991; c=relaxed/simple;
	bh=5hp6BSZbxZj2Pr+QPPZZs67WB8/x2xvYNNb8anOXj0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkMG1OZm/28mkuueAQ1ENzEB/2obOb0SoOJg/AWckMtTYs8OKA9g//N5HHoJaOlLot2+bIJPSOgcExx+yE56dOoHP7KlyqQ2BfE7fNSdlFXIv0CTgboSXebj/+QMkU4HNen4as843N/5rzsguB5tV+ghb9zn4V08hcC2juzMUjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2ww7kbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2ww7kbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFF2C4CECD;
	Wed,  6 Nov 2024 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898991;
	bh=5hp6BSZbxZj2Pr+QPPZZs67WB8/x2xvYNNb8anOXj0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2ww7kbv6327mB9PpAucBP9WUSAr9mUJQn2Efigd0uo4iazRmxemGurhc3K1M+Ym1
	 /gtlWnlAkybGXbAS53ClkJa/DHxUUcNSa7doA0HOzddwqRnqqS8OEaCEgICeTUx22o
	 OhX2+aGV2eoDH6kg5orEO8cYcF8VfZjNd0sFu4G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 387/462] RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP
Date: Wed,  6 Nov 2024 13:04:40 +0100
Message-ID: <20241106120341.084072643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 01750eb5458e0..38e2fbf84e276 100644
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



