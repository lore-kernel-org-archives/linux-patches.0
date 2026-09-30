Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316D951A148;
	Wed, 30 Sep 2026 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788480; cv=none; b=GyQK8rycanCLv1h2wAW9kM/yvvr9o0vqz8ikgVAIwAdDS412eY96FVb8ufJ8ICMJgyQajH0dm7TApgD8xjRlQTTqhBw77W0bIuVN3yGVAX23N4Q8s6QZQLUKJ2k5Z83eE1X4mSKwY7s+y6OlBE0ofwHNQtzd35xoHkx1GE5lhaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788480; c=relaxed/simple;
	bh=KZaFhYXwsXVyf78aZgiFwnVTlGD42j7g6eqx+jLbQ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPZrsWzBCUSJI2EbotQDa4myB0FxVr2JU0pYZh4bbWY7Hk3854A+bQM83mo4IF1MTwGEfQAnhTPkKcUy6CowdwmSJnlnDoIvXp+f5L67STHze2xpQmgpHGJdRgiejxPZ0VSIStYuyQPkozHTrS7j3nfIBB0HvZSWqWc/QF+n27E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USgDqXm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USgDqXm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C781F000FF;
	Wed, 30 Sep 2026 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788478;
	bh=NIhOTp/I+D5/+pT31fcRjELbG3kWs4MRjXn8uZtoyuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USgDqXm4DL7Yjjl14Wu+u9RnMrtON3i0+49XUN6c/B19Wx5jJ/XeOM7FI6RTpkoXR
	 54f1dVtJcdh1P9szKTgFySGSxVOn6gpI2mcq4ckTTcXMddGuxJi/Bxfq+m2kt/lqJf
	 Xf36cUMCSQly+ZvgZvhPCjBxW4tb0YAGfQVRwel0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/877] pppoatm: ensure a writable skb header and linear data
Date: Wed, 30 Sep 2026 17:17:30 +0200
Message-ID: <20260930152417.727362404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ecc7253683a3c55caa868ce0ee530fcb0044bd3c ]

In pppoatm_send(), LLC encapsulation checks whether there is sufficient
headroom for the 4-byte LLC header, but does not ensure that the skb header
is writable.

Normal transmit packets passing through ppp_start_xmit() have their header
unshared via skb_cow_head(). However, packets can also reach pppoatm_send()
via PPP channel bridging (PPPIOCBRIDGECHAN) without going through
ppp_start_xmit().

Use skb_cow_head() to ensure both sufficient headroom and a writable
header before pushing the LLC header.

While at it:
- Call pskb_may_pull(skb, 1) before inspecting skb->data[0] to prevent
  out-of-bounds reads on zero-length or non-linear frames (e.g. from
  bridging).
- Defer SC_COMP_PROT protocol compression until after pppoatm_may_send()
  succeeds. This eliminates the temporary skb allocation on admission failure
  and completely removes the fragile "undo" heuristic at the nospace label,
  avoiding any risk of reading uninitialized headroom or performing an
  unbalanced skb_push().

Fixes: 4cf476ced45d ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260912233048.3977192-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/pppoatm.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 3e4f17d335feb..b668a30b67a8d 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -292,10 +292,13 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 	struct atm_vcc *vcc;
 	int ret;
 
+	if (!pskb_may_pull(skb, 1)) {
+		kfree_skb(skb);
+		return DROP_PACKET;
+	}
+
 	ATM_SKB(skb)->vcc = pvcc->atmvcc;
 	pr_debug("(skb=0x%p, vcc=0x%p)\n", skb, pvcc->atmvcc);
-	if (skb->data[0] == '\0' && (pvcc->flags & SC_COMP_PROT))
-		(void) skb_pull(skb, 1);
 
 	vcc = ATM_SKB(skb)->vcc;
 	bh_lock_sock(sk_atm(vcc));
@@ -318,23 +321,13 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 
 	switch (pvcc->encaps) {		/* LLC encapsulation needed */
 	case e_llc:
-		if (skb_headroom(skb) < LLC_LEN) {
-			struct sk_buff *n;
-			n = skb_realloc_headroom(skb, LLC_LEN);
-			if (n != NULL &&
-			    !pppoatm_may_send(pvcc, n->truesize)) {
-				kfree_skb(n);
-				goto nospace;
-			}
-			consume_skb(skb);
-			skb = n;
-			if (skb == NULL) {
-				bh_unlock_sock(sk_atm(vcc));
-				return DROP_PACKET;
-			}
-		} else if (!pppoatm_may_send(pvcc, skb->truesize))
+		if (skb_cow_head(skb, LLC_LEN)) {
+			bh_unlock_sock(sk_atm(vcc));
+			kfree_skb(skb);
+			return DROP_PACKET;
+		}
+		if (!pppoatm_may_send(pvcc, skb->truesize))
 			goto nospace;
-		memcpy(skb_push(skb, LLC_LEN), pppllc, LLC_LEN);
 		break;
 	case e_vc:
 		if (!pppoatm_may_send(pvcc, skb->truesize))
@@ -347,6 +340,12 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 		return 1;
 	}
 
+	if (skb->data[0] == '\0' && (pvcc->flags & SC_COMP_PROT))
+		skb_pull(skb, 1);
+
+	if (pvcc->encaps == e_llc)
+		memcpy(skb_push(skb, LLC_LEN), pppllc, LLC_LEN);
+
 	atm_account_tx(vcc, skb);
 	pr_debug("atm_skb(%p)->vcc(%p)->dev(%p)\n",
 		 skb, ATM_SKB(skb)->vcc, ATM_SKB(skb)->vcc->dev);
@@ -356,13 +355,6 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 	return ret;
 nospace:
 	bh_unlock_sock(sk_atm(vcc));
-	/*
-	 * We don't have space to send this SKB now, but we might have
-	 * already applied SC_COMP_PROT compression, so may need to undo
-	 */
-	if ((pvcc->flags & SC_COMP_PROT) && skb_headroom(skb) > 0 &&
-	    skb->data[-1] == '\0')
-		(void) skb_push(skb, 1);
 	return 0;
 }
 
-- 
2.53.0



