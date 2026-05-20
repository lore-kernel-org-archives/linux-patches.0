Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D7933CEA2;
	Wed, 20 May 2026 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301992; cv=none; b=ThhLDs9B53iZV7835T4uI8Q9AIXYFRbdGcRWdaMNSV+Xj7e/zj0SJl01BFAtMji0OuFwQ5A+2J4mzR6SWa4IDIbLVEZoO0gGfT1jSr9aPGj+cQoYBSzoLeTgKhhTJ+AiQTy5PhNdhkKaAZJ0TK4taF3m1cjnhcxSaI5/s2gUFo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301992; c=relaxed/simple;
	bh=fFvqWqiFWihi0YTThMMbjOq8kytY7sQE5hpS0iUQhhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUVXXm6oIfqp0CS4rP+rJ5bgnaHKh4GrRSVFaAZ1fV8i1Sc0BgUcGudD/xuCGH+ofBvUxcD47xI/xwvfxmSyasKWlVcyRkCg5B0EDh2KKtANbJVfSWiT15lN7urugNPSVQ5Yon2Bv9p+NM0PhMSJoIaXHCiiDYNc/asTLb/RPdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0e3hJ9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0e3hJ9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AB21F00893;
	Wed, 20 May 2026 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301990;
	bh=NoCk5rxpSldERgVJMPZjMKCqDDFw69en8J6EF9Trbk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0e3hJ9qZGVgXaC0/o9o0kkm0DXsIRyr9BcvJOu9jTy+i2O5U8NNv+E0O7h98v4BS
	 M1GV/rrUQWQtV45XfZrLuJep6z6x9cMl/HGV7j/mkzWGopQxz57a5rzQW8IAOw9Oei
	 Qf60exD4Ypqv70MAmmgSarBEVL9eVgICZuiOGCkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/508] dm cache: fix dirty mapping checking in passthrough mode switching
Date: Wed, 20 May 2026 18:18:40 +0200
Message-ID: <20260520162100.716906923@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index acffed750e3ed..c9d13a30ce86d 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1756,17 +1756,6 @@ int dm_cache_write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *
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
index 77953a171860e..8db906ea3bef0 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2510,23 +2510,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
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
@@ -2852,6 +2837,12 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
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
@@ -3085,7 +3076,7 @@ static int cache_preresume(struct dm_target *ti)
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



