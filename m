Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F83B95FA;
	Fri,  4 Sep 2026 05:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500116; cv=none; b=tkoUAVqErCuMA13NM55nRgp2oaL5cPGnV9Eqrl8uEyzWAq7MayT2loylAt9JzgWJlX1wtIFEfanbwFJ74ohZ7VClag9b1wM12kqQObwVJh0fEtByZoxyKzGY2Fx0W/jcNABemIG+/6LsU/MDTP/lbIRiRHmkQwO2WZbdjw+qPxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500116; c=relaxed/simple;
	bh=E34/zrHf5iG6DkAo3+k1Y5sqWKCeIdlQg3X1llDNVBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3kEJ14kk2Veb/+rRXlEImbSWehPKf6+dtX91lAai9uyZrWcsahV3tnX7gNSnH93kKwrHo0IY9f0iI1GoYMqCpqhetKgYAoSbDipQW4BY86Ndh+NM39NbB+Q1uDp3mU+PPQSMhiyCH6s3EhcrO1SfXoj4q3nIAyY7ye6DD+5buw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TNxuTTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TNxuTTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9931F00A3D;
	Fri,  4 Sep 2026 05:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500115;
	bh=sbIrxISS2Chagkd1TKaNDsId788h6G2aFbPLNZ1K/3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TNxuTTyuecuzBbLjQ3WDUZT+acqrhf0gjxgeTZDl7sFxEZUaVRDbaw56qCPxVZsb
	 L5+nct8/WbTr3VGHQArLD9SuXbcAq2gj5Lu/7idlLXgCjFgMItOHWCNchZs2Vueq9o
	 ksxencHDOyiOJk2tDEK52AfCHTs0Cmt2KAatN8kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 656/713] dm-pcache: validate on-media seg_num against the cache device size
Date: Fri,  4 Sep 2026 07:00:24 +0200
Message-ID: <20260904045818.540293496@linuxfoundation.org>
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

commit 62d92e45abe9e087370f9fc5d876b95673aced34 upstream.

seg_num is read from the crc32c-only superblock, so whoever supplies the
cache device on a table load (CAP_SYS_ADMIN) controls it. It sizes
cache->segments[] and is the value every later on-media segment id is
bounded against, yet it is never checked against the device. Because
cache_dev->mapping is the direct map of the pmem, CACHE_DEV_SEGMENT() for
a segment id past the device resolves to ordinary kernel memory beyond
the mapping; a new-cache init reaching such an id has cache_seg_init() ->
cache_dev_zero_range() memset() 12 KiB over that memory -- an
out-of-bounds write into the kernel heap at table load. A zero seg_num
makes the segment allocations ZERO_SIZE_PTR.

Reject a seg_num that is zero, larger than the device can hold, or larger
than PCACHE_CACHE_SEGS_MAX before it is used.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_dev.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-pcache/cache_dev.c
+++ b/drivers/md/dm-pcache/cache_dev.c
@@ -242,6 +242,8 @@ int cache_dev_start(struct dm_pcache *pc
 	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
 	struct pcache_sb sb;
 	bool format = false;
+	u32 seg_num;
+	u64 max_segs;
 	int ret;
 
 	mutex_init(&cache_dev->seg_lock);
@@ -269,7 +271,25 @@ int cache_dev_start(struct dm_pcache *pc
 		goto dax_release;
 
 	cache_dev->sb_flags = le32_to_cpu(sb.flags);
-	ret = cache_dev_init(cache_dev, le32_to_cpu(sb.seg_num));
+
+	/*
+	 * seg_num is read from the crc32c-only superblock, so whoever supplies
+	 * the cache device controls it. It is the ceiling every later on-media
+	 * segment id is validated against, so bound it against what the device
+	 * physically holds before it is trusted, or a forged seg_num lets a
+	 * segment id address past the DAX mapping.
+	 */
+	seg_num = le32_to_cpu(sb.seg_num);
+	max_segs = (bdev_nr_bytes(cache_dev->dm_dev->bdev) - PCACHE_SEGMENTS_OFF) /
+		   PCACHE_SEG_SIZE;
+	if (seg_num == 0 || seg_num > max_segs || seg_num > PCACHE_CACHE_SEGS_MAX) {
+		pcache_dev_err(pcache, "invalid seg_num %u from cache device (device holds %llu, max %u)\n",
+			       seg_num, max_segs, (u32)PCACHE_CACHE_SEGS_MAX);
+		ret = -EIO;
+		goto dax_release;
+	}
+
+	ret = cache_dev_init(cache_dev, seg_num);
 	if (ret)
 		goto dax_release;
 


