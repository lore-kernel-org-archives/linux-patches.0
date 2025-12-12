Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C1B30E0EB;
	Fri, 12 Dec 2025 06:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765519959; cv=none; b=e5ibbflbJVs9U1n5Q6U7OCU6sCvel+IzgFz2T1W3tkhi1dJ9bB3hm7sxLOmq6Zbe1tVV4HFASlgbWJF0ieNrs+Fa03/wUcO0ZmG1S7A2Xc+8U8e3SK5r1m6drmM8kmuBe4jfwe6jOycLI8WNFBSIgJ3b6NbzUBTDq/Crhid8p0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765519959; c=relaxed/simple;
	bh=05xYo20/GHTIaq4/s7wjhs+/FWTiMvP8O5HV5Ohd5RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WWx/jiRdeoqecseF4cGCwZRdG5gt0hgG8QW75hSGkh7F7RyYhlIgTaJ6UgfKActt7kceWz1bIUWi4McvRmfvsEn3k4m4VMjwb2lW8OujL6AZWXdBW/qFkU0eyfM3Csf4oeekTDsQtHhpS3aQ/xCbZrJQKuN1tZ7KEQun/8bTrnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rA8II03q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rA8II03q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B069C4CEF1;
	Fri, 12 Dec 2025 06:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765519958;
	bh=05xYo20/GHTIaq4/s7wjhs+/FWTiMvP8O5HV5Ohd5RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rA8II03qD8BpKqF1AvjxVaFzWwJ9HWlgMzbAQN0shHaT+fJK6cAIAtHLNMZ+EITmB
	 LjzjwBAGgh23xFidjiqhRJw6V5wqOeHhPe6jmVOGEibAgCU9b3mas+aj/Lig2VhM52
	 15NUwapW4FDO6Wy0H1HmzCYFisM7hKbI/oQwteRlvPYTOt214HBzFfTp3FVhVYCOu5
	 eWsmD30Y3avJ7Ar0JdoiHqm36e0j71SnVpukZ2+ZCDvlOGHoH6YWBcroPtsTuPRPq2
	 VW27AeNEd/CHlua0xVq16Nj+poFTz3EhU8ZrROVhPKF+ttaxG7p8nDcUBtDhwCIdho
	 z6lRIuRArCihg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Jiping Ma <jiping.ma2@windriver.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	dm-devel@lists.linux.dev,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.6] dm-snapshot: fix 'scheduling while atomic' on real-time kernels
Date: Fri, 12 Dec 2025 01:12:14 -0500
Message-ID: <20251212061223.305139-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212061223.305139-1-sashal@kernel.org>
References: <20251212061223.305139-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8581b19eb2c5ccf06c195d3b5468c3c9d17a5020 ]

There is reported 'scheduling while atomic' bug when using dm-snapshot on
real-time kernels. The reason for the bug is that the hlist_bl code does
preempt_disable() when taking the lock and the kernel attempts to take
other spinlocks while holding the hlist_bl lock.

Fix this by converting a hlist_bl spinlock into a regular spinlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Jiping Ma <jiping.ma2@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Summary

**Bug Analysis:**
The commit fixes a genuine runtime bug on PREEMPT_RT kernels. The
`hlist_bl` implementation uses bit spinlocks with `preempt_disable()`,
creating an atomic context. When dm-snapshot code then tries to take
other spinlocks (which on RT kernels are sleeping locks/rt_mutexes), it
triggers "scheduling while atomic" warnings.

**Historical Context:**
The buggy code (using `hlist_bl` in dm-snapshot) was introduced in
commit `f79ae415b64c35` ("dm snapshot: Make exception tables scalable")
which landed in **v5.2**. This means all current stable/LTS trees
(5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y) contain the vulnerable
code.

**Risk vs Benefit:**

| Factor | Assessment |
|--------|------------|
| Bug severity | HIGH - causes kernel BUG on RT systems |
| Fix correctness | HIGH - straightforward lock type conversion |
| Code scope | CONTAINED - dm-snapshot only |
| Regression risk | LOW - semantically equivalent locking |
| User impact | RT kernel users with dm-snapshot |

