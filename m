Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645FD4156F0;
	Fri,  4 Sep 2026 05:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500110; cv=none; b=XpA76lpbGvwEsdqPsR7aqkNn5v9gMsMuCQ5mA2VggbCK0+uZxO5Wm1Fevnjvx4VhHs0fDDyD/mYYuENZpXL/OpnXgaHadk53swT8RoclopbeiPKrLe3+J3zgHnEHE5VrfpZ3B3nimf1oOulUR02IENLg7K+lKUzzIIVAQfmcCX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500110; c=relaxed/simple;
	bh=Vtiw6jo5vpIXZkYt/jPSZauhqUpj941I2hpTB4H305w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q44YQZF/5Q0XUeP2wd3fjkI7WiBNiJV5NG9PuRYul3TTkcoh5ugQYBqu6HoytDw0f8pji9dcq7JH/hNTewQNm29tagzTEf0YYs6S8O1NoSZN3xtW8SqFXp0kU8jJ9hBsrQ40+DmuVESV6BSC9JHW/dplhfXfbXiUhJ540Prz4RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiysoWVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiysoWVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93E91F00A3D;
	Fri,  4 Sep 2026 05:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500109;
	bh=zQAIixbam93xtZxoNVrM5dnRi0p8LxbmVYHQUzMJXKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiysoWVNhhLZMJoIM+NGgl2WQ3CeCMySIz3QLh8XWzq7vkxfYLAKrFvmw/pE7gMAS
	 xLjJJs3A1KqjchnlM8ZF7nbJTBJ6gGP2eGWgTRykYtiYsc8SFjvY2V7AhI9SRo7PFF
	 lqWT+nZbP2touH4otZ3nqcgczzYXDbfr+jdxtZ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 654/713] dm-pcache: validate geometry fields from on-disk cache_info
Date: Fri,  4 Sep 2026 07:00:22 +0200
Message-ID: <20260904045818.494901463@linuxfoundation.org>
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

commit 32d1809da31094ef76fd98dc1f1a8b55ca1295dd upstream.

cache_segs_init() iterates cache_info->n_segs times indexing
cache->segments[], which is sized to the cache device geometry, and
get_seg_id() takes each segment id from the on-media cache_info and the
per-segment next_seg link. Both come from cache device metadata that is
only CRC-protected with a fixed public seed, so whoever supplies the
cache device on a table load (CAP_SYS_ADMIN) controls them: an oversized
n_segs or an out-of-range id drives an out-of-bounds access of
cache->segments[] and a wild CACHE_DEV_SEGMENT() pointer into the device
mapping -- an out-of-bounds read and write from on-disk data.

Reject an n_segs that exceeds the device segment count and a segment id
that is out of range before either is used. Valid metadata is unaffected.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -247,6 +247,13 @@ static int get_seg_id(struct pcache_cach
 		} else {
 			*seg_id = cache->cache_info.seg_id;
 		}
+
+		if (*seg_id >= cache_dev->seg_num) {
+			pcache_dev_err(pcache, "invalid segment id %u from cache device (seg_num %u)\n",
+				       *seg_id, cache_dev->seg_num);
+			ret = -EIO;
+			goto err;
+		}
 	}
 	return 0;
 err:
@@ -262,6 +269,13 @@ static int cache_segs_init(struct pcache
 	int ret;
 	u32 i;
 
+	if (cache_info->n_segs > cache->cache_dev->seg_num) {
+		pcache_dev_err(CACHE_TO_PCACHE(cache),
+			       "cache_info n_segs %u exceeds cache device segments %u\n",
+			       cache_info->n_segs, cache->cache_dev->seg_num);
+		return -EIO;
+	}
+
 	for (i = 0; i < cache_info->n_segs; i++) {
 		ret = get_seg_id(cache, prev_cache_seg, new_cache, &seg_id);
 		if (ret)


