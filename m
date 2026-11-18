Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039959;
	b=fUX3WfwbhN1KL4bkP+K7jA1ybmzRkkO4XTvQo/qTDhIkr7JHGczEvTnt6hRvOpzYBJ3f
	 ExFBIXeNDoiwsmO0X8ylW1Nf7dkIuGm28diLr+y1luP1aary0l+M/HwUxz/FUeqIKGaeL
	 ZdZsIA11LiqGVmRCdxwEkJE9i2E4LfTsF2OSA2QRH0FDzLYB77LZx30olPTnQ9q8rAqhi
	 GMzRLXVfk/Or5uTJ5h7t5VKC4BxvDFpkl5XZ0d9tnYK2U+57xZ9GnYCraEPK2hefGg6aF
	 qqAIp55JHDS3pX/nsW52ayJBkr3yBxXoYSo9sUSR/qsK4sM8+5eLRkTwOzZ2JiNh3gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fiJw4xA9U2BipDNimd9EGMOf/AKDqcawcOmtedqv4gk=;
	b=I0lKXJ0UprSWEoE6LKEgDxcNHL04em6Ps5kStSdaCI/cbxfvkU6PwmUOvRihQ52P0omc
	 ei4kj9Y3waCBJ+RCbr3Hwun/qEUs+8w2gvKcl/pZX12sYANg6j+mxbgsxXAwH1ZDm7DLx
	 C0Wi5Ye6zL6r20EHXTzJPnUhd5vDd7eXYbgchTOaWGouhaNaN/ShvIXgWDnP8fccVLC69
	 ARGh5/x6U2H1gWeP45ekc+Qsd+R933IpqNambz5eaZCjNhqrN+pJKnxpGtIqzeSuTTPYB
	 QipyNS0sMzQxXR2J2em5K8yn6kfyO4D6dAgC3Pk04vpCz22FqJ7yH1KUb7x6bzG2ISA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ah9297Nq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F82606A325;
	Wed, 18 Nov 2026 22:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ah9297Nq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988751F000C4;
	Wed, 18 Nov 2026 22:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039959;
	bh=fiJw4xA9U2BipDNimd9EGMOf/AKDqcawcOmtedqv4gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ah9297NqY0UAotfPCO21mxM/C2AgrCStcQntgvb82gAcuD2uL8/+/ddhyoMORZmdg
	 JVZrWSXFndDkTatC9QcuMTc13tpfIyRfzALHfEHcVmGirXHYCbQeGrwOA4kagbUILb
	 E2PuNfiPkooka6NkrLDiXhnAxJFfi5mJc2Jbnc54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2287/3318] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:48:29 +0100
Message-ID: <20261118150430.365703356@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b63d21631f836528ef660d7b5a0d84890ff6dbd5 ]

rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
selection and copies the flow label from the AH attribute:

	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
	       sizeof(*ip6h->flow_lbl));

ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
array to a single __u8 and yields 1.  The memcpy therefore copies only
the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
uninitialised in the skb buffer (alloc_skb() does not zero the data).
The resulting LAG hash is computed over one byte of real flow-label
data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
bonded interface can be steered to the wrong slave.

Use sizeof(ip6h->flow_lbl) (the array, 3 bytes) so the whole flow label
is copied.

Fixes: bd3920eac1331 ("RDMA/core: Add LAG functionality")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916120926.1761-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 66c7e1e6600dc..10e22648f8131 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -59,7 +59,7 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 		ip6h->version = 6;
 		ip6h->nexthdr = IPPROTO_UDP;
 		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
-		       sizeof(*ip6h->flow_lbl));
+		       sizeof(ip6h->flow_lbl));
 		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
 		       sizeof(struct in6_addr));
 		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
-- 
2.53.0



