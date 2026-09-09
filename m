Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81994F55A5;
	Wed,  9 Sep 2026 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962086; cv=none; b=B1pRfOGtnJUqvT80z61XWKy68SxgQUEe6MXoKUDoOsr0+zwo6mw2aSOglJvMQOJsgVb32cFiMtqEyezbkuZKnAw7mGGIxSIqMFI4oZrvh6gJzjSw1wPKSBKhtZ3VkE9sq1fVMLna6Q8zQT1ZR54SoAqICmOdK2elM26jSiFw5Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962086; c=relaxed/simple;
	bh=qRQZ1cXx1NznQqh5GOXQ87WUKMCEoptn5oNZ0mgnClU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3AvxEwiz5OQh9+7kZmD14epWtpWHjLAiBmIBa/pkeOoP+N+bsUh0Mi3TOsc9XhDbA7ieSxwvYXXE9T0au+osEmwY0kk7R5B6L5wV4viL1NwmhzSNUoJ/NeyNaRgDLplsau0UIPhczXo4MaIcaUxPcsKEfwMAWq7oQeEoRj7Wzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/23XrJ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/23XrJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159991F00A3A;
	Wed,  9 Sep 2026 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962084;
	bh=QvOdDSS6gBTO/NPFBtG+uDl3ZkuSeWLuiSFdHdtvoQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/23XrJ8rA62M2d8+sNw0MjrFzrNpsL3U2MpPLG0GUyqbois0dCbsmvoDtsS5oEaB
	 a3dwGXcEgvou+HqT/TRnXwpOKxSWapIevYFhJo3pRwEqS2fhDDjZlsr6XDpMhgbKZG
	 +t1Z8w32PetiAlBl4acmO82wTW+X3qvH8g+99+kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 127/556] memcg: keep folios objcg same as its node
Date: Wed,  9 Sep 2026 15:36:47 +0200
Message-ID: <20260909134234.928180748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit bf4ade7dbd76d4ec8697840e4ebb15ed77c5ec26 upstream.

memcg_reparent_objcgs() has an inherent assumption that a folio's objcg is
the objcg of the folio's node.  Folio migration across nodes breaks that
assumption: the new folio simply inherits the old folio's objcg while
living on a different node.

Once the assumption is broken, the reparenting of the folio's objcg and
the reparenting of the folio's LRU list are no longer atomic.
memcg_reparent_objcgs() handles one node per iteration and drops all the
locks in between, so the objcg gets reparented in the iteration for the
objcg's node while the LRU list gets spliced in the iteration for the
folio's node.  Any LRU operation on that folio in between resolves its
lruvec through the objcg, and thus takes the lru_lock of the wrong memcg,
not the lru_lock of the list the folio is actually on.

Fix this by selecting the objcg by folio_nid() at charge time, and by
re-deriving it for the destination node in mem_cgroup_migrate() and
mem_cgroup_replace_folio().

Link: https://lore.kernel.org/20260807142406.443516-1-shakeel.butt@linux.dev
Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 83 insertions(+), 17 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2907,10 +2907,9 @@ struct mem_cgroup *mem_cgroup_from_virt(
 	return folio_memcg_check(virt_to_folio(p));
 }
 
