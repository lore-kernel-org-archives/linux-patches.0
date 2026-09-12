Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53736299920;
	Sat, 12 Sep 2026 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205823; cv=none; b=ATlYOtxUBSgOaOWIPKSjHQCetIcWA9S3WU9UtRPbryJ0uygX39rgiBbpqK1UPMAzlFgaQRJVr41sNvd6g6k2j+PJmgMb4YYkEl+yAWPq4JYvvHon9iEuRextVA/o2oZJO+68fGYGuYm9Foh9tAIH7zWsRh9/u7PIuF8PFAtYmNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205823; c=relaxed/simple;
	bh=H3q5jjqgKY5n7RjqRJvjGFfjdo+B1lYfw95r3KiJw+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEJ2cxZ37/cU5z+keN1Srg73t7pTxYBarR9udeTWJIRZjYHeo1KcUHemi0m7CdpJyGXR7FYXVAUwqoRO3Vi9vrOAeDSpOMqshR4YBo1k/AmSeK8EY3gnkrGGWVnKwhWRC4pNEyJzeg8KhNqvDMiPFeBd/CXmAdwotORtsGEondQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFjhi4ZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFjhi4ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E041F000FF;
	Sat, 12 Sep 2026 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205822;
	bh=SYO0iRY5m084Crjx7fxvmD1KUlYx+JVHpi5Pp9eorJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFjhi4ZVs7DQhPE20FEy3GegOSVWWW6DaTd8TNB6ucVwIU3OcfEIp9JGHJQ0MGTKm
	 l7ckqzGOW9asc+YOAwAtYfoOVRUd9ut5xXG8DqLvvQ/VX8PRkWLW1lu1P8J4iU9CQv
	 kQwkCVEElRhe2cf2D/poDNywm1dRHr6BzL2nEdDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0079/1518] dm-pcache: reject a kset that overruns its segment
Date: Sat, 12 Sep 2026 08:37:28 +0200
Message-ID: <20260912065625.244295028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 7ac1f10f987a2ffae4aecf0e2ceca8f552b665cb ]

cache_replay(), the writeback worker and the GC worker read a kset of
get_kset_onmedia_size() bytes and advance the position by it. A forged
key_num makes that size exceed the segment's remaining space, so the
advance walks past the segment and trips the cache_pos_advance() BUG_ON.

Reject a kset whose on-media size exceeds cache_seg_remain() before use.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ backported missing writeback_errors support from the upstream dependency. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.h           |    1 +
 drivers/md/dm-pcache/cache_gc.c        |    5 +++++
 drivers/md/dm-pcache/cache_key.c       |    5 +++++
 drivers/md/dm-pcache/cache_writeback.c |    8 ++++++++
 4 files changed, 19 insertions(+)

--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -180,6 +180,7 @@ struct pcache_cache {
 		u32 advance;
 		int ret;
 	} writeback_ctx;
+	atomic_t		writeback_errors;
 
 	char gc_kset_onmedia_buf[PCACHE_KSET_ONMEDIA_SIZE_MAX];
 	struct delayed_work	gc_work;
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -134,6 +134,11 @@ void pcache_cache_gc_fn(struct work_stru
 			continue;
 		}
 
+		if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&key_tail)) {
+			atomic_inc(&cache->gc_errors);
+			return;
+		}
+
 		for (i = 0; i < kset_onmedia->key_num; i++) {
 			struct pcache_cache_key key_tmp = { 0 };
 
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -811,6 +811,11 @@ int cache_replay(struct pcache_cache *ca
 		}
 
 		/* Replay the kset and check for errors. */
+		if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(pos)) {
+			ret = -EIO;
+			goto out;
+		}
+
 		ret = kset_replay(cache, kset_onmedia);
 		if (ret)
 			goto out;
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -229,6 +229,9 @@ void cache_writeback_fn(struct work_stru
 	if (pcache_is_stopping(pcache))
 		goto unlock;
 
+	if (atomic_read(&cache->writeback_errors))
+		goto unlock;
+
 	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
 
 	mutex_lock(&cache->dirty_tail_lock);
@@ -246,6 +249,11 @@ void cache_writeback_fn(struct work_stru
 		goto queue_work;
 	}
 
+	if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&dirty_tail)) {
+		atomic_inc(&cache->writeback_errors);
+		goto unlock;
+	}
+
 	ret = cache_kset_insert_tree(cache, kset_onmedia);
 	if (ret) {
 		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;


