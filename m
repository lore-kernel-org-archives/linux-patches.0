Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADF5348C6B;
	Wed, 30 Sep 2026 19:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796274; cv=none; b=m1vPuLd5kfLJjTHUp0dL0YYa+PQ018CcX/UN0q9YRmrgwQZNeVPR9g8IaTScVOF7I8h1aEE6J6FnwKJ29KeIbrW7dfyfoWS9BA5/m9doUcApvWdXRVlQsPW9WD+EMaR7CRqvISGjXCQyklfMPm8SACdR7DIS9HalybJHBjD7a7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796274; c=relaxed/simple;
	bh=q6/kPGHEP2bqUlJ7m2+MRSYVAk0NEKyV+XzqBHyv8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDr2PUXZL930hFniDBJP+Ur1WUiXCQ2fGxHG/iKm+T7nHW2DqBToXvOYxW0nAYZ2eWZskxs/dNFgbu5N53G4KAxqWDPlMlJyJtKddsuU7uS/MzsgMNwAFvOrhRyuw3TAOjwQ8ruGNfyqkNyE4XLaUOkXV3dpHjoS5VKQQ1ATqaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vx4mvWQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vx4mvWQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C191F000FF;
	Wed, 30 Sep 2026 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796273;
	bh=6PBIU3KaWYhY98h62loQDkDXrAso8HVUTWGoyFMinYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vx4mvWQY5DUU9DmmW1UtwrrKXuRkfaNQOH2P4JcDHcWjwfs8CgrRnUsQYG26zagm2
	 FO6zuxXcBxZx+toc4iFY1FBO/dpVejeLrRZe6HuIsO/GjoHE8AIgRPeKBUtft6D9AI
	 lJfNg4CAHNOXOH5YKqvTi1/T4t99Wt5dLzqYQvLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0810/1193] pppoatm: ensure a writable skb header and linear data
Date: Wed, 30 Sep 2026 17:24:54 +0200
Message-ID: <20260930152452.241923926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



