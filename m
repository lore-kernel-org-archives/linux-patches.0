Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB4B46EC7D;
	Tue, 21 Jul 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656930; cv=none; b=gAoPoD/U30UhEO+hIESuAvUUKcRfiKVcbxkpkJOZqN9CIka81pCX8sUw+ah+xNZju5EZjkxoIfcvIYSwFzTyekP0y/8YmQ3p7zUsuAC+oQgjGjkn4VmBL22T+BhPCjPuqLamKc0uklHwVk+a+OPmBGU5SrKry9ofcM9EWQ5u2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656930; c=relaxed/simple;
	bh=VmLdVtj8LdxkR81K0PdTErFmPSzEVPNzhcZOr7i7z0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucanGAV0V8DKo5FLDi0Uw06RtGgJQGxNB0+ApzknCcBucxMJ/oqN1SF+7KEjQV/mVEdSupWFq0R14fyYNyjN64b0PoZ7PVg6q5QOKKSSrJmc6hA8WEPtr3R9dKCkEYfCwfqk5uZQ/oP8gsJ2MyU0U8JHE2NwwKONJnIuJQ3yoi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOz2fZ0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOz2fZ0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF31F000E9;
	Tue, 21 Jul 2026 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656928;
	bh=GnMlFjka9EVcr9qcRPuM0Uy5JlO9rua6CnDqYoxbiU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOz2fZ0sKB/5ISG9ErUYWFXd4rpH/ScHQHP1i0yBnQ29bvh1N3uQ8pLQhFFZ+iGJi
	 wFXuhTf1qkNthxWrgpvVwDKV3uBY3MGUA/OOQpn/c54t8tO3WXObyvd7gG6euFneBw
	 w6cHE7BxtDK+qmMlN3Blf7JtxMG7EQrdPPWHTlf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0573/1611] eventpoll: rename epi->next and txlist for clarity
Date: Tue, 21 Jul 2026 17:11:29 +0200
Message-ID: <20260721152528.264415471@linuxfoundation.org>
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

[ Upstream commit f38567bb63ae029e3b63fcb99b6a2dcc6f421e69 ]

