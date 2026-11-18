Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034821;
	b=lg6T3teJdua9dCAPYXO2+yDZBIQerRW8AkgdiGrAEeQkupMKJy0HS1uBdx0/YUIGkONM
	 DAJI3D1xAXO/XnlV3A1LXIDz6O61hi4e+Ypg3w6kDw98XdszI7ZZvm321Z4Qnwj/rzOYW
	 /JktpwUnahVQh9Mt0EhdOfzspw1O4KMZfyPWJmYx8uT/ohj0u3Xw9EALwYkQyH2gS1eem
	 B4smCLpcpOpKE7smAHPH/kJPX8wSeTNZZA7VV0lWbUo2eZlTy5SuvBSX7GW4CguzJCDv/
	 vSqlMIizzAFc8/lpdaNshAx0gFoBPFQC6i1XIyo4J3jISHTkSZK8o9OzqQW2ccpf0RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DSu8xwL/WZC0+m/NBBFhohlXBnHuPud0gc1hvch2XOM=;
	b=c/0zL2/pYFN93WwCf7Fw6wZcC+CW4zeqKyDQQ1TeU85gIiisVrVAzS4ZtFPTAvZIaxDf
	 yURnmAp/ejD5zYzLgkFGMS8xclLC18+cw6PRz6R+/pU3IsAsSyWk9i9QCy4/t7FpdrhHJ
	 TE6QDVEtX165Kl1tFWeomJHCMGY94ysspjKA63Fsx9FLJkosrTWRHWJp5PiarcY6Gmn+d
	 d1iQ7sQgCMofANIv+WOqm21FnCasK/fKDHWf1p+czt0umE8TBD6glmYUpp0bf1bUHPrHi
	 HhM1Vw7QLHIVKBg8SO8huZIzjwQnuoFD6iaRFa4DBsx9tPd+RchytzxsMxZvh2mzWRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKohTRT9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DC9606A320;
	Wed, 18 Nov 2026 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKohTRT9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A440F1F000C6;
	Wed, 18 Nov 2026 20:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034821;
	bh=DSu8xwL/WZC0+m/NBBFhohlXBnHuPud0gc1hvch2XOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKohTRT9Go6JZZhdmlUJPWBOgcfgFsctdGQTCsP/0KefzMZ+83w4vPGBb5RKHN3Tb
	 ospl64/OobYl//88LFQr7M5IauPcublFuJr+LCQJ6S0fO2sF1ZV/yFb+GU/I61lEbB
	 WBXFgYhogqDYtDweCsHSiLC32zloyXHAHRbng6Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0506/3318] net: mctp: avoid confusion over local/peer dest/source addresses
Date: Wed, 18 Nov 2026 15:18:48 +0100
Message-ID: <20261118150332.274050380@linuxfoundation.org>
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
index 6dbed4ca22205..d7e331ce099ad 100644
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
index 805f7376cebe3..d6e0350b1c949 100644
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
index acd3cecc8a367..bd1b0e912d1ee 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -625,11 +625,11 @@ static void mctp_reserve_tag(struct net *net, struct mctp_sk_key *key,
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
@@ -639,11 +639,11 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
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
 
@@ -664,8 +664,8 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 		if (tmp->tag & MCTP_HDR_FLAG_TO)
 			continue;
 
-		if (!(mctp_address_matches(tmp->peer_addr, daddr) &&
-		      mctp_address_matches(tmp->local_addr, saddr)))
+		if (!(mctp_address_matches(tmp->peer_addr, peer) &&
+		      mctp_address_matches(tmp->local_addr, local)))
 			continue;
 
 		spin_lock(&tmp->lock);
@@ -957,7 +957,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 			key = mctp_lookup_prealloc_tag(msk, daddr,
 						       req_tag, &tag);
 		else
-			key = mctp_alloc_local_tag(msk, daddr, saddr,
+			key = mctp_alloc_local_tag(msk, saddr, daddr,
 						   false, &tag);
 
 		if (IS_ERR(key)) {
-- 
2.53.0



