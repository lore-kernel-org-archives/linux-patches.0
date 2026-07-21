Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B64433BC4;
	Tue, 21 Jul 2026 19:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662345; cv=none; b=DAaEEFaG+m56FKhH1yD52uXXHW5vs6NGUERdO2GAsAfziJEHaoKZdoh2eo50bJrWiS4xw+aRr/0C+iwMR6BSVQf1dDQba3pKj0vgCpp/cXBk+maEbGJ4RAx2EdyTVFf5s/Ox9EdeqC5dUTJTvMiXQ0veQ/jymFkBhVFPdJGbtyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662345; c=relaxed/simple;
	bh=GNlKY7r1wU43EFzcDz3g+WaQG1eX3PSq0K5QUhmrmbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uit21mYwKs7FYeWOuPmGvul51i8MHUEAaryPEBQ5o2R0IoIU+7ogPRTyYZW9YSLtAkffhdEymu6U673mAE9Ro8IcGe1+ZPpHNz9OAelGppTevhNNZ9q5IRR9zeGoMgFZGSmyQkfFO6+ZLmq+2gfALF8/c6hau++Bxs3LtkLD4Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTj1mHYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTj1mHYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B641F00A3A;
	Tue, 21 Jul 2026 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662344;
	bh=WJTXMGCnwqgCEQQ8y+fN0fTuJUJEvy2/npOBvM7klds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTj1mHYTL8dlsj07ABqWiOLxUQnxj86ubhGOtexqqyVjL4w7lvMQIE45r3GUn4oo7
	 bNJVjymUmXPVuHvl8W5TcCdpQxnLV9gcVv3Nt+lT+G2w83dwFV0KoEB88ViXHsA1WF
	 dx64vIJyFVaaFF3Ndc+c+7Ja1z7uKMxJu8d6L3E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0407/1276] eventpoll: split ep_insert() into alloc + register stages
Date: Tue, 21 Jul 2026 17:14:10 +0200
Message-ID: <20260721152455.205959411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e0e35f4cb983a55a36e79e9b2a20ca0e0688fae6 ]

ep_insert() was 130 lines and mixed four concerns in one body: user
quota charge and epitem allocation, attach-into-file-hlist plus
rbtree insert plus target-ep locking, reverse-path + EPOLLWAKEUP +
poll-queue install with rollback, and ready-list publication.
Factor the first two concerns into named helpers so the body reduces
to orchestration.

ep_alloc_epitem() charges the user's epoll_watches quota, allocates
a fresh epitem, and initializes its fields. On failure it returns
ERR_PTR(-ENOSPC) or ERR_PTR(-ENOMEM); on success the epi is not yet
linked into anything.

ep_register_epitem() installs @epi into @tfile's f_ep hlist and
@ep's rbtree, optionally chains @tfile onto tfile_check_list for the
path check, takes the tep->mtx nested lock for the epoll-watches-
epoll case, and finally takes the ep_get() reference that pairs
with ep_remove()'s ep_put() in ep_insert()'s error paths. On failure
it frees the epi and decrements epoll_watches to match
ep_alloc_epitem().

ep_insert()'s remaining body is the rollback-via-ep_remove() chain
(reverse_path_check, EPOLLWAKEUP source creation, ep_ptable_queue_proc
allocation) and the ready-list / wake publication. Remove a few
stale comments that duplicated function-level documentation or
described obvious code.

No functional change; rollback boundaries unchanged -- every error
path after ep_register_epitem() still calls ep_remove(), preserving
the ep->refcount invariant that keeps ep_remove()'s WARN_ON_ONCE safe.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260424-work-epoll-rework-v1-10-249ed00a20f3@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 111 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 37 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8fdcae75e039ed..5954acefa927c0 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1675,68 +1675,112 @@ static int ep_attach_file(struct file *file, struct epitem *epi)
 }
 
 /*
- * Must be called with "mtx" held.
+ * Charge the user's epoll_watches quota, allocate a fresh epitem for
+ * @tfile/@fd, and initialize its fields. The returned item is not yet
+ * linked into any data structure; the caller must install it via
+ * ep_register_epitem() (which takes over on success) or kmem_cache_free()
+ * it and decrement epoll_watches on its own.
+ *
+ * Returns ERR_PTR(-ENOSPC) if the quota is exceeded, ERR_PTR(-ENOMEM)
+ * if the slab allocation fails.
  */
