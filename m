Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044148;
	b=KVSwD4T8tmyc+1cnXHbtGp04sGdwe/avMN3xpyLcs9q4NUdgF0HdZun7NCevl9Rv5aZ6
	 DAYwSTETZazS6WyevjngzYiHarWI7wLpp+Xmrpz8J/UhZRMKifFU44GwlsGuJfpN/1vfk
	 I7Em84uvmcFT9iiMUN56D/Xqugjs0S9fizh+jxKuAuCqulEy2mhR6OYG19Z/VIvRybsSj
	 oxtKcQ3Qe/tlEIblUj0xn3jFZczlZOY/+nbf4LrdyEkfZGPXmerNyYjBgpFrPUcLfSQ96
	 qUeQIrioeqd7hgIDKq6bKbbZQ1D83ZjiM/XsJJQy4Yr3uVfpWwyiybElQ5yM7CQ8J6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfpLbLYZ/iogM8EBxk3mY13mSEsuoHckpIgyEq/7mCw=;
	b=f3XKqBYifthHsIXfs7RW+2jQKw341fjO5Mt0bshw1bjPmOjW5VcumNz5Zw+mcBMJkTox
	 VvPSJSmljXWDZRro0EVIJEN95D3feHKtpox7yNsrCzVPjIeUahNa54yImJBTghL9p9F81
	 t4ym8SVWfCi5AWBJcmq8uCp73KqDnDswz2DwK50t3vIFtgxl1lVq1hAxfdLG6n/6BPS17
	 AhTbvuuDfiDmRAZImpHVx4f+IyV/1qL8zAZbxcBqPzdMobnf6cpWZoLLlxVFtcs27N7ed
	 5XijM7ORWOFh5CEjChuq1/rVhfSPZBxWXmpiSi4GTXhgeSmVsRauQ4ZJn9YKzUy6ACA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zr/WV5XP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04787606A325;
	Wed, 18 Nov 2026 23:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zr/WV5XP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF431F000C4;
	Wed, 18 Nov 2026 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044147;
	bh=IfpLbLYZ/iogM8EBxk3mY13mSEsuoHckpIgyEq/7mCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zr/WV5XP5Hzw2Tv12XqgDWoScQERCR7e++rq0x90hEt6dedqu2BPAs4YRZd/D9P1U
	 bfItrfkWIefop+thouu9aZupzzgesDb9dVhWzlHheInyc6Gs32X7NBllNbAwRpGSVk
	 2DQmj6b1a89/qrbqLD2V9E1dMR8/JrRKAobFE3hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0461/2857] net: mctp: avoid confusion over local/peer dest/source addresses
Date: Wed, 18 Nov 2026 15:24:55 +0100
Message-ID: <20261118150218.022113113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit ee076b73e576b0a052d5686d873346b285ae50ea ]

We have a double-swap of local and peer addresses in
mctp_alloc_local_tag; the arguments in both call sites are swapped, but
there is also a swap in the implementation of alloc_local_tag. This is
opaque because we're using source/dest address references, which don't
match the local/peer semantics.

Avoid this confusion by naming the arguments as 'local' and 'peer', and
remove the double swap. The calling order now matches mctp_key_alloc.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 26cc0e69cce0 ("mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mctp.h |  4 ++--
 net/mctp/af_mctp.c |  2 +-
 net/mctp/route.c   | 16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 2da82878155bb..357f1cda11e45 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -90,7 +90,7 @@ struct mctp_sock {
 };
 
 /* Key for matching incoming packets to sockets or reassembly contexts.
- * Packets are matched on (src,dest,tag).
+ * Packets are matched on (peer EID, local EID, tag).
  *
  * Lifetime / locking requirements:
  *
@@ -258,7 +258,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 
 void mctp_key_unref(struct mctp_sk_key *key);
 struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
-					 mctp_eid_t daddr, mctp_eid_t saddr,
+					 mctp_eid_t local, mctp_eid_t peer,
 					 bool manual, u8 *tagp);
 
 /* routing <--> device interface */
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 8f241c92e03d8..609e67210e454 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -366,7 +366,7 @@ static int mctp_ioctl_alloctag(struct mctp_sock *msk, unsigned long arg)
 	if (ctl.flags)
 		return -EINVAL;
 
-	key = mctp_alloc_local_tag(msk, ctl.peer_addr, MCTP_ADDR_ANY,
+	key = mctp_alloc_local_tag(msk, MCTP_ADDR_ANY, ctl.peer_addr,
 				   true, &tag);
 	if (IS_ERR(key))
 		return PTR_ERR(key);
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 00fc79c05b4ac..cbcf5ecec93bb 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -634,11 +634,11 @@ static void mctp_reserve_tag(struct net *net, struct mctp_sk_key *key,
 	refcount_inc(&key->refs);
 }
 
-/* Allocate a locally-owned tag value for (saddr, daddr), and reserve
+/* Allocate a locally-owned tag value for (local, peer), and reserve
  * it for the socket msk
  */
 struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
-					 mctp_eid_t daddr, mctp_eid_t saddr,
+					 mctp_eid_t local, mctp_eid_t peer,
 					 bool manual, u8 *tagp)
 {
 	struct net *net = sock_net(&msk->sk);
@@ -648,11 +648,11 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 	u8 tagbits;
 
 	/* for NULL destination EIDs, we may get a response from any peer */
-	if (daddr == MCTP_ADDR_NULL)
-		daddr = MCTP_ADDR_ANY;
+	if (peer == MCTP_ADDR_NULL)
+		peer = MCTP_ADDR_ANY;
 
 	/* be optimistic, alloc now */
-	key = mctp_key_alloc(msk, saddr, daddr, 0, GFP_KERNEL);
+	key = mctp_key_alloc(msk, local, peer, 0, GFP_KERNEL);
 	if (!key)
 		return ERR_PTR(-ENOMEM);
 
@@ -673,8 +673,8 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 		if (tmp->tag & MCTP_HDR_FLAG_TO)
 			continue;
 
-		if (!(mctp_address_matches(tmp->peer_addr, daddr) &&
-		      mctp_address_matches(tmp->local_addr, saddr)))
+		if (!(mctp_address_matches(tmp->peer_addr, peer) &&
+		      mctp_address_matches(tmp->local_addr, local)))
 			continue;
 
 		spin_lock(&tmp->lock);
@@ -966,7 +966,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 			key = mctp_lookup_prealloc_tag(msk, daddr,
 						       req_tag, &tag);
 		else
-			key = mctp_alloc_local_tag(msk, daddr, saddr,
+			key = mctp_alloc_local_tag(msk, saddr, daddr,
 						   false, &tag);
 
 		if (IS_ERR(key)) {
-- 
2.53.0



