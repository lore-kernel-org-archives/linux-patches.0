Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6287B186E58;
	Mon, 23 Dec 2024 16:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969847; cv=none; b=mH7nz+2/PBSmdtHiS/2vgxwbp6l8k9u+PS4slRSNvFSzNqXPFuNDFV3oomzAnQ7ISFnVX6V3KAIgnSHWnrM+4zM/OKRhZZvPqlbXrFqtVYgBnehVit1s3D7UKIwkmzL8tRqUtVPMvouzogsDjVTaC+k+JAS9qWPmTFxilTtFwic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969847; c=relaxed/simple;
	bh=sW9AA0H4t/wZpt6ThU8zVYENJWSoSl6QpoAf9uGv0xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgRO6bbcnqnr6H5wO9Enk6KlORTMpYxF1bFtkc+G1Nw8+bdoLM0Uf2xzg31N1+KEYHXJ6zPvGZu6K5PLUur1+/Zvlp3T3oVPg9Z3uvq+xiivVpsELk1R2gDES/LOJqVohnl2nTSaARmnZN/J/FKxfOR9TGEakI78IvWMVuvCuWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xY91MH0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xY91MH0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCEFC4CED3;
	Mon, 23 Dec 2024 16:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969847;
	bh=sW9AA0H4t/wZpt6ThU8zVYENJWSoSl6QpoAf9uGv0xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xY91MH0Cg2kmMcGnXP3obU++4MyH7sbuk6Kgm7vnGVfwgvGWc3/+8ykUuWIY4uMMq
	 WuqvU+yS8R49uOUEG9QwBtHToG7syIupO32cF6S8snsm5LokKwCEk5hpMeadL8h1if
	 v3+hjWhRk7GQvMc8vU7jwAciuY3E2Oc7mbCmFGtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 071/160] net: mctp: handle skb cleanup on sock_queue failures
Date: Mon, 23 Dec 2024 16:58:02 +0100
Message-ID: <20241223155411.429397588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

commit ce1219c3f76bb131d095e90521506d3c6ccfa086 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/route.c           |   36 +++++++++++++-----
 net/mctp/test/route-test.c |   86 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 10 deletions(-)

--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -374,8 +374,13 @@ static int mctp_route_input(struct mctp_
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
 
@@ -434,7 +439,9 @@ static int mctp_route_input(struct mctp_
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
@@ -443,7 +450,6 @@ static int mctp_route_input(struct mctp_
 						   MCTP_TRACE_KEY_REPLIED);
 				key = NULL;
 			}
-			rc = 0;
 			goto out_unlock;
 		}
 
@@ -470,8 +476,10 @@ static int mctp_route_input(struct mctp_
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
@@ -489,6 +497,8 @@ static int mctp_route_input(struct mctp_
 				key = NULL;
 			} else {
 				rc = mctp_frag_queue(key, skb);
+				if (!rc)
+					skb = NULL;
 			}
 		}
 
@@ -503,12 +513,19 @@ static int mctp_route_input(struct mctp_
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
@@ -527,8 +544,7 @@ out_unlock:
 	if (any_key)
 		mctp_key_unref(any_key);
 out:
-	if (rc)
-		kfree_skb(skb);
+	kfree_skb(skb);
 	return rc;
 }
 
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -837,6 +837,90 @@ static void mctp_test_route_input_multip
 	mctp_test_route_input_multiple_nets_key_fini(test, &t2);
 }
 
+/* Input route to socket, using a single-packet message, where sock delivery
+ * fails. Ensure we're handling the failure appropriately.
+ */
+static void mctp_test_route_input_sk_fail_single(struct kunit *test)
+{
+	const struct mctp_hdr hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_TO);
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct socket *sock;
+	struct sk_buff *skb;
+	int rc;
+
+	__mctp_route_test_init(test, &dev, &rt, &sock, MCTP_NET_ANY);
+
+	/* No rcvbuf space, so delivery should fail. __sock_set_rcvbuf will
+	 * clamp the minimum to SOCK_MIN_RCVBUF, so we open-code this.
+	 */
+	lock_sock(sock->sk);
+	WRITE_ONCE(sock->sk->sk_rcvbuf, 0);
+	release_sock(sock->sk);
+
+	skb = mctp_test_create_skb(&hdr, 10);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skb);
+	skb_get(skb);
+
+	mctp_test_skb_set_dev(skb, dev);
+
+	/* do route input, which should fail */
+	rc = mctp_route_input(&rt->rt, skb);
+	KUNIT_EXPECT_NE(test, rc, 0);
+
+	/* we should hold the only reference to skb */
+	KUNIT_EXPECT_EQ(test, refcount_read(&skb->users), 1);
+	kfree_skb(skb);
+
+	__mctp_route_test_fini(test, dev, rt, sock);
+}
+
+/* Input route to socket, using a fragmented message, where sock delivery fails.
+ */
+static void mctp_test_route_input_sk_fail_frag(struct kunit *test)
+{
+	const struct mctp_hdr hdrs[2] = { RX_FRAG(FL_S, 0), RX_FRAG(FL_E, 1) };
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct sk_buff *skbs[2];
+	struct socket *sock;
+	unsigned int i;
+	int rc;
+
+	__mctp_route_test_init(test, &dev, &rt, &sock, MCTP_NET_ANY);
+
+	lock_sock(sock->sk);
+	WRITE_ONCE(sock->sk->sk_rcvbuf, 0);
+	release_sock(sock->sk);
+
+	for (i = 0; i < ARRAY_SIZE(skbs); i++) {
+		skbs[i] = mctp_test_create_skb(&hdrs[i], 10);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skbs[i]);
+		skb_get(skbs[i]);
+
+		mctp_test_skb_set_dev(skbs[i], dev);
+	}
+
+	/* first route input should succeed, we're only queueing to the
+	 * frag list
+	 */
+	rc = mctp_route_input(&rt->rt, skbs[0]);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+
+	/* final route input should fail to deliver to the socket */
+	rc = mctp_route_input(&rt->rt, skbs[1]);
+	KUNIT_EXPECT_NE(test, rc, 0);
+
+	/* we should hold the only reference to both skbs */
+	KUNIT_EXPECT_EQ(test, refcount_read(&skbs[0]->users), 1);
+	kfree_skb(skbs[0]);
+
+	KUNIT_EXPECT_EQ(test, refcount_read(&skbs[1]->users), 1);
+	kfree_skb(skbs[1]);
+
+	__mctp_route_test_fini(test, dev, rt, sock);
+}
+
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 
 static void mctp_test_flow_init(struct kunit *test,
@@ -1053,6 +1137,8 @@ static struct kunit_case mctp_test_cases
 			 mctp_route_input_sk_reasm_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_route_input_sk_keys,
 			 mctp_route_input_sk_keys_gen_params),
+	KUNIT_CASE(mctp_test_route_input_sk_fail_single),
+	KUNIT_CASE(mctp_test_route_input_sk_fail_frag),
 	KUNIT_CASE(mctp_test_route_input_multiple_nets_bind),
 	KUNIT_CASE(mctp_test_route_input_multiple_nets_key),
 	KUNIT_CASE(mctp_test_packet_flow),