-static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+						      int nid)
 {
-	int nid = numa_node_id();
-
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
 
@@ -2921,12 +2920,13 @@ static struct obj_cgroup *__get_obj_cgro
 	return NULL;
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+							   int nid)
 {
 	struct obj_cgroup *objcg;
 
 	rcu_read_lock();
-	objcg = __get_obj_cgroup_from_memcg(memcg);
+	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
 	rcu_read_unlock();
 
 	return objcg;
@@ -2970,7 +2970,7 @@ static struct obj_cgroup *current_objcg_
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
-		objcg = __get_obj_cgroup_from_memcg(memcg);
+		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
 		rcu_read_unlock();
 
 		/*
@@ -5133,7 +5133,7 @@ static int charge_memcg(struct folio *fo
 	int ret = 0;
 	struct obj_cgroup *objcg;
 
-	objcg = get_obj_cgroup_from_memcg(memcg);
+	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
 		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
@@ -5332,6 +5332,46 @@ void __mem_cgroup_uncharge_folios(struct
 		uncharge_batch(&ug);
 }
 
+/*
+ * An LRU folio must hold the objcg belonging to its own node.
+ *
+ * memcg_reparent_objcgs() reparents a dying cgroup one node at a time: the
+ * folios on that node's LRU lists move to the parent and that node's objcg is
+ * redirected to the parent, atomically under the node's lru_lock.
+ * folio_lruvec_lock() relies on this to provide a stable folio<->lruvec
+ * binding. If a folio holds another node's objcg, its list membership and its
+ * lruvec resolution change in separate lock sections, and an LRU operation in
+ * between can re-add the folio to, and strand it on, the LRU list of a dead
+ * memcg.
+ *
+ * So when migration transfers the memcg state to a folio on another node,
+ * re-derive the objcg for the destination node. If the memcg is dying and the
+ * destination node has already been reparented, the lookup walks up to the
+ * nearest live ancestor - which is also where that node's LRU lists went.
+ *
+ * Returns the objcg to commit to @new, with a reference for the caller.
+ */
+static struct obj_cgroup *get_migration_objcg(struct folio *old,
+					      struct folio *new)
+{
+	struct obj_cgroup *old_objcg, *new_objcg;
+	int new_nid = folio_nid(new);
+
+	old_objcg = get_obj_cgroup_from_folio(old);
+
+	if (folio_nid(old) == new_nid)
+		return old_objcg;
+
+	rcu_read_lock();
+	new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						new_nid);
+	rcu_read_unlock();
+
+	obj_cgroup_put(old_objcg);
+
+	return new_objcg;
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5360,21 +5400,28 @@ void mem_cgroup_replace_folio(struct fol
 	if (folio_memcg_charged(new))
 		return;
 
-	objcg = folio_objcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!objcg, old);
-	if (!objcg)
+	VM_WARN_ON_ONCE_FOLIO(!folio_objcg(old), old);
+	if (!folio_objcg(old))
 		return;
 
+	objcg = get_migration_objcg(old, new);
+
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
-	/* Force-charge the new page. The old one will be freed soon */
+
+	/*
+	 * Force-charge the new page. The old one will be freed soon.
+	 *
+	 * The rootness of the committed objcg decides whether the final
+	 * uncharge of @new goes through the page counters (see
+	 * uncharge_folio()); charge them only if the uncharge will.
+	 */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5386,14 +5433,15 @@ void mem_cgroup_replace_folio(struct fol
  * @new: Replacement folio.
  *
  * Transfer the memcg data from the old folio to the new folio for migration.
- * The old folio's data info will be cleared. Note that the memory counters
- * will remain unchanged throughout the process.
+ * The old folio's data info will be cleared. The memory counters remain
+ * unchanged, unless the charge moves out of a fully reparented ancestry
+ * and has to be settled (see below).
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *new_objcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5414,12 +5462,30 @@ void mem_cgroup_migrate(struct folio *ol
 	if (!objcg)
 		return;
 
-	/* Transfer the charge and the objcg ref */
-	commit_charge(new, objcg);
+	new_objcg = get_migration_objcg(old, new);
+
+	/*
+	 * @old was charged through a non-root objcg, so its charge is in the
+	 * page counters. If the re-derivation walked up to the root objcg -
+	 * @old's entire ancestry is dying and already reparented - the final
+	 * uncharge of @new will skip the page counters (see uncharge_folio()).
+	 * Settle them now: this is @old's eventual uncharge, moved up to the
+	 * point where its charge record ends.
+	 */
+	if (obj_cgroup_is_root(new_objcg) && !obj_cgroup_is_root(objcg)) {
+		rcu_read_lock();
+		memcg_uncharge(obj_cgroup_memcg(objcg), folio_nr_pages(old));
+		rcu_read_unlock();
+	}
+
+	commit_charge(new, new_objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
 	old->memcg_data = 0;
+
+	/* @new holds its own reference now, drop @old's */
+	obj_cgroup_put(objcg);
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);


