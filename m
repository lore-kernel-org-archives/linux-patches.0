Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623021;
	b=cPPLnf4wsc6FYJLRD4XxxlNelmeH66AQl7gDzfKLURVFx9b9/F419q+87a/InYmPfI9a
	 oxTY0n/nb15MvEfzV3ZzoWvYyRVW050d2l/bw4In12efjcqDDXJmDx48N08xtWMZPNIj/
	 YFQh4eyJySyrx/F5TNh6pbSClfZHBRtry6OSaSm9pFZUeDU3OsNmnRX6TcC6drhvBRYDF
	 Wp7iOOytrY9wWfC8+uczoRlZDndXVFYnsj0zBhYAnw+x7Fi8ct3/Z9JLCk0YhItffBvMK
	 WftyCcgm31fbPgxgjFFRjYj7/eszJke4RrgzqCySvn2metzywfojxFeTPJObg2haUaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hqIVzwaT+lnvnJbS+UyMoK6Og9pLue8qU/aYPsYfj7s=;
	b=xBobWOCmugufxN7MO+N8l0pYqmW2Pji5fp8vlIghZtAC9KCU50J6LbEXNSWFiYsy5k/1
	 zSthokSc5b7qSyHvSxfwkbt9zv5BerxprvgJyRBjARIchw03xioGHSosLH1rYKUjOgs/T
	 JWFvbhVMY/Sell64FFXF8p2edfHRGgJsADy6ylCQihFmWM6hV5N22Yt/WW+ijSs3s0Q+x
	 06V58V5xY6M3JYiXsdvSWLYmKdJimK9Q32SO/GFovmAlKYi/ubvpZLRpxLIch4F/pOOyA
	 tooZoNRksa41s/fE+WbOhBbrrvvU8Rsmx7/JRaoOGKFY19ANEQRfskA76qOF4z4Bgrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgVwGmLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39B9606A32D;
	Wed, 25 Nov 2026 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgVwGmLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA591F000E0;
	Wed, 25 Nov 2026 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623021;
	bh=hqIVzwaT+lnvnJbS+UyMoK6Og9pLue8qU/aYPsYfj7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgVwGmLb6ABJq3SiA1DyoQCr6sCpUN9/kCSxQp4AQyhmarLOdFgPL6l06waIcS3sC
	 B+LrAGckUW47j6gJCYyx/LNftGAKeqVViQ4ElOP0YWttJeO5rFaM/gkyhJmktjzoXM
	 0d8oqrzDraMOXUzu6sXRCn+eWn4iL4nnqk9cQK9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taesoo Kim <tsgatesv@gmail.com>,
	Cen Zhang <cenzhang@linux.microsoft.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 723/990] net: gro: invalidate frag0 after a pull
Date: Wed, 25 Nov 2026 15:34:50 +0100
Message-ID: <20261125143839.011959005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

commit 98d949a15ff9d3fffaa6983223178374aab92db6 upstream.

Since commit bd56a29c7a4e ("net: gro: change skb_gro_network_header()"),
skb_gro_header_slow() no longer invalidates NAPI_GRO_CB(skb)->frag0
after pskb_may_pull(). skb_gro_may_pull() keeps comparing against the
frag0_len value set in skb_gro_reset_offset(), assuming that after a
slow pull, all later accesses are beyond frag0_len.

This is not true:

- udp4_gro_receive() and udp6_gro_receive() read the network header
  with skb_gro_network_header() after udp_gro_udphdr() pulled the
  UDP header.

- vxlan_gro_receive() calls skb_gro_remcsum_cleanup() at a lower
  offset after the inner handlers pulled their headers.

- skb_gro_remcsum_process() can pull beyond the inner Ethernet header
  before eth_gro_receive() reads it.

- napi_frags_skb() calls __skb_pull(skb, ETH_HLEN) after a slow pull,
  so frag0 still points to the Ethernet header.

If the pull consumed the first page fragment, __skb_pull_tail() released
it. If the head had to grow, pskb_expand_head() freed the old one.
These reads, and the 2-byte write in skb_gro_remcsum_cleanup(), then
access memory the skb no longer holds a reference on.

esp4_gro_receive(), esp6_gro_receive(), skb_gro_receive_list() and
udp_gro_receive_segment() also pull directly and never invalidated
frag0.

Add skb_gro_frag0_invalidate(), which only clears frag0_len, and call
it before each of these pulls. This is a single store in the slow path,
and frag0 stays non NULL, so skb_gro_network_header() does not need
a NULL test.

frag0 must be invalidated even if the pull fails: __pskb_pull_tail()
can return NULL after pskb_expand_head() freed the old head, for
instance if a frag_list member has to be cloned or pulled.

