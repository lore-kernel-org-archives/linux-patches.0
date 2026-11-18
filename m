Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027335;
	b=rjo/0W1wfqXB9cCDJg9C3CkKMszFBhCUZ/im8InxDAVEPu1L8lYVdJn3hji5Qha2mNU0
	 SfUFIkLTXWVx3dYl+PHJwUguAFigBmNGVga61DOktwK1GX16IbZ3+/9J4+epw+/oit5Vj
	 Qq4P6bwPOcCbmeKDBpSqbukQuwJESgAYSfFQifi9NExYzSvqYe0VPfZ6BXu14EIhRUZuv
	 hH2scUOKgM/GAMHKX1OxRqU+k6IKTEbXBwJ7uJCsGxfLoKCT2zcmI2JoEaETTE+YzB0NM
	 g24qBEmxHKbgfQ5D3R5f7Zhmw6b2DuhqkPjq9+7g0Sy/Cc+4d9DTTXm7zoqv+uP71Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mMjzec3Se9Nxym4/bgbPoG+C3Qoz0TZdL6Qa1SEqBj0=;
	b=AEZ49f/TjpkgK4iUXuMDaRlOBKPGK0vLR4OAgdsOnHOTMZQQ+5VXHQOpZVOgf+fYNiF6
	 SHpY1EkjDFgBx1Wjg/gOCfkLprN0G3W2ONc3Dn0vYekUmflOCg7DTFavRZWNLKi9yCajW
	 eOHOlIPim5xldemAyU2UR6hIMkkOCSv6vejhhFayYkEY4CxAaB4vDVO/wzQaOKZm08vAf
	 neFcZQJujR1zbKMqyYOVEjrgAhSuJlo46Qyxghu2BxOEPemHWVZYk3CxQegDtYISxdc0Y
	 8vnqwSjcZEz9ymUSzwVZ8LNWt6XbHE/AYIVaW/l2mYvNNxYl6X9bpNO2K0ZwEnS4l1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ja52XPG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD3960A260D;
	Wed, 18 Nov 2026 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ja52XPG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFF01F000C4;
	Wed, 18 Nov 2026 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027335;
	bh=mMjzec3Se9Nxym4/bgbPoG+C3Qoz0TZdL6Qa1SEqBj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ja52XPG6Kfj1ZJlig99D/Tf5lbEcf2M926/RrlepHT3QJAlW4SWKq1q8aRhGSTDLJ
	 K9parNNP+5L1A5z2MxRJS8nhMRPxv6B+M4WTADT+gvUMzdCw8vmuWq+8JbpH9A+Qw7
	 t2x1L74/Mi+fixfP4BHE6BULpzGBJeFlGRo/5C3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1753/2151] RDMA/core: Reject LAG selection when source MAC lookup fails
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150225.710191311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index eeae4b0898ee0..f44f59e60a164 100644
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