-static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
-		     struct file *tfile, int fd, int full_check)
+static struct epitem *ep_alloc_epitem(struct eventpoll *ep,
+				      const struct epoll_event *event,
+				      struct file *tfile, int fd)
 {
-	int error, pwake = 0;
-	__poll_t revents;
 	struct epitem *epi;
-	struct ep_pqueue epq;
-	struct eventpoll *tep = NULL;
-
-	if (is_file_epoll(tfile))
-		tep = tfile->private_data;
-
-	lockdep_assert_irqs_enabled();
 
 	if (unlikely(percpu_counter_compare(&ep->user->epoll_watches,
 					    max_user_watches) >= 0))
-		return -ENOSPC;
+		return ERR_PTR(-ENOSPC);
 	percpu_counter_inc(&ep->user->epoll_watches);
 
-	if (!(epi = kmem_cache_zalloc(epi_cache, GFP_KERNEL))) {
+	epi = kmem_cache_zalloc(epi_cache, GFP_KERNEL);
+	if (unlikely(!epi)) {
 		percpu_counter_dec(&ep->user->epoll_watches);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	/* Item initialization follow here ... */
 	INIT_LIST_HEAD(&epi->rdllink);
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
 	epi->event = *event;
 	epi->next = EP_UNACTIVE_PTR;
 
+	return epi;
+}
+
+/*
+ * Install @epi into its target file's f_ep hlist and into @ep's rbtree,
+ * taking one additional reference on @ep for the lifetime of the item.
+ *
+ * If @tep is non-NULL, the target file is itself an eventpoll; we hold
+ * tep->mtx at subclass 1 across the attach + rbtree insert to serialize
+ * with the target side. RB tree ops are protected by @ep->mtx, which
+ * the caller already holds.
+ *
+ * On failure the epi is freed and the epoll_watches counter decremented,
+ * matching ep_alloc_epitem()'s allocation. After this returns
+ * successfully, ep_insert()'s later error paths use ep_remove() for
+ * unwind; that cannot drop @ep's refcount to zero because the ep file
+ * itself still holds the original reference.
+ */
+static int ep_register_epitem(struct eventpoll *ep, struct epitem *epi,
+			      struct eventpoll *tep, int full_check)
+{
+	struct file *tfile = epi->ffd.file;
+	int error;
+
 	if (tep)
 		mutex_lock_nested(&tep->mtx, 1);
-	/* Add the current item to the list of active epoll hook for this file */
-	if (unlikely(ep_attach_file(tfile, epi) < 0)) {
+
+	error = ep_attach_file(tfile, epi);
+	if (unlikely(error)) {
 		if (tep)
 			mutex_unlock(&tep->mtx);
 		kmem_cache_free(epi_cache, epi);
 		percpu_counter_dec(&ep->user->epoll_watches);
-		return -ENOMEM;
+		return error;
 	}
 
 	if (full_check && !tep)
 		list_file(tfile);
 
-	/*
-	 * Add the current item to the RB tree. All RB tree operations are
-	 * protected by "mtx", and ep_insert() is called with "mtx" held.
-	 */
 	ep_rbtree_insert(ep, epi);
+
 	if (tep)
 		mutex_unlock(&tep->mtx);
 
-	/*
-	 * ep_remove() calls in the later error paths can't lead to
-	 * ep_free() as the ep file itself still holds an ep reference.
-	 */
 	ep_get(ep);
+	return 0;
+}
+
+/*
+ * Must be called with "mtx" held.
+ */
+static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
+		     struct file *tfile, int fd, int full_check)
+{
+	int error, pwake = 0;
+	__poll_t revents;
+	struct epitem *epi;
+	struct ep_pqueue epq;
+	struct eventpoll *tep = NULL;
+
+	if (is_file_epoll(tfile))
+		tep = tfile->private_data;
+
+	lockdep_assert_irqs_enabled();
+
+	epi = ep_alloc_epitem(ep, event, tfile, fd);
+	if (IS_ERR(epi))
+		return PTR_ERR(epi);
 
-	/* now check if we've created too many backpaths */
+	error = ep_register_epitem(ep, epi, tep, full_check);
+	if (error)
+		return error;
+
+	/* Reject the insert if the new link would create too many back-paths. */
 	if (unlikely(full_check && reverse_path_check())) {
 		ep_remove(ep, epi);
 		return -EINVAL;
@@ -1763,28 +1807,21 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	 */
 	revents = ep_item_poll(epi, &epq.pt, 1);
 
-	/*
-	 * We have to check if something went wrong during the poll wait queue
-	 * install process. Namely an allocation for a wait queue failed due
-	 * high memory pressure.
-	 */
+	/* ep_ptable_queue_proc() signals allocation failure by clearing epq.epi. */
 	if (unlikely(!epq.epi)) {
 		ep_remove(ep, epi);
 		return -ENOMEM;
 	}
 
-	/* We have to drop the new item inside our item list to keep track of it */
+	/* Drop the new item onto the ready list if it is already ready. */
 	spin_lock_irq(&ep->lock);
 
-	/* record NAPI ID of new item if present */
 	ep_set_busy_poll_napi_id(epi);
 
-	/* If the file is already "ready" we drop it inside the ready list */
 	if (revents && !ep_is_linked(epi)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
 		ep_pm_stay_awake(epi);
 
-		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
 			wake_up(&ep->wq);
 		if (waitqueue_active(&ep->poll_wait))
-- 
2.53.0



