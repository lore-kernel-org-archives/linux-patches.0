Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870D216415;
	Sat,  3 Feb 2024 04:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933500; cv=none; b=FWeejYrdKmsQii8uNZiNffVpJangdVdwcUiMSpTvBDasElXVGngeeFTRBSL4aulcyBTL8hmVXmcMis1JYFxVegdPC7jj58PIot3oCyeVqLxNVzctgEFjE9OUw2zCDkSuIZ4VxN3ERw98bR7fEsnLz2iKpRJ1pIWXs/e9oA9Atqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933500; c=relaxed/simple;
	bh=1gFvm1Vc0C3qNzM6ezlSMIC44b1x6WAUNZM9t16yUDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIDQcyxEeP2SMK4n+jv2E+/qpoJtcrXVi4cEYVIgwlZkJ3Fm+pgyAXjAsZRzCTJedCzABm9s7y1FF37phqvQvAxHKD9ci2AqS1qLkQVd0FGJMu2KMS3TQJDA5aMFDnqO/8ecnm7dIPA1a8zCOVkkHFm24k5GpkDM+SjUiArZWCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvpHyUjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvpHyUjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0A9C433F1;
	Sat,  3 Feb 2024 04:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933500;
	bh=1gFvm1Vc0C3qNzM6ezlSMIC44b1x6WAUNZM9t16yUDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvpHyUjEbU9I16nYwYL+AbrTPfoKDW2diWfkOPTJXvQ8ikcGJrUUHCX3K1KTs7L4O
	 xgKy3Yl/sGlF13iJCf7k2O5yTJ6GJRnKXz56py+FNO4g/bAez/EEJ2n32W3TZWHG+u
	 /55xIvgwodez7OiEOGG8FVMVrjrDv6FZec/TvA78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/322] debugobjects: Stop accessing objects after releasing hash bucket lock
Date: Fri,  2 Feb 2024 20:01:51 -0800
Message-ID: <20240203035359.507957977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit 9bb6362652f3f4d74a87d572a91ee1b38e673ef6 ]

After release of the hashbucket lock the tracking object can be modified or
freed by a concurrent thread.  Using it in such a case is error prone, even
for printing the object state:

    1. T1 tries to deactivate destroyed object, debugobjects detects it,
       hash bucket lock is released.

    2. T2 preempts T1 and frees the tracking object.

    3. The freed tracking object is allocated and initialized for a
       different to be tracked kernel object.

    4. T1 resumes and reports error for wrong kernel object.

Create a local copy of the tracking object before releasing the hash bucket
lock and use the local copy for reporting and fixups to prevent this.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20231025-debugobjects_fix-v3-1-2bc3bf7084c2@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 200 ++++++++++++++++++---------------------------
 1 file changed, 78 insertions(+), 122 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a517256a270b..c90834a209b5 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -620,9 +620,8 @@ static void debug_objects_fill_pool(void)
 static void
 __debug_object_init(void *addr, const struct debug_obj_descr *descr, int onstack)
 {
-	enum debug_obj_state state;
+	struct debug_obj *obj, o;
 	struct debug_bucket *db;
-	struct debug_obj *obj;
 	unsigned long flags;
 
 	debug_objects_fill_pool();
@@ -643,24 +642,18 @@ __debug_object_init(void *addr, const struct debug_obj_descr *descr, int onstack
 	case ODEBUG_STATE_INIT:
 	case ODEBUG_STATE_INACTIVE:
 		obj->state = ODEBUG_STATE_INIT;
-		break;
-
-	case ODEBUG_STATE_ACTIVE:
-		state = obj->state;
-		raw_spin_unlock_irqrestore(&db->lock, flags);
-		debug_print_object(obj, "init");
-		debug_object_fixup(descr->fixup_init, addr, state);
-		return;
-
-	case ODEBUG_STATE_DESTROYED:
 		raw_spin_unlock_irqrestore(&db->lock, flags);
-		debug_print_object(obj, "init");
 		return;
 	default:
 		break;
 	}
 
+	o = *obj;
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+	debug_print_object(&o, "init");
+
+	if (o.state == ODEBUG_STATE_ACTIVE)
+		debug_object_fixup(descr->fixup_init, addr, o.state);
 }
 
 /**
@@ -701,11 +694,9 @@ EXPORT_SYMBOL_GPL(debug_object_init_on_stack);
 int debug_object_activate(void *addr, const struct debug_obj_descr *descr)
 {
 	struct debug_obj o = { .object = addr, .state = ODEBUG_STATE_NOTAVAILABLE, .descr = descr };
-	enum debug_obj_state state;
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
-	int ret;
 
 	if (!debug_objects_enabled)
 		return 0;
@@ -717,49 +708,38 @@ int debug_object_activate(void *addr, const struct debug_obj_descr *descr)
 	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object_or_alloc(addr, db, descr, false, true);
-	if (likely(!IS_ERR_OR_NULL(obj))) {
-		bool print_object = false;
-
+	if (unlikely(!obj)) {
+		raw_spin_unlock_irqrestore(&db->lock, flags);
+		debug_objects_oom();
+		return 0;
+	} else if (likely(!IS_ERR(obj))) {
 		switch (obj->state) {
-		case ODEBUG_STATE_INIT:
-		case ODEBUG_STATE_INACTIVE:
-			obj->state = ODEBUG_STATE_ACTIVE;
-			ret = 0;
-			break;
-
 		case ODEBUG_STATE_ACTIVE:
-			state = obj->state;
-			raw_spin_unlock_irqrestore(&db->lock, flags);
-			debug_print_object(obj, "activate");
-			ret = debug_object_fixup(descr->fixup_activate, addr, state);
-			return ret ? 0 : -EINVAL;
-
 		case ODEBUG_STATE_DESTROYED:
-			print_object = true;
-			ret = -EINVAL;
+			o = *obj;
 			break;
+		case ODEBUG_STATE_INIT:
+		case ODEBUG_STATE_INACTIVE:
+			obj->state = ODEBUG_STATE_ACTIVE;
+			fallthrough;
 		default:
-			ret = 0;
-			break;
+			raw_spin_unlock_irqrestore(&db->lock, flags);
+			return 0;
 		}
-		raw_spin_unlock_irqrestore(&db->lock, flags);
-		if (print_object)
-			debug_print_object(obj, "activate");
-		return ret;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+	debug_print_object(&o, "activate");
 
-	/* If NULL the allocation has hit OOM */
-	if (!obj) {
-		debug_objects_oom();
-		return 0;
+	switch (o.state) {
+	case ODEBUG_STATE_ACTIVE:
+	case ODEBUG_STATE_NOTAVAILABLE:
+		if (debug_object_fixup(descr->fixup_activate, addr, o.state))
+			return 0;
+		fallthrough;
+	default:
+		return -EINVAL;
 	}
-
-	/* Object is neither static nor tracked. It's not initialized */
-	debug_print_object(&o, "activate");
-	ret = debug_object_fixup(descr->fixup_activate, addr, ODEBUG_STATE_NOTAVAILABLE);
-	return ret ? 0 : -EINVAL;
 }
 EXPORT_SYMBOL_GPL(debug_object_activate);
 