Two list-related names were confusing in isolation:

  struct epitem::next
    A singly-linked link slot used only when an epi is queued on
    ep->ovflist during an ep_start_scan/ep_done_scan window. The
    bare name "next" suggests a generic list link and doesn't say
    which list it belongs to.

  txlist
    The caller-local list_head used by ep_send_events() and
    __ep_eventpoll_poll() to hold the batch of items stolen from
    ep->rdllist for the current scan. "txlist" ("transmission
    list") is abbreviated and overloaded: it doesn't distinguish
    itself from ep->rdllist or ep->ovflist at a glance.

Rename for what each actually is:

  struct epitem::next   -> struct epitem::ovflist_next
  local txlist          -> scan_batch

With these in place:
  - epi->ovflist_next reads as "this is the ep->ovflist link slot",
    matching the rdllink pattern above it.
  - scan_batch reads as "the batch currently being scanned", clearly
    distinct from rdllist (canonical ready list) and ovflist
    (scan-window overflow).

ep->rdllist and ep->ovflist struct field names are preserved -- they
are long-standing interface-facing identifiers, and the new inline
helpers (ep_is_scanning, epi_on_ovflist, ...) already hide the
sentinel semantics at call sites.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260424-work-epoll-rework-v1-15-249ed00a20f3@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 62 ++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f2a09086f67f2f..43a89ae84f881d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -142,15 +142,15 @@
  *   NULL            - scan active, no spill yet.
  *   pointer to epi  - scan active with spilled items (LIFO).
  *
- * Encoded in epi->next:
+ * Encoded in epi->ovflist_next:
  *   EP_UNACTIVE_PTR - epi is not on ovflist.
  *   otherwise       - next epi on ovflist (NULL at tail).
  *
  * ep_start_scan() flips "not scanning" to "scanning" and splices
- * rdllist into a caller-local txlist. ep_done_scan() drains ovflist
+ * rdllist into a caller-local scan_batch. ep_done_scan() drains ovflist
  * back to rdllist (list_add head-insert reverses LIFO to FIFO),
  * flips back to "not scanning", and re-splices any items the caller
- * left in txlist (e.g., level-triggered re-queues).
+ * left in scan_batch (e.g., level-triggered re-queues).
  *
  *
  * Removal paths
@@ -261,14 +261,16 @@ struct epitem {
 		struct rcu_head rcu;
 	};
 
-	/* List header used to link this structure to the eventpoll ready list */
+	/* Link on the owning eventpoll's ready list (ep->rdllist). */
 	struct list_head rdllink;
 
 	/*
-	 * Works together "struct eventpoll"->ovflist in keeping the
-	 * single linked chain of items.
+	 * Link on the owning eventpoll's scan-overflow list (ep->ovflist),
+	 * EP_UNACTIVE_PTR when not linked. See epi_on_ovflist() /
+	 * epi_clear_ovflist() and the "Ready-list state machine" section
+	 * in the top-of-file banner.
 	 */
-	struct epitem *next;
+	struct epitem *ovflist_next;
 
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
@@ -535,13 +537,13 @@ static inline void ep_exit_scan(struct eventpoll *ep)
 /* True iff @epi is currently linked on its ep's ovflist. */
 static inline bool epi_on_ovflist(const struct epitem *epi)
 {
-	return epi->next != EP_UNACTIVE_PTR;
+	return epi->ovflist_next != EP_UNACTIVE_PTR;
 }
 
 /* Mark @epi as not on any ovflist (init and post-drain). */
 static inline void epi_clear_ovflist(struct epitem *epi)
 {
-	epi->next = EP_UNACTIVE_PTR;
+	epi->ovflist_next = EP_UNACTIVE_PTR;
 }
 
 /**
@@ -894,7 +896,7 @@ static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
  * ep->mutex needs to be held because we could be hit by
  * eventpoll_release_file() and epoll_ctl().
  */
-static void ep_start_scan(struct eventpoll *ep, struct list_head *txlist)
+static void ep_start_scan(struct eventpoll *ep, struct list_head *scan_batch)
 {
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -906,13 +908,13 @@ static void ep_start_scan(struct eventpoll *ep, struct list_head *txlist)
 	 */
 	lockdep_assert_irqs_enabled();
 	spin_lock_irq(&ep->lock);
-	list_splice_init(&ep->rdllist, txlist);
+	list_splice_init(&ep->rdllist, scan_batch);
 	ep_enter_scan(ep);
 	spin_unlock_irq(&ep->lock);
 }
 
 static void ep_done_scan(struct eventpoll *ep,
-			 struct list_head *txlist)
+			 struct list_head *scan_batch)
 {
 	struct epitem *epi, *nepi;
 
@@ -923,10 +925,10 @@ static void ep_done_scan(struct eventpoll *ep,
 	 * We re-insert them inside the main ready-list here.
 	 */
 	for (nepi = READ_ONCE(ep->ovflist); (epi = nepi) != NULL; ) {
-		nepi = epi->next;
+		nepi = epi->ovflist_next;
 		epi_clear_ovflist(epi);
 		/*
-		 * Skip items that the caller already returned via @txlist
+		 * Skip items that the caller already returned via @scan_batch
 		 * -- the list_splice() below takes care of those.
 		 */
 		if (!ep_is_linked(epi)) {
@@ -942,9 +944,9 @@ static void ep_done_scan(struct eventpoll *ep,
 	ep_exit_scan(ep);
 
 	/*
-	 * Quickly re-inject items left on "txlist".
+	 * Quickly re-inject items left on "scan_batch".
 	 */
-	list_splice(txlist, &ep->rdllist);
+	list_splice(scan_batch, &ep->rdllist);
 	__pm_relax(ep->ws);
 
 	if (!list_empty(&ep->rdllist)) {
@@ -1171,7 +1173,7 @@ static __poll_t ep_item_poll(const struct epitem *epi, poll_table *pt, int depth
 static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int depth)
 {
 	struct eventpoll *ep = file->private_data;
-	LIST_HEAD(txlist);
+	LIST_HEAD(scan_batch);
 	struct epitem *epi, *tmp;
 	poll_table pt;
 	__poll_t res = 0;
@@ -1186,8 +1188,8 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 	 * the ready list.
 	 */
 	mutex_lock_nested(&ep->mtx, depth);
-	ep_start_scan(ep, &txlist);
-	list_for_each_entry_safe(epi, tmp, &txlist, rdllink) {
+	ep_start_scan(ep, &scan_batch);
+	list_for_each_entry_safe(epi, tmp, &scan_batch, rdllink) {
 		if (ep_item_poll(epi, &pt, depth + 1)) {
 			res = EPOLLIN | EPOLLRDNORM;
 			break;
@@ -1201,7 +1203,7 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 			list_del_init(&epi->rdllink);
 		}
 	}
-	ep_done_scan(ep, &txlist);
+	ep_done_scan(ep, &scan_batch);
 	mutex_unlock(&ep->mtx);
 	return res;
 }
@@ -1459,7 +1461,7 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
 	 */
 	if (ep_is_scanning(ep)) {
 		if (!epi_on_ovflist(epi)) {
-			epi->next = READ_ONCE(ep->ovflist);
+			epi->ovflist_next = READ_ONCE(ep->ovflist);
 			WRITE_ONCE(ep->ovflist, epi);
 			ep_pm_stay_awake_rcu(epi);
 		}
@@ -1980,7 +1982,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
  * next slot), 0 if the re-poll reported no caller-requested events
  * (@epi drops out of the ready list; a future callback will re-add
  * it), or -EFAULT if copy_to_user() faulted (in which case @epi is
- * re-inserted at the head of @txlist so ep_done_scan() merges it
+ * re-inserted at the head of @scan_batch so ep_done_scan() merges it
  * back to rdllist for the next attempt).
  *
  * PM bookkeeping and level-triggered re-queue are handled here.
@@ -1989,7 +1991,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 static int ep_deliver_event(struct eventpoll *ep, struct epitem *epi,
 			    poll_table *pt,
 			    struct epoll_event __user **uevents,
-			    struct list_head *txlist)
+			    struct list_head *scan_batch)
 {
 	struct epoll_event __user *next;
 	struct wakeup_source *ws;
@@ -2027,7 +2029,7 @@ static int ep_deliver_event(struct eventpoll *ep, struct epitem *epi,
 		 * ep_done_scan() splices it onto rdllist for the next
 		 * attempt.
 		 */
-		list_add(&epi->rdllink, txlist);
+		list_add(&epi->rdllink, scan_batch);
 		ep_pm_stay_awake(epi);
 		return -EFAULT;
 	}
@@ -2053,7 +2055,7 @@ static int ep_send_events(struct eventpoll *ep,
 			  struct epoll_event __user *events, int maxevents)
 {
 	struct epitem *epi, *tmp;
-	LIST_HEAD(txlist);
+	LIST_HEAD(scan_batch);
 	poll_table pt;
 	int res = 0;
 
@@ -2068,19 +2070,19 @@ static int ep_send_events(struct eventpoll *ep,
 	init_poll_funcptr(&pt, NULL);
 
 	mutex_lock(&ep->mtx);
-	ep_start_scan(ep, &txlist);
+	ep_start_scan(ep, &scan_batch);
 
 	/*
 	 * We can loop without lock because we are passed a task-private
-	 * txlist; items cannot vanish while we hold ep->mtx.
+	 * scan_batch; items cannot vanish while we hold ep->mtx.
 	 */
-	list_for_each_entry_safe(epi, tmp, &txlist, rdllink) {
+	list_for_each_entry_safe(epi, tmp, &scan_batch, rdllink) {
 		int delivered;
 
 		if (res >= maxevents)
 			break;
 
-		delivered = ep_deliver_event(ep, epi, &pt, &events, &txlist);
+		delivered = ep_deliver_event(ep, epi, &pt, &events, &scan_batch);
 		if (delivered < 0) {
 			if (!res)
 				res = delivered;
@@ -2089,7 +2091,7 @@ static int ep_send_events(struct eventpoll *ep,
 		res += delivered;
 	}
 
-	ep_done_scan(ep, &txlist);
+	ep_done_scan(ep, &scan_batch);
 	mutex_unlock(&ep->mtx);
 
 	return res;
-- 
2.53.0



