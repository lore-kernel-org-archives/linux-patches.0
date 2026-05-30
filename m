Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7232C11D9;
	Sat, 30 May 2026 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164040; cv=none; b=E0uYvZr2h0kevhObpEqWVDXNEGxwwdkks7Giu1jKh0mbAAwr0EDMjMtcdWHbfQ/oB3hxs3DRnQeoTYjlWKeuRr5aqdTOyZIdekTo+474zIKR4bc8bA/3Em3uqezSyC9Mv8A1FRpBhYuUqLwx2LdvdqSMsz4eClul/BZG9kGxpck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164040; c=relaxed/simple;
	bh=AyEnkKmPgqlboqUCHb80BsC/HXzdnCpvOYNAf7w22yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsRFhxOaOxuQ302HbJNkuazJ9iSkB0JpQs0uzPM1NKIH8BCGOuT4s3RWR/TB4cmtICDIgSDYRIKJu7NhUvjw0Yh08lrgP7HnBtXTy8Y3TFriZCjJjjKHIeibH+DeFEv8puqE0kgOTRiDwbfYYYtTf52Y4nv+1T5dky38kv0kOsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG/N5JUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG/N5JUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908F61F00893;
	Sat, 30 May 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164039;
	bh=dDe4aLPg+c4FKypBN5PCjuwwuuhslyFqIo6L35aGsjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iG/N5JUnW0ljZxknQ+2kRuZyrLtqyEXRxOYsQ5XFD/pHWILhEVTH72KbjXRT3PvlF
	 LB/CROrfLHuqXMkwwfPgCBsCAeCeVk1KHWXo4ZnZX31qtXEOuN63d2YiJjfW4FzfhR
	 xX1Wt1pZtQia8MAK5TlmYErf2pCvzYPkMPjE/Ig0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/776] dm cache: support shrinking the origin device
Date: Sat, 30 May 2026 18:02:31 +0200
Message-ID: <20260530160251.722140806@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit c2662b1544cbd8ea3181381bb899b8e681dfedc7 ]

This patch introduces formal support for shrinking the cache origin by
reducing the cache target length via table reloads. Cache blocks mapped
beyond the new target length must be clean and are invalidated during
preresume. If any dirty blocks exist in the area being removed, the
preresume operation fails without setting the NEEDS_CHECK flag in
superblock, and the resume ioctl returns EFBIG. The cache device remains
suspended until a table reload with target length that fits existing
mappings is performed.

Without this patch, reducing the cache target length could result in
io errors (RHBZ: 2134334), out-of-bounds memory access to the discard
bitset, and security concerns regarding data leakage.

Verification steps:

1. create a cache metadata with some cached blocks mapped to the tail
   of the origin device. Here we use cache_restore v1.0 to build a
   metadata with one clean block mapped to the last origin block.

cat <<EOF >> cmeta.xml
<superblock uuid="" block_size="128" nr_cache_blocks="512" \
policy="smq" hint_width="4">
  <mappings>
    <mapping cache_block="0" origin_block="4095" dirty="false"/>
  </mappings>
</superblock>
EOF
dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=2
dmsetup remove cmeta

2. bring up the cache whilst shrinking the cache origin by one block:

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524160 linear /dev/sdc 262144"
dmsetup create cache --table "0 524160 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

3. check the number of cached data blocks via dmsetup status. It is
   expected to be zero.

dmsetup status cache | cut -d ' ' -f 7

In addition to the script above, this patch can be verified using the
"cache/resize" tests in dmtest-python:

