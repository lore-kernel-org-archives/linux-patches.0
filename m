Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940631AAE28;
	Sat, 17 Oct 2026 17:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257849; cv=none; b=GUdyTt2ODqkUfD4yaVlpNzsH2411eVs5HcvlDEVCAe+9DvvIguAP0F2Sm4RN37KwRPA4rfYG8J5SYc6VWit6ZScstb6NvlijiO0/R1bUujV4gD+mY6whg+jCXmtzmqPGjXRzVgkGi2afLsO8epvC3m+Stwe7S8qRPtiHKKMJMs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257849; c=relaxed/simple;
	bh=XVfpq8xwD5mH8DF3y1Bkm+vmzWc+UsHFBYWVUXj5S3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAPZQwn9fpQWk8jpro6PntW01/bOlvuJ16EdAGZn5BoM0w8b3IFsY7FAOoSsSHFhLclhk9e8LTuHDmEDL8p957POsL3NR5YBWKYEfotMxgMH4P+3ILhDm8IzxdCGUyGIhUyey//ocdFgLTanWtqRdRpW1g6HGWTykMLTnRVjSVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+bgqfKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+bgqfKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DAF1F000C4;
	Sat, 17 Oct 2026 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257848;
	bh=XL5pCrUoGpCMBolRkOnbvWx/7/11jaWeRgY4kSMmfjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+bgqfKGrytMtwIMRnSfgbvdBcWv6gfm0nfcE6dG17HFn5tePv44o/4tdWU1HpGnY
	 euPQLFCLEK5TMD5d9O1PdgrG3XtMtEjGHCrZtTIZrDpdRYMmWZRRyJ5VMYBPqv8NC4
	 fwvuHdTsPeCcKodCHcpKC2Kla/CEfd/FJPBoOTxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0689/1674] net: mctp: unshare packets when reassembling
Date: Sat, 17 Oct 2026 17:49:21 +0200
Message-ID: <20261017160448.792951548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit f5d83cf0eeb90fade4d5c4d17d24b8bee9ceeecc ]

Ensure that the frag_list used for reassembly isn't shared with other
packets. This avoids incorrect reassembly when packets are cloned, and
prevents a memory leak due to circular references between fragments and
their skb_shared_info.

The upcoming MCTP-over-USB driver uses skb_clone which can trigger the
problem - other MCTP drivers don't share SKBs.

A kunit test is added to reproduce the issue.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250306-matt-mctp-usb-v1-1-085502b3dd28@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c           |  10 +++-
 net/mctp/test/route-test.c | 112 +++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 6d6e19c049396..acd3cecc8a367 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -298,8 +298,14 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 		& MCTP_HDR_SEQ_MASK;
 
 	if (!key->reasm_head) {
-		key->reasm_head = skb;
-		key->reasm_tailp = &(skb_shinfo(skb)->frag_list);
+		/* Since we're manipulating the shared frag_list, ensure it isn't
+		 * shared with any other SKBs.
+		 */
+		key->reasm_head = skb_unshare(skb, GFP_ATOMIC);
+		if (!key->reasm_head)
+			return -ENOMEM;
+
+		key->reasm_tailp = &(skb_shinfo(key->reasm_head)->frag_list);
 		key->last_seq = this_seq;
 		return 0;
 	}
diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index a944490a724d3..ef6a3d6115ca2 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -665,6 +665,117 @@ static void mctp_route_input_sk_keys_to_desc(
 KUNIT_ARRAY_PARAM(mctp_route_input_sk_keys, mctp_route_input_sk_keys_tests,
 		  mctp_route_input_sk_keys_to_desc);
 
+/* Input route to socket, using a fragmented message created from clones.
+ */
+static void mctp_test_route_input_cloned_frag(struct kunit *test)
+{
+	/* 5 packet fragments, forming 2 complete messages */
+	const struct mctp_hdr hdrs[5] = {
+		RX_FRAG(FL_S, 0),
+		RX_FRAG(0, 1),
+		RX_FRAG(FL_E, 2),
+		RX_FRAG(FL_S, 0),
+		RX_FRAG(FL_E, 1),
+	};
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct sk_buff *skb[5];
+	struct sk_buff *rx_skb;
+	struct socket *sock;
+	size_t data_len;
+	u8 compare[100];
+	u8 flat[100];
+	size_t total;
+	void *p;
+	int rc;
+
+	/* Arbitrary length */
+	data_len = 3;
+	total = data_len + sizeof(struct mctp_hdr);
+
+	__mctp_route_test_init(test, &dev, &rt, &sock);
+
+	/* Create a single skb initially with concatenated packets */
+	skb[0] = mctp_test_create_skb(&hdrs[0], 5 * total);
+	skb[0]->dev = dev->ndev;
+	__mctp_cb(skb[0]);
+	memset(skb[0]->data, 0 * 0x11, skb[0]->len);
+	memcpy(skb[0]->data, &hdrs[0], sizeof(struct mctp_hdr));
+
+	/* Extract and populate packets */
+	for (int i = 1; i < 5; i++) {
+		skb[i] = skb_clone(skb[i - 1], GFP_ATOMIC);
+		KUNIT_ASSERT_TRUE(test, skb[i]);
+		p = skb_pull(skb[i], total);
+		KUNIT_ASSERT_TRUE(test, p);
+		skb_reset_network_header(skb[i]);
+		skb[i]->dev = dev->ndev;
+		__mctp_cb(skb[i]);
+		memcpy(skb[i]->data, &hdrs[i], sizeof(struct mctp_hdr));
+		memset(&skb[i]->data[sizeof(struct mctp_hdr)], i * 0x11, data_len);
+	}
+	for (int i = 0; i < 5; i++)
+		skb_trim(skb[i], total);
+
+	/* SOM packets have a type byte to match the socket */
+	skb[0]->data[4] = 0;
+	skb[3]->data[4] = 0;
+
+	skb_dump("pkt1 ", skb[0], false);
+	skb_dump("pkt2 ", skb[1], false);
+	skb_dump("pkt3 ", skb[2], false);
+	skb_dump("pkt4 ", skb[3], false);
+	skb_dump("pkt5 ", skb[4], false);
+
+	for (int i = 0; i < 5; i++) {
+		KUNIT_EXPECT_EQ(test, refcount_read(&skb[i]->users), 1);
+		/* Take a reference so we can check refcounts at the end */
+		skb_get(skb[i]);
+	}
+
+	/* Feed the fragments into MCTP core */
+	for (int i = 0; i < 5; i++) {
+		rc = mctp_route_input(&rt->rt, skb[i]);
+		KUNIT_EXPECT_EQ(test, rc, 0);
+	}
+
+	/* Receive first reassembled message */
+	rx_skb = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_EXPECT_EQ(test, rx_skb->len, 3 * data_len);
+	rc = skb_copy_bits(rx_skb, 0, flat, rx_skb->len);
+	for (int i = 0; i < rx_skb->len; i++)
+		compare[i] = (i / data_len) * 0x11;
+	/* Set type byte */
+	compare[0] = 0;
+
+	KUNIT_EXPECT_MEMEQ(test, flat, compare, rx_skb->len);
+	KUNIT_EXPECT_EQ(test, refcount_read(&rx_skb->users), 1);
+	kfree_skb(rx_skb);
+
+	/* Receive second reassembled message */
+	rx_skb = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_EXPECT_EQ(test, rx_skb->len, 2 * data_len);
+	rc = skb_copy_bits(rx_skb, 0, flat, rx_skb->len);
+	for (int i = 0; i < rx_skb->len; i++)
+		compare[i] = (i / data_len + 3) * 0x11;
+	/* Set type byte */
+	compare[0] = 0;
+
+	KUNIT_EXPECT_MEMEQ(test, flat, compare, rx_skb->len);
+	KUNIT_EXPECT_EQ(test, refcount_read(&rx_skb->users), 1);
+	kfree_skb(rx_skb);
+
+	/* Check input skb refcounts */
+	for (int i = 0; i < 5; i++) {
+		KUNIT_EXPECT_EQ(test, refcount_read(&skb[i]->users), 1);
+		kfree_skb(skb[i]);
+	}
+
+	__mctp_route_test_fini(test, dev, rt, sock);
+}
+
 static struct kunit_case mctp_test_cases[] = {
 	KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_rx_input, mctp_rx_input_gen_params),
@@ -673,6 +784,7 @@ static struct kunit_case mctp_test_cases[] = {
 			 mctp_route_input_sk_reasm_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_route_input_sk_keys,
 			 mctp_route_input_sk_keys_gen_params),
+	KUNIT_CASE(mctp_test_route_input_cloned_frag),
 	{}
 };
 
-- 
2.53.0



