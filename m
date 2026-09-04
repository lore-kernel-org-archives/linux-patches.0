Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA2F3ECBDA;
	Fri,  4 Sep 2026 06:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501724; cv=none; b=nHXm0kZdEqG2RwuY9sGj8Gc1BjwKaUkEuxJ7hXshzeLIICU7M6Y6vByPzuB9zumk5WQJD51Glc6sQsIAWthOgGIaMIxFv1sChKKT2BNbYqV7KdDEyLoh976Ivnp8ltApj46TSTMN9+4Z6BR1oFaKD5kqtq/Tlb8r1QDZjqsNm3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501724; c=relaxed/simple;
	bh=ZSwe33cfYRNwVTgPc+Ct83EO/PDkoUeXE5bIatApVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LG0sD0F0zmttN780FQ/SOSaIxNEz2X2p8SeXS81aYhuiIHzVOPwV7hKdShOSs3ExzeZjFRh4Fj1t0E/AmrQGzb9m9RHFcWKheC6E3lVmBdTY7+23NzLi2e+ZsiIURY8jJ7fjyoD28OU0V+0ssDUFwaqOT8TY07tEr4KJi6BoC6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHKPrDNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHKPrDNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157E91F00A3E;
	Fri,  4 Sep 2026 06:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501723;
	bh=a0owpLE5rS1Bfh6B38UULcnkxfSlH3MdBjAuVElhvII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHKPrDNsRXnmBzyyFj9/go8CdCu4iCTe+ooY3oghj77hGvB5F6UPkirjSFPIDR3kB
	 zRULg7o8tNB/D19NG35zzbX8dJfJbGCZ1GEgCPmsfSF4aUPUCbnYKFNq/IPgA8dF9L
	 3/4B/O/FYxIKpEQVfekE48X8X8fIvNeF9EB+5slg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 510/552] dm-pcache: clamp the tail kset read to the segment data region
Date: Fri,  4 Sep 2026 07:01:07 +0200
Message-ID: <20260904045802.201911569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit becf07e2b0053027495ecd671b1f82fb2e615f68 upstream.

The tail-kset read in cache_replay(), the writeback worker and the GC
worker bounds its length by PCACHE_SEG_SIZE - seg_off, the raw segment
size rather than the data region. A tail near the segment end reads past
the segment data into the following control area.

Clamp the read to cache_seg_remain(), the data region.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_gc.c        |    2 +-
 drivers/md/dm-pcache/cache_key.c       |    2 +-
 drivers/md/dm-pcache/cache_writeback.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -37,7 +37,7 @@ static bool need_gc(struct pcache_cache
 
 	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->gc_kset_onmedia_buf;
 
-	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - key_tail->seg_off);
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(key_tail));
 	ret = copy_mc_to_kernel(kset_onmedia, key_addr, to_copy);
 	if (ret) {
 		pcache_dev_err(pcache, "error to read kset: %d", ret);
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -779,7 +779,7 @@ int cache_replay(struct pcache_cache *ca
 	__set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
 
 	while (true) {
-		to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - pos->seg_off);
+		to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(pos));
 		ret = copy_mc_to_kernel(kset_onmedia, cache_pos_addr(pos), to_copy);
 		if (ret) {
 			ret = -EIO;
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -48,7 +48,7 @@ static inline bool is_cache_clean(struct
 	addr = cache_pos_addr(dirty_tail);
 	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
 
-	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - dirty_tail->seg_off);
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(dirty_tail));
 	ret = copy_mc_to_kernel(kset_onmedia, addr, to_copy);
 	if (ret) {
 		pcache_dev_err(pcache, "error to read kset: %d", ret);


