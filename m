Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DC436CE19;
	Wed, 20 May 2026 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300320; cv=none; b=VIMzOp3BhOzeJCT/zC5wuFkZohLB4Ar7Zvm3hcGNTFw36CaEuvoSBVjvfDzC5V5nVF3aaSkuo54UP+F2f39zAhF6DIfki7BnTdaglQEiwzQl/Uo75sca2YCqPOfjy4KpRQmcEZ2TT9H8DzltkUcDHDrpbN3mbSWiTh5L+n0Xr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300320; c=relaxed/simple;
	bh=URsdik23wF4Qa4aZGptMFA3dLUPw8l2li6pyCH1ko50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSzD3q3c6qButPMXF3Z7fWHubzu6QotuRy8nhsu/jahwI6rzcZp+1WMbD5cjkNbRLqLeJLMTtDDEluYr3OXz8ZD3lN6+O3mZUYOJXbA4qQlisu34cGI2fDxgquFjiIBrfrLAZQwgp3OA79pkweexSXn7sDRxxoqUN7eHwuJd+Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OK6mZRfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OK6mZRfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098B81F000E9;
	Wed, 20 May 2026 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300319;
	bh=0+bdgk1xrAyl4PDoeUDkOGWlBwB9V/fBzWLOmkGoEjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OK6mZRfdjqq5B/oXS718qolTrQVEAlJzOvw0WTGFX2iPDu0I2GxnzDpvZEUtqoZUo
	 MQxfK+9idED2IdKFZa504wRbWxDR3waaqUjtckcpLkylyKQ30pHs2MYMhpeGCVyZMe
	 VFjUD7+WLZu5Tmw8Cmg+HrYiX446w3ptMvtT5J1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/666] dm cache: fix dirty mapping checking in passthrough mode switching
Date: Wed, 20 May 2026 18:15:42 +0200
Message-ID: <20260520162114.052079104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 322586745bd1a0e5f3559fd1635fdeb4dbd1d6b8 ]

As mentioned in commit 9b1cc9f251af ("dm cache: share cache-metadata
object across inactive and active DM tables"), dm-cache assumed table
reload occurs after suspension, while LVM's table preload breaks this
assumption. The dirty mapping check for passthrough mode was designed
around this assumption and is performed during table creation, causing
the check to fail with preload while metadata updates are ongoing. This
risks loading dirty mappings into passthrough mode, resulting in data
loss.

Reproduce steps:

1. Create a writeback cache with zero migration_threshold to produce
   dirty mappings

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writeback smq \
2 migration_threshold 0"

2. Preload a table in passthrough mode

dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"

3. Write to the first cache block to make it dirty

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

4. Resume the inactive table. Now it's possible to load the dirty block
   into passthrough mode.

dmsetup resume cache

Fix by moving the checks to the preresume phase to support table
preloading. Also remove the unused function dm_cache_metadata_all_clean.

Fixes: 2ee57d587357 ("dm cache: add passthrough mode")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-metadata.c | 11 -----------
 drivers/md/dm-cache-metadata.h |  5 -----
 drivers/md/dm-cache-target.c   | 25 ++++++++-----------------
 3 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 24cd87fddf752..4447679cfc471 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1747,17 +1747,6 @@ int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *
 	return r;
 }
 
-int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result)
-{
-	int r;
-
-	READ_LOCK(cmd);
-	r = blocks_are_unmapped_or_clean(cmd, 0, cmd->cache_blocks, result);
-	READ_UNLOCK(cmd);
-
-	return r;
-}
-
 void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd)
 {
 	WRITE_LOCK_VOID(cmd);
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 57afc70479472..24e4af14fcca4 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -138,11 +138,6 @@ void dm_cache_dump(struct dm_cache_metadata *cmd);
  */
 int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *p);
 
-/*
- * Query method.  Are all the blocks in the cache clean?
- */
-int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result);
-
 int dm_cache_metadata_needs_check(struct dm_cache_metadata *cmd, bool *result);
 int dm_cache_metadata_set_needs_check(struct dm_cache_metadata *cmd);
 void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd);
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index c9a7fd97b7304..68751841e124f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2506,23 +2506,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 		goto bad;
 	}
 
-	if (passthrough_mode(cache)) {
-		bool all_clean;
-
-		r = dm_cache_metadata_all_clean(cache->cmd, &all_clean);
-		if (r) {
-			*error = "dm_cache_metadata_all_clean() failed";
-			goto bad;
-		}
-
-		if (!all_clean) {
-			*error = "Cannot enter passthrough mode unless all blocks are clean";
-			r = -EINVAL;
-			goto bad;
-		}
-
+	if (passthrough_mode(cache))
 		policy_allow_migrations(cache->policy, false);
-	}
 
 	spin_lock_init(&cache->lock);
 	bio_list_init(&cache->deferred_bios);
@@ -2848,6 +2833,12 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
 	struct cache *cache = context;
 
 	if (dirty) {
+		if (passthrough_mode(cache)) {
+			DMERR("%s: cannot enter passthrough mode unless all blocks are clean",
+			      cache_device_name(cache));
+			return -EBUSY;
+		}
+
 		set_bit(from_cblock(cblock), cache->dirty_bitset);
 		atomic_inc(&cache->nr_dirty);
 	} else
@@ -3081,7 +3072,7 @@ static int cache_preresume(struct dm_target *ti)
 					   load_filtered_mapping, cache);
 		if (r) {
 			DMERR("%s: could not load cache mappings", cache_device_name(cache));
-			if (r != -EFBIG)
+			if (r != -EFBIG && r != -EBUSY)
 				metadata_operation_failed(cache, "dm_cache_load_mappings", r);
 			return r;
 		}
-- 
2.53.0



