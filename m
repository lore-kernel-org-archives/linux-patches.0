Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042371;
	b=p1xcDgB8svy6pzxbworM5k3FzzagwARwp6R72ZLDnIxCIPc5oNZRD/h2vhZciGhYkDzv
	 gC1Vp2w46aGiZN5eTsTaxNqmFUN6ufv6OThved5UoKKyXR0Evc5U5TZKJgnN8P1+zzmvZ
	 INXLowcGuLEgcvpf1LxdAYxCT7udcd5ZFzch+qfHe2ACUAmtvLPKrDPf9+c1obsZM1Qup
	 WfRpCjch29yB5TVN97mnV/j9xAg/TkExxW9L2zEUiaubB5CoRB5xtH6E/aeXPZNJLD0r3
	 H39t/Q0AFxSBZW5pmowA7jMNDZgHHDPb4dLWZzUW3rEptRk4C+UZBJdj+rURmNx9flQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nhPha+cCkkvpUmTDu5iLfMbRoq+q/z1z4JPenbTGEqg=;
	b=I4Xyd9WSLv4+xrjcxQlBj9M6cfsVyg0TKELvLlnkfEMLzd8/STJDiqljnB77xnXltheR
	 3jqn06wAfeIpPkLJLAYbwpmaz3ixavSpd7lpZ6jBSDdQlL5a6kbQzEWRtCLJJyjSxV74L
	 qKWmMBq+aEoUBSXwaxTvRoHAgNYtrTx4AxqEn5BDaA0lLzeqB2NwlNOVRaNcD0oda8Cfw
	 d26kTA86KecmZ22R329vcQihTD02CceYhJsZq1OvZbeVDBgefoB2+vJqpTlb1whil02LJ
	 0jNMYnYMDFouPImWLIhBa1faTmuYq3HYpRLWinJ9r7uN/S8N9f0ZUoQMU81Vtp90Caw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H8wHVsxb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D478B606A31C;
	Wed, 18 Nov 2026 22:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H8wHVsxb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAA11F000C4;
	Wed, 18 Nov 2026 22:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042371;
	bh=nhPha+cCkkvpUmTDu5iLfMbRoq+q/z1z4JPenbTGEqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8wHVsxbyLWhFQ+tmg1xr9wpgYQRazYd2Cptp8Cluwq59xFhF3/GfT1hkEolB3Zf3
	 cv8YMh1H5op9kvukFJz+LUCXhSVdR5NEEYtLWlqk0EUyfJQ97OI8kPSypCgKhqrtWb
	 T9wQtsDN9jiwRxFFVacsQ/bV3cq6NdqVZJEdDVlI=
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
Subject: [PATCH 6.6 3146/3318] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:02:48 +0100
Message-ID: <20261118150454.249227326@linuxfoundation.org>
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
index 28e84b894936b..74d24551fd8d0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4399,10 +4399,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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



