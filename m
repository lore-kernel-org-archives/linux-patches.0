Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704236;
	b=Tpj3dZw+ZAc13uR3t6ph22djPRySI01SMrgTaQyD9Cg7MmmnPtuB7fQuE9DSY9vMBSMv
	 5lJALprsOqLYVe0oJTHqaoxEe7ULsqDGtVXo4qLaC+vZ7tQwbadRnjhmZ6bKErHaqFJr/
	 5NFG7CyaKbzJ9CuJJcHbn9V9+WkzBweMMOmdtu6FGhZNlAfkF1V0QqnOiUzE3V+mC+5IB
	 iN/EHsTeWTLiivudCoBEVyvArk3jA8BEEKdt+Wa0klbSG5mwOnHvnZcnd5iahRxVCdBlP
	 nLQZyHzjWILKSteTU3EUmp7vWvehzXArl/IUEP3pnmn14XyLYtQkN+S0HdWorWVTZig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G2yU55V+6D1QHG3vT5nqfr6s+EdsZZTX/G1gBEpeVIA=;
	b=Im28poyO+XObqB+c9V2wmJBFM9E0ASjFZUgsKr4hBBIHtG7ObqXsoOU05sycy6bVoz2s
	 UaZ46yiH4Rs0C8R6kXcLwjZEkOrRS4GQXIC2ibP4TtpGlu8TJ3Bj3fQT7W9dk1Pp7F+Xg
	 u4G0x1oPCokQWtdWu2HM8SOlySEDMmyLlLIle6L/xxHaMxTwOBCRQv5X+MOZEarF4ydN1
	 UXBV0BtFS3EnTB3JJbTHCRpv2HMuW2ROJaqClcz0FJrq6ykW7AxDdnCC1Iu2t7RAwANBW
	 /S1UxhbMMkEV2BA0Ha8aWbYRfQM1oUZidrXsomL3tvcwu5jeD4x0Pto44ngf/tPYDTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHwnPm6+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBF9606A31C;
	Thu, 26 Nov 2026 14:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHwnPm6+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0E61F000C6;
	Thu, 26 Nov 2026 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704235;
	bh=G2yU55V+6D1QHG3vT5nqfr6s+EdsZZTX/G1gBEpeVIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHwnPm6+yqiWkhc92E4aAY6IhqFtCnDT5nbCZboovNC1grEIY3hBsCoUcQBH5YMRB
	 l6LZzmUee1G5XSvmNck0peMQDCxopHjzNxn5PevVTjITWheVD/SkFznOUovF8t8iWO
	 bm4CvGBzfzWT9jHqmRoc0T5gEAGGK4btvy3Mq+so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/265] net/iucv: take a private, writable frame before rewriting it in place
Date: Thu, 26 Nov 2026 15:36:24 +0100
Message-ID: <20261126143608.884840198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 034c4c79b898d..c21a0326951f2 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2065,11 +2065,20 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
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



