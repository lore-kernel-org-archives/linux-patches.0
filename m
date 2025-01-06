Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA00136326;
	Mon,  6 Jan 2025 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176724; cv=none; b=ZnrX7iryKOEvxcuiXHTSCen79llszFA9pmQEoMuxaG70stHAuTYGRPWkq2GeUZfXZDvJaFO7XXh+L6nzTfGozf/NWTb90vErBSqWDQTfqUz5HZGQEbIggMr7bGjx8XcQuCJ23h51i0B3PNzQ54gYekccW9mHeeYFqM10Kt0D2eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176724; c=relaxed/simple;
	bh=le3Y3HjTJaIk0Ycj7PF6kesix4CJ2/lGcImpxyrHe5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq2iqyVE31tULEMocIULycOVl9JkcqQIrF313Vb5FXVt26uNH+Ta0Xh1dR5LyZGqIKixeSA66B6iDXme4hICKGXdTfPrhRdU8k0rR9E2iCFWoHlbZMS5NRP73FFuL1HSDV41gbWaUqiTO45LcFOq2IIufyqHHugfoCHEzmIEfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wESzf3i/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wESzf3i/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524ABC4CED2;
	Mon,  6 Jan 2025 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176723;
	bh=le3Y3HjTJaIk0Ycj7PF6kesix4CJ2/lGcImpxyrHe5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wESzf3i/RsyV00rcHGEQV+p3V25jBfeRKr2wDlM8WfutNKkli+pvHDhkKAI9WY/Xb
	 lQsUDeJAV4hnCac8wUQ8ibtJxMULRYXao+fi051Z2mrrCme1wfGC4qgHWeX0nSGUpo
	 XGB6MNRQpoLfazPDfmlbiCrBZO+46V514dUcmjvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/81] net: mctp: handle skb cleanup on sock_queue failures
Date: Mon,  6 Jan 2025 16:15:43 +0100
Message-ID: <20250106151129.865644705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea7cb9973128..e72cdd4ce588 100644
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



