Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621393;
	b=GhrJqk3oLu7RFHAuwwTsapu/F01Uv/AegYWiCxPFll++Ev9i7LP2xbWiCf6fdBGqS8c+
	 y6NEQA9rPsE3x2dvmyluDVKjjRFNfsD8eEZWraxfXYeU2ycvEX5fVVwtHWn1bOvfWbeNd
	 f5kdN50lFMG8Zv3Er52HIEZsd4MhSADzzca9V82fT7G8mj5w7cmtVsPSeu2CK74AAX+Br
	 EcpvgMmcmZszNnn86wNBp/Zyr/JYrIwp25RrMqTLoMd1EE4+b5ASS8a/MN5l1BjmY5xME
	 2UvAayeEA1+aSN6f42BApi+kbX2X6sxIPInpNnVZsObjJ0gQYBAxmY6fq2o2GAf9tKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DkXn1nCXA0UXegTBho3vI+rztkvSJJIdx6Q4Bo2ASy0=;
	b=APvSx4PINdJoz32Cm/26PyXFqIihvL9/z4Rq1XWcMpsW3MjC3iISr3c4Bz/9cbC6McQe
	 kD04WUVe2LNqFhTR3tEAZeArLk30QioFK/fG6pG7pGUkgZHpMmFoYRi7ONjrehy+E9mvm
	 cENYWn3P9jrgFIkmzSybOdEK4fk3kJM09esXQhN1W7u4aIsigrpuDVF7ADMYxsliB6sNf
	 Os0JfiCwJ9YWsXA6GZZW2ewRuvQmqNgCCVhlzG2nGnmTJsoGk7+ZVqPNUQMu7+78tbZSa
	 fhI35xfHehlx6vAcezhRmuvS+V/l1RgXtWSx0jnNGb7AwythQ5Kp6eEkSPIgVI92FWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2OTOzmO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDED606A331;
	Wed, 25 Nov 2026 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2OTOzmO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8D61F000EF;
	Wed, 25 Nov 2026 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621392;
	bh=DkXn1nCXA0UXegTBho3vI+rztkvSJJIdx6Q4Bo2ASy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2OTOzmO9bbkiKq8es4d7hiCTEtCeM/63Wq46wCTZs5La2PxtqGA5yoHvSF//waaT
	 M1bLCFyInijYiSOk+jfYc4xIlysq2IK2M3dS3eIMpC6vwQJhdH4Zg+lIfFrb9+VFqz
	 fDIvOAX43Rkbug0M5YRSiCnAHk+kKygxz9pw7jvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/990] net/iucv: take a private, writable frame before rewriting it in place
Date: Wed, 25 Nov 2026 15:25:33 +0100
Message-ID: <20261125143825.983629633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit f38bce9af9e2a3cced7d303a1476f21c1f42bcb7 ]

afiucv_hs_rcv() rewrites the frame in place -- EBCASC() on four name
fields, then afiucv_swap_src_dest() swaps them and pushes an Ethernet
header -- and can hand the same skb to dev_queue_xmit(), without making
it private first, so a packet socket that also gets the frame reads the
rewritten names. An ETH_P_ALL tap runs first and leaves af_iucv a
cloned skb; a socket opened for ETH_P_AF_IUCV sits on a ptype_specific
list, walked after ptype_base[], so deliver_skb() takes a reference and
af_iucv runs on an skb that is shared but not cloned.

Unshare, then cow, in that order: skb_cow() can reach
pskb_expand_head(), which has BUG_ON(skb_shared()). skb_cow() tests
skb_cloned(), which is what a rewrite of the data needs; skb_cow_head()
tests only the header. Asking for ETH_HLEN also covers the unchecked
push in afiucv_swap_src_dest(); on the ordinary path eth_type_trans()
has already pulled that much, so it only compares.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Closes: https://sashiko.dev/#/patchset/20260813-b4-disp-60433a46-v1-1-509e1200533e@proton.me?part=1
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261028-b4-disp-1edbbc34-v3-1-13495411f5b9@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 3472bdde31af4..a8601a8782409 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2072,11 +2072,20 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	int err = NET_RX_SUCCESS;
 	char nullstring[8];
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return NET_RX_SUCCESS;
+
 	if (!pskb_may_pull(skb, sizeof(*trans_hdr))) {
 		kfree_skb(skb);
 		return NET_RX_SUCCESS;
 	}
 
+	if (skb_cow(skb, ETH_HLEN)) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
 	trans_hdr = iucv_trans_hdr(skb);
 	EBCASC(trans_hdr->destAppName, sizeof(trans_hdr->destAppName));
 	EBCASC(trans_hdr->destUserID, sizeof(trans_hdr->destUserID));
-- 
2.53.0



