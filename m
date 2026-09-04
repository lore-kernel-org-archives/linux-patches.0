Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA79D3815E1;
	Fri,  4 Sep 2026 05:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500127; cv=none; b=ZPdcyb6dobf8G/QUtZCABKt59io7ZEWBPikTbPkxxr9VdmG+AwKfwEzP67Bh/9XCqOm49rYgT8r3vAdUDdwuji87Wi94xicQ5WUo0EE7gHGNYLlAWayVuh32R90Bli3Cvxo+eYQjb6t0Jmnj/XFjxcQKQhPjBRsocF09hmP7Mq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500127; c=relaxed/simple;
	bh=MVlt2UZ21tIr/ZbUX+gosMCzIM0KAkD8q/PuvrB6Q+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8vYi5luSuOppbiclwmQkDiPZVT9VDChgUYYc8PdBzH0Q3awAMby0g5rCfOXVCoP/01AZbhrUmWXK2GYGo2n5QQohqaBqc6fKXlP55F4ny9ZkLwTuHq6rFcJdytpTZHmEzR4NeR3//wgjdkP2S3h9pf2iD7Tz78h0KmuHdX2wWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsMV2KvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsMV2KvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB1A1F00A3D;
	Fri,  4 Sep 2026 05:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500126;
	bh=YAJUTmxqgfaeKHD+MAGnTAc21TcjaUhhB4JxVQArnrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsMV2KvW6kGLB4dPWAT3IcJLHvaMygLCaAWuU2yUuMldBIEcjBFv2bLX4pFpwodCL
	 jqikYi9XYmI1SCFxV0+Wd3tyAFRM4+Gs/fDL00vqvJ65p68FBcb+jX9I1lJcAUSsdE
	 8+fPU6bLYxNyojxOl5HV7k2Ej5pQct0PbbXtkx4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 660/713] dm-pcache: only hand out initialized cache segments
Date: Fri,  4 Sep 2026 07:00:28 +0200
Message-ID: <20260904045818.630238652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/dm-pcache/cache_segment.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -243,8 +243,16 @@ struct pcache_cache_segment *get_cache_s
 
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


