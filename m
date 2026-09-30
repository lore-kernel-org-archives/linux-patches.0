Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18114D6C2E;
	Wed, 30 Sep 2026 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792009; cv=none; b=b1tt9mX1/vHmQMEXZh660BvfbVEFnX4G4Du/W9J0TDvdRrO46Gz8dCjzr0Dc7eS/NTvchBp/7g1/TVLXX1D2DYJE42/0DS1xgS0z3NgywI93RTf+RLLojk3hOs9eRB5U12EfQHAWzjY60SYYxlJXVtrh+y974kHaQE/BxRY6m2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792009; c=relaxed/simple;
	bh=I9ChGezGSuMac0kBJwibYaXCIkdLoqzq1UkS7lQC+lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pd7xCG2+iT0SYXaeBNIwNjxX0phXkIKiKyBGfD/hfaO7WBvL1MUYr2E79YxAZ+etF3aa95zrJbKc5TR1kSLLvFZSqbBCeHyjg2+x/+2ZSw1+3Okdb69UPOxHqi1Dkg6PKmX/GevBY/+GJxGMPTM1EydeizQqeS9l05bZ97HFggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWdtP3Q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWdtP3Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064EC1F000FF;
	Wed, 30 Sep 2026 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792007;
	bh=YTaRuPkufBFYVoCWPsnsxYNfdW0xwVAy2VDU5KCYHIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWdtP3Q09781E/6851Qzc0A8sh1Og9qtA/gK6uItb5tmineSzKFKNHwDpOL+1bOTo
	 lN3iC01nEKNWVbbHTCSzEbNFKe48FbXbkPI8ieSdAVCLRKmoLbJxhitK1ihZUxagia
	 NqTJDzBJupYkn4T5IMcQ6rVS9fBUkHOsvA+lyO78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 501/752] pppoatm: ensure a writable skb header and linear data
Date: Wed, 30 Sep 2026 17:26:11 +0200
Message-ID: <20260930152409.102528313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



