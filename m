Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84DD356A12;
	Tue, 21 Jul 2026 19:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662349; cv=none; b=vEqmNjn/CEFuzBu5+7KhOp4Bbr8z4gxVCrCt8aANW1/BYY2I0HjkkhFqJi/MJYFERQIm7cvXmR4qJ7STApxQzYhHHf1r668zeHH2eyl3bjIiMF2Av1RmVjwa0kSeM4rWEjB0zAAJa2M+bKtMh1mKUt1oYgt3BOvVf2hjr8U3XwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662349; c=relaxed/simple;
	bh=VUlEURIyAd6BK1mvRT7k7oxbs/Aa1JWFTrjNgOOh0Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL9zSEZdTemv1fx8+aGvEsOF3TddyIGMa/bzlZ1l4Rw2NvxaDrAgKZ8IYurG+8+wkxj/q3FJE8X+CihwcTVVvrm4rTPlXvNW52IVlDwFBkFVHRk3SF2WUtmP+KgyGnGF6BaZ5e9qTc9bOSGXWq8a+CSkmLH2ieTV/XlyRdce+40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x13IqfhA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x13IqfhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB9D1F000E9;
	Tue, 21 Jul 2026 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662346;
	bh=IDQ+NEOqdT/kEeLX4eWVkcFeaIxifFM35F68ZOLAyso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x13IqfhACLHfqA1t1gys0JJDfrgtLuDL+DVuOZnUbYRW6n4dS5SI7ZC5P8V810bYj
	 bDTjtv8qYuz2wX4EtBJ6cqBdH07m4KhnewNx6XtMPYIPRCV/TNE4azzozum9FWgoAq
	 QXJlNjZw3uPu4dYOwWm8PRTHgH78dWWugbRKvNwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0408/1276] eventpoll: extract ep_deliver_event() from ep_send_events()
Date: Tue, 21 Jul 2026 17:14:11 +0200
Message-ID: <20260721152455.228341063@linuxfoundation.org>
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

[ Upstream commit 499a5e7f4a57fa08a297c627d007a55069acac9a ]

ep_send_events()'s body covered two concerns: per-item work (PM
wakeup-source bookkeeping, re-poll, copy_to_user, level-trigger
re-queue, EPOLLONESHOT mask clear) and the scan-level accumulator
(maxevents cap, EFAULT preservation, txlist/rdllist splice).

Extract the per-item work as ep_deliver_event(), which returns a
tri-state int:

  1       one event was delivered; caller advances the counter,
  0       re-poll produced no caller-requested events (item drops
          out of the ready list; a future callback will re-queue),
 -EFAULT  copy_to_user() faulted; item is already re-inserted at
          the head of the txlist so ep_done_scan() splices it back
          to rdllist.

The per-item comments (PM ordering, the "sole writer to rdllist"
invariant for the LT re-queue, the EFAULT semantics) move into
ep_deliver_event(). ep_send_events() reduces to the fatal-signal
short-circuit, scan bracket, and a short txlist walk that accumulates
the deliveries and preserves the "first error wins" EFAULT contract
(res = delivered only if no event was previously delivered; otherwise
the success count is returned and -EFAULT is reported on the next
call).

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260424-work-epoll-rework-v1-12-249ed00a20f3@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 138 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 84 insertions(+), 54 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 5954acefa927c0..5b4f4c1c04306b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1913,6 +1913,82 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi,
 	return 0;
 }
 
