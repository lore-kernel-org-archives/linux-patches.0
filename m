Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2DD3AA19B;
	Wed, 23 Sep 2026 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173376; cv=none; b=AsS0hqyzBwd2i8Ng2Bx+7VAjf++gCYMYWJrs7D0xCxSFGTbZfHm9rrSuV+IRUKRa3reNWxz/1i1A3ZB246TGAPSPrvJCmjhLGmIuDxDqtA30LzJ6QvmOcEpFPjEAvurLnWiERi5jVT02VMEQUlaPNndPFYuiWelTaV7Whg7XOR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173376; c=relaxed/simple;
	bh=Hj1LkWxYQQRNsryxUNWUjbxkdD0D/BtncPoZ///nhK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeV9fZVpFMD6IVDwvNpgKCQ+A3jDL10RrN8qt97BTwtzK/SqvSztwz1htJ0MBZDigSGs/s26BOWfNBzTLfy68JLfCPUDnF2e7ACR/LLYH63BgqppDb7J26Tw8xfVhKzDrHAQvcE1Om6jjmkYPg+n8cQzZRWidb8nas2A7dUGIeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ9cPlyV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ9cPlyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54641F000FF;
	Wed, 23 Sep 2026 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173375;
	bh=U3NqCIElL1LSbFSsgDoMEdDosgEpNfTiJCXR2VxFwT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZ9cPlyVAPK/XLywR5O3FLRihERqK4H8BlGTRccDNhXxrg66E8aDFfvuTMo1eRaty
	 MnMVWuws5Y6o68cDc90zzGBHnPGsr2KavgAo5v31tw2aPqS1ProP7OfgFKdOpDjEAd
	 P16JdGbUjpgerBbN8PvVkNaHcAjtLKAlTd4pufqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 182/438] pppoatm: ensure a writable skb header and linear data
Date: Wed, 23 Sep 2026 16:03:23 +0200
Message-ID: <20260923140649.483008924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6da52d12df68e..5214786e61d11 100644
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
@@ -317,23 +320,13 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 
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
@@ -346,6 +339,12 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
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
@@ -355,13 +354,6 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
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



