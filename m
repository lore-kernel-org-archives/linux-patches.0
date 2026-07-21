Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CD246EC91;
	Tue, 21 Jul 2026 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656932; cv=none; b=bg5KRFpivuhA8zxHarp9CKj91uQtoVGREM/GSh8T99AVEBqeiN+RCy2QVR7CelSwEoAlbHpYLr7EIkqa/hVPVCQYRn6jsLDoa9cBQS4eSZrRIulQyyxgtMGPIJfCI0hcPdHCZrBKpsWy10+b77jqkcLKJbh9VeewtIUCqzBW2q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656932; c=relaxed/simple;
	bh=Mepk+ZEd2GtzsRM3ONsSmTOdBmSBYJ781IiSeEPzdVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw4EMMsCOv8QuBUGyKSd9QLcsv7usL7T8wZEoS2irQ5dmID4W06bdMkdcTq4mBxY9ttr4xZrPdRMsi+6FYZ50s6i4B5atqnO1TQZLs7699BVo8OP7IcIjY44O8i+ec7H0fzOZR1u+OoLjcnESUOmIGR2Neh3Yfjg4xZKgsOLRCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1D1sS4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1D1sS4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153B21F000E9;
	Tue, 21 Jul 2026 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656931;
	bh=bmUC1UsAQtlg4WxDWKR4BXCT8pwhfSkDbbWr0/OW8vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1D1sS4yuu0YnCUuHZiSPALI2IdikXpxdiMnXqyMj6/pvXH3z31gA/19WDz3/f68R
	 FXICRzmtTwNJ7CSNMBtuz4H0jwE/C4nDBSqHU2X4LA1OkiNj6MJpvtNi8XTUVXCw2/
	 /B7ycTwWgpQ3vJeAZk0CllIGp/VikOqAQ3Omr2ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Nam Cao <namcao@linutronix.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0574/1611] eventpoll: Fix epoll_wait() report false negative
Date: Tue, 21 Jul 2026 17:11:30 +0200
Message-ID: <20260721152528.286946427@linuxfoundation.org>
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
index 43a89ae84f881d..1c31ee84dbe592 100644
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
@@ -908,8 +915,12 @@ static void ep_start_scan(struct eventpoll *ep, struct list_head *scan_batch)
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
 
@@ -940,6 +951,9 @@ static void ep_done_scan(struct eventpoll *ep,
 			ep_pm_stay_awake(epi);
 		}
 	}
+
+	write_seqcount_begin(&ep->seq);
+
 	/* Back out of scan mode; callbacks target ep->rdllist again. */
 	ep_exit_scan(ep);
 
@@ -947,6 +961,9 @@ static void ep_done_scan(struct eventpoll *ep,
 	 * Quickly re-inject items left on "scan_batch".
 	 */
 	list_splice(scan_batch, &ep->rdllist);
+
+	write_seqcount_end(&ep->seq);
+
 	__pm_relax(ep->ws);
 
 	if (!list_empty(&ep->rdllist)) {
@@ -1331,6 +1348,7 @@ static int ep_alloc(struct eventpoll **pep)
 
 	mutex_init(&ep->mtx);
 	spin_lock_init(&ep->lock);
+	seqcount_spinlock_init(&ep->seq, &ep->lock);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
-- 
2.53.0



