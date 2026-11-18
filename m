Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016500;
	b=Bfx3x2yUODV3uZb1tenRuPSz8GkTCwIf8CKMiWSI1Cyw5CBk2HJ9ymCNl5yPgNtpr0oG
	 ROav33Ld1s+NrcumtIPfDc1aXvurJFygPIbjCevZZ18JeYcxTeQQ2UcAfrCAWWYQ1J3KZ
	 xmBENAKGSAMpZGS3FNkPnrj5IiqkQRLt+c4bJ7kgVJGL4E7lsIQey5PWq7R+hEIEvunc0
	 0U0wxS2IdpwoGIFfIBPIifzR7oNzi6lYcM1ckgSGYcLe16lmzmjrAvoomO2N+aus46Wbv
	 xv7WG+5Lym2CrqV5MojqoijSAMRsr0SDVCPJGnihy4eC67dU6d15fushoP5eNrnT8bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zo8pmpW72/B/zV+FBt5FzyUwQWFRKm1NSJhS/ezTtWk=;
	b=CH/lfOxk18MMfkSBjVsrTs1Rh34VsN6PxRQHDKyfw4WRwiHEgQqVrZ2unEJs6eLBfuzp
	 rQALIyLGIZbs9+slcBXrIc7kP0V0WzVkQYUqA/+dcuaLN5V1b0pOM6dQa0RSO3aLzIojX
	 l9cYGKZxdZfGVdBxDK99yqAKlH3l6ZUkcMLJHdAaVK4KWNLiDlKqlQslsSNTb1iW+XcPt
	 k2gNc9oHxBkRLnQtrN5QpulyU1NJ/J6LCQgra+EICNfk0vjaS9V36Pg1Y+VTMqRztSIh0
	 aZVrqIE9TuHfuibWCSyjofVnuo9RMJ+lERF8oSihyC9W6JFZ+EPvL6REAcLZZrxqS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZHfMndq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE22606A32C;
	Wed, 18 Nov 2026 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZHfMndq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7751F000C4;
	Wed, 18 Nov 2026 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016500;
	bh=Zo8pmpW72/B/zV+FBt5FzyUwQWFRKm1NSJhS/ezTtWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZHfMndqEH4+9jpMHSssgiTbJuHqyU+9tsJCvaSScjGaGHrbDS9ikEbdq7kDH8LFH
	 ToRNYYqN5DCncC1tnFyDsxc/Z5uuzrXxEeHOqp1RFTWSsT1hNqJMACDkp53hzYpiPX
	 RN7RI6LQd+km++2Lm8DnAFM8+lmCydDA5ui16V7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0550/2651] accel/amdxdna: Fix race between unmap and free BO
Date: Wed, 18 Nov 2026 15:29:50 +0100
Message-ID: <20261118150307.550855949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 95 +++++++++++++----------------
 drivers/accel/amdxdna/amdxdna_gem.h |  3 +-
 2 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index e861db6f93693..398d0a58b53a7 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -164,30 +164,6 @@ void amdxdna_gem_heap_free(struct amdxdna_client *client, struct amdxdna_gem_obj
 	mutex_unlock(&client->mm_lock);
 }
 
