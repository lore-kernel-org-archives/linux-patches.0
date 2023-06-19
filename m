Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9F9BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A9DC433C0;
	Mon, 19 Jun 2023 10:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172158;
	bh=6GzSfgiQWmo3kU36CG7SFCR0GWiPj2HMkXY1OakdfKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yF8QgzS+h+lKrxYdQEKFTmCZwD9WXstQ2q4J1Q3N7X8DGDSei7OUY0gXdnMm5eJxd
	 fHg9kmhwNUxemf+rSh2I5/jBJKszSX6nKTfwgQ0SMMw1jPj4LfTpIGnC67e2idjWdN
	 2xXW2R+V87zWXmfBRTSrAyinrxZWpft7B39z+V2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/89] RDMA/cma: Always set static rate to 0 for RoCE
Date: Mon, 19 Jun 2023 12:30:45 +0200
Message-ID: <20230619102140.860189827@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 58030c76cce473b6cfd630bbecb97215def0dff8 ]

Set static rate to 0 as it should be discovered by path query and
has no meaning for RoCE.
This also avoid of using the rtnl lock and ethtool API, which is
a bottleneck when try to setup many rdma-cm connections at the same
time, especially with multiple processes.

Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/f72a4f8b667b803aee9fa794069f61afb5839ce4.1685960567.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c |  4 ++--
 include/rdma/ib_addr.h        | 23 -----------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fdcad8d6a5a07..db24f7dfa00f7 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3069,7 +3069,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	route->path_rec->traffic_class = tos;
 	route->path_rec->mtu = iboe_get_mtu(ndev->mtu);
 	route->path_rec->rate_selector = IB_SA_EQ;
-	route->path_rec->rate = iboe_get_rate(ndev);
+	route->path_rec->rate = IB_RATE_PORT_CURRENT;
 	dev_put(ndev);
 	route->path_rec->packet_life_time_selector = IB_SA_EQ;
 	/* In case ACK timeout is set, use this value to calculate
@@ -4719,7 +4719,7 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	if (!ndev)
 		return -ENODEV;
 
-	ib.rec.rate = iboe_get_rate(ndev);
+	ib.rec.rate = IB_RATE_PORT_CURRENT;
 	ib.rec.hop_limit = 1;
 	ib.rec.mtu = iboe_get_mtu(ndev->mtu);
 
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index b0e636ac66900..8c5c9582c4fb9 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -193,29 +193,6 @@ static inline enum ib_mtu iboe_get_mtu(int mtu)
 		return 0;
 }
 
-static inline int iboe_get_rate(struct net_device *dev)
-{
-	struct ethtool_link_ksettings cmd;
-	int err;
-
-	rtnl_lock();
-	err = __ethtool_get_link_ksettings(dev, &cmd);
-	rtnl_unlock();
-	if (err)
-		return IB_RATE_PORT_CURRENT;
-
-	if (cmd.base.speed >= 40000)
-		return IB_RATE_40_GBPS;
-	else if (cmd.base.speed >= 30000)
-		return IB_RATE_30_GBPS;
-	else if (cmd.base.speed >= 20000)
-		return IB_RATE_20_GBPS;
-	else if (cmd.base.speed >= 10000)
-		return IB_RATE_10_GBPS;
-	else
-		return IB_RATE_PORT_CURRENT;
-}
-
 static inline int rdma_link_local_addr(struct in6_addr *addr)
 {
 	if (addr->s6_addr32[0] == htonl(0xfe800000) &&
-- 
2.39.2



