Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74F7189902;
	Fri, 15 Nov 2024 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652817; cv=none; b=sDhHyUEjJEe5lKuEI1H/XEgLdayRz54W87acASQXRxo1dBMmtBHP+ycrtl5FIo53dTxfGhMZ8ZtY3XmTB8OjOOz46a+W9vC+9UNAS7NKg9OaksACbTPLNgDq749pVm8HG3iYdWDPIGKYy8DvKSxrlpjhNEQhLyxzUWvrqYF81rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652817; c=relaxed/simple;
	bh=Ns0sYMhu886R4S9qyyImfXSjkNtTb/vcAzHoniSNDIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7Kriae00PNcv5xJesbvkZmDGhyM+LweAqhDvuUYQOlII0EOfAHcLCSHbsz/+FpZTcEWbgDbBgiTug48J36FxGxNsZh4rBFGMOJ1qv6YKrzNnfuBrex805Ocd29mSRGcfoA6K8A/lstTiYgotzmkqztjlVBoLmYbK18g6uxJWQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zolmkig2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zolmkig2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172ACC4CECF;
	Fri, 15 Nov 2024 06:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652817;
	bh=Ns0sYMhu886R4S9qyyImfXSjkNtTb/vcAzHoniSNDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zolmkig20dcju1nsvk87hB/LrYqUWti9TR43sx6e91ZPLVvYh/vO6z7fp7Tox0qr3
	 YLL7/qjKF4s35y2oRAqy6egVH+OPDOcaZ9XDUL7TEBzF5zLFqHK+n2ZBx2vKFuWxPE
	 +LN6wDf/u7XFtcj7XVXbLRkr2LL+GXAPYX84rXmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>
Subject: [PATCH 4.19 23/52] dm cache: fix potential out-of-bounds access on the first resume
Date: Fri, 15 Nov 2024 07:37:36 +0100
Message-ID: <20241115063723.694049653@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

commit c0ade5d98979585d4f5a93e4514c2e9a65afa08d upstream.

Out-of-bounds access occurs if the fast device is expanded unexpectedly
before the first-time resume of the cache table. This happens because
expanding the fast device requires reloading the cache table for
cache_create to allocate new in-core data structures that fit the new
size, and the check in cache_preresume is not performed during the
first resume, leading to the issue.

Reproduce steps:

1. prepare component devices:

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct

2. load a cache table of 512 cache blocks, and deliberately expand the
   fast device before resuming the cache, making the in-core data
   structures inadequate.

dmsetup create cache --notable
dmsetup reload cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
dmsetup reload cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup resume cdata
dmsetup resume cache

3. suspend the cache to write out the in-core dirty bitset and hint
   array, leading to out-of-bounds access to the dirty bitset at offset
   0x40:

dmsetup suspend cache

KASAN reports:

  BUG: KASAN: vmalloc-out-of-bounds in is_dirty_callback+0x2b/0x80
  Read of size 8 at addr ffffc90000085040 by task dmsetup/90

  (...snip...)
  The buggy address belongs to the virtual mapping at
   [ffffc90000085000, ffffc90000087000) created by:
   cache_ctr+0x176a/0x35f0

  (...snip...)
  Memory state around the buggy address:
   ffffc90000084f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   ffffc90000084f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  >ffffc90000085000: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 f8 f8 f8 f8
                                             ^
   ffffc90000085080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
   ffffc90000085100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8

Fix by checking the size change on the first resume.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: f494a9c6b1b6 ("dm cache: cache shrinking support")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2991,24 +2991,24 @@ static dm_cblock_t get_cache_dev_size(st
 static bool can_resize(struct cache *cache, dm_cblock_t new_size)
 {
 	if (from_cblock(new_size) > from_cblock(cache->cache_size)) {
-		if (cache->sized) {
-			DMERR("%s: unable to extend cache due to missing cache table reload",
-			      cache_device_name(cache));
-			return false;
-		}
+		DMERR("%s: unable to extend cache due to missing cache table reload",
+		      cache_device_name(cache));
+		return false;
 	}
 
 	/*
 	 * We can't drop a dirty block when shrinking the cache.
 	 */
-	new_size = to_cblock(find_next_bit(cache->dirty_bitset,
-					   from_cblock(cache->cache_size),
-					   from_cblock(new_size)));
-	if (new_size != cache->cache_size) {
-		DMERR("%s: unable to shrink cache; cache block %llu is dirty",
-		      cache_device_name(cache),
-		      (unsigned long long) from_cblock(new_size));
-		return false;
+	if (cache->loaded_mappings) {
+		new_size = to_cblock(find_next_bit(cache->dirty_bitset,
+						   from_cblock(cache->cache_size),
+						   from_cblock(new_size)));
+		if (new_size != cache->cache_size) {
+			DMERR("%s: unable to shrink cache; cache block %llu is dirty",
+			      cache_device_name(cache),
+			      (unsigned long long) from_cblock(new_size));
+			return false;
+		}
 	}
 
 	return true;
@@ -3039,20 +3039,15 @@ static int cache_preresume(struct dm_tar
 	/*
 	 * Check to see if the cache has resized.
 	 */
-	if (!cache->sized) {
-		r = resize_cache_dev(cache, csize);
-		if (r)
-			return r;
-
-		cache->sized = true;
-
-	} else if (csize != cache->cache_size) {
+	if (!cache->sized || csize != cache->cache_size) {
 		if (!can_resize(cache, csize))
 			return -EINVAL;
 
 		r = resize_cache_dev(cache, csize);
 		if (r)
 			return r;
+
+		cache->sized = true;
 	}
 
 	if (!cache->loaded_mappings) {


