Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042110;
	b=RRxfj6iHBtCPGEBWVA4H1Ex0yYju3OjqyMLGEtW2riQDqVNBJEDMMt+gJcUcVaDsi4PI
	 HeNqZ8TpA2bQtxm+dSgQxw2S5AVnKt0AtAQGVqgPkLqoQ1Dkw8ThpO9MCQA4/Q9clXIYD
	 ECkQZgDVtIbpnJnT9wvVlDd0XvMkHqgxSAvfsfAgv19gP4qHJl32F88yNQWCCeY/uJYKW
	 dMyDSNo2mBe6j1QQ6rmSod7o8drphchq2rl70xXPwSa9wsRaCDZv1/d0Xp4mVA/fn3/Hw
	 BbRfEkGqDXbRfi9Sy9hJC5mhs5v/Nu10mzNWEw8AFBvhJut3JmcxpPX9cEbcj8heKyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=69/ni0kvzh9rju3NTtVmFM7mjZQa0fyLcJpsEDCEfEM=;
	b=UplfOKQNjJYdfNDw00LJ8r2PVSNmJEltvNyXXrg2fW+aUfUkCNF3FHq5VIkLqt9KJXfx
	 McGmIaiAeGE7RWB0es0JYp6DWrqE8rjFEH49AKgJIYsInp505IJxGP01eFmg0INuYpUeA
	 am0kkoZUATzmIw9vFVry26Opdxy3cs5js0ISJDcxvt8+QngQfpMjqrB0sc40XWb1/SzSW
	 wGVjYdeBTNTNFdSNDmUun0n+fXbFgvvK874yRlRrNVWZQVHbfW4k7fhIaJJ1l017tCQg4
	 MSeT7x3OzUskO4M3J70YdX7l0FqiaVlP3jLI072/fu6CN6NzBUFT3iLFSo12zDur3Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHjazzTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752BA606A32C;
	Wed, 18 Nov 2026 22:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHjazzTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF56B1F000C4;
	Wed, 18 Nov 2026 22:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042110;
	bh=69/ni0kvzh9rju3NTtVmFM7mjZQa0fyLcJpsEDCEfEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHjazzTdgIuaZYowwTkB7fgy7T4NmaKZppEbYtcTj4QNf+C9fryak2x1vEuVEB9zv
	 +YnkKSbaNgVhLXs5BOE47TjF2lg8ghqVLOWI1NFPdQJtiLaHw/rmoNtqu3CdvC2yEh
	 4w50Wcz0TnVF2PDO1Lz9bSWSMChGbX1Qj3g66nGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3026/3318] RDMA/core: Reject LAG selection when source MAC lookup fails
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150450.977531412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fdfd099222d9de9e2f1b8d69e94494c5489272cc ]

GID deletion can clear the source device association after LAG lookup
retains the bonding master. Ignoring the resulting L2 lookup failure
copies uninitialized source MAC bytes into the synthetic hash packet.

Read the source MAC before allocating the packet and propagate lookup
errors to the caller, so failed lookups cannot influence slave selection.

Fixes: bd3920eac133 ("RDMA/core: Add LAG functionality")
Link: https://patch.msgid.link/20261015-ib-core-fixes-v1-3-60f6da3ddec3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 10e22648f8131..56967d349a20a 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -19,6 +19,11 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 	u8 smac[ETH_ALEN];
 	bool is_ipv4;
 	int hdr_len;
+	int ret;
+
+	ret = rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
+	if (ret)
+		return ERR_PTR(ret);
 
 	is_ipv4 = ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw);
 	hdr_len = ETH_HLEN + sizeof(struct udphdr) + LL_RESERVED_SPACE(netdev);
@@ -26,7 +31,7 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 
 	skb = alloc_skb(hdr_len, flags);
 	if (!skb)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	skb->dev = netdev;
 	skb_reserve(skb, hdr_len);
@@ -70,7 +75,6 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 	skb->protocol = eth->h_proto = htons(is_ipv4 ? ETH_P_IP : ETH_P_IPV6);
-	rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
 	memcpy(eth->h_source, smac, ETH_ALEN);
 	memcpy(eth->h_dest, ah_attr->roce.dmac, ETH_ALEN);
 
@@ -86,8 +90,8 @@ static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
 	struct sk_buff *skb;
 
 	skb = rdma_build_skb(master, ah_attr, flags);
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(skb))
+		return ERR_CAST(skb);
 
 	rcu_read_lock();
 	slave = netdev_get_xmit_slave(master, skb,
-- 
2.53.0



