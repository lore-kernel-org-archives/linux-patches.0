Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622375;
	b=qZ7VDJun7Rz76WuVY2TJXqs0Y6eIzEzCnhEU/dqrItHp7zhJe3piWYP3vadugx2C38vI
	 sqHjAF9ua3XFbB5FiRq6DLVznhQfMg/N8wI6kQ6JXRQYppaiRuBdHP5Qad5IXuB4YSYjk
	 22C+wbmVBo3rd8pJ/0g0leUWjbUz5GRP5oT654TWeS7+J/7DMzrZi5MIblJsT1qNOol/H
	 W3gHGZWWpiKVixO1WJUykHLuxBNN4nyaS9kGVstJvzqYDkoUyW/K2hN3S1pAlwMvxdzFU
	 w0N7SIoZp+iZNFWOBKDd7GvrGNyKrTsM9eAWQ7FbtEdZ79x+SLfnY4Zc6Fv32UdjS2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PEiMiNmh93MZa3eXYNIU8ed0eFnxypXJ6+ePNdyfnBw=;
	b=cSOZ3I4EY6in52cxwVZmn8zlyg6AYp3cmC+gUDs5KqOWIBUHJYRaYXG/Qqhia3EJuVGT
	 RV28Dnb3vrlo1/KtoimBEYR27hCZ5zfz8an4WQeUNQ/7gW/bzqlFLRQAqa7+ai370OWWi
	 yUgFZYvG6wMRqIo0Sm9VLCqZ6pFsWsiccn0kmVwVzekEY5fbP2k261dVczjqoNzGWNAr2
	 lH/LOpN/bf01oqD8MUDzEnMyJYY5GyDV06QIlp3hYlmhIWRW+wlaocKoLLOF85A0+fcgE
	 Cj+3nnn4GlDDO6N3XJX30IzEDCITqF3ntH8yIFHovMAOA7hT/1G+WYXKk4Lzd9mlStA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5k0R8TR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166EE606A323;
	Wed, 25 Nov 2026 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5k0R8TR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494741F000CF;
	Wed, 25 Nov 2026 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622374;
	bh=PEiMiNmh93MZa3eXYNIU8ed0eFnxypXJ6+ePNdyfnBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5k0R8TR2mrGMr12A6ELRzr86RVZdaeyKUs+4ddFkzQig8PByhZPN7gkd2tlLLJLr
	 V2/4AgVzW89I4tTlsZqUmsPGgBBCRh98488z7CMnqSldwLakJVbxB5/4qkQ5BT2/IK
	 ltlRHD7QqwwYm7trJ+IlB5uQ/JalLHY1BQE0w7QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 517/990] accel/amdxdna: Fix race between unmap and free BO
Date: Wed, 25 Nov 2026 15:31:24 +0100
Message-ID: <20261125143834.206218937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit ac18f34f5927e420ae529be72aec86201a262d04 ]

A userspace process can concurrently trigger an unmap, which queues
hmm_unreg_work, and free BO. If amdxdna_hmm_unreg_work() executes
list_del(&mapp->node) and is preempted before calling amdxdna_umap_put(),
amdxdna_hmm_unregister_all() can fail to find the mapping in the list
and return without calling cancel_work_sync(). This allows object
destruction to proceed while the worker still holds a pointer to the BO
in the umap structure.

Moving the work item from struct amdxdna_umap to struct amdxdna_gem_obj.
The worker no longer holds a pointer to an individual mapping, so there
is no longer a window where the umap has been unlinked from umap_list but
work is still pending against it. The work item now lives in the BO
itself, so use a single cancel_work_sync() in the free path to drain the
work.

Fixes: 445d20910429 ("accel/amdxdna: Fix unexpected wait when flushing notifier_wq")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260917154824.1872220-1-lizhi.hou@amd.com
[ sashal: Adapted the hmm_unreg_work move to the older gem code: the uva field is named userptr, and amdxdna_gem_create_obj() was not relocated since it already follows the worker. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 47 +++++++++++------------------
 drivers/accel/amdxdna/amdxdna_gem.h |  3 +-
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index e416a6ef7304e..cc22981d73598 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -127,10 +127,8 @@ static bool amdxdna_hmm_invalidate(struct mmu_interval_notifier *mni,
 
 	if (range->event == MMU_NOTIFY_UNMAP) {
 		down_write(&xdna->notifier_lock);
-		if (!mapp->unmapped) {
-			queue_work(xdna->notifier_wq, &mapp->hmm_unreg_work);
-			mapp->unmapped = true;
-		}
+		mapp->unmapped = true;
+		queue_work(xdna->notifier_wq, &abo->hmm_unreg_work);
 		up_write(&xdna->notifier_lock);
 	}
 
@@ -160,13 +158,13 @@ static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
 		if (!compare_range(mapp, vma->vm_mm, vma->vm_start, vma->vm_end))
 			continue;
 
-		queue_work(xdna->notifier_wq, &mapp->hmm_unreg_work);
 		mapp->unmapped = true;
+		queue_work(xdna->notifier_wq, &abo->hmm_unreg_work);
 	}
 	up_write(&xdna->notifier_lock);
 }
 
