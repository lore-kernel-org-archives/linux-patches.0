Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041732;
	b=ZcpzBxxGQ75+xelPbYzA59ktCjk4LicXUSSj7d4NtbX7pLhLqezW2mFuoFKmun+mAutb
	 EWYNcycPq6SAIwcpbWD9w4ugFrLTt2oZfKjzTOesxvTnqN9Uyjd3peu+HIY+jgSwfqDV/
	 fJrGllloJDU6A0SAXF4eUmSJefM32tbgiy3ZLUJpyz2ddj/ki07SM5620V3zKAleedm+8
	 1M8OtKRWmwMrOnuqZsAWDT98IuGXaGRNQQbMjKPp95cmonWRwQaJBbXjPmp1ZPDnN0KDh
	 e53ye9VeszkuW1goqw4z1SdaMNwgkHZT9IyndO60+R/lhRDUOxWDO+770D19iVdXleg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hDPCxOYsCTFVhlbrPXJ1SuLQemVpjUR2MC2LTaZ1bZk=;
	b=e2px2z5oLfku4nP9sGlv06zJWFh9DVhTFBVQC7GETr7v+ud5p1caQRqYDXB3Ip9+VL+B
	 M8xiZWdEBoe87cU9L9PnucSXgurHn0xoeLiknHe2BPGcMouT4QqdR+5T36/jXHOQZdUWJ
	 wIASXlnepTwm/JpdHcKO6pTfd30XvcfjB+EqYZOzQSxxjBb4wgoRvESvh39o+yPz8BXv9
	 VM3MMKcXqBXEDIQYMrbb3uM67Hl/0GOTZHIsg0BK6MEhi1iS8d0kaKQZx1+GQbcRpC3Of
	 8zWwOvodOSv9KS6YQxogZeXiA8LgWCN8C7Mh3+pk3hUxQ9/DDJG0+FoGJRSNq/KM7iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytSqOBcD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EAB606A32C;
	Wed, 18 Nov 2026 22:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytSqOBcD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0781F000C4;
	Wed, 18 Nov 2026 22:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041732;
	bh=hDPCxOYsCTFVhlbrPXJ1SuLQemVpjUR2MC2LTaZ1bZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytSqOBcDj53EyXAR6dFy3CL7cqL6i/VRthy6xbyE2mmcS1IU/u1+TOeGqoQ0xq4Ie
	 scSyRBF9qvIAmbZZlBQRH0TCMlKNbjPBb5l4HgkCZG8XX0wkpdnFkzFsMl5y4s1WlZ
	 +xo3wukAhftc1JZcJ7IQcSTjoa+1Tox7AfTNLyp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2919/3318] RDMA/rxe: Make rxe_loopback match rxe_send behavior
Date: Wed, 18 Nov 2026 15:59:01 +0100
Message-ID: <20261118150447.991708689@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 55bec1c440e6852e907c47cd33fbbf63fcc5f1ba ]

The rxe send path currently counts the number of skbs outstanding between
the rxe driver and the ethernet driver to prevent too many packets to
accumulate waiting to send. This patch makes the local loopback path
behave the same way. The loopback path forwards the packets to the receive
path which will eventually call kfree_skb on all packets and drop the qp
references. This makes the loopback path more useful for software testing.

Link: https://lore.kernel.org/r/20240329145513.35381-13-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 56a27df6cedd ("RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 857988eed4edb..2bff70ef2f706 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -386,6 +386,12 @@ static int rxe_loopback(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 {
 	memcpy(SKB_TO_PKT(skb), pkt, sizeof(*pkt));
 
+	skb->destructor = rxe_skb_tx_dtor;
+	skb->sk = pkt->qp->sk->sk;
+
+	rxe_get(pkt->qp);
+	atomic_inc(&pkt->qp->skb_out);
+
 	if (skb->protocol == htons(ETH_P_IP))
 		skb_pull(skb, sizeof(struct iphdr));
 	else
-- 
2.53.0