@@ -770,10 +750,10 @@ EXPORT_SYMBOL_GPL(debug_object_activate);
  */
 void debug_object_deactivate(void *addr, const struct debug_obj_descr *descr)
 {
+	struct debug_obj o = { .object = addr, .state = ODEBUG_STATE_NOTAVAILABLE, .descr = descr };
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
-	bool print_object = false;
 
 	if (!debug_objects_enabled)
 		return;
@@ -785,33 +765,24 @@ void debug_object_deactivate(void *addr, const struct debug_obj_descr *descr)
 	obj = lookup_object(addr, db);
 	if (obj) {
 		switch (obj->state) {
+		case ODEBUG_STATE_DESTROYED:
+			break;
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
 		case ODEBUG_STATE_ACTIVE:
-			if (!obj->astate)
-				obj->state = ODEBUG_STATE_INACTIVE;
-			else
-				print_object = true;
-			break;
-
-		case ODEBUG_STATE_DESTROYED:
-			print_object = true;
-			break;
+			if (obj->astate)
+				break;
+			obj->state = ODEBUG_STATE_INACTIVE;
+			fallthrough;
 		default:
-			break;
+			raw_spin_unlock_irqrestore(&db->lock, flags);
+			return;
 		}
+		o = *obj;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
-	if (!obj) {
-		struct debug_obj o = { .object = addr,
-				       .state = ODEBUG_STATE_NOTAVAILABLE,
-				       .descr = descr };
-
-		debug_print_object(&o, "deactivate");
-	} else if (print_object) {
-		debug_print_object(obj, "deactivate");
-	}
+	debug_print_object(&o, "deactivate");
 }
 EXPORT_SYMBOL_GPL(debug_object_deactivate);
 
@@ -822,11 +793,9 @@ EXPORT_SYMBOL_GPL(debug_object_deactivate);
  */
 void debug_object_destroy(void *addr, const struct debug_obj_descr *descr)
 {
-	enum debug_obj_state state;
+	struct debug_obj *obj, o;
 	struct debug_bucket *db;
-	struct debug_obj *obj;
 	unsigned long flags;
-	bool print_object = false;
 
 	if (!debug_objects_enabled)
 		return;
@@ -836,32 +805,31 @@ void debug_object_destroy(void *addr, const struct debug_obj_descr *descr)
 	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
-	if (!obj)
-		goto out_unlock;
+	if (!obj) {
+		raw_spin_unlock_irqrestore(&db->lock, flags);
+		return;
+	}
 
 	switch (obj->state) {
+	case ODEBUG_STATE_ACTIVE:
+	case ODEBUG_STATE_DESTROYED:
+		break;
 	case ODEBUG_STATE_NONE:
 	case ODEBUG_STATE_INIT:
 	case ODEBUG_STATE_INACTIVE:
 		obj->state = ODEBUG_STATE_DESTROYED;
-		break;
-	case ODEBUG_STATE_ACTIVE:
-		state = obj->state;
+		fallthrough;
+	default:
 		raw_spin_unlock_irqrestore(&db->lock, flags);
-		debug_print_object(obj, "destroy");
-		debug_object_fixup(descr->fixup_destroy, addr, state);
 		return;
-
-	case ODEBUG_STATE_DESTROYED:
-		print_object = true;
-		break;
-	default:
-		break;
 	}
-out_unlock:
+
+	o = *obj;
 	raw_spin_unlock_irqrestore(&db->lock, flags);
-	if (print_object)
-		debug_print_object(obj, "destroy");
+	debug_print_object(&o, "destroy");
+
+	if (o.state == ODEBUG_STATE_ACTIVE)
+		debug_object_fixup(descr->fixup_destroy, addr, o.state);
 }
 EXPORT_SYMBOL_GPL(debug_object_destroy);
 
@@ -872,9 +840,8 @@ EXPORT_SYMBOL_GPL(debug_object_destroy);
  */
 void debug_object_free(void *addr, const struct debug_obj_descr *descr)
 {
-	enum debug_obj_state state;
+	struct debug_obj *obj, o;
 	struct debug_bucket *db;
-	struct debug_obj *obj;
 	unsigned long flags;
 
 	if (!debug_objects_enabled)
@@ -885,24 +852,26 @@ void debug_object_free(void *addr, const struct debug_obj_descr *descr)
 	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
-	if (!obj)
-		goto out_unlock;
+	if (!obj) {
+		raw_spin_unlock_irqrestore(&db->lock, flags);
+		return;
+	}
 
 	switch (obj->state) {
 	case ODEBUG_STATE_ACTIVE:
-		state = obj->state;
-		raw_spin_unlock_irqrestore(&db->lock, flags);
-		debug_print_object(obj, "free");
-		debug_object_fixup(descr->fixup_free, addr, state);
-		return;
+		break;
 	default:
 		hlist_del(&obj->node);
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		free_object(obj);
 		return;
 	}
-out_unlock:
+
+	o = *obj;
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+	debug_print_object(&o, "free");
+
+	debug_object_fixup(descr->fixup_free, addr, o.state);
 }
 EXPORT_SYMBOL_GPL(debug_object_free);
 
@@ -954,10 +923,10 @@ void
 debug_object_active_state(void *addr, const struct debug_obj_descr *descr,
 			  unsigned int expect, unsigned int next)
 {
+	struct debug_obj o = { .object = addr, .state = ODEBUG_STATE_NOTAVAILABLE, .descr = descr };
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
-	bool print_object = false;
 
 	if (!debug_objects_enabled)
 		return;
@@ -970,28 +939,19 @@ debug_object_active_state(void *addr, const struct debug_obj_descr *descr,
 	if (obj) {
 		switch (obj->state) {
 		case ODEBUG_STATE_ACTIVE:
-			if (obj->astate == expect)
-				obj->astate = next;
-			else
-				print_object = true;
-			break;
-
+			if (obj->astate != expect)
+				break;
+			obj->astate = next;
+			raw_spin_unlock_irqrestore(&db->lock, flags);
+			return;
 		default:
-			print_object = true;
 			break;
 		}
+		o = *obj;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
-	if (!obj) {
-		struct debug_obj o = { .object = addr,
-				       .state = ODEBUG_STATE_NOTAVAILABLE,
-				       .descr = descr };
-
-		debug_print_object(&o, "active_state");
-	} else if (print_object) {
-		debug_print_object(obj, "active_state");
-	}
+	debug_print_object(&o, "active_state");
 }
 EXPORT_SYMBOL_GPL(debug_object_active_state);
 
@@ -999,12 +959,10 @@ EXPORT_SYMBOL_GPL(debug_object_active_state);
 static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 {
 	unsigned long flags, oaddr, saddr, eaddr, paddr, chunks;
-	const struct debug_obj_descr *descr;
-	enum debug_obj_state state;
+	int cnt, objs_checked = 0;
+	struct debug_obj *obj, o;
 	struct debug_bucket *db;
 	struct hlist_node *tmp;
-	struct debug_obj *obj;
-	int cnt, objs_checked = 0;
 
 	saddr = (unsigned long) address;
 	eaddr = saddr + size;
@@ -1026,12 +984,10 @@ static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 
 			switch (obj->state) {
 			case ODEBUG_STATE_ACTIVE:
-				descr = obj->descr;
-				state = obj->state;
+				o = *obj;
 				raw_spin_unlock_irqrestore(&db->lock, flags);
-				debug_print_object(obj, "free");
-				debug_object_fixup(descr->fixup_free,
-						   (void *) oaddr, state);
+				debug_print_object(&o, "free");
+				debug_object_fixup(o.descr->fixup_free, (void *)oaddr, o.state);
 				goto repeat;
 			default:
 				hlist_del(&obj->node);
-- 
2.43.0



