Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097F94DAF8A;
	Fri,  9 Oct 2026 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555248; cv=none; b=lLADfuPl7uoQeADkpkh9GvTMnxv/YdQjhOBJYfcvBZoWTu9YAi0b9coZKGS7W/BS4Aw50hgLIhz0a20YrV5hFExXwB7k2zvjCJ3lD7mAHFsRl1PqhZYHOtV0m3bV+/lzdMyUk0XMhffLcrxQqueusF5lQyDG4/vhHO7AbF9azdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555248; c=relaxed/simple;
	bh=z4wUdky3InbRf4JyzXz1BmgndHxxDAeu8gnzm7Zu7fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8BZZXF2fVVCDd+CdZ5l0tOAKu8IOdNcT8kMdcRLMcWcj4UkjuIlDYgfG7VI3NW6lTfug6xnQFJENYXwM0NMeQXzJ8hnQ+4MxH5QfRAcI9jFtVKLR9XW8pGl5ARvvXxjWJ3V57SKUb8+6azcthz95fWvE4QotgCD0BIMythgX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aO5mgxrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aO5mgxrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854621F00898;
	Fri,  9 Oct 2026 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555242;
	bh=PUaLnJA2kNOYsWHU/T3U/FVlI0PkVgF+Xu4KhWpDKm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aO5mgxrqMXPFpFNYUldO/D3yxkqTD369Omul24euuJo9xP/OavW4xsypKim1+aSv8
	 0F4V3YvT2oGOA3YxZ72tiChs8YpM0HDKrhaLiyh5pzCwZQ7eI0AWTlRukhaHlh5932
	 maNb7f+rOszR9ub9eIuBxnbL1YfDTI6mg24kGp8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 001/428] dm-pcache: reject a kset that overruns its segment
Date: Fri,  9 Oct 2026 16:05:38 +0200
Message-ID: <20261009140946.049886099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-pcache/cache_gc.c        | 5 +++++
 drivers/md/dm-pcache/cache_key.c       | 5 +++++
 drivers/md/dm-pcache/cache_writeback.c | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index a167892be7cef..d551848912b45 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -146,6 +146,11 @@ void pcache_cache_gc_fn(struct work_struct *work)
 			continue;
 		}
 
+		if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&key_tail)) {
+			atomic_inc(&cache->gc_errors);
+			return;
+		}
+
 		for (i = 0; i < kset_onmedia->key_num; i++) {
 			struct pcache_cache_key key_tmp = { 0 };
 
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index a0d109f85504d..61a71876ca1d1 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -822,6 +822,11 @@ int cache_replay(struct pcache_cache *cache)
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
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index c34db79fcefb4..c8a4c8110a581 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -261,6 +261,11 @@ void cache_writeback_fn(struct work_struct *work)
 		goto queue_work;
 	}
 
+	if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&dirty_tail)) {
+		atomic_inc(&cache->writeback_errors);
+		goto unlock;
+	}
+
 	ret = cache_kset_insert_tree(cache, kset_onmedia);
 	if (ret) {
 		atomic_inc(&cache->writeback_errors);
-- 
2.53.0



