Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CAF15884E;
	Tue, 23 Jul 2024 18:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760284; cv=none; b=cHhaINhwQsbywHlt5AbCe7CRDIvDnOjTNWXzVm7G+q+DVQENiHYyvSmVQfaL62VgIi5U9Vx4agc6bQwy6wDdiuaTliki22W3dfUGMBXA6TqFtQzszkznx5URfcSi332WKvfue7vI6uq7Wk8FLYmcftn/S8zwRt9aP/Y0kHNnIw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760284; c=relaxed/simple;
	bh=XT7emBviASMS8lP1BfGZFxR4oD4vM6bbpAMsIeOqx3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5YS2DTrMx6eLm9jEj48ORcXvw2ZjbmepkleGuJgqIScs56TrleN/lf3PzpOr79GvRNZnH9jUQzRbG7cGKDoNgalU9BbpDzrt1uNXHuGSq8ULUinOrOwgY/MFOP5BQwjRKCuwoQNk4a7t0lbJ6fODDFCLesBKxBdEG7uE9p3p7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpSZIaxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpSZIaxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B022C4AF0A;
	Tue, 23 Jul 2024 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760284;
	bh=XT7emBviASMS8lP1BfGZFxR4oD4vM6bbpAMsIeOqx3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpSZIaxVm5jABFNSa/+KbdUOoa6UO7Dezg6P+8dNeFI8X2GuEhaBvo0Ad0Jqn2EXZ
	 iGSzRgGp48JbBAcZdD9LHXdXu4+G/ldhNOFIu2qEUTxYWuOS7a2J2NO2QW+EUKWCVN
	 5TptAm3Er49Qcz3Jtmf3xGmE9iPE6Glaige/SEq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.9 163/163] cachefiles: fix slab-use-after-free in cachefiles_withdraw_cookie()
Date: Tue, 23 Jul 2024 20:24:52 +0200
Message-ID: <20240723180149.766533439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 5d8f805789072ea7fd39504694b7bd17e5f751c4 ]

We got the following issue in our fault injection stress test:

==================================================================
BUG: KASAN: slab-use-after-free in cachefiles_withdraw_cookie+0x4d9/0x600
Read of size 8 at addr ffff888118efc000 by task kworker/u78:0/109

CPU: 13 PID: 109 Comm: kworker/u78:0 Not tainted 6.8.0-dirty #566
Call Trace:
 <TASK>
 kasan_report+0x93/0xc0
 cachefiles_withdraw_cookie+0x4d9/0x600
 fscache_cookie_state_machine+0x5c8/0x1230
 fscache_cookie_worker+0x91/0x1c0
 process_one_work+0x7fa/0x1800
 [...]

Allocated by task 117:
 kmalloc_trace+0x1b3/0x3c0
 cachefiles_acquire_volume+0xf3/0x9c0
 fscache_create_volume_work+0x97/0x150
 process_one_work+0x7fa/0x1800
 [...]

Freed by task 120301:
 kfree+0xf1/0x2c0
 cachefiles_withdraw_cache+0x3fa/0x920
 cachefiles_put_unbind_pincount+0x1f6/0x250
 cachefiles_daemon_release+0x13b/0x290
 __fput+0x204/0xa00
 task_work_run+0x139/0x230
 do_exit+0x87a/0x29b0
 [...]
==================================================================

Following is the process that triggers the issue:

           p1                |             p2
------------------------------------------------------------
                              fscache_begin_lookup
                               fscache_begin_volume_access
                                fscache_cache_is_live(fscache_cache)
