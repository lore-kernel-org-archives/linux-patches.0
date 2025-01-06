Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1881547E3;
	Mon,  6 Jan 2025 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177313; cv=none; b=jhcfdgDRlek6vb5JhXmyojqJ9sILMNkeYH3tNuIUNuBB5omQe2mHtW0mMFqgGckzDQrTRhRe36Nh/a4h9Zxj5VNstjTtVJPsjQu997DDN5Yti8FwnYH77xdn6gLFABIDMQv4y8D8rTe8fdOFFZayQsQDoWObBQhlI0fI/yZAqes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177313; c=relaxed/simple;
	bh=x9mkbSc5B5tlaUfQrH/dS0FWzlO5NffgSVwgYoDz2Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ4R8VpM1uCbnp/72Ucs93+RLFerWDKUNhX/gRDx+thvTv9rOhPsEtpAItFB7JQN2xrNULEIBq7B2CDs1XLtrTyDVweXyHNj784ywAE/TOpR6DleNMhRyomQayj8ZRnRoySHTXxkUfbwIX+Dtdciw06U4iiJSQKWfG0hDCi0elA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpG0Fi3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpG0Fi3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21154C4CED2;
	Mon,  6 Jan 2025 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177311;
	bh=x9mkbSc5B5tlaUfQrH/dS0FWzlO5NffgSVwgYoDz2Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpG0Fi3+6zC7JQ3tOOTdm66mXIx5iVuTbedIIaZOxrLPfQ8xWRalQ2/WRcR5HI3Fg
	 4dL/W5flHmROPjUpssbWezUFIdxfIVD8H5JVRNnP81Ya/qJAL+hpXys7n5ar2hyu4F
	 2i7hrn1HZqNpgj+T8VOV33UImkUb8oIBUA451fLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/222] net: mctp: handle skb cleanup on sock_queue failures
Date: Mon,  6 Jan 2025 16:15:24 +0100
Message-ID: <20250106151155.152675423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit ce1219c3f76bb131d095e90521506d3c6ccfa086 ]

Currently, we don't use the return value from sock_queue_rcv_skb, which
means we may leak skbs if a message is not successfully queued to a
socket.

Instead, ensure that we're freeing the skb where the sock hasn't
otherwise taken ownership of the skb by adding checks on the
sock_queue_rcv_skb() to invoke a kfree on failure.

In doing so, rather than using the 'rc' value to trigger the
kfree_skb(), use the skb pointer itself, which is more explicit.

Also, add a kunit test for the sock delivery failure cases.

Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20241218-mctp-next-v2-1-1c1729645eaa@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index c6a815df9d35..d3c1f54386ef 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -334,8 +334,13 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 	msk = NULL;
 	rc = -EINVAL;
 
-	/* we may be receiving a locally-routed packet; drop source sk
-	 * accounting
+	/* We may be receiving a locally-routed packet; drop source sk
+	 * accounting.
+	 *
+	 * From here, we will either queue the skb - either to a frag_queue, or
+	 * to a receiving socket. When that succeeds, we clear the skb pointer;
+	 * a non-NULL skb on exit will be otherwise unowned, and hence
+	 * kfree_skb()-ed.
 	 */
 	skb_orphan(skb);
 
@@ -389,7 +394,9 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		 * pending key.
 		 */
 		if (flags & MCTP_HDR_FLAG_EOM) {
-			sock_queue_rcv_skb(&msk->sk, skb);
+			rc = sock_queue_rcv_skb(&msk->sk, skb);
+			if (!rc)
+				skb = NULL;
 			if (key) {
 				/* we've hit a pending reassembly; not much we
 				 * can do but drop it
@@ -398,7 +405,6 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 						   MCTP_TRACE_KEY_REPLIED);
 				key = NULL;
 			}
-			rc = 0;
 			goto out_unlock;
 		}
 
@@ -425,8 +431,10 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * this function.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (!rc)
+			if (!rc) {
 				trace_mctp_key_acquire(key);
+				skb = NULL;
+			}
 
 			/* we don't need to release key->lock on exit, so
 			 * clean up here and suppress the unlock via
@@ -444,6 +452,8 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 				key = NULL;
 			} else {
 				rc = mctp_frag_queue(key, skb);
+				if (!rc)
+					skb = NULL;
 			}
 		}
 
@@ -458,12 +468,19 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		else
 			rc = mctp_frag_queue(key, skb);
 
+		if (rc)
+			goto out_unlock;
+
+		/* we've queued; the queue owns the skb now */
+		skb = NULL;
+
 		/* end of message? deliver to socket, and we're done with
 		 * the reassembly/response key
 		 */
-		if (!rc && flags & MCTP_HDR_FLAG_EOM) {
-			sock_queue_rcv_skb(key->sk, key->reasm_head);
-			key->reasm_head = NULL;
+		if (flags & MCTP_HDR_FLAG_EOM) {
+			rc = sock_queue_rcv_skb(key->sk, key->reasm_head);
+			if (!rc)
+				key->reasm_head = NULL;
 			__mctp_key_done_in(key, net, f, MCTP_TRACE_KEY_REPLIED);
 			key = NULL;
 		}
@@ -482,8 +499,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 	if (any_key)
 		mctp_key_unref(any_key);
 out:
-	if (rc)
-		kfree_skb(skb);
+	kfree_skb(skb);
 	return rc;
 }
 
-- 
2.39.5



