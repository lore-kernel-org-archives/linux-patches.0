Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027817;
	b=R1DW3ZCXEPvlcYg6j49EiR2/ptsUCLQ4guPdCXwmkYR+PSErhmExYE2yBhOYLrAyybgd
	 ZCWCtei9NoKrrDexL+y5t0tTRPP7Dv4P6ALPJeUkm1oMwfanFZkm5VXxuK7U+eEMi1o44
	 soLMTRNsU+zMI1iJIAYbElBB+gF4WY72EM4FAyjn7k35AX1B8ARwFwz0RT3ryc6RDl1pw
	 5aorF1KQ1B5pgSERYTrsnGK0gBG2y37WV/dv6w/AAUfIqUaIWJWI1snc2loVneR7Rzizn
	 ZKm9thETwXTkCt3XhCAs1fj0ePKFlGqrteBD6U+Mp8a+vWSg5NNd6kcaJGWyIgHaqFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTTg6yA04+2kz5hoRYHisco+QaHkdvPHUMjtRskN0q4=;
	b=3/zGWcyGcGI1A+Q9AhzhsxYk3j7Mf/xRyHOgdeV7MbvG/J7DS99lVtO8gEMPU/ilkH+7
	 4HMM5sXzJVQpBm72B3QNVjnK6F+di1mA3+1JkPY9+a7NMpvACSp8g1Q3WoB/K6NGzVmMV
	 p5qs7Uzu/HWi0v2H2t6pee/vYwOcgJOy08MhtH8LiuUnHm1hEkaara6BdAdXfeNfJXJ8r
	 YhPLh/0WsU3N+JhRM5SGtue6xiduMNxq/B0japrALx/a5zDt6y5j7VvI9EcxKKpzJLNgz
	 ro9jPFeRWAFb9vtAiGZAm/6SHW+7ymWuAn7fL+XSye0ev7HtKGQwSTQw3p0Pr73sVcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTG9dNOG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E07606A325;
	Wed, 18 Nov 2026 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTG9dNOG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6861F000C4;
	Wed, 18 Nov 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027817;
	bh=QTTg6yA04+2kz5hoRYHisco+QaHkdvPHUMjtRskN0q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTG9dNOGTlfrjnRTFEvzhqThqse1nEoMvM8BTcQhwLy+yg1Tb/tGTaTlYr5b3h/Xu
	 z3GJX17Jw2nygbEF1Tu2PPrWkRi360cunptb599LSyUCUhwDuc4Cfl2hvohIzOFww0
	 AF0G0Fv5SHVAUkges/w4FIoR21fUQdHlaRdJAN0w=
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
Subject: [PATCH 6.18 1925/2151] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:01:00 +0100
Message-ID: <20261118150231.903607104@linuxfoundation.org>
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
index 5993b2b4beb99..e28802a46fd29 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4685,10 +4685,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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



