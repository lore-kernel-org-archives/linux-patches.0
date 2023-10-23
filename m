Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7677014263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYjcS66D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47BAC433C8;
	Mon, 23 Oct 2023 11:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059387;
	bh=uLKE75M24s8c8tKeRMlLuzZUSG52iz6EChGtoBmjMQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYjcS66Dh14eb6X6fsGH4XPLVLx+BJuxv0wAkuNZincmAHUDkXaoxbC05x8i2e9O6
	 GHJSD1n3RrbrziTu0/72uRl+RTiv+Ir+/qYZJ6X4NjK+dr1B23reg/kctlUWd8rWfs
	 SIkih73lzP4tksRLHwwAWzfWjnWwaPQhBVMW+iOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Albert Huang <huangjie.albert@bytedance.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 161/241] net/smc: fix smc clc failed issue when netdevice not in init_net
Date: Mon, 23 Oct 2023 12:55:47 +0200
Message-ID: <20231023104837.800243857@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Albert Huang <huangjie.albert@bytedance.com>

[ Upstream commit c68681ae46eaaa1640b52fe366d21a93b2185df5 ]

If the netdevice is within a container and communicates externally
through network technologies such as VxLAN, we won't be able to find
routing information in the init_net namespace. To address this issue,
we need to add a struct net parameter to the smc_ib_find_route function.
This allow us to locate the routing information within the corresponding
net namespace, ensuring the correct completion of the SMC CLC interaction.

Fixes: e5c4744cfb59 ("net/smc: add SMC-Rv2 connection establishment")
Signed-off-by: Albert Huang <huangjie.albert@bytedance.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://lore.kernel.org/r/20231011074851.95280-1-huangjie.albert@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 3 ++-
 net/smc/smc_ib.c | 7 ++++---
 net/smc/smc_ib.h | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fa7b8015cd7bb..01bd576ffa5e1 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1199,6 +1199,7 @@ static int smc_connect_rdma_v2_prepare(struct smc_sock *smc,
 		(struct smc_clc_msg_accept_confirm_v2 *)aclc;
 	struct smc_clc_first_contact_ext *fce =
 		smc_get_clc_first_contact_ext(clc_v2, false);
+	struct net *net = sock_net(&smc->sk);
 	int rc;
 
 	if (!ini->first_contact_peer || aclc->hdr.version == SMC_V1)
@@ -1208,7 +1209,7 @@ static int smc_connect_rdma_v2_prepare(struct smc_sock *smc,
 		memcpy(ini->smcrv2.nexthop_mac, &aclc->r0.lcl.mac, ETH_ALEN);
 		ini->smcrv2.uses_gateway = false;
 	} else {
-		if (smc_ib_find_route(smc->clcsock->sk->sk_rcv_saddr,
+		if (smc_ib_find_route(net, smc->clcsock->sk->sk_rcv_saddr,
 				      smc_ib_gid_to_ipv4(aclc->r0.lcl.gid),
 				      ini->smcrv2.nexthop_mac,
 				      &ini->smcrv2.uses_gateway))
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 9b66d6aeeb1ae..89981dbe46c94 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -193,7 +193,7 @@ bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport)
 	return smcibdev->pattr[ibport - 1].state == IB_PORT_ACTIVE;
 }
 
-int smc_ib_find_route(__be32 saddr, __be32 daddr,
+int smc_ib_find_route(struct net *net, __be32 saddr, __be32 daddr,
 		      u8 nexthop_mac[], u8 *uses_gateway)
 {
 	struct neighbour *neigh = NULL;
@@ -205,7 +205,7 @@ int smc_ib_find_route(__be32 saddr, __be32 daddr,
 
 	if (daddr == cpu_to_be32(INADDR_NONE))
 		goto out;
-	rt = ip_route_output_flow(&init_net, &fl4, NULL);
+	rt = ip_route_output_flow(net, &fl4, NULL);
 	if (IS_ERR(rt))
 		goto out;
 	if (rt->rt_uses_gateway && rt->rt_gw_family != AF_INET)
@@ -235,6 +235,7 @@ static int smc_ib_determine_gid_rcu(const struct net_device *ndev,
 	if (smcrv2 && attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP &&
 	    smc_ib_gid_to_ipv4((u8 *)&attr->gid) != cpu_to_be32(INADDR_NONE)) {
 		struct in_device *in_dev = __in_dev_get_rcu(ndev);
+		struct net *net = dev_net(ndev);
 		const struct in_ifaddr *ifa;
 		bool subnet_match = false;
 
@@ -248,7 +249,7 @@ static int smc_ib_determine_gid_rcu(const struct net_device *ndev,
 		}
 		if (!subnet_match)
 			goto out;
-		if (smcrv2->daddr && smc_ib_find_route(smcrv2->saddr,
+		if (smcrv2->daddr && smc_ib_find_route(net, smcrv2->saddr,
 						       smcrv2->daddr,
 						       smcrv2->nexthop_mac,
 						       &smcrv2->uses_gateway))
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 034295676e881..ebcb05ede7f55 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -113,7 +113,7 @@ void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index,
 			 struct smc_init_info_smcrv2 *smcrv2);
-int smc_ib_find_route(__be32 saddr, __be32 daddr,
+int smc_ib_find_route(struct net *net, __be32 saddr, __be32 daddr,
 		      u8 nexthop_mac[], u8 *uses_gateway);
 bool smc_ib_is_valid_local_systemid(void);
 int smcr_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb);
-- 
2.40.1



