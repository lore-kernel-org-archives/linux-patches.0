Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3214388A;
	Tue, 23 Apr 2024 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908457; cv=none; b=T4w89a8CloVDyI2lenbyU09S6RG183Qycir/NNroT43Z2xEaDiUZ2iJ/PYD0Q6BgeHHQCgKSRYpInkOMHKBr4c3QvNBdM7wSg0cNZwqJOKXExH8Zu7iM/vZyNde3gQne0XxvhUU0j7/lwURrhu+FkOtsalAvRtPx2oLTRVrZfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908457; c=relaxed/simple;
	bh=6iTR3H5FNMEx9uGlgYJ42sMhf3a1GQIS+df17ecZN6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOksG9HQ1ULWYDgnZo5n/r8mxixMDqMpDGDgV78SOUIagcgMeN1Z7fHf91ZbfFMzTc3XTxE+tlo7agiCaytmVoUmYTWDg2IR9TVGPiOShEm3NWJF4X9v5ZzCuiCsD224Eb4FF1ChXdIkmJqliXX+Im/Pvmg3gE7NA8h+QRjJjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQJYKnjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQJYKnjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C9CC116B1;
	Tue, 23 Apr 2024 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908457;
	bh=6iTR3H5FNMEx9uGlgYJ42sMhf3a1GQIS+df17ecZN6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQJYKnjoe2tN2stzJCqkAPsFHely8V9BDtTl0o3YZZoN8tBhcHSo23oA9dB+HGFdW
	 3dYOwWmGNPoNFg1Lh5xFNIDc/9/dEviiSxasfexwONhCCK1t+tjUqATJbnL6BpqHgn
	 rGGnAeQBPuRQil27cPU8DPH+06sm6PTUcEKxt4jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 017/158] netfilter: nft_set_pipapo: constify lookup fn args where possible
Date: Tue, 23 Apr 2024 14:37:19 -0700
Message-ID: <20240423213856.424335489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f04df573faf90bb828a2241b650598c02c074323 ]

Those get called from packet path, content must not be modified.
No functional changes intended.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c      | 18 +++++----
 net/netfilter/nft_set_pipapo.h      |  6 +--
 net/netfilter/nft_set_pipapo_avx2.c | 59 +++++++++++++++++------------
 3 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index b3b282de802de..7756d70af868c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -360,7 +360,7 @@
  * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
  */
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
-		  union nft_pipapo_map_bucket *mt, bool match_only)
+		  const union nft_pipapo_map_bucket *mt, bool match_only)
 {
 	unsigned long bitset;
 	int k, ret = -1;
@@ -412,9 +412,9 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_scratch *scratch;
 	unsigned long *res_map, *fill_map;
 	u8 genmask = nft_genmask_cur(net);
+	const struct nft_pipapo_match *m;
+	const struct nft_pipapo_field *f;
 	const u8 *rp = (const u8 *)key;
-	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
 	bool map_index;
 	int i;
 
@@ -519,11 +519,13 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 {
 	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *m = priv->clone;
 	unsigned long *res_map, *fill_map = NULL;
-	struct nft_pipapo_field *f;
+	const struct nft_pipapo_match *m;
+	const struct nft_pipapo_field *f;
 	int i;
 
+	m = priv->clone;
+
 	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
 	if (!res_map) {
 		ret = ERR_PTR(-ENOMEM);
@@ -1597,7 +1599,7 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
-		struct nft_pipapo_field *f;
+		const struct nft_pipapo_field *f;
 		int i, start, rules_fx;
 
 		start = first_rule;
@@ -2039,8 +2041,8 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
-	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
+	const struct nft_pipapo_match *m;
+	const struct nft_pipapo_field *f;
 	int i, r;
 
 	rcu_read_lock();
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 3842c7341a9f4..42464e7c24ac0 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -187,7 +187,7 @@ struct nft_pipapo_elem {
 };
 
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
-		  union nft_pipapo_map_bucket *mt, bool match_only);
+		  const union nft_pipapo_map_bucket *mt, bool match_only);
 
 /**
  * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
@@ -195,7 +195,7 @@ int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
  * @dst:	Area to store result
  * @data:	Input data selecting table buckets
  */
-static inline void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
+static inline void pipapo_and_field_buckets_4bit(const struct nft_pipapo_field *f,
 						 unsigned long *dst,
 						 const u8 *data)
 {
@@ -223,7 +223,7 @@ static inline void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
  * @dst:	Area to store result
  * @data:	Input data selecting table buckets
  */
-static inline void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
+static inline void pipapo_and_field_buckets_8bit(const struct nft_pipapo_field *f,
 						 unsigned long *dst,
 						 const u8 *data)
 {
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index a3a8ddca99189..d08407d589eac 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -212,8 +212,9 @@ static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	u8 pg[2] = { pkt[0] >> 4, pkt[0] & 0xf };
@@ -274,8 +275,9 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	u8 pg[4] = { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
@@ -350,8 +352,9 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	u8 pg[8] = {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf,
 		      pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
@@ -445,8 +448,9 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
-				        struct nft_pipapo_field *f, int offset,
-				        const u8 *pkt, bool first, bool last)
+					const struct nft_pipapo_field *f,
+					int offset, const u8 *pkt,
+					bool first, bool last)
 {
 	u8 pg[12] = {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf,
 		       pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
@@ -534,8 +538,9 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
-					struct nft_pipapo_field *f, int offset,
-					const u8 *pkt, bool first, bool last)
+					const struct nft_pipapo_field *f,
+					int offset, const u8 *pkt,
+					bool first, bool last)
 {
 	u8 pg[32] = {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf,
 		       pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
@@ -669,8 +674,9 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
@@ -726,8 +732,9 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
@@ -790,8 +797,9 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
@@ -865,8 +873,9 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
-				       struct nft_pipapo_field *f, int offset,
-				       const u8 *pkt, bool first, bool last)
+				       const struct nft_pipapo_field *f,
+				       int offset, const u8 *pkt,
+				       bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
@@ -950,8 +959,9 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
-					struct nft_pipapo_field *f, int offset,
-					const u8 *pkt, bool first, bool last)
+					const struct nft_pipapo_field *f,
+					int offset, const u8 *pkt,
+					bool first, bool last)
 {
 	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
 	unsigned long *lt = f->lt, bsize = f->bsize;
@@ -1042,8 +1052,9 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
  * word index to be checked next (i.e. first filled word).
  */
 static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
-					struct nft_pipapo_field *f, int offset,
-					const u8 *pkt, bool first, bool last)
+					const struct nft_pipapo_field *f,
+					int offset, const u8 *pkt,
+					bool first, bool last)
 {
 	unsigned long bsize = f->bsize;
 	int i, ret = -1, b;
@@ -1119,9 +1130,9 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_scratch *scratch;
 	u8 genmask = nft_genmask_cur(net);
+	const struct nft_pipapo_match *m;
+	const struct nft_pipapo_field *f;
 	const u8 *rp = (const u8 *)key;
-	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
 	unsigned long *res, *fill;
 	bool map_index;
 	int i, ret = 0;
-- 
2.43.0



