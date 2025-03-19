Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519C1D514F;
	Wed, 19 Mar 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394852; cv=none; b=N2LWEOTyR4PgWJWYDvQiimMzphAcEa+emXbUBJ+P7HQFwSo8jBAhtJsmJR5I2GZKvLVu2LZme+1wj4RZAFZlb8J/nlkWvZeN3XPsj18Bzv93QtU0+e4N5zi9CWuh+22K9oFMl6I22Eg2ibwezIFyOCSY6syXkiglAByrmWeIeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394852; c=relaxed/simple;
	bh=HLdBDpUxFVzrx86rIM4vXe8IUUWfyoopPO5kPEa1IAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIrn5qU1gIbBS54yCbw7gSEghhGgsgqJDvVrSuqoTgPiWK1gV8ccSV+sw1bOdgk+ilyquR7BkEnN/R06LQlM/HVm//6V28EDd5zjG3f6QVys07/I+fDsSqu6MKPvMspQqywZgH/1KrVs0+KNYtkwvh3y8Qd10u6iDUijryXPgSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfZmFy0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfZmFy0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB460C4CEE4;
	Wed, 19 Mar 2025 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394851;
	bh=HLdBDpUxFVzrx86rIM4vXe8IUUWfyoopPO5kPEa1IAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfZmFy0r+t56W93f1nm1i4YlsOdHmTVzGV9IECFZAlAYY/YqgVbP1IA7yBebHCLEz
	 qAsmBhY59OmvgnyaGkupmuXT+60QJbMzotjXwIH5nhpHKXQuEbmlELkk5w3ZP+g29L
	 RNIpPPJ0v/KoFt3lzB+C118Skt3b/9Hl+u8hrOOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 039/241] net: mctp: unshare packets when reassembling
Date: Wed, 19 Mar 2025 07:28:29 -0700
Message-ID: <20250319143028.686028072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 net/mctp/test/route-test.c | 109 +++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 3f2bd65ff5e3c..4c460160914f0 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -332,8 +332,14 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
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
index 17165b86ce22d..06c1897b685a8 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -921,6 +921,114 @@ static void mctp_test_route_input_sk_fail_frag(struct kunit *test)
 	__mctp_route_test_fini(test, dev, rt, sock);
 }
 
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
+	__mctp_route_test_init(test, &dev, &rt, &sock, MCTP_NET_ANY);
+
+	/* Create a single skb initially with concatenated packets */
+	skb[0] = mctp_test_create_skb(&hdrs[0], 5 * total);
+	mctp_test_skb_set_dev(skb[0], dev);
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
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 
 static void mctp_test_flow_init(struct kunit *test,
@@ -1144,6 +1252,7 @@ static struct kunit_case mctp_test_cases[] = {
 	KUNIT_CASE(mctp_test_packet_flow),
 	KUNIT_CASE(mctp_test_fragment_flow),
 	KUNIT_CASE(mctp_test_route_output_key_create),
+	KUNIT_CASE(mctp_test_route_input_cloned_frag),
 	{}
 };
 
-- 
2.39.5



