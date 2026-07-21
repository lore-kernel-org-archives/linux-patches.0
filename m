Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD3F46D2D0;
	Tue, 21 Jul 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656927; cv=none; b=haW97oWCT78W4EmJeqDGSdWT3AFwr7Nrm4cvRmlrHkphqUMTtBBcR3XafB6oScll25fWWAFUgNkh4n2dT5IK7twTgLM9wr0BSRj2Vh/NZa8hRjQXHdWD+XIhVoAAPQPzuhVH8TrC3ZMJ5lGzHiMJCK0cMUXphdgH4ht5x7tPpOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656927; c=relaxed/simple;
	bh=KIPEhssXYu7cI0GiQEuOOTdlR+HQo1fMdOHe/mj9b+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrIozDh8pb5I8drwrTLZ7vyPWkNJoIgO1opw+toef0iSXMLnXomW9drVlOWTaKOSeW8FQ+sCYIncKDnH4KzpSsF4/iLdq23LO4jBYpK9SDSS0UjcBgiNMtKRoR9hYpJJSE98lMEOOstFEOIzBKKRTkk0mlDmm9Co+2XgYsClb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1I0caXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1I0caXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03B31F00A3A;
	Tue, 21 Jul 2026 18:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656926;
	bh=UxIat1oTH8WK+wkrS7wX3/ENHImDJKjaSPaAcONEZy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1I0caXu+VLdU+HhzSqqaf73GwucpOjERE8KHEb0xU6d6p2v021Vzn+497pKHlk9E
	 9HPFYDhhKEy9CqAc8QGhUpIiVYQBnUeQSYzZ9oj/VRPLZcVro+zebu2tm3kxAvvCa6
	 Qb6H4q+R+3e4GBfbxbAG6tPgkXD8xQJOLYb+ygHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0572/1611] eventpoll: wrap EP_UNACTIVE_PTR in typed sentinel helpers
Date: Tue, 21 Jul 2026 17:11:28 +0200
Message-ID: <20260721152528.243101972@linuxfoundation.org>
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

[ Upstream commit 0dcb726466a556f273beaadfb76f12d1b0087dd7 ]

ep->ovflist and epi->next both use EP_UNACTIVE_PTR (a cast to
(void *)-1) as a sentinel, with distinct meanings at each site:

  ep->ovflist == EP_UNACTIVE_PTR         no scan in progress
  epi->next   == EP_UNACTIVE_PTR         epi not on ovflist

Call sites had to know the sentinel's value and, by convention, what
it meant in each context. Hide both behind inline helpers:

  ep_is_scanning(ep)       predicate for "scan in progress"
  ep_enter_scan(ep)        WRITE_ONCE flip to NULL (scan start)
  ep_exit_scan(ep)         WRITE_ONCE flip to sentinel (scan end)
  epi_on_ovflist(epi)      predicate for "epi is on ovflist"
  epi_clear_ovflist(epi)   clear epi's ovflist link slot

Convert ep_events_available(), ep_start_scan(), ep_done_scan(),
ep_poll_callback(), and ep_alloc_epitem() to use the wrappers. The
ovflist state-machine transitions are now named, not encoded in
sentinel comparisons, and the top-of-file "Ready-list state machine"
section is the single place that spells out the sentinel's meaning.

ep_alloc() keeps the raw "ep->ovflist = EP_UNACTIVE_PTR" init (no
concurrent access at that point) with an inline "not scanning"
comment, and the tfile_check_list sentinel is left alone -- it will
disappear entirely when the loop-check globals move into a
stack-allocated ep_ctl_ctx in a later commit.

Also rework ep_done_scan()'s for-loop: the combined initializer +
update clause that advanced nepi AND cleared epi->next in one step
was clever but hard to read; splitting the update into two
statements inside the body makes the epi_clear_ovflist() call
visible.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260424-work-epoll-rework-v1-14-249ed00a20f3@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 73 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ef580dbdecf8ee..f2a09086f67f2f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -507,6 +507,43 @@ static inline struct epitem *ep_item_from_wait(wait_queue_entry_t *p)
 	return container_of(p, struct eppoll_entry, wait)->base;
 }
 
