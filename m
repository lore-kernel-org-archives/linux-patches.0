Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020965;
	b=AVTXyv50LUG7ihbX/JHPm7QgM5yE/N39Zx7Llh5jK+A84mWnppnmFLjkbbeoABfEwsaQ
	 1cY5OWrMDjTghI0L4wdF4BI0ct4OT+wrhElSsT5SVnahZIsl2amD2PCbGIggSshMWTbQB
	 nYNx3MSTa/9dXBrJ43V0vg9F1Ja4KZoWfQ0YHuJmJbursrau8IsAL5+wd1+lCENIptkFE
	 w0MPPR3v2Kyo6YZwZ5vRAnVsPScTWYykXJao2JPwgjXdJrFJvgyC49mkqoNf/6fHS3kTV
	 fiDCVC+rSm+0wvkrt/LpeqAdNp9A0EW9Izb3dKI3dQcMsJbS7wzhPBbG3L8JR7s9NsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GGwj7ggU/dvToFVsu5R72MEaZdv5eeilYqq3tgBKkh4=;
	b=moimV8e6WK88pGJrhGD1eztCS9NjyqxQxJvq77YAZWviO9sCV2Xa5PV8oithm8jETYMY
	 gOixv5gOUqlckx2K8QggDdm98PqcnFs7FIm2qNHxZqCz97xnULDYTEOzx3AbjAJZ0yExj
	 YITb17bUm5QmE90LB8VMmV28jGvQ3qAZCK9mZYAsSt7xp7pW504fqBvuq3DttzV33nSZw
	 ItoAIjJhJF1AMRgv5po/1KiKmaPq0GTZMVIyXclPIFa8dnK/jZ33N8bZJQtRsgJZYEkD9
	 mPw31F1RH3crONilDRdAzjVPwnMKD5ADVwq1y11+9e77uMeZ3/nNfgFcDQoIHtY971A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sCtE3ki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59045606A31C;
	Wed, 18 Nov 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sCtE3ki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE81F000C4;
	Wed, 18 Nov 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020965;
	bh=GGwj7ggU/dvToFVsu5R72MEaZdv5eeilYqq3tgBKkh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sCtE3kimSG6+RrMv2uV9u5574Fxt2kWpiBYqljohF7vvxiNaNmkVD0xEDQMEXG2t
	 obE2J1JguIMSEapQQEUhOceXOyJlKObzO0BBoQPY6FaOM21ulqP8nz3G2mGzFJurz+
	 dGH0VTHasPLCm9eOD+OzgwM33TPZgQWxlktZ7Pxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2137/2651] RDMA/core: Reject LAG selection when source MAC lookup fails
Date: Wed, 18 Nov 2026 15:56:17 +0100
Message-ID: <20261118150402.812987653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 88aac911e8ee1..651c868aa04e5 100644
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



