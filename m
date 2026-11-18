Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032791;
	b=rAgs6naT6wvPkLghbUhgZe9jkIdI0OYcN437XKmBSesL38i4CI4DUPaLnUGnvE3qFb+5
	 AyrPrdUhLhauNVjyOgKFbgBbiqdFX3g/F4Ndn++G4+2yMBzr4e2qDLfheiPatZjYVoSEg
	 /UeJLIl7CaKUoQJI2imPQ9LL0F/2FvLxhHRq4Cx+Fv7ljVd35clnADGHn7lVDIsYxka9V
	 ObVSC/MV8X8EJEmWoEhBiVsJw7aM0357xPePpzL68QF3Dv1HUyMsaaOove45EMdeUyFrC
	 3litG7Zfqg6QlgkVcaGTrsBd6GgklIZxCPaQBptFu081E5QCvWJzmz9Pq3WLP2GLEQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pEXZaYkIcoMGPsVTj3X3hZ9VQi82uEQ5CP2kZwhE9IA=;
	b=hGfTqClMe49WzZcvVbkPNhgtYcDCdcccipgIYkPsGbYTurNKwON0M4sZNJ6eQidBwFfF
	 Xz9vMVGBdBg/KESsPdmXA32lOP0A5mowfVLBglb6POFCjcnOqEQzBMJy6n+aX10iG5IJ3
	 zrx8jX7GGpchdn+1Z+Zj7FR4RExKKxmGiuXXk5xqW7uw0Nyu8iXxUbYJgNv3/NgR2eQFt
	 7GSq1NLLpHsHE/YYjd1m5TlWY3634uHPWHr8wHPKoQvQSrwpR5kbuEE0PK2fvTSxUmysO
	 jkSc1b9OAMMBEOtIuI7qRJiiH+BLrYD+yfhVfH4bm7pjE7KO0qx7wvG8bWj6i9o3GCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEdgJPHS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAF2606A31C;
	Wed, 18 Nov 2026 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEdgJPHS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4273B1F000C5;
	Wed, 18 Nov 2026 20:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032791;
	bh=pEXZaYkIcoMGPsVTj3X3hZ9VQi82uEQ5CP2kZwhE9IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEdgJPHSEWV6b2vlm3p6HDYQ04QsxLDGrWOoKcxUi+Zl71q0cWGdA0ZG42hK27Y4I
	 XmZDBptD5ecD2XAxNBSsKH47KAEyqURjenLhIAx/L06P17c0atv2OynkqvbAcdsNL9
	 TDMqCe0hf57c6Ismr0cz32ATktKuHWCkXlXt2Pz8=
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
Subject: [PATCH 6.12 1537/1756] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:01:04 +0100
Message-ID: <20261118150110.134299583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c6006dc958c91..8bcf153977fb1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4673,10 +4673,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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



