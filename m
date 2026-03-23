Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC4A3BE644;
	Mon, 23 Mar 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283378; cv=none; b=Mq8+P7ukd2tk65MNzUrmoTlKQAcK6/3pfDCRTumasCYgOkyDMb7k7pCfdKkyHon2NLwimOdm2UOIlznpDqi+MvRuJEiGonsOq6e1ucr3bm5OkVPC24vBXhA50zxYMIeJxCTkqilpDXtcYEPm69AhWNkpjPpWcRSpi+QEFLlUBSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283378; c=relaxed/simple;
	bh=NQJegeNQehNHhgF/u2R2CEQ+yO93d8L1BfJAM9JN0KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7xHQx6j3B0yuiamSPQArRbu2SXFmohHtLhaqEsk8YFJGeiKRqZsHxrA4L8yFlBS6VOOUuJEjS/GO/Ce+agvKo3YcjE/o0mJ70skNrTPDtxcn7gAwhTp96YHq3qYFS463l+Dzn4V3uG7IYNWVyx9mBQ3UVoDjkeFQE5rNhFxljY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIpegjpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIpegjpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9430CC2BCB0;
	Mon, 23 Mar 2026 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283377;
	bh=NQJegeNQehNHhgF/u2R2CEQ+yO93d8L1BfJAM9JN0KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIpegjpDKWSb6vx0Mp7RNtJO0LaXL+Bini6ZGtIp4piYff5cA8Uz7ZbByGgyu3Iwf
	 grrRx9EFgteO79ALCD5O3JENYvLCi6PsTGb+vcCLzMuQBTNcUWWq2ZNwSMIqzYLaTN
	 TPjW9IHJGFt4rnluB325oPBLIW8R35OgOfe4GFlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"pablo@netfilter.org, netdev@vger.kernel.org, sbrivio@redhat.com, XiaoHua Wang" <561399680@139.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	XiaoHua Wang <561399680@139.com>
Subject: [PATCH 6.1 474/481] netfilter: nft_set_pipapo: prevent overflow in lookup table allocation
Date: Mon, 23 Mar 2026 14:47:36 +0100
Message-ID: <20260323134536.768408830@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 4c5c6aa9967dbe55bd017bb509885928d0f31206 ]

When calculating the lookup table size, ensure the following
multiplication does not overflow:

- desc->field_len[] maximum value is U8_MAX multiplied by
  NFT_PIPAPO_GROUPS_PER_BYTE(f) that can be 2, worst case.
- NFT_PIPAPO_BUCKETS(f->bb) is 2^8, worst case.
- sizeof(unsigned long), from sizeof(*f->lt), lt in
  struct nft_pipapo_field.

Then, use check_mul_overflow() to multiply by bucket size and then use
check_add_overflow() to the alignment for avx2 (if needed). Finally, add
lt_size_check_overflow() helper and use it to consolidate this.

While at it, replace leftover allocation using the GFP_KERNEL to
GFP_KERNEL_ACCOUNT for consistency, in pipapo_resize().

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ Adjust context ]
Signed-off-by: XiaoHua Wang <561399680@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   58 +++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -610,6 +610,30 @@ static void *nft_pipapo_get(const struct
 			 nft_genmask_cur(net), get_jiffies_64());
 }
 
+
+/**
+ * lt_calculate_size() - Get storage size for lookup table with overflow check
+ * @groups:	Amount of bit groups
+ * @bb:		Number of bits grouped together in lookup table buckets
+ * @bsize:	Size of each bucket in lookup table, in longs
+ *
+ * Return: allocation size including alignment overhead, negative on overflow
+ */
+static ssize_t lt_calculate_size(unsigned int groups, unsigned int bb,
+				 unsigned int bsize)
+{
+	ssize_t ret = groups * NFT_PIPAPO_BUCKETS(bb) * sizeof(long);
+
+	if (check_mul_overflow(ret, bsize, &ret))
+		return -1;
+	if (check_add_overflow(ret, NFT_PIPAPO_ALIGN_HEADROOM, &ret))
+		return -1;
+	if (ret > INT_MAX)
+		return -1;
+
+	return ret;
+}
+
 /**
  * pipapo_resize() - Resize lookup or mapping table, or both
  * @f:		Field containing lookup and mapping tables
@@ -628,6 +652,7 @@ static int pipapo_resize(struct nft_pipa
 	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
 	size_t new_bucket_size, copy;
 	int group, bucket;
+	ssize_t lt_size;
 
 	new_bucket_size = DIV_ROUND_UP(rules, BITS_PER_LONG);
 #ifdef NFT_PIPAPO_ALIGN
@@ -643,10 +668,11 @@ static int pipapo_resize(struct nft_pipa
 	else
 		copy = new_bucket_size;
 
-	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
-			  new_bucket_size * sizeof(*new_lt) +
-			  NFT_PIPAPO_ALIGN_HEADROOM,
-			  GFP_KERNEL);
+	lt_size = lt_calculate_size(f->groups, f->bb, new_bucket_size);
+	if (lt_size < 0)
+		return -ENOMEM;
+
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return -ENOMEM;
 
@@ -845,7 +871,7 @@ static void pipapo_lt_bits_adjust(struct
 {
 	unsigned long *new_lt;
 	int groups, bb;
-	size_t lt_size;
+	ssize_t lt_size;
 
 	lt_size = f->groups * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize *
 		  sizeof(*f->lt);
@@ -855,15 +881,17 @@ static void pipapo_lt_bits_adjust(struct
 		groups = f->groups * 2;
 		bb = NFT_PIPAPO_GROUP_BITS_LARGE_SET;
 
-		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
-			  sizeof(*f->lt);
+		lt_size = lt_calculate_size(groups, bb, f->bsize);
+		if (lt_size < 0)
+			return;
 	} else if (f->bb == NFT_PIPAPO_GROUP_BITS_LARGE_SET &&
 		   lt_size < NFT_PIPAPO_LT_SIZE_LOW) {
 		groups = f->groups / 2;
 		bb = NFT_PIPAPO_GROUP_BITS_SMALL_SET;
 
-		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
-			  sizeof(*f->lt);
+		lt_size = lt_calculate_size(groups, bb, f->bsize);
+		if (lt_size < 0)
+			return;
 
 		/* Don't increase group width if the resulting lookup table size
 		 * would exceed the upper size threshold for a "small" set.
@@ -874,7 +902,7 @@ static void pipapo_lt_bits_adjust(struct
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL_ACCOUNT);
+	new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 	if (!new_lt)
 		return;
 
@@ -1348,13 +1376,15 @@ static struct nft_pipapo_match *pipapo_c
 
 	for (i = 0; i < old->field_count; i++) {
 		unsigned long *new_lt;
+		ssize_t lt_size;
 
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
 
-		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
-				  src->bsize * sizeof(*dst->lt) +
-				  NFT_PIPAPO_ALIGN_HEADROOM,
-				  GFP_KERNEL_ACCOUNT);
+		lt_size = lt_calculate_size(src->groups, src->bb, src->bsize);
+		if (lt_size < 0)
+			goto out_lt;
+
+		new_lt = kvzalloc(lt_size, GFP_KERNEL_ACCOUNT);
 		if (!new_lt)
 			goto out_lt;
 


