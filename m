Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E174315A;
	Sun,  7 Sep 2025 20:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277597; cv=none; b=Jgr9UQiT8R45TDtCFnW3LYq9Yw9mYCmIa1l6irVDoY3okdx938Vfy0iqon4zzeoCwDbNAmGDzejewvcw5fRfTgl/LFQKIe/2JFEt0fkpFvgASGzYZJR9ntTAojwId3Sb6XS4jw1pwndId1jmyXAaJKqCNzziUxMiSOpJGyFULu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277597; c=relaxed/simple;
	bh=Z8SsJDerRv2ho0DAJZuNC5xGr4Q0JBTU69G0xTZ7g4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrH3Nl3qkiA9t+bTLzAoy1EibG/5WkrFEDH6eO/h660oFrp5BZsqA6a8dIi/Ftgk7MWrU9BeQjIbqgD4h/BhfPuj/xmbwAeJca+m7ToSi4Y+byWK9Z/T9L8KxNhSgsIimLFv6hqRcUD7OLS04HAW79Prp/Sa9DFkLScN0spY3GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMdir4iX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMdir4iX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347DFC4CEF0;
	Sun,  7 Sep 2025 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277596;
	bh=Z8SsJDerRv2ho0DAJZuNC5xGr4Q0JBTU69G0xTZ7g4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMdir4iX3JBqgH9CfqOgt8M/YH+VeB2elpUDD/MiWY68zXd6G00vk6bStc7iibQ2A
	 6wj98bDQuYKtE5yCKYegMxcaLn1g3l48VcdiqpKJvYut6vAYjQ1fjK4BTOneFsCbY2
	 PQUZVUmPoYM4fXu2odaUIoisPNL9MI3Oa0OW0PXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 062/183] net: mctp: mctp_fraq_queue should take ownership of passed skb
Date: Sun,  7 Sep 2025 21:58:09 +0200
Message-ID: <20250907195617.264481994@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index d9c8e5a5f9ce9..19ff259d7bc43 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -325,6 +325,7 @@ static void mctp_skb_set_flow(struct sk_buff *skb, struct mctp_sk_key *key) {}
 static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev) {}
 #endif
 
+/* takes ownership of skb, both in success and failure cases */
 static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 {
 	struct mctp_hdr *hdr = mctp_hdr(skb);
@@ -334,8 +335,10 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
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
@@ -349,10 +352,10 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 	exp_seq = (key->last_seq + 1) & MCTP_HDR_SEQ_MASK;
 
 	if (this_seq != exp_seq)
-		return -EINVAL;
+		goto err_free;
 
 	if (key->reasm_head->len + skb->len > mctp_message_maxlen)
-		return -EINVAL;
+		goto err_free;
 
 	skb->next = NULL;
 	skb->sk = NULL;
@@ -366,6 +369,10 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 	key->reasm_head->truesize += skb->truesize;
 
 	return 0;
+
+err_free:
+	kfree_skb(skb);
+	return -EINVAL;
 }
 
 static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
@@ -476,18 +483,16 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
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
@@ -505,8 +510,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 				key = NULL;
 			} else {
 				rc = mctp_frag_queue(key, skb);
-				if (!rc)
-					skb = NULL;
+				skb = NULL;
 			}
 		}
 
@@ -516,17 +520,16 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
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
2.50.1



