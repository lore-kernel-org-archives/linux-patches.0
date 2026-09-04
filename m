Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D967405C3F;
	Fri,  4 Sep 2026 06:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501730; cv=none; b=UepQ2uCp1HhIYQ0vDlMtFguLcRMaWQwliSPobqbgIKGNEirR5nkKE6zEtmExirqaQLdYMkj5e0WrAXh/YA6LuoWK3IMiKv4kPYHTtkISF/ag7dbo8LCNLoN75ewIXuHH62LiJOY2Z2Onsi2xtpnOiVw38CZq+hAHQ/8tozwW2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501730; c=relaxed/simple;
	bh=wEYAzH/8wODSBg9W11nex93nnxI463JxoaWYPbit85Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2xW4Dzzdnv2CYuRfYD+o/O8B/Tg7CxEcwk4rhNboFeFAC1qVJB95Sze5cX5mtvDvmSvnokj09YsFHsgP/CblkHn1n1+AN1Y9EYzK+ggPKlY66BBfSf5rZ0ibt666W7dPITjJVYnHknjikSigqSufTU89FtHddwoBf2Qm/c8OJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBScSeWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBScSeWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C526C1F00A3D;
	Fri,  4 Sep 2026 06:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501729;
	bh=QEo/Hs8jnfO+vxyJlS5fYLi7ciirblEFES9yOksZToI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBScSeWvBBuyZym+SP2jG0EEK/Hqts5vAOAw5AJn82AKH3ipkiq5/Vhq+kHqQRkt7
	 8/JhVieu8H9bUEdPy1pk5Vhrel+ubDuzw5HALBL5oNJgfxzYAPLh10MJGFZjc0RaVF
	 QfWAVa1uu+iXXwcYZTYk0xuP28jV+7eTTJN9FQi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 512/552] dm-pcache: only hand out initialized cache segments
Date: Fri,  4 Sep 2026 07:01:09 +0200
Message-ID: <20260904045802.244652844@linuxfoundation.org>
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

commit 2df0fc042e299bae3c0f60ea5cd2af9285658e9f upstream.

get_cache_segment() scans the segment map up to cache->n_segs, the
physical device segment count, but cache_segs_init() only initializes
the first cache_info->n_segs segments. A crafted image with
cache_info->n_segs smaller than the device count leaves the remaining
pcache_cache_segment structs zeroed (segment.data == NULL), and the
allocator can hand one to cache_kset_close(), which writes through the
returned segment's data pointer with no NULL check.

Bound the allocator's search to cache_info->n_segs so only initialized
segments are ever returned. A conforming cache sets n_segs equal to the
device segment count, so this rejects nothing legitimate.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_segment.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
index 9d92e2b067ed..c698ebbc626d 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -243,8 +243,16 @@ struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache)
 
 	spin_lock(&cache->seg_map_lock);
 again:
-	seg_id = find_next_zero_bit(cache->seg_map, cache->n_segs, cache->last_cache_seg);
-	if (seg_id == cache->n_segs) {
+	/*
+	 * Only allocate initialized segments. cache_segs_init() initializes
+	 * cache_info.n_segs of the cache->n_segs device segments; a forged
+	 * smaller cache_info.n_segs leaves the rest as zeroed structs whose data
+	 * pointer is NULL. Bounding the search to cache_info.n_segs keeps such a
+	 * segment from reaching cache_kset_close(), which writes through it.
+	 */
+	seg_id = find_next_zero_bit(cache->seg_map, cache->cache_info.n_segs,
+				    cache->last_cache_seg);
+	if (seg_id == cache->cache_info.n_segs) {
 		/* reset the hint of ->last_cache_seg and retry */
 		if (cache->last_cache_seg) {
 			cache->last_cache_seg = 0;
-- 
2.55.0



