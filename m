Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050152;
	b=2EA2amwDwHh5UG8Na64HSgcLDbpNnbWO9h0+M7SHd6W3VAeU6v+7rabNKFgKdUENUy07
	 vo9Eu1Aoytkl2iXei4jmgcQ6BRYxMySvFq7xfbfAaPtPGOtNpj03zWYVXBa+5shdHNXZa
	 kqvS/ZO1YFOFMbzOUzToKGsVCmDWde0t3XlpaxLjF1BJHksv6p35aTPNaY+jjbX+ufdwN
	 lH6JfogbWKgxsZ/Rxf+a3OI8bYd+hUiv13QD7fdHM3wXVfw3lsE3M9TmDMGs5fdXbgpzW
	 Cu9sJd/XLTaHnfRMANO/qqgUFES2amG7YAIbBGWk/ffpu6JJPvEKIsc3luxyuFxvd/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cvps0sdfbbDMSsh1reUfXVqwP4jTJyGr1QGg+vrPUlM=;
	b=SWMwGC82s78xsTgx9p6+M3Xo+du+3KDJRfPk90q672wdK91Xu2VX17Ua3qbU58E34Uym
	 PtvB7ufZ22849tKU3uhp4KhNvEyy/9IqlON1sjYPa6WeT7MzFnewbbb+zqN58W0rLjcDf
	 M6Dt0rwc3bOlT3ycBGu8sjCey5POhpW4zSLDuRw0Mv8034icFwwlZKgNv7Wijju9cecaZ
	 OzNksoAjMnf7s/Lc4+8tRLF0y/OfkPKCr4awksRvI519drIByhTngP+bxE4p7gh6EkYXU
	 v+BHv4+CcqnWQjYcoolsC76GLOZ54e6+Qie20Exsd/X6XN3U7zV0tOaOyUF8oPxAgRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rPq/TNqj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60967606A334;
	Thu, 19 Nov 2026 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPq/TNqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE13C1F000C8;
	Thu, 19 Nov 2026 01:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050152;
	bh=Cvps0sdfbbDMSsh1reUfXVqwP4jTJyGr1QGg+vrPUlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPq/TNqjbsZQuKXrIejALHZG5tItek66mQ/O8G3v1B5f9iVAkSso2I39LvXSO5Mwm
	 N2jRy8u5/roXSirHUg0Ro/5hpDdpoFulywdajPUN+FrhlCKXbs6VqZdNZ5j4zccLod
	 yWMYcKW2Qt0nJISkBGFztAUS6Sxtjl5kdC782SyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2606/2857] RDMA/core: Reject LAG selection when source MAC lookup fails
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150335.394286060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c18642accfce5..9f2e5431757f9 100644
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