./dmtest run --rx cache/resize/shrink_origin --result-set default

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Stable-dep-of: 322586745bd1 ("dm cache: fix dirty mapping checking in passthrough mode switching")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 72 ++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1498ffbcb0e03..238d2bea41d8d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -405,6 +405,12 @@ struct cache {
 	mempool_t migration_pool;
 
 	struct bio_set bs;
+
+	/*
+	 * Cache_size entries. Set bits indicate blocks mapped beyond the
+	 * target length, which are marked for invalidation.
+	 */
+	unsigned long *invalid_bitset;
 };
 
 struct per_bio_data {
@@ -1918,6 +1924,9 @@ static void __destroy(struct cache *cache)
 	if (cache->discard_bitset)
 		free_bitset(cache->discard_bitset);
 
+	if (cache->invalid_bitset)
+		free_bitset(cache->invalid_bitset);
+
 	if (cache->copier)
 		dm_kcopyd_client_destroy(cache->copier);
 
@@ -2506,6 +2515,13 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	}
 	clear_bitset(cache->discard_bitset, from_dblock(cache->discard_nr_blocks));
 
+	cache->invalid_bitset = alloc_bitset(from_cblock(cache->cache_size));
+	if (!cache->invalid_bitset) {
+		*error = "could not allocate bitset for invalid blocks";
+		goto bad;
+	}
+	clear_bitset(cache->invalid_bitset, from_cblock(cache->cache_size));
+
 	cache->copier = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(cache->copier)) {
 		*error = "could not create kcopyd client";
@@ -2804,6 +2820,24 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
 	return policy_load_mapping(cache->policy, oblock, cblock, dirty, hint, hint_valid);
 }
 
+static int load_filtered_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
+				 bool dirty, uint32_t hint, bool hint_valid)
+{
+	struct cache *cache = context;
+
+	if (from_oblock(oblock) >= from_oblock(cache->origin_blocks)) {
+		if (dirty) {
+			DMERR("%s: unable to shrink origin; cache block %u is dirty",
+			      cache_device_name(cache), from_cblock(cblock));
+			return -EFBIG;
+		}
+		set_bit(from_cblock(cblock), cache->invalid_bitset);
+		return 0;
+	}
+
+	return load_mapping(context, oblock, cblock, dirty, hint, hint_valid);
+}
+
 /*
  * The discard block size in the on disk metadata is not
  * neccessarily the same as we're currently using.  So we have to
@@ -2958,6 +2992,24 @@ static int resize_cache_dev(struct cache *cache, dm_cblock_t new_size)
 	return 0;
 }
 
+static int truncate_oblocks(struct cache *cache)
+{
+	uint32_t nr_blocks = from_cblock(cache->cache_size);
+	uint32_t i;
+	int r;
+
+	for_each_set_bit(i, cache->invalid_bitset, nr_blocks) {
+		r = dm_cache_remove_mapping(cache->cmd, to_cblock(i));
+		if (r) {
+			DMERR_LIMIT("%s: invalidation failed; couldn't update on disk metadata",
+				    cache_device_name(cache));
+			return r;
+		}
+	}
+
+	return 0;
+}
+
 static int cache_preresume(struct dm_target *ti)
 {
 	int r = 0;
@@ -2982,11 +3034,25 @@ static int cache_preresume(struct dm_target *ti)
 	}
 
 	if (!cache->loaded_mappings) {
+		/*
+		 * The fast device could have been resized since the last
+		 * failed preresume attempt.  To be safe we start by a blank
+		 * bitset for cache blocks.
+		 */
+		clear_bitset(cache->invalid_bitset, from_cblock(cache->cache_size));
+
 		r = dm_cache_load_mappings(cache->cmd, cache->policy,
-					   load_mapping, cache);
+					   load_filtered_mapping, cache);
 		if (r) {
 			DMERR("%s: could not load cache mappings", cache_device_name(cache));
-			metadata_operation_failed(cache, "dm_cache_load_mappings", r);
+			if (r != -EFBIG)
+				metadata_operation_failed(cache, "dm_cache_load_mappings", r);
+			return r;
+		}
+
+		r = truncate_oblocks(cache);
+		if (r) {
+			metadata_operation_failed(cache, "dm_cache_remove_mapping", r);
 			return r;
 		}
 
@@ -3460,7 +3526,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {2, 2, 0},
+	.version = {2, 3, 0},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
2.53.0