+/*
+ * Ready-list / ovflist state (see "Ready-list state machine" in the
+ * top-of-file banner for the full state machine). EP_UNACTIVE_PTR is
+ * the sentinel; these wrappers name each transition and each test so
+ * call sites do not need to know the sentinel's value.
+ */
+
+/* True iff @ep is between ep_enter_scan() and ep_exit_scan(). */
+static inline bool ep_is_scanning(struct eventpoll *ep)
+{
+	return READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
+}
+
+/* Called by ep_start_scan(): divert ep_poll_callback() to ovflist. */
+static inline void ep_enter_scan(struct eventpoll *ep)
+{
+	WRITE_ONCE(ep->ovflist, NULL);
+}
+
+/* Called by ep_done_scan(): redirect ep_poll_callback() back to rdllist. */
+static inline void ep_exit_scan(struct eventpoll *ep)
+{
+	WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
+}
+
+/* True iff @epi is currently linked on its ep's ovflist. */
+static inline bool epi_on_ovflist(const struct epitem *epi)
+{
+	return epi->next != EP_UNACTIVE_PTR;
+}
+
+/* Mark @epi as not on any ovflist (init and post-drain). */
+static inline void epi_clear_ovflist(struct epitem *epi)
+{
+	epi->next = EP_UNACTIVE_PTR;
+}
+
 /**
  * ep_events_available - Checks if ready events might be available.
  *
@@ -517,8 +554,7 @@ static inline struct epitem *ep_item_from_wait(wait_queue_entry_t *p)
  */
 static inline int ep_events_available(struct eventpoll *ep)
 {
-	return !list_empty_careful(&ep->rdllist) ||
-		READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
+	return !list_empty_careful(&ep->rdllist) || ep_is_scanning(ep);
 }
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
@@ -871,7 +907,7 @@ static void ep_start_scan(struct eventpoll *ep, struct list_head *txlist)
 	lockdep_assert_irqs_enabled();
 	spin_lock_irq(&ep->lock);
 	list_splice_init(&ep->rdllist, txlist);
-	WRITE_ONCE(ep->ovflist, NULL);
+	ep_enter_scan(ep);
 	spin_unlock_irq(&ep->lock);
 }
 
@@ -886,29 +922,24 @@ static void ep_done_scan(struct eventpoll *ep,
 	 * other events might have been queued by the poll callback.
 	 * We re-insert them inside the main ready-list here.
 	 */
-	for (nepi = READ_ONCE(ep->ovflist); (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+	for (nepi = READ_ONCE(ep->ovflist); (epi = nepi) != NULL; ) {
+		nepi = epi->next;
+		epi_clear_ovflist(epi);
 		/*
-		 * We need to check if the item is already in the list.
-		 * During the "sproc" callback execution time, items are
-		 * queued into ->ovflist but the "txlist" might already
-		 * contain them, and the list_splice() below takes care of them.
+		 * Skip items that the caller already returned via @txlist
+		 * -- the list_splice() below takes care of those.
 		 */
 		if (!ep_is_linked(epi)) {
 			/*
-			 * ->ovflist is LIFO, so we have to reverse it in order
-			 * to keep in FIFO.
+			 * ovflist is LIFO; list_add() head-insert here
+			 * reverses the iteration order into FIFO.
 			 */
 			list_add(&epi->rdllink, &ep->rdllist);
 			ep_pm_stay_awake(epi);
 		}
 	}
-	/*
-	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
-	 * releasing the lock, events will be queued in the normal way inside
-	 * ep->rdllist.
-	 */
-	WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
+	/* Back out of scan mode; callbacks target ep->rdllist again. */
+	ep_exit_scan(ep);
 
 	/*
 	 * Quickly re-inject items left on "txlist".
@@ -1302,7 +1333,7 @@ static int ep_alloc(struct eventpoll **pep)
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
 	ep->rbr = RB_ROOT_CACHED;
-	ep->ovflist = EP_UNACTIVE_PTR;
+	ep->ovflist = EP_UNACTIVE_PTR;	/* not scanning */
 	ep->user = get_current_user();
 	refcount_set(&ep->refcount, 1);
 
@@ -1426,8 +1457,8 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 	 * semantics). All the events that happen during that period of time are
 	 * chained in ep->ovflist and requeued later on.
 	 */
-	if (READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR) {
-		if (epi->next == EP_UNACTIVE_PTR) {
+	if (ep_is_scanning(ep)) {
+		if (!epi_on_ovflist(epi)) {
 			epi->next = READ_ONCE(ep->ovflist);
 			WRITE_ONCE(ep->ovflist, epi);
 			ep_pm_stay_awake_rcu(epi);
@@ -1734,7 +1765,7 @@ static struct epitem *ep_alloc_epitem(struct eventpoll *ep,
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
 	epi->event = *event;
-	epi->next = EP_UNACTIVE_PTR;
+	epi_clear_ovflist(epi);
 
 	return epi;
 }
-- 
2.53.0



