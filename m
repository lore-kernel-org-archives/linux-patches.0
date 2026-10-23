Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774104;
	b=mMc77UEqre4rdNshCLA2Trh/Tt2ricdW1c4skMROSvRTkSfDKLUHpYFz+1DL+Kd4wDk3
	 3pHfCBffQDLXmXs1lJDHB4nYDsGbrouKT7gl6Xg0Q9LIOIPDVINf2YegiViATnxiCx5Mt
	 +8+onuHPxOd1muuHRqWv/TgyFY/6DdEH6z0PYyRkoVwIebmATwXuVHTaX7BehzY4gWFEi
	 4cDKuUKsk0s+rYpKaNlWayOlhfjDo0YU91XsSZS5YAjbioFVaMzKcW4FrlV7mbUOdjJGz
	 v1VtjjyZb8U2l4wacUcfi0XWUTJ9+KjE1oNh8hk/FcwgIckd8gyCaVoPbSmujycOkWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DGBAvT2vMJo6ZiMAsQCUKGU56R7n1HSEu8L1NEBMPuA=;
	b=ecdMYKocrzsPG5tAFUFdv9YiUYZf0KKkRnxTM6+PmmXySU+0aSCpGh5hmzvFS8LURyY1
	 3+qwBZLjSilizBBcHWLNxR+bPCzIbKeCc5SiV9gMspfvOPaHBRcvMGMWKYSvYP+3AnFLl
	 WYlpEv/qsY+xA7Azsr1XHFSjyhQIKnHWi7muvSja9hGn6Omj0aL/52YisO+mlDFYmuj4W
	 H5I7zLlXuiNNK3Ymd1QwhLeBdmMT5sNAdkQugySE/tO3E+3PjyEAXZ3p7H59yIFM4VfUT
	 Ru3hJ+1YslVRigiOBNdA5NENHj/BWgow58sNz7QkTkkWjRZEQqSg78sb1GT9diYfY+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0G6CCQl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12FE606A31D;
	Fri, 23 Oct 2026 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0G6CCQl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C01F01825;
	Fri, 23 Oct 2026 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774103;
	bh=DGBAvT2vMJo6ZiMAsQCUKGU56R7n1HSEu8L1NEBMPuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0G6CCQloW6CrfniglUYMRbFGwY4yQX8D5MrB+2SUDGNPhZtmFZluDa3Gkbo+Y1gL
	 Oc47G+gIRlQjGicHNxYlGJ5g2dtif9eIhBIoNb9wqyIGUHdLVR5oyiouA0FWdIq4LC
	 Hmn6Wcn1QD29y/ToJUeNk379dgQ/M9acO7VCHhZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 122/193] dm cache: fix issue with background work locking
Date: Fri, 23 Oct 2026 18:36:39 +0200
Message-ID: <20261023163717.091315093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -339,8 +339,6 @@ struct cache {
 	struct list_head invalidation_requests;
 
 	sector_t migration_threshold;
-	wait_queue_head_t migration_wait;
-	atomic_t nr_allocated_migrations;
 
 	/*
 	 * The number of in flight migrations that are performing
@@ -396,7 +394,11 @@ struct cache {
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
@@ -487,19 +489,13 @@ static struct dm_cache_migration *alloc_
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
@@ -1029,34 +1025,39 @@ static void calc_discard_block_range(str
 
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
@@ -2515,9 +2516,7 @@ static int cache_create(struct cache_arg
 
 	spin_lock_init(&cache->lock);
 	bio_list_init(&cache->deferred_bios);
-	atomic_set(&cache->nr_allocated_migrations, 0);
 	atomic_set(&cache->nr_io_migrations, 0);
-	init_waitqueue_head(&cache->migration_wait);
 
 	r = -ENOMEM;
 	atomic_set(&cache->nr_dirty, 0);
@@ -2600,8 +2599,10 @@ static int cache_create(struct cache_arg
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


