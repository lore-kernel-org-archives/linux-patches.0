Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81948157E82;
	Mon,  6 Jan 2025 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176797; cv=none; b=BKQx9LjZpm8QFfVrf2Qod9crr7hZvTpf+zItLGkmBtzl2hgcQS0OP5Kr64KvsYcjfsuoYSm3SrtD6Vcuew+3eOReuhniuSuwR+6pjiEf7tPV6ssFbgQgBzxAceeTPe+dX70B95S2DpX8OeDAVtGZAaUqb++bEajA57WQIc7W/y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176797; c=relaxed/simple;
	bh=2er5CSH0vC738TbF9so/uP7ynA0O3kg2sFgR4MmNVTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDmaSt6ROwavIylqCZZCK0vboPUnirmBC+bLQ/VNArh68AGsywqdocQYOrxWexrezNjdPRsZQsxwJ2sfLZENwHbPHZcYivcMKa5r9vS9sYJJvLOSR9vatEneI8aDaEHrR+h71dLinlIbSeq1VKkQxdwn+PZAwLqd+nQ5EC8Jn4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgRvFWYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgRvFWYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994B5C4CED6;
	Mon,  6 Jan 2025 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176797;
	bh=2er5CSH0vC738TbF9so/uP7ynA0O3kg2sFgR4MmNVTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgRvFWYvkvka4RVZvGHT+61sG8jrMrzntMQcscQETGycUh+Fr9p6XoC5i4n29smke
	 s5FMJzMHlq4L1bKNjKdOyc/sSQT+wYKYHz/yO6WOA0yH8CzBbtbkqMGNq1xCXLZ7F9
	 G/Uu7kkQiT7UqfUP/otKrDMHPOpKkpM2HkvNbr+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/81] net: Fix netns for ip_tunnel_init_flow()
Date: Mon,  6 Jan 2025 16:16:07 +0100
Message-ID: <20250106151130.763819370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit b5a7b661a073727219fedc35f5619f62418ffe72 ]

The device denoted by tunnel->parms.link resides in the underlay net
namespace. Therefore pass tunnel->net to ip_tunnel_init_flow().

Fixes: db53cd3d88dc ("net: Handle l3mdev in ip_tunnel_init_flow")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20241219130336.103839-1-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 +--
 net/ipv4/ip_tunnel.c                                | 6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index b3472fb94617..8883ef012747 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -423,8 +423,7 @@ mlxsw_sp_span_gretap4_route(const struct net_device *to_dev,
 
 	parms = mlxsw_sp_ipip_netdev_parms4(to_dev);
 	ip_tunnel_init_flow(&fl4, parms.iph.protocol, *daddrp, *saddrp,
-			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0,
-			    0);
+			    0, 0, tun->net, parms.link, tun->fwmark, 0, 0);
 
 	rt = ip_route_output_key(tun->net, &fl4);
 	if (IS_ERR(rt))
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 4f30ccf2d321..67cabc40f1dc 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -294,7 +294,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
-				    iph->tos & INET_DSCP_MASK, dev_net(dev),
+				    iph->tos & INET_DSCP_MASK, tunnel->net,
 				    tunnel->parms.link, tunnel->fwmark, 0, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
@@ -611,7 +611,7 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id),
-			    tos & INET_DSCP_MASK, dev_net(dev), 0, skb->mark,
+			    tos & INET_DSCP_MASK, tunnel->net, 0, skb->mark,
 			    skb_get_hash(skb), key->flow_flags);
 
 	if (!tunnel_hlen)
@@ -774,7 +774,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
 			    tunnel->parms.o_key, tos & INET_DSCP_MASK,
-			    dev_net(dev), READ_ONCE(tunnel->parms.link),
+			    tunnel->net, READ_ONCE(tunnel->parms.link),
 			    tunnel->fwmark, skb_get_hash(skb), 0);
 
 	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
-- 
2.39.5