+/*
+ * Attempt to deliver one event for @epi into @*uevents.
+ *
+ * Returns 1 if an event was delivered (with *uevents advanced to the
+ * next slot), 0 if the re-poll reported no caller-requested events
+ * (@epi drops out of the ready list; a future callback will re-add
+ * it), or -EFAULT if copy_to_user() faulted (in which case @epi is
+ * re-inserted at the head of @txlist so ep_done_scan() merges it
+ * back to rdllist for the next attempt).
+ *
+ * PM bookkeeping and level-triggered re-queue are handled here.
+ * Caller holds ep->mtx and the scan is active.
+ */
+static int ep_deliver_event(struct eventpoll *ep, struct epitem *epi,
+			    poll_table *pt,
+			    struct epoll_event __user **uevents,
+			    struct list_head *txlist)
+{
+	struct epoll_event __user *next;
+	struct wakeup_source *ws;
+	__poll_t revents;
+
+	/*
+	 * Activate ep->ws before deactivating epi->ws to prevent
+	 * triggering auto-suspend here (in case we reactivate epi->ws
+	 * below).  Rearranging to delay the deactivation would let
+	 * epi->ws drift out of sync with ep_is_linked().
+	 */
+	ws = ep_wakeup_source(epi);
+	if (ws) {
+		if (ws->active)
+			__pm_stay_awake(ep->ws);
+		__pm_relax(ws);
+	}
+
+	list_del_init(&epi->rdllink);
+
+	/*
+	 * Re-poll under ep->mtx so userspace cannot change the item
+	 * out from under us. If no caller-requested events remain,
+	 * @epi stays off the ready list; the poll callback will
+	 * re-queue it when events next appear.
+	 */
+	revents = ep_item_poll(epi, pt, 1);
+	if (!revents)
+		return 0;
+
+	next = epoll_put_uevent(revents, epi->event.data, *uevents);
+	if (!next) {
+		/*
+		 * copy_to_user() faulted: put the item back so
+		 * ep_done_scan() splices it onto rdllist for the next
+		 * attempt.
+		 */
+		list_add(&epi->rdllink, txlist);
+		ep_pm_stay_awake(epi);
+		return -EFAULT;
+	}
+	*uevents = next;
+
+	if (epi->event.events & EPOLLONESHOT) {
+		epi->event.events &= EP_PRIVATE_BITS;
+	} else if (!(epi->event.events & EPOLLET)) {
+		/*
+		 * Level-triggered: re-queue so the next epoll_wait()
+		 * rechecks availability. We are the sole writer to
+		 * rdllist here -- epoll_ctl() callers are locked out
+		 * by ep->mtx, and the poll callback queues to ovflist
+		 * during scans.
+		 */
+		list_add_tail(&epi->rdllink, &ep->rdllist);
+		ep_pm_stay_awake(epi);
+	}
+	return 1;
+}
+
 static int ep_send_events(struct eventpoll *ep,
 			  struct epoll_event __user *events, int maxevents)
 {
@@ -1935,70 +2011,24 @@ static int ep_send_events(struct eventpoll *ep,
 	ep_start_scan(ep, &txlist);
 
 	/*
-	 * We can loop without lock because we are passed a task private list.
-	 * Items cannot vanish during the loop we are holding ep->mtx.
+	 * We can loop without lock because we are passed a task-private
+	 * txlist; items cannot vanish while we hold ep->mtx.
 	 */
 	list_for_each_entry_safe(epi, tmp, &txlist, rdllink) {
-		struct wakeup_source *ws;
-		__poll_t revents;
+		int delivered;
 
 		if (res >= maxevents)
 			break;
 
-		/*
-		 * Activate ep->ws before deactivating epi->ws to prevent
-		 * triggering auto-suspend here (in case we reactive epi->ws
-		 * below).
-		 *
-		 * This could be rearranged to delay the deactivation of epi->ws
-		 * instead, but then epi->ws would temporarily be out of sync
-		 * with ep_is_linked().
-		 */
-		ws = ep_wakeup_source(epi);
-		if (ws) {
-			if (ws->active)
-				__pm_stay_awake(ep->ws);
-			__pm_relax(ws);
-		}
-
-		list_del_init(&epi->rdllink);
-
-		/*
-		 * If the event mask intersect the caller-requested one,
-		 * deliver the event to userspace. Again, we are holding ep->mtx,
-		 * so no operations coming from userspace can change the item.
-		 */
-		revents = ep_item_poll(epi, &pt, 1);
-		if (!revents)
-			continue;
-
-		events = epoll_put_uevent(revents, epi->event.data, events);
-		if (!events) {
-			list_add(&epi->rdllink, &txlist);
-			ep_pm_stay_awake(epi);
+		delivered = ep_deliver_event(ep, epi, &pt, &events, &txlist);
+		if (delivered < 0) {
 			if (!res)
-				res = -EFAULT;
+				res = delivered;
 			break;
 		}
-		res++;
-		if (epi->event.events & EPOLLONESHOT)
-			epi->event.events &= EP_PRIVATE_BITS;
-		else if (!(epi->event.events & EPOLLET)) {
-			/*
-			 * If this file has been added with Level
-			 * Trigger mode, we need to insert back inside
-			 * the ready list, so that the next call to
-			 * epoll_wait() will check again the events
-			 * availability. At this point, no one can insert
-			 * into ep->rdllist besides us. The epoll_ctl()
-			 * callers are locked out by
-			 * ep_send_events() holding "mtx" and the
-			 * poll callback will queue them in ep->ovflist.
-			 */
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-			ep_pm_stay_awake(epi);
-		}
+		res += delivered;
 	}
+
 	ep_done_scan(ep, &txlist);
 	mutex_unlock(&ep->mtx);
 
-- 
2.53.0



