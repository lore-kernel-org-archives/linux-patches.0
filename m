Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9549E1DF726;
	Wed,  6 Nov 2024 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895771; cv=none; b=C+8vT64mqQKIALKwV9jEZJln9KA1t3oLSXhhhJBHcBzotHWx3hOYk9jt5xploKpEtrZmBKCZDjG2+qAIScL9djJ38cE/0cEhPQn+R1fqh+hlVbCBQSJNsOyDL8caPIwW6V4InLjbGiPp0afKsNKXItjZRpINrJMGlgBQHDGoHZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895771; c=relaxed/simple;
	bh=Vz2v8M0w2xHO6V0gmR6AcIQCs+ZZYm38xCUaCMOW6+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCffKvx3RtMb2uRb5IHmON3TuBHmQcMM3fiIMnNa5I63xCiqfda3OE/LZDNfJiyNFG8T/bh6HP7S9wC45EsQMjMiJMnrTEJhQ97F/HsLsarlf6QBh40cCsPSDXE46x5eBZ0yUywqNVLdwwItQjucq/fQeDjMRYr/VQ35YwrKEK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlzzSKkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlzzSKkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176D7C4CECD;
	Wed,  6 Nov 2024 12:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895771;
	bh=Vz2v8M0w2xHO6V0gmR6AcIQCs+ZZYm38xCUaCMOW6+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlzzSKkhg/pX3H9M3hjkC2dCvbV8wd1KbIq3Hy54HEeQbQycdP8AJ2gvZ+YdMES7q
	 KCxxb6HbrTYW5doilpXCuJegyT+g0oq9NF+paTRg9GIPWt+WVq0uai+eTFQpIsjEnP
	 zHzA59K+6AVuqjFh+PvqT3tf4Sq6ULqdQeEhBwHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 294/350] RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP
Date: Wed,  6 Nov 2024 13:03:42 +0100
Message-ID: <20241106120328.082657827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f9ea863a80885..81b5b009a0dde 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2043,7 +2043,7 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 	err = -ENOMEM;
 	if (n->dev->flags & IFF_LOOPBACK) {
 		if (iptype == 4)
-			pdev = ip_dev_find(&init_net, *(__be32 *)peer_ip);
+			pdev = __ip_dev_find(&init_net, *(__be32 *)peer_ip, false);
 		else if (IS_ENABLED(CONFIG_IPV6))
 			for_each_netdev(&init_net, pdev) {
 				if (ipv6_chk_addr(&init_net,
@@ -2058,12 +2058,12 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
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
 		ep->smac_idx = cxgb4_tp_smt_idx(adapter_type,
@@ -2077,7 +2077,6 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
 		ep->rss_qid = cdev->rdev.lldi.rxq_ids[
 			cxgb4_port_idx(pdev) * step];
 		set_tcp_window(ep, (struct port_info *)netdev_priv(pdev));
-		dev_put(pdev);
 	} else {
 		pdev = get_real_dev(n->dev);
 		ep->l2t = cxgb4_l2t_get(cdev->rdev.lldi.l2t,
-- 
2.43.0



