Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021640;
	b=Vw0v21MDCdQ9tS8ez6qr8izZH0nzGZSuSg1/+ixZZNiGYfb/XGGrAgaWyEhKrtwCDqAF
	 +jTvCQfwd7CRK/oMqLmEk8G7i4xK2vNQI8ws2wD+h2YweoC2y10wtVPmEhlwzPWQgdnqM
	 WoJ6BpRI7bCY1WhjxFJLJNayQa8OAKtusI0e8l9EK5DBH8os75CKV0R+EaoopFC4yXF7h
	 6flQXPQjFdxgS3nBT1rllX0GlxpBB62d9TwMcjPcF1Tb93/sAuBglkA2WbI1THPBGHjXi
	 hgPViztIDEiABqhdjSU+5OPE96libkOQI05T1m6oJQjorkhIenCl1udzPq6IT5cUDyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mr4eeLtmARLRPB0cf5n0x/88FI10iMOjCllmKO2IxI4=;
	b=TRjuGQyEwqlDjSWTbx64KRJff3oanPCRMojP+q+ebAgv5PPhV3hopu03O4j+oHFLB4ZT
	 O9VmNoKw8rAKQ8khB/RXfDP5P6E0BHnaUqFSDRmxVGTFtdLjcgO5RpdvNUIK1EvOGzRMD
	 g+FvMUZGrwm9AkBrd0x8oQ5rb3z3TYgJHmvA9s2PjSyChFoZazNYCWQVaLd58adeS4O4H
	 O6lf0wYbcIKTEdy/r8NB5VO9dSV6p4BDrG2AlPFMHdJpot7iiYgaRZl+9WSO5/M1/pxk8
	 P2Ig1lzlTDAMEgAb6LpFPyh8PpBfgp3mLxHVUjrUCHw3FHCKQdgFL9JqDQBdifw9C1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1Zx5y1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE33606A320;
	Wed, 18 Nov 2026 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1Zx5y1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AD81F000C4;
	Wed, 18 Nov 2026 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021639;
	bh=mr4eeLtmARLRPB0cf5n0x/88FI10iMOjCllmKO2IxI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1Zx5y1x6GAtFkLJgFasj9JZjAEJR2xtuyiBElTpkURIY4du9xeciqKqjREoOXk3v
	 ABsc8hfXJuczDpFsgIaaRw4aquL5k9wfg2zNy8as9u/ukQfY/X8ZemSsDWAbd/ACvK
	 wVcGUxJynsKdZQ0ECe1Idh1wRoNazkmGIZmQx/RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Simon Polack <spolack+git@mailbox.org>,
	Willem de Bruijn <willemb@google.com>,
	Wang Zhan <wang.zhan@smartx.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2379/2651] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:00:19 +0100
Message-ID: <20261118150411.109194658@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 546daf344420b5dce27eded3ad15be12628dd185 ]

skb_segment_list() detaches the frag_list from the head skb and moves
its members one by one to the skb->next chain. On error, err_linearize
frees that chain with kfree_skb_list(skb->next), relying on the members
not yet processed to still be linked after the current one.

This does not hold when the current member was shared: it is replaced
by skb_clone(), and __skb_clone() clears ->next. If __skb_linearize()
then fails on that clone, the remaining members are no longer reachable
from skb->next nor from skb_shinfo(skb)->frag_list, and they leak.

The skb_shared() error branch already relinks nskb->next to list_skb
before jumping to err_linearize. Do it unconditionally right after nskb
is added to the chain, so every error exit sees the remaining members.
On the last member list_skb is NULL, which still terminates the chain.

Fixes: 53475c5dd856 ("net: fix use-after-free when UDP GRO with shared fraglist")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Simon Polack <spolack+git@mailbox.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Wang Zhan <wang.zhan@smartx.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261021161858.761205-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0c1229c544d24..512eddc0fc3d6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4747,10 +4747,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		else
 			tail->next = nskb;
 
-		if (unlikely(err)) {
-			nskb->next = list_skb;
+		/* nskb may be a clone with a NULL ->next: keep the remaining
+		 * members linked so that err_linearize frees them.
+		 */
+		nskb->next = list_skb;
+
+		if (unlikely(err))
 			goto err_linearize;
-		}
 
 		tail = nskb;
 
-- 
2.53.0



