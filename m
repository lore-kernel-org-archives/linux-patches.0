Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117E722AE68;
	Tue, 29 Apr 2025 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949209; cv=none; b=BfjxFKwRCJkXtEFwLYUKDwMXBgyU8mcsrMIKGr7FVOowy/r5CZa8z5+QD4DG/vuQSCKog+pUJnHk3PNW6z6d1rQ37y6wOXeEieJaFZCxN0WmbnEJBlEIauo3oOZDWoe/rjYsMdn8B0Zgx7C0C5Dbgmh+MLkCIqSvxxmUBLSMJR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949209; c=relaxed/simple;
	bh=bqCMHSxsSQjJ2cZ5dFmUdd0Q1tOiFL9zd1KJqkQxm6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e98J0B64hOPcNjkerHaVahFuOGnTwjzKqqdh580ZuifHPDZ2eebLoIccoPlN4xyYvyo2q6JGrKeuAm2Z3REmZl6sjPNlNAzQBbFrBBmWvC1b+Haw81lGRI0rNj5lzVury8Kzx59biB7Ou4WBAJYJ4lxMWMhGuAtiieNN8gx2e+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgzVAfcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgzVAfcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AACC4CEE3;
	Tue, 29 Apr 2025 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949208;
	bh=bqCMHSxsSQjJ2cZ5dFmUdd0Q1tOiFL9zd1KJqkQxm6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgzVAfcKR6PMBZClOmYB6bBaKtriPX4tosR8rBGanHfFLynKiRhUgLd7aupb3ZWPe
	 3P/qYGDcif4YBXdFfXS0GUl1k4AudDQowV0GPR4Zmetjo7EJvua4s1HE+DlXUH4rQR
	 3T3f8b6kVoxcERgq70IFUKq3dmms6YWvpkdFy89Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Subject: [PATCH 5.15 245/373] dm cache: fix flushing uninitialized delayed_work on cache_ctr error
Date: Tue, 29 Apr 2025 18:42:02 +0200
Message-ID: <20250429161133.204361732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

commit 135496c208ba26fd68cdef10b64ed7a91ac9a7ff upstream.

An unexpected WARN_ON from flush_work() may occur when cache creation
fails, caused by destroying the uninitialized delayed_work waker in the
error path of cache_create(). For example, the warning appears on the
superblock checksum error.

Reproduce steps:

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/urandom of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

Kernel logs:

(snip)
WARNING: CPU: 0 PID: 84 at kernel/workqueue.c:4178 __flush_work+0x5d4/0x890

Fix by pulling out the cancel_delayed_work_sync() from the constructor's
error path. This patch doesn't affect the use-after-free fix for
concurrent dm_resume and dm_destroy (commit 6a459d8edbdb ("dm cache: Fix
UAF in destroy()")) as cache_dtr is not changed.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: 6a459d8edbdb ("dm cache: Fix UAF in destroy()")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1890,16 +1890,13 @@ static void check_migrations(struct work
  * This function gets called on the error paths of the constructor, so we
  * have to cope with a partially initialised struct.
  */
-static void destroy(struct cache *cache)
+static void __destroy(struct cache *cache)
 {
-	unsigned i;
-
 	mempool_exit(&cache->migration_pool);
 
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
-	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 
@@ -1927,13 +1924,22 @@ static void destroy(struct cache *cache)
 	if (cache->policy)
 		dm_cache_policy_destroy(cache->policy);
 
+	bioset_exit(&cache->bs);
+
+	kfree(cache);
+}
+
+static void destroy(struct cache *cache)
+{
+	unsigned int i;
+
+	cancel_delayed_work_sync(&cache->waker);
+
 	for (i = 0; i < cache->nr_ctr_args ; i++)
 		kfree(cache->ctr_args[i]);
 	kfree(cache->ctr_args);
 
-	bioset_exit(&cache->bs);
-
-	kfree(cache);
+	__destroy(cache);
 }
 
 static void cache_dtr(struct dm_target *ti)
@@ -2546,7 +2552,7 @@ static int cache_create(struct cache_arg
 	*result = cache;
 	return 0;
 bad:
-	destroy(cache);
+	__destroy(cache);
 	return r;
 }
 
@@ -2597,7 +2603,7 @@ static int cache_ctr(struct dm_target *t
 
 	r = copy_ctr_args(cache, argc - 3, (const char **)argv + 3);
 	if (r) {
-		destroy(cache);
+		__destroy(cache);
 		goto out;
 	}
 