cachefiles_daemon_release
 cachefiles_put_unbind_pincount
  cachefiles_daemon_unbind
   cachefiles_withdraw_cache
    fscache_withdraw_cache
     fscache_set_cache_state(cache, FSCACHE_CACHE_IS_WITHDRAWN);
    cachefiles_withdraw_objects(cache)
    fscache_wait_for_objects(fscache)
      atomic_read(&fscache_cache->object_count) == 0
                              fscache_perform_lookup
                               cachefiles_lookup_cookie
                                cachefiles_alloc_object
                                 refcount_set(&object->ref, 1);
                                 object->volume = volume
                                 fscache_count_object(vcookie->cache);
                                  atomic_inc(&fscache_cache->object_count)
    cachefiles_withdraw_volumes
     cachefiles_withdraw_volume
      fscache_withdraw_volume
      __cachefiles_free_volume
       kfree(cachefiles_volume)
                              fscache_cookie_state_machine
                               cachefiles_withdraw_cookie
                                cache = object->volume->cache;
                                // cachefiles_volume UAF !!!

After setting FSCACHE_CACHE_IS_WITHDRAWN, wait for all the cookie lookups
to complete first, and then wait for fscache_cache->object_count == 0 to
avoid the cookie exiting after the volume has been freed and triggering
the above issue. Therefore call fscache_withdraw_volume() before calling
cachefiles_withdraw_objects().

This way, after setting FSCACHE_CACHE_IS_WITHDRAWN, only the following two
cases will occur:
1) fscache_begin_lookup fails in fscache_begin_volume_access().
2) fscache_withdraw_volume() will ensure that fscache_count_object() has
   been executed before calling fscache_wait_for_objects().

Fixes: fe2140e2f57f ("cachefiles: Implement volume support")
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-4-libaokun@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/cache.c  |   35 ++++++++++++++++++++++++++++++++++-
 fs/cachefiles/volume.c |    1 -
 2 files changed, 34 insertions(+), 2 deletions(-)

--- a/fs/cachefiles/cache.c
+++ b/fs/cachefiles/cache.c
@@ -313,7 +313,39 @@ static void cachefiles_withdraw_objects(
 }
 
 /*
- * Withdraw volumes.
+ * Withdraw fscache volumes.
+ */
+static void cachefiles_withdraw_fscache_volumes(struct cachefiles_cache *cache)
+{
+	struct list_head *cur;
+	struct cachefiles_volume *volume;
+	struct fscache_volume *vcookie;
+
+	_enter("");
+retry:
+	spin_lock(&cache->object_list_lock);
+	list_for_each(cur, &cache->volumes) {
+		volume = list_entry(cur, struct cachefiles_volume, cache_link);
+
+		if (atomic_read(&volume->vcookie->n_accesses) == 0)
+			continue;
+
+		vcookie = fscache_try_get_volume(volume->vcookie,
+						 fscache_volume_get_withdraw);
+		if (vcookie) {
+			spin_unlock(&cache->object_list_lock);
+			fscache_withdraw_volume(vcookie);
+			fscache_put_volume(vcookie, fscache_volume_put_withdraw);
+			goto retry;
+		}
+	}
+	spin_unlock(&cache->object_list_lock);
+
+	_leave("");
+}
+
+/*
+ * Withdraw cachefiles volumes.
  */
 static void cachefiles_withdraw_volumes(struct cachefiles_cache *cache)
 {
@@ -381,6 +413,7 @@ void cachefiles_withdraw_cache(struct ca
 	pr_info("File cache on %s unregistering\n", fscache->name);
 
 	fscache_withdraw_cache(fscache);
+	cachefiles_withdraw_fscache_volumes(cache);
 
 	/* we now have to destroy all the active objects pertaining to this
 	 * cache - which we do by passing them off to thread pool to be
--- a/fs/cachefiles/volume.c
+++ b/fs/cachefiles/volume.c
@@ -133,7 +133,6 @@ void cachefiles_free_volume(struct fscac
 
 void cachefiles_withdraw_volume(struct cachefiles_volume *volume)
 {
-	fscache_withdraw_volume(volume->vcookie);
 	cachefiles_set_volume_xattr(volume);
 	__cachefiles_free_volume(volume);
 }


