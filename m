Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042779;
	b=jFwO/FR1hhhgxkE1IATpu+deKSF1QfpUsZ2cG07iQvUxH2SdwL5fPliPgeMev4OJMEzb
	 czUFmeoTxWtDBBjHky7butYZBzVZvK+mVMv3n2IJoM1WqtD1p75AWsbGRdUC8SCEFIkq4
	 BoZu9vi45rt2z+FkxnOvV21YpetBfZ6yqPb+j+iyctsnJlLR5vdoactMd9e4EiLOPAV/Q
	 mu3wURpJKStKx1iXQ5lHkqnE3kqZnVLvURTp8JKTEKnkjYiyzTdDuOPRJJ6Z71LIJf83t
	 xzPPUmZlyNPMxI6BPje0s+Ubdkyy42vvVRZkRMt9TqR2yKbtutjlmLVD/E0vgbd3N2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nhJG5BXaRXHcggxJ6Wv62jvK3e7uoGmwY6xgUf5rB+8=;
	b=UWatemeLH2xmN1MSug9iFz8U6dIvhA6bHSOYYn6ckz8szDU/0siM41rHruoePrQZHcMO
	 F0+ehREJ/9NpzFjgAGH4HavJ4XFDfbKT2yxFr4Vf6u5+8FRrkpzDm0bY9oeOnINLDVnY9
	 ePBlQ6ev/4cyQKl+TwJIk4LjHfZQA7jvPQ+qAIb6X4tnrlhpHej7jK1C5sqijaDAmQL02
	 JEtKYeE7LDjDK5wDJ682PWAM1ws4IPAAxyBbYG27gTu9SFnPWq53V4fB/F5R/+7CkUE3i
	 lsjpev2UDWk9sPpGhcwCsMHuDmBVDFDWYD7p2blu2nPK5Qn3NVzvm8IMChOlype9asA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uG6NGONf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F218606A31C;
	Wed, 18 Nov 2026 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uG6NGONf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001CE1F000C4;
	Wed, 18 Nov 2026 22:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042779;
	bh=nhJG5BXaRXHcggxJ6Wv62jvK3e7uoGmwY6xgUf5rB+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uG6NGONfTePLV6kcITSOnx0O+4YBqBN3E/WIraRzmIVZo0BB0zgAbZVexWh++DBuq
	 KFENwmpx2U5SXH1iY4r7d1cEDkge98ld8UC0Y5qCl05/mAVThDtuHlbFBlQp7AXTuM
	 ahDjGIuH9rKU6TgFQo3PMqmg06mkCmSdX4rS1pME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3242/3318] net: mctp: mctp_fraq_queue should take ownership of passed skb
Date: Wed, 18 Nov 2026 16:04:24 +0100
Message-ID: <20261118150456.932696262@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 773b27a8a2f00ce3134e92e50ea4794a98ba2b76 ]

As of commit f5d83cf0eeb9 ("net: mctp: unshare packets when
reassembling"), we skb_unshare() in mctp_frag_queue(). The unshare may
invalidate the original skb pointer, so we need to treat the skb as
entirely owned by the fraq queue, even on failure.

Fixes: f5d83cf0eeb9 ("net: mctp: unshare packets when reassembling")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20250829-mctp-skb-unshare-v1-1-1c28fe10235a@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: d2bfe74a8fe2 ("net: mctp: free reassembly head skb when key_add fails on SOM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 12a9e2af8cbc4..d3b20981e4ab8 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -328,6 +328,7 @@ static void mctp_skb_set_flow(struct sk_buff *skb, struct mctp_sk_key *key) {}
 static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev) {}
 #endif
 
+/* takes ownership of skb, both in success and failure cases */
 static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 {
 	struct mctp_hdr *hdr = mctp_hdr(skb);
@@ -337,8 +338,10 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 		& MCTP_HDR_SEQ_MASK;
 
 	if (!key->reasm_head) {
-		/* Since we're manipulating the shared frag_list, ensure it isn't
-		 * shared with any other SKBs.
+		/* Since we're manipulating the shared frag_list, ensure it
+		 * isn't shared with any other SKBs. In the cloned case,
+		 * this will free the skb; callers can no longer access it
+		 * safely.
 		 */
 		key->reasm_head = skb_unshare(skb, GFP_ATOMIC);
 		if (!key->reasm_head)
@@ -352,10 +355,10 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 	exp_seq = (key->last_seq + 1) & MCTP_HDR_SEQ_MASK;
 
 	if (this_seq != exp_seq)
-		return -EINVAL;
+		goto err_free;
 
 	if (key->reasm_head->len + skb->len > mctp_message_maxlen)
-		return -EINVAL;
+		goto err_free;
 
 	skb->next = NULL;
 	skb->sk = NULL;
@@ -369,6 +372,10 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 	key->reasm_head->truesize += skb->truesize;
 
 	return 0;
+
+err_free:
+	kfree_skb(skb);
+	return -EINVAL;
 }
 
 static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
@@ -481,18 +488,16 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * key isn't observable yet
 			 */
 			mctp_frag_queue(key, skb);
+			skb = NULL;
 
 			/* if the key_add fails, we've raced with another
 			 * SOM packet with the same src, dest and tag. There's
 			 * no way to distinguish future packets, so all we
-			 * can do is drop; we'll free the skb on exit from
-			 * this function.
+			 * can do is drop.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (!rc) {
+			if (!rc)
 				trace_mctp_key_acquire(key);
-				skb = NULL;
-			}
 
 			/* we don't need to release key->lock on exit, so
 			 * clean up here and suppress the unlock via
@@ -510,8 +515,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 				key = NULL;
 			} else {
 				rc = mctp_frag_queue(key, skb);
-				if (!rc)
-					skb = NULL;
+				skb = NULL;
 			}
 		}
 
@@ -521,17 +525,16 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		 */
 
 		/* we need to be continuing an existing reassembly... */
-		if (!key->reasm_head)
+		if (!key->reasm_head) {
 			rc = -EINVAL;
-		else
+		} else {
 			rc = mctp_frag_queue(key, skb);
+			skb = NULL;
+		}
 
 		if (rc)
 			goto out_unlock;
 
-		/* we've queued; the queue owns the skb now */
-		skb = NULL;
-
 		/* end of message? deliver to socket, and we're done with
 		 * the reassembly/response key
 		 */
-- 
2.53.0



