Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04AA415F0E;
	Tue, 21 Jul 2026 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662356; cv=none; b=qxiOQg+NaGNDhpJ7bHyZUiYCZBEyG04H82xhk+me0cwsiVxnKk3ync52R0x7E/pF5AK3NLKOIHbJ8lqZrGN5seEM8eoP4SuFWT1gCnpSboFsYLeFMTd5TdiQqpEAyeVMJLgiMg91xeZOx6aGAQ8h/NJlrdeUxjVv99e8tlfSz40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662356; c=relaxed/simple;
	bh=c2+qd1JvZzy+cRm6Bvg9rx6suffqKwCumnC4g6vNPAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILBYug06R45PABPS/WQpiXk0utEpyAIlGzdHOomoSSgu0T+zuLo5vG1Ls9weg44sPxQYPMYI0KelCvElWnDcsUzUdvors9VCEyIEF8efEr4aGSy1TYrk8XYgr4bJ4/aQCdNV9lcUk2LCf6zwBhz+rKkpE3iTxOv9eRgy/jrrdvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4JUrgGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4JUrgGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2181F00ADB;
	Tue, 21 Jul 2026 19:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662354;
	bh=yeT6vI2aIE0IlKJicNlLPSm/7BJFpFazMFkMACRGw38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4JUrgGDyWtjhF24Wy+Kanw0anBmDnahrhEk6og9nWl7gb9ux5VedPFsAHUCEb9+K
	 N3+AlZ9pZDYt5IBtQkED0gQtUdkVdJvVSGzgA1opRwfiPhDuQZmEET4SESFiS4vVEP
	 I3x4lpsCvPec6OfpNxeSzBowQ+rGWMGuZ1HPt6XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0411/1276] eventpoll: Fix epoll_wait() report false negative
Date: Tue, 21 Jul 2026 17:14:14 +0200
Message-ID: <20260721152455.293252569@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 0c4aefe3c2d0f272a2ad73699a12d4446ffdbe7b ]

ep_events_available() checks for available events by looking at
ep->rdllist and ep_is_scanning(). However, this is done without a lock
and can report false negative if ep_start_scan() or ep_done_scan() are
executed by another task concurrently. For example:
_________________________________________________________________________
                                   |ep_start_scan()
                                   |  list_splice_init(&ep->rdllist, ...)
ep_events_available()              |
  !list_empty_careful(&ep->rdllist)|
  || ep_is_scanning(ep)            |
	                           |  ep_enter_scan(ep)
___________________________________|_____________________________________

Another example:
_________________________________________________________________________
ep_events_available()              |
                                   |ep_start_scan()
                                   |  list_splice_init(&ep->rdllist, ...)
	                           |  ep_enter_scan(ep)
  !list_empty_careful(&ep->rdllist)|
                                   |ep_done_scan()
                                   |  ep_exit_scan(ep)
                                   |  list_splice(..., &ep->rdllist)
  || ep_is_scanning(ep)            |
___________________________________|_____________________________________

In the above examples, ep_events_available() sees no event despite
events being available. In case epoll_wait() is called with timeout=0,
epoll_wait() will wrongly return "no event" to user.

Introduce a sequence lock to resolve this issue.

Measuring the time consumption of 10 million loop iterations doing
epoll_wait(), the following performance drop is observed:

   timeout  #event  before    after    diff
     0ms      0     3727ms   3974ms   +6.6%
     0ms      1     8099ms   9134ms    +13%
     1ms      1    13525ms  13586ms  +0.45%

Considering the use case of epoll_wait() (wait for events, do something
with the events, repeat), it should only contribute to a small portion of
user's CPU consumption. Therefore this performance drop is not alarming.

Fixes: c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/4363cd8e34a21d4f0d257be1b33e84dc25030fdf.1780422138.git.namcao@linutronix.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 855dd357edd0ee..5a19edda2b7777 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -38,6 +38,7 @@
 #include <linux/compat.h>
 #include <linux/rculist.h>
 #include <linux/capability.h>
+#include <linux/seqlock.h>
 #include <net/busy_poll.h>
 
 /*
@@ -324,6 +325,9 @@ struct eventpoll {
 	/* Lock which protects rdllist and ovflist */
 	spinlock_t lock;
 
+	/* Protect switching between rdllist and ovflist */
+	seqcount_spinlock_t seq;
+
 	/* RB tree root used to store monitored fd structs */
 	struct rb_root_cached rbr;
 
@@ -556,7 +560,10 @@ static inline void epi_clear_ovflist(struct epitem *epi)
  */
 static inline int ep_events_available(struct eventpoll *ep)
 {
-	return !list_empty_careful(&ep->rdllist) || ep_is_scanning(ep);
+	unsigned int seq = read_seqcount_begin(&ep->seq);
+
+	return !list_empty_careful(&ep->rdllist) || ep_is_scanning(ep) ||
+		read_seqcount_retry(&ep->seq, seq);
 }
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
@@ -880,8 +887,12 @@ static void ep_start_scan(struct eventpoll *ep, struct list_head *scan_batch)
 	 */
 	lockdep_assert_irqs_enabled();
 	spin_lock_irq(&ep->lock);
+	write_seqcount_begin(&ep->seq);
+
 	list_splice_init(&ep->rdllist, scan_batch);
 	ep_enter_scan(ep);
+
+	write_seqcount_end(&ep->seq);
 	spin_unlock_irq(&ep->lock);
 }
 
@@ -912,6 +923,9 @@ static void ep_done_scan(struct eventpoll *ep,
 			ep_pm_stay_awake(epi);
 		}
 	}
+
+	write_seqcount_begin(&ep->seq);
+
 	/* Back out of scan mode; callbacks target ep->rdllist again. */
 	ep_exit_scan(ep);
 
@@ -919,6 +933,9 @@ static void ep_done_scan(struct eventpoll *ep,
 	 * Quickly re-inject items left on "scan_batch".
 	 */
 	list_splice(scan_batch, &ep->rdllist);
+
+	write_seqcount_end(&ep->seq);
+
 	__pm_relax(ep->ws);
 
 	if (!list_empty(&ep->rdllist)) {
@@ -1302,6 +1319,7 @@ static int ep_alloc(struct eventpoll **pep)
 
 	mutex_init(&ep->mtx);
 	spin_lock_init(&ep->lock);
+	seqcount_spinlock_init(&ep->seq, &ep->lock);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
-- 
2.53.0



