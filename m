Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211974;
	b=TyzBgxr8ykGu4m0GLB4IrWuSGj5p5ypIhNvPCp4SBBabEyqBj4jp0jquKlFB/oVCIp3r
	 5K7xwk6Aaubswwao59TEZp0Mq2PxxMPzVd20kvHt+pNPPh4VR20JN1aHcUYiKEKtxwPBD
	 gANMGtCTgqu2voQFs4L/rMGXBhUHtzHlrtD3prr4yPJLdWWtZP9fEZ7i+kUsqPiCgmgun
	 nXzhuZSaBSEjfedgxHTrUJEouJzQ0kc2P8dFh0PY4GqA0WlfwYeznQYiWGmE022GdF1B7
	 XewB9MBZFYi03KMTyuphkZz2Hf2PU9nsbXw9tyO1yI2poqoU+lzD0lPr0w/AUM3+A0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=knEZNTC5OV4VmIx0aR8NydGMgniqOhens6xctKC+hkA=;
	b=RJaR0S7GHKaLDWXajSL4aMwcQ46e+NuSINf42wHgSG072nKsf26EI7W7ncwrNDkc+Vxx
	 v8/Rp7/E5XwjP28ExS7obbcjQV62WWUIiv2w8eELouNf6cPNb92ahxtHFyMD3e1qeo573
	 k67DEkgWBHmigTlzoubDJ7JNnlgocHQNhH5VBByyu+3SFgF5fkCaizfZHtnOhNi0QHVG1
	 /0OqsgaEF1WHAk8D7uQE0ddLNAya54rafYYGBsFkzyQpzIHdYA3wXPv1zRc9WAOAfgr6Q
	 KHfEfW25nk7pWNLNAo14Eurlt4ngRUDaTlXGyML5lbrH/h2IK70vox56XfLB9Q2wXVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EDG0WyQS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5AD606A31A;
	Wed, 28 Oct 2026 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EDG0WyQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3081F01825;
	Wed, 28 Oct 2026 18:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211974;
	bh=knEZNTC5OV4VmIx0aR8NydGMgniqOhens6xctKC+hkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EDG0WyQSXCqTW9kBmuc9iuIie7QEztIp7la9fYZtD5Bfw4/5Ftl6eTVxCIEIvgZqS
	 dR/W7F3kIiuyNlDR8dgDZa2AYoyYSLyV7lFa7h/1gci9vc6l3Y6aayHibEk1jEYk+v
	 b0aI3oy4Piu3PCQGTi7z8dCJYbGjuTPFMYuS9oaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 511/571] dm cache: fix issue with background work locking
Date: Wed, 28 Oct 2026 18:00:58 +0100
Message-ID: <20261028170020.154956252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit bc9781c0247de107876f32929f1637db93a42b34 upstream.

dm cache used a rw_semaphore for background_work_lock. Write locks on
rw_semaphores have strict owner semantics, but there was no guarantee
that the process that locked background_work_lock was the same process
that unlocked it. This can be easily seen using a kernel compiled with
CONFIG_DEBUG_RWSEMS. Given a dm cache device <cache>, run: 'dmsetup
suspend <cache> && dmsetup resume <cache>'. This will trigger a kernel
warning:

DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE))

triggered by cache_resume(). To fix this, switch from a rw_semaphore to
a spinlock and a wait queue. dm cache already has a wait queue and
associated counter, migration_wait and nr_allocated_migrations, that was
getting woken up when background work was getting completed, but wasn't
actually used by anything. This is replaced by the background_work queue
and counter.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Matthew Sakai <msakai@redhat.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |   55 +++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -338,8 +338,6 @@ struct cache {
 	struct list_head invalidation_requests;
 
 	sector_t migration_threshold;
-	wait_queue_head_t migration_wait;
-	atomic_t nr_allocated_migrations;
 
 	/*
 	 * The number of in flight migrations that are performing
@@ -395,7 +393,11 @@ struct cache {
 	bool loaded_mappings:1;
 	bool loaded_discards:1;
 
-	struct rw_semaphore background_work_lock;
+	/* background work management */
+	bool background_work_allowed;
+	unsigned background_work_nr;
+	spinlock_t background_work_lock;
+	wait_queue_head_t background_work_wait;
 
 	struct batcher committer;
 	struct work_struct commit_ws;
@@ -486,19 +488,13 @@ static struct dm_cache_migration *alloc_
 	memset(mg, 0, sizeof(*mg));
 
 	mg->cache = cache;
-	atomic_inc(&cache->nr_allocated_migrations);
 
 	return mg;
 }
 
 static void free_migration(struct dm_cache_migration *mg)
 {
-	struct cache *cache = mg->cache;
-
-	if (atomic_dec_and_test(&cache->nr_allocated_migrations))
-		wake_up(&cache->migration_wait);
-
-	mempool_free(mg, &cache->migration_pool);
+	mempool_free(mg, &mg->cache->migration_pool);
 }
 
 /*----------------------------------------------------------------*/
@@ -1026,34 +1022,39 @@ static void calc_discard_block_range(str
 
 static void prevent_background_work(struct cache *cache)
 {
-	lockdep_off();
-	down_write(&cache->background_work_lock);
-	lockdep_on();
+	spin_lock_irq(&cache->background_work_lock);
+	cache->background_work_allowed = false;
+	wait_event_lock_irq(cache->background_work_wait,
+			    cache->background_work_nr == 0,
+			    cache->background_work_lock);
+	spin_unlock_irq(&cache->background_work_lock);
 }
 
 static void allow_background_work(struct cache *cache)
 {
-	lockdep_off();
-	up_write(&cache->background_work_lock);
-	lockdep_on();
+	spin_lock_irq(&cache->background_work_lock);
+	cache->background_work_allowed = true;
+	spin_unlock_irq(&cache->background_work_lock);
 }
 
 static bool background_work_begin(struct cache *cache)
 {
 	bool r;
 
-	lockdep_off();
-	r = down_read_trylock(&cache->background_work_lock);
-	lockdep_on();
-
+	spin_lock_irq(&cache->background_work_lock);
+	r = cache->background_work_allowed;
+	if (r)
+		cache->background_work_nr++;
+	spin_unlock_irq(&cache->background_work_lock);
 	return r;
 }
 
 static void background_work_end(struct cache *cache)
 {
-	lockdep_off();
-	up_read(&cache->background_work_lock);
-	lockdep_on();
+	spin_lock_irq(&cache->background_work_lock);
+	if (--cache->background_work_nr == 0)
+		wake_up(&cache->background_work_wait);
+	spin_unlock_irq(&cache->background_work_lock);
 }
 
 /*----------------------------------------------------------------*/
@@ -2477,9 +2478,7 @@ static int cache_create(struct cache_arg
 
 	spin_lock_init(&cache->lock);
 	bio_list_init(&cache->deferred_bios);
-	atomic_set(&cache->nr_allocated_migrations, 0);
 	atomic_set(&cache->nr_io_migrations, 0);
-	init_waitqueue_head(&cache->migration_wait);
 
 	r = -ENOMEM;
 	atomic_set(&cache->nr_dirty, 0);
@@ -2561,8 +2560,10 @@ static int cache_create(struct cache_arg
 		     issue_op, cache, cache->wq);
 	dm_iot_init(&cache->tracker);
 
-	init_rwsem(&cache->background_work_lock);
-	prevent_background_work(cache);
+	init_waitqueue_head(&cache->background_work_wait);
+	spin_lock_init(&cache->background_work_lock);
+	cache->background_work_allowed = false;
+	cache->background_work_nr = 0;
 
 	*result = cache;
 	return 0;


