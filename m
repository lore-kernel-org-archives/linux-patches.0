Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6A0414A2A;
	Fri,  4 Sep 2026 05:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500122; cv=none; b=Ry4lbwE5qwZSItEPBZyUmJWFqR8V0tuPXk1mTG9P3Nj6irH09Un0GTQLqXu8pdW7wG2jiVfMMg9kav+5SHog7BSFv6BLjlNSZlhGHH5udyl0q1lyuByUY5Pt1VxxiEjGy2PDQFN03z1IuDb5bh+hPdAc/my5z4uB1OS0vfhden8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500122; c=relaxed/simple;
	bh=0JCkwFXCMl+RChhhIfISf0PN7tyO1LhO7YV1Uw5zZXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1jnQUYDGep5Np2oqQ4X6G0R4fTj7C0TAf1SoLslRjKj8N9iDeJA0Sh4DbnNduEyqhrnzAjk2S9gMalUI4a6jQ8zI6lc+N9w59EuEN3dVHLx5AUQBrqE1GvAECLe/tdXkURIspJ9U+ZCoVGEE+Eqs8vZjyCqdPachiivuKs+w0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwXroeGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwXroeGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292EF1F00A3D;
	Fri,  4 Sep 2026 05:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500120;
	bh=iyTyIrEGHnkFI2wAZKFjfk8P1fIyQpC3S/1gHIfMhfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwXroeGbCzETzb2K8qAa9LHkJMmmrCUfqzEy79eBdoHkZDAQn+tov21BIJIKO5a5K
	 1G8HPPg7UPayiDGax/HaFsFgqeB76et7Pc3ISmdzzAjLgG2mHDXe00RteykyUprXtL
	 eMVa4Gs9n73BjrmQlzsox31+4KZAk6YLx4DeDoYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 658/713] dm-pcache: clamp the tail kset read to the segment data region
Date: Fri,  4 Sep 2026 07:00:26 +0200
Message-ID: <20260904045818.583994892@linuxfoundation.org>
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


