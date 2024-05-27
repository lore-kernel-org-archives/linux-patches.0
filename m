Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6347C160877;
	Mon, 27 May 2024 19:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838596; cv=none; b=GjNE2wglSKdDunaRCyvVIxWQ/73YMcSIznoEAyhtnXKsS2M7vh6VGEnE1YmJ3O21cXuS+TEFWX3LESUHHlIfihisXOv6gglPHYnqwx+vqapiNrNSuBzWeBoQ8mhm33d3Uc7URDqRMB4wewoaA23W/vkFCMkcUyCem9+NF0bqZ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838596; c=relaxed/simple;
	bh=j7byoY24LXlga5o+fFlJCjTzRMHbz9Ftz8ABoQJY+4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4V7RrpL7Yx1MWB2g1+rSvC//iNN38nThjqkFaoRgWSKN5ftSiXhxMf2GrLn4HLW4JStiN9enD80rDJBgMJbRvtS1rTEsW4USqACpKkgim/e1mzCP3MBy6S7UxaiQNdIAg53u2zOLfIAfXuDmog6e+SUOPTkjqIzAXePU5hoT0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do7Hwspe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do7Hwspe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB226C4AF0C;
	Mon, 27 May 2024 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838596;
	bh=j7byoY24LXlga5o+fFlJCjTzRMHbz9Ftz8ABoQJY+4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Do7Hwspe+hgDWwjw7auCNwvEtz2fpWHNpRmEtqvCS55rLQuvN2yjtaafv7n7SIddX
	 Wis5RlnlagcYcUBRmHUG6h8FEz1SGYh6KkPz188lmsAQYxHOiJQSuHp11djmgSKNQc
	 gcOid1GbpZCSNedN1F0Xr2qtAxCcivcchlBbdB0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 437/493] RDMA/rxe: Fix incorrect rxe_put in error path
Date: Mon, 27 May 2024 20:57:19 +0200
Message-ID: <20240527185644.565919760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 8776618dbbd1b6f210b31509507e1aad461d6435 ]

In rxe_send() a ref is taken on the qp to keep it alive until the
kfree_skb() has a chance to call the skb destructor rxe_skb_tx_dtor()
which drops the reference. If the packet has an incorrect protocol the
error path just calls kfree_skb() which will call the destructor which
will drop the ref. Currently the driver also calls rxe_put() which is
incorrect. Additionally since the packets sent to rxe_send() are under the
control of the driver and it only ever produces IPV4 or IPV6 packets the
simplest fix is to remove all the code in this block.

Link: https://lore.kernel.org/r/20240329145513.35381-12-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Fixes: 9eb7f8e44d13 ("IB/rxe: Move refcounting earlier in rxe_send()")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index cd59666158b18..e5827064ab1e2 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -366,18 +366,10 @@ static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
 	rxe_get(pkt->qp);
 	atomic_inc(&pkt->qp->skb_out);
 
-	if (skb->protocol == htons(ETH_P_IP)) {
+	if (skb->protocol == htons(ETH_P_IP))
 		err = ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+	else
 		err = ip6_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
-	} else {
-		rxe_dbg_qp(pkt->qp, "Unknown layer 3 protocol: %d\n",
-				skb->protocol);
-		atomic_dec(&pkt->qp->skb_out);
-		rxe_put(pkt->qp);
-		kfree_skb(skb);
-		return -EINVAL;
-	}
 
 	if (unlikely(net_xmit_eval(err))) {
 		rxe_dbg_qp(pkt->qp, "error sending packet: %d\n", err);
-- 
2.43.0