-static struct amdxdna_gem_obj *
-amdxdna_gem_create_obj(struct drm_device *dev, size_t size)
-{
-	struct amdxdna_gem_obj *abo;
-
-	abo = kzalloc_obj(*abo);
-	if (!abo)
-		return ERR_PTR(-ENOMEM);
-
-	abo->pinned = false;
-	abo->assigned_hwctx = AMDXDNA_INVALID_CTX_HANDLE;
-	mutex_init(&abo->lock);
-
-	abo->mem.dma_addr = AMDXDNA_INVALID_ADDR;
-	abo->mem.uva = AMDXDNA_INVALID_ADDR;
-	abo->mem.size = size;
-	abo->open_ref = 0;
-	abo->internal = false;
-	INIT_LIST_HEAD(&abo->mem.umap_list);
-	xa_init_flags(&abo->heap_xa, XA_FLAGS_ALLOC);
-
-	return abo;
-}
-
 static void
 amdxdna_gem_destroy_obj(struct amdxdna_gem_obj *abo)
 {
@@ -278,10 +254,8 @@ static bool amdxdna_hmm_invalidate(struct mmu_interval_notifier *mni,
 
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
 
@@ -311,13 +285,13 @@ static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
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
@@ -325,16 +299,18 @@ static void amdxdna_hmm_unregister_all(struct amdxdna_gem_obj *abo)
 
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
+		abo->mem.uva = AMDXDNA_INVALID_ADDR;
 	up_write(&xdna->notifier_lock);
 
-	list_for_each_entry_safe(mapp, tmp, &dead, node) {
-		cancel_work_sync(&mapp->hmm_unreg_work);
+	list_for_each_entry_safe(mapp, tmp, &dead, node)
 		amdxdna_umap_put(mapp);
-	}
 }
 
 static void amdxdna_umap_release(struct kref *ref)
@@ -353,24 +329,10 @@ void amdxdna_umap_put(struct amdxdna_umap *mapp)
 
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
-		abo->mem.uva = AMDXDNA_INVALID_ADDR;
-	up_write(&xdna->notifier_lock);
-
-	amdxdna_umap_put(mapp);
+	amdxdna_hmm_unreg_umaps(abo, false);
 }
 
 static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
@@ -422,8 +384,6 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	mapp->abo = abo;
 	kref_init(&mapp->refcnt);
 
-	INIT_WORK(&mapp->hmm_unreg_work, amdxdna_hmm_unreg_work);
-
 	ret = mmu_interval_notifier_insert_locked(&mapp->notifier,
 						  current->mm,
 						  addr,
@@ -449,6 +409,31 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	return ret;
 }
 
+static struct amdxdna_gem_obj *
+amdxdna_gem_create_obj(struct drm_device *dev, size_t size)
+{
+	struct amdxdna_gem_obj *abo;
+
+	abo = kzalloc_obj(*abo);
+	if (!abo)
+		return ERR_PTR(-ENOMEM);
+
+	abo->pinned = false;
+	abo->assigned_hwctx = AMDXDNA_INVALID_CTX_HANDLE;
+	mutex_init(&abo->lock);
+
+	abo->mem.dma_addr = AMDXDNA_INVALID_ADDR;
+	abo->mem.uva = AMDXDNA_INVALID_ADDR;
+	abo->mem.size = size;
+	abo->open_ref = 0;
+	abo->internal = false;
+	INIT_LIST_HEAD(&abo->mem.umap_list);
+	xa_init_flags(&abo->heap_xa, XA_FLAGS_ALLOC);
+	INIT_WORK(&abo->hmm_unreg_work, amdxdna_hmm_unreg_work);
+
+	return abo;
+}
+
 static void amdxdna_gem_dev_obj_free(struct drm_gem_object *gobj)
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(gobj->dev);
@@ -756,7 +741,9 @@ static void amdxdna_gem_obj_free(struct drm_gem_object *gobj)
 	struct amdxdna_dev *xdna = to_xdna_dev(gobj->dev);
 	struct amdxdna_gem_obj *abo = to_xdna_obj(gobj);
 
-	amdxdna_hmm_unregister_all(abo);
+	/* No notifier survives this, so no new work can be queued. */
+	amdxdna_hmm_unreg_umaps(abo, true);
+	cancel_work_sync(&abo->hmm_unreg_work);
 
 	if (abo->pinned)
 		amdxdna_gem_unpin(abo);
diff --git a/drivers/accel/amdxdna/amdxdna_gem.h b/drivers/accel/amdxdna/amdxdna_gem.h
index 5dfefdcf13560..9b4aa21a37c99 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.h
+++ b/drivers/accel/amdxdna/amdxdna_gem.h
@@ -14,13 +14,11 @@
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
@@ -44,6 +42,7 @@ struct amdxdna_gem_obj {
 	struct mutex			lock; /* Protects: pinned, mem.kva, open_ref */
 	struct amdxdna_mem		mem;
 	int				open_ref;
+	struct work_struct		hmm_unreg_work;
 
 	/* Below members are initialized when needed */
 	struct drm_mm_node		mm_node; /* For AMDXDNA_BO_DEV */
-- 
2.53.0



