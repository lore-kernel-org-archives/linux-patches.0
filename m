Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963846D091;
	Tue, 21 Jul 2026 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656922; cv=none; b=OyQMRlOAOfoxjpWhHsM/JzSS3J31NfIlN4ebipaDaUNe2LiFYmrUt5/TMqckojnmr0UQhquNoIQizS1hNnZlg3koIS2zZREMMBw6teN0516qqOCXEbXUqCu7hpSYGXTC1h2khns58pJNEPLJ04HTWiovhyVpLVLnqsmusBYY6w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656922; c=relaxed/simple;
	bh=YiaObqoAbIdjNo0GWEDZ4ULGuW4+FCQd2m96MCW3TeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNLqLMXQDk/uSP5wb136wbvJTnOrv8xF9QkD/6Xu7en8tjgi06B4TpMJ16VykSGCZBF1nu9qtjFFaumGgaGlgc9zdoUQjbb41rolxptE94l5KoJeuTXcRHsS5sdQ+AjOvEcDAQ0nbtD8qsh8xBLsb4dTrHr7trgHimEVFc5vMuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3SA+5/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3SA+5/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A352F1F000E9;
	Tue, 21 Jul 2026 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656921;
	bh=asW6vHlh/qGFImfMoaWfaxmC7j1rubnEHM1eA3jS5gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3SA+5/TubtUqJP0OCvR/zADBvYjL7u0vaXNG8OfZQcdHhXHLCF2p6awyW/0aVofk
	 GqZorwJNX0ENy+xlPVS2g1hDUDRcgpFRZneJi1nJgBUYgi4CbqR2lC62R0C+eS0G5Q
	 KQ1QnAyuR6OZthTMK1dGuo/DkIp+VPYniZCVtJfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0570/1611] eventpoll: split ep_insert() into alloc + register stages
Date: Tue, 21 Jul 2026 17:11:26 +0200
Message-ID: <20260721152528.199175673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c326577669ae4d..d63d40d4e26064 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1704,68 +1704,112 @@ static int ep_attach_file(struct file *file, struct epitem *epi)
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
@@ -1792,28 +1836,21 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
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