**Stable Criteria Checklist:**
- ✅ Fixes a real bug (scheduling while atomic)
- ✅ Obviously correct (converts bit spinlock to regular spinlock)
- ✅ Small and contained (within dm-snapshot subsystem)
- ✅ No new features or APIs
- ✅ Authored by subsystem maintainer (Mikulas Patocka)
- ✅ Has Reported-by indicating real user impact
- ⚠️ No explicit `Cc: stable` tag (but this isn't required)

**Conclusion:**
This commit is an excellent stable backport candidate. It fixes a real,
reported bug that causes kernel warnings and potential instability on
PREEMPT_RT kernels when using dm-snapshot. The fix is well-understood,
uses standard kernel primitives, and is authored by the DM subsystem
maintainer. The change is self-contained and poses low regression risk
since it maintains the same locking semantics while fixing RT
compatibility.

**YES**

 drivers/md/dm-exception-store.h |  2 +-
 drivers/md/dm-snap.c            | 73 +++++++++++++++------------------
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index b679766375381..061b4d3108132 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -29,7 +29,7 @@ typedef sector_t chunk_t;
  * chunk within the device.
  */
 struct dm_exception {
-	struct hlist_bl_node hash_list;
+	struct hlist_node hash_list;
 
 	chunk_t old_chunk;
 	chunk_t new_chunk;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f40c18da40000..dbd148967de42 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -40,10 +40,15 @@ static const char dm_snapshot_merge_target_name[] = "snapshot-merge";
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
+struct dm_hlist_head {
+	struct hlist_head head;
+	spinlock_t lock;
+};
+
 struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned int hash_shift;
-	struct hlist_bl_head *table;
+	struct dm_hlist_head *table;
 };
 
 struct dm_snapshot {
@@ -628,8 +633,8 @@ static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk);
 
 /* Lock to protect access to the completed and pending exception hash tables. */
 struct dm_exception_table_lock {
-	struct hlist_bl_head *complete_slot;
-	struct hlist_bl_head *pending_slot;
+	spinlock_t *complete_slot;
+	spinlock_t *pending_slot;
 };
 
 static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
@@ -638,20 +643,20 @@ static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
 	struct dm_exception_table *complete = &s->complete;
 	struct dm_exception_table *pending = &s->pending;
 
-	lock->complete_slot = &complete->table[exception_hash(complete, chunk)];
-	lock->pending_slot = &pending->table[exception_hash(pending, chunk)];
+	lock->complete_slot = &complete->table[exception_hash(complete, chunk)].lock;
+	lock->pending_slot = &pending->table[exception_hash(pending, chunk)].lock;
 }
 
 static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
 {
-	hlist_bl_lock(lock->complete_slot);
-	hlist_bl_lock(lock->pending_slot);
+	spin_lock_nested(lock->complete_slot, 1);
+	spin_lock_nested(lock->pending_slot, 2);
 }
 
 static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
 {
-	hlist_bl_unlock(lock->pending_slot);
-	hlist_bl_unlock(lock->complete_slot);
+	spin_unlock(lock->pending_slot);
+	spin_unlock(lock->complete_slot);
 }
 
 static int dm_exception_table_init(struct dm_exception_table *et,
@@ -661,13 +666,15 @@ static int dm_exception_table_init(struct dm_exception_table *et,
 
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
-	et->table = kvmalloc_array(size, sizeof(struct hlist_bl_head),
+	et->table = kvmalloc_array(size, sizeof(struct dm_hlist_head),
 				   GFP_KERNEL);
 	if (!et->table)
 		return -ENOMEM;
 
-	for (i = 0; i < size; i++)
-		INIT_HLIST_BL_HEAD(et->table + i);
+	for (i = 0; i < size; i++) {
+		INIT_HLIST_HEAD(&et->table[i].head);
+		spin_lock_init(&et->table[i].lock);
+	}
 
 	return 0;
 }
@@ -675,16 +682,17 @@ static int dm_exception_table_init(struct dm_exception_table *et,
 static void dm_exception_table_exit(struct dm_exception_table *et,
 				    struct kmem_cache *mem)
 {
-	struct hlist_bl_head *slot;
+	struct dm_hlist_head *slot;
 	struct dm_exception *ex;
-	struct hlist_bl_node *pos, *n;
+	struct hlist_node *pos;
 	int i, size;
 
 	size = et->hash_mask + 1;
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
+		hlist_for_each_entry_safe(ex, pos, &slot->head, hash_list) {
+			hlist_del(&ex->hash_list);
 			kmem_cache_free(mem, ex);
 			cond_resched();
 		}
@@ -700,7 +708,7 @@ static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
 
 static void dm_remove_exception(struct dm_exception *e)
 {
-	hlist_bl_del(&e->hash_list);
+	hlist_del(&e->hash_list);
 }
 
 /*
@@ -710,12 +718,11 @@ static void dm_remove_exception(struct dm_exception *e)
 static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
 						chunk_t chunk)
 {
-	struct hlist_bl_head *slot;
-	struct hlist_bl_node *pos;
+	struct hlist_head *slot;
 	struct dm_exception *e;
 
-	slot = &et->table[exception_hash(et, chunk)];
-	hlist_bl_for_each_entry(e, pos, slot, hash_list)
+	slot = &et->table[exception_hash(et, chunk)].head;
+	hlist_for_each_entry(e, slot, hash_list)
 		if (chunk >= e->old_chunk &&
 		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
 			return e;
@@ -762,18 +769,17 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 static void dm_insert_exception(struct dm_exception_table *eh,
 				struct dm_exception *new_e)
 {
-	struct hlist_bl_head *l;
-	struct hlist_bl_node *pos;
+	struct hlist_head *l;
 	struct dm_exception *e = NULL;
 
-	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
+	l = &eh->table[exception_hash(eh, new_e->old_chunk)].head;
 
 	/* Add immediately if this table doesn't support consecutive chunks */
 	if (!eh->hash_shift)
 		goto out;
 
 	/* List is ordered by old_chunk */
-	hlist_bl_for_each_entry(e, pos, l, hash_list) {
+	hlist_for_each_entry(e, l, hash_list) {
 		/* Insert after an existing chunk? */
 		if (new_e->old_chunk == (e->old_chunk +
 					 dm_consecutive_chunk_count(e) + 1) &&
@@ -804,13 +810,13 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 		 * Either the table doesn't support consecutive chunks or slot
 		 * l is empty.
 		 */
-		hlist_bl_add_head(&new_e->hash_list, l);
+		hlist_add_head(&new_e->hash_list, l);
 	} else if (new_e->old_chunk < e->old_chunk) {
 		/* Add before an existing exception */
-		hlist_bl_add_before(&new_e->hash_list, &e->hash_list);
+		hlist_add_before(&new_e->hash_list, &e->hash_list);
 	} else {
 		/* Add to l's tail: e is the last exception in this slot */
-		hlist_bl_add_behind(&new_e->hash_list, &e->hash_list);
+		hlist_add_behind(&new_e->hash_list, &e->hash_list);
 	}
 }
 
@@ -820,7 +826,6 @@ static void dm_insert_exception(struct dm_exception_table *eh,
  */
 static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 {
-	struct dm_exception_table_lock lock;
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
@@ -833,17 +838,7 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	/*
-	 * Although there is no need to lock access to the exception tables
-	 * here, if we don't then hlist_bl_add_head(), called by
-	 * dm_insert_exception(), will complain about accessing the
-	 * corresponding list without locking it first.
-	 */
-	dm_exception_table_lock_init(s, old, &lock);
-
-	dm_exception_table_lock(&lock);
 	dm_insert_exception(&s->complete, e);
-	dm_exception_table_unlock(&lock);
 
 	return 0;
 }
@@ -873,7 +868,7 @@ static int calc_max_buckets(void)
 	/* use a fixed size of 2MB */
 	unsigned long mem = 2 * 1024 * 1024;
 
-	mem /= sizeof(struct hlist_bl_head);
+	mem /= sizeof(struct dm_hlist_head);
 
 	return mem;
 }
-- 
2.51.0