-static void amdxdna_hmm_unregister_all(struct amdxdna_gem_obj *abo)
+static void amdxdna_hmm_unreg_umaps(struct amdxdna_gem_obj *abo, bool force)
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(to_gobj(abo)->dev);
 	struct amdxdna_umap *mapp, *tmp;
@@ -174,16 +172,18 @@ static void amdxdna_hmm_unregister_all(struct amdxdna_gem_obj *abo)
 
 	down_write(&xdna->notifier_lock);
 	list_for_each_entry_safe(mapp, tmp, &abo->mem.umap_list, node) {
+		if (!force && !mapp->unmapped)
+			continue;
+
 		mapp->unmapped = true;
-		mapp->cleanup = true;
 		list_move(&mapp->node, &dead);
 	}
+	if (list_empty(&abo->mem.umap_list))
+		abo->mem.userptr = AMDXDNA_INVALID_ADDR;
 	up_write(&xdna->notifier_lock);
 
-	list_for_each_entry_safe(mapp, tmp, &dead, node) {
-		cancel_work_sync(&mapp->hmm_unreg_work);
+	list_for_each_entry_safe(mapp, tmp, &dead, node)
 		amdxdna_umap_put(mapp);
-	}
 }
 
 static void amdxdna_umap_release(struct kref *ref)
@@ -202,24 +202,10 @@ void amdxdna_umap_put(struct amdxdna_umap *mapp)
 
 static void amdxdna_hmm_unreg_work(struct work_struct *work)
 {
-	struct amdxdna_umap *mapp = container_of(work, struct amdxdna_umap,
-						 hmm_unreg_work);
-	struct amdxdna_gem_obj *abo = mapp->abo;
-	struct amdxdna_dev *xdna;
+	struct amdxdna_gem_obj *abo = container_of(work, struct amdxdna_gem_obj,
+						   hmm_unreg_work);
 
-	xdna = to_xdna_dev(to_gobj(mapp->abo)->dev);
-	down_write(&xdna->notifier_lock);
-	if (mapp->cleanup) {
-		up_write(&xdna->notifier_lock);
-		return;
-	}
-
-	list_del(&mapp->node);
-	if (list_empty(&abo->mem.umap_list))
-		abo->mem.userptr = AMDXDNA_INVALID_ADDR;
-	up_write(&xdna->notifier_lock);
-
-	amdxdna_umap_put(mapp);
+	amdxdna_hmm_unreg_umaps(abo, false);
 }
 
 static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
@@ -271,8 +257,6 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	mapp->abo = abo;
 	kref_init(&mapp->refcnt);
 
-	INIT_WORK(&mapp->hmm_unreg_work, amdxdna_hmm_unreg_work);
-
 	ret = mmu_interval_notifier_insert_locked(&mapp->notifier,
 						  current->mm,
 						  addr,
@@ -591,7 +575,9 @@ static void amdxdna_gem_obj_free(struct drm_gem_object *gobj)
 
 	XDNA_DBG(xdna, "BO type %d xdna_addr 0x%llx", abo->type, abo->mem.dev_addr);
 
-	amdxdna_hmm_unregister_all(abo);
+	/* No notifier survives this, so no new work can be queued. */
+	amdxdna_hmm_unreg_umaps(abo, true);
+	cancel_work_sync(&abo->hmm_unreg_work);
 
 	if (abo->pinned)
 		amdxdna_gem_unpin(abo);
@@ -644,6 +630,7 @@ amdxdna_gem_create_obj(struct drm_device *dev, size_t size)
 	abo->mem.dev_addr = AMDXDNA_INVALID_ADDR;
 	abo->mem.size = size;
 	INIT_LIST_HEAD(&abo->mem.umap_list);
+	INIT_WORK(&abo->hmm_unreg_work, amdxdna_hmm_unreg_work);
 
 	return abo;
 }
diff --git a/drivers/accel/amdxdna/amdxdna_gem.h b/drivers/accel/amdxdna/amdxdna_gem.h
index 8d89874f1fca3..b6573ffe8d7cc 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.h
+++ b/drivers/accel/amdxdna/amdxdna_gem.h
@@ -11,13 +11,11 @@
 struct amdxdna_umap {
 	struct mmu_interval_notifier	notifier;
 	struct hmm_range		range;
-	struct work_struct		hmm_unreg_work;
 	struct amdxdna_gem_obj		*abo;
 	struct list_head		node;
 	struct kref			refcnt;
 	bool				invalid;
 	bool				unmapped;
-	bool				cleanup;
 };
 
 struct amdxdna_mem {
@@ -38,6 +36,7 @@ struct amdxdna_gem_obj {
 	bool				pinned;
 	struct mutex			lock; /* Protects: pinned */
 	struct amdxdna_mem		mem;
+	struct work_struct		hmm_unreg_work;
 
 	/* Below members is uninitialized when needed */
 	struct drm_mm			mm; /* For AMDXDNA_BO_DEV_HEAP */
-- 
2.53.0