As frag0 is now invalidated before a pull that can fail,
gro_try_pull_from_frag0() can see an skb whose linear part does not
cover skb_gro_offset() while frag0 still points to the start of the
packet, for instance after skb_gro_remcsum_cleanup() pulled a shorter
length. Copying from frag0 would then corrupt the headers: only use
frag0 while frag0_len is not zero, and use pskb_may_pull() otherwise.
If this pull fails, for instance after a failed pskb_pull() in
esp4_gro_receive(), do not hold the packet: later GRO lookups and
gro_complete() handlers expect its headers in the linear part.

This was found by Taesoo Kim and Cen Zhang, using LLM assisted code
analysis, and confirmed with reproducers.

Fixes: bd56a29c7a4e ("net: gro: change skb_gro_network_header()")
Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Cc: stable@vger.kernel.org
Reported-by: Taesoo Kim <tsgatesv@gmail.com>
Reported-by: Cen Zhang <cenzhang@linux.microsoft.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261104151042.1157782-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/gro.h       |   10 ++++++++++
 net/core/gro.c          |   20 ++++++++++++++++----
 net/ipv4/esp4_offload.c |    1 +
 net/ipv4/udp_offload.c  |    1 +
 net/ipv6/esp6_offload.c |    1 +
 5 files changed, 29 insertions(+), 4 deletions(-)

--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -160,9 +160,19 @@ static inline bool skb_gro_may_pull(cons
 	return likely(hlen <= NAPI_GRO_CB(skb)->frag0_len);
 }
 
+/* A pull can release the page fragment frag0 points to, or reallocate
+ * skb->head, even if it fails. Call this before the pull, to make sure later
+ * skb_gro_header() and skb_gro_network_header() calls no longer use frag0.
+ */
+static inline void skb_gro_frag0_invalidate(struct sk_buff *skb)
+{
+	NAPI_GRO_CB(skb)->frag0_len = 0;
+}
+
 static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
 					unsigned int offset)
 {
+	skb_gro_frag0_invalidate(skb);
 	if (!pskb_may_pull(skb, hlen))
 		return NULL;
 
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -250,6 +250,7 @@ int skb_gro_receive_list(struct sk_buff
 	if (unlikely(skb->remcsum_offload))
 		return -EINVAL;
 
+	skb_gro_frag0_invalidate(skb);
 	if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
 		NAPI_GRO_CB(skb)->flush = 1;
 		return -ENOMEM;
@@ -464,12 +465,19 @@ static void gro_pull_from_frag0(struct s
 	}
 }
 
-static void gro_try_pull_from_frag0(struct sk_buff *skb)
+static bool gro_try_pull_from_frag0(struct sk_buff *skb)
 {
 	int grow = skb_gro_offset(skb) - skb_headlen(skb);
 
-	if (grow > 0)
+	if (grow <= 0)
+		return true;
+
+	/* frag0 can only be used if no pull happened. */
+	if (likely(NAPI_GRO_CB(skb)->frag0_len)) {
 		gro_pull_from_frag0(skb, grow);
+		return true;
+	}
+	return pskb_may_pull(skb, skb_gro_offset(skb));
 }
 
 static void gro_flush_oldest(struct gro_node *gro, struct list_head *head)
@@ -571,13 +579,17 @@ found_ptype:
 	if (NAPI_GRO_CB(skb)->flush)
 		goto normal;
 
+	/* Must be called before setting NAPI_GRO_CB(skb)->{age|last}.
+	 * A held packet must have its headers in the linear part.
+	 */
+	if (unlikely(!gro_try_pull_from_frag0(skb)))
+		goto normal;
+
 	if (unlikely(gro_list->count >= MAX_GRO_SKBS))
 		gro_flush_oldest(gro, &gro_list->list);
 	else
 		gro_list->count++;
 
-	/* Must be called before setting NAPI_GRO_CB(skb)->{age|last} */
-	gro_try_pull_from_frag0(skb);
 	NAPI_GRO_CB(skb)->age = jiffies;
 	NAPI_GRO_CB(skb)->last = skb;
 	if (!skb_is_gso(skb))
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -37,6 +37,7 @@ static struct sk_buff *esp4_gro_receive(
 	__be32 seq;
 	__be32 spi;
 
+	skb_gro_frag0_invalidate(skb);
 	if (!pskb_pull(skb, offset))
 		return NULL;
 
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -759,6 +759,7 @@ static struct sk_buff *udp_gro_receive_s
 			pp = p;
 		} else {
 			if (NAPI_GRO_CB(skb)->is_flist) {
+				skb_gro_frag0_invalidate(skb);
 				if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
 					NAPI_GRO_CB(skb)->flush = 1;
 					return NULL;
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -64,6 +64,7 @@ static struct sk_buff *esp6_gro_receive(
 	if (NAPI_GRO_CB(skb)->proto == IPPROTO_UDP)
 		encap_type = UDP_ENCAP_ESPINUDP;
 
+	skb_gro_frag0_invalidate(skb);
 	if (!pskb_pull(skb, offset))
 		return NULL;
 


