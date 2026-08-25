Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755A847143A;
	Tue, 25 Aug 2026 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665378; cv=none; b=MJPJPnFn/OsE5N4HCoLwaWZyENx7zFj+nPJuH/UmWEnVKwB/uX6JqABuByx4JhG7/StxA1q3r44o16jHZtb2A4CZMDwKjGW8xC3pGhgZRaqUu3Ial0LBFidEWt6yRBvsf1yyxWBBhfV/Shj7K0knwHzzKM3zFQLHrQbELQzXeYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665378; c=relaxed/simple;
	bh=LQDqKodeRGajF6GVQWI84oADfnmpZ4Edq3bEe3AItC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkinNsBVNO0X0kDK02yWC9uR9TuC1Rr8DTh15esYh9QduTvlq0Bgg3aZpwQadCA/XTHaxy+BKHtOm10Ul3fCEMqxiR65uZ03FEFCQfgGICHeKwL1/HgMWZCYrXnjJy/JB4IWaQbjf+o/e09rhPC+ZkKZRmuYbEsDReqwZjqq2MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uwt6yfsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uwt6yfsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEDB1F000E9;
	Tue, 25 Aug 2026 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665377;
	bh=Kq4/yS7GuNFayy5hZNoxdgX/kbccwCdP9SozEKzyhng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uwt6yfsrMe+4IS6Nj/dlRw5XPt3sunYuSXfqlZLoBfOnhjOs7AdeUdyPCA8AgEM9U
	 0414BrM2rmF5G4qpJ033kepB5WUd5N5GfajQWpqkhr2Ii5WtaO1VqXdCd9RKcNpl+m
	 PmX/PBnvDZw0tzlhhnscp48hwWo7cOsUhSvYp89E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+350a93852ac854927f45@syzkaller.appspotmail.com,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 79/94] futex: Fix might_sleep() warning in futex_pivot_pending()
Date: Tue, 25 Aug 2026 15:26:15 +0200
Message-ID: <20260825132544.965702385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit d8aa5dd97944a72d4a9e3cc79bb80fcac7d6e829 upstream.

A younger me put a WARN in might_sleep() to warn about nested sleep loops. This
younger me also build a wait-loop variant that can deal with it. This wait-loop
variant doesn't have all the fancy wrappers, since it isn't used much. It also
lacks wait-bit support.

Add the wait-bit support and use it to fix the nested wait issue.

Fixes: 8e7ff730dd96 ("futex: Fix race in futex_pivot_pending() during private hash resize")
Reported-by: syzbot+350a93852ac854927f45@syzkaller.appspotmail.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260820074927.GH1246887@noisy.programming.kicks-ass.net
Closes: https://syzkaller.appspot.com/bug?extid=350a93852ac854927f45
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/wait.h     |    1 +
 include/linux/wait_bit.h |    1 +
 kernel/futex/core.c      |   27 ++++++++++++++++++++++++++-
 kernel/sched/wait.c      |   15 +++++++++++++++
 kernel/sched/wait_bit.c  |   14 +++++++++++---
 5 files changed, 54 insertions(+), 4 deletions(-)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1213,6 +1213,7 @@ long prepare_to_wait_event(struct wait_q
 void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
 int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
+int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
 #define DEFINE_WAIT_FUNC(name, function)					\
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -32,6 +32,7 @@ int out_of_line_wait_on_bit_timeout(unsi
 int out_of_line_wait_on_bit_lock(unsigned long *word, int, wait_bit_action_f *action, unsigned int mode);
 struct wait_queue_head *bit_waitqueue(unsigned long *word, int bit);
 extern void __init wait_bit_init(void);
+extern struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg);
 
 int wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -44,6 +44,7 @@
 #include <linux/prctl.h>
 #include <linux/mempolicy.h>
 #include <linux/mmap_lock.h>
+#include <linux/wait_bit.h>
 
 #include "futex.h"
 #include "../locking/rtmutex_common.h"
@@ -1866,11 +1867,35 @@ static int futex_hash_allocate(unsigned
 		futex_hash_bucket_init(&fph->queues[i], fph);
 
 	if (custom) {
+		struct wait_bit_queue_entry __wbq_entry;
+		struct wait_queue_head *__wq_head;
+
 		/*
 		 * Only let prctl() wait / retry; don't unduly delay clone().
 		 */
 again:
-		wait_var_event(mm, futex_pivot_pending(mm));
+		__wq_head = __var_waitqueue(mm);
+		init_wait_var_entry(&__wbq_entry, mm, 0);
+		__wbq_entry.wq_entry.func = woken_wake_bit_function;
+		add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
+
+		/*
+		 * add_wait_queue()		futex_ref_put()
+		 * MB (this)			MB (implied)
+		 * futex_pivot_pending()	wake_up_var()
+		 *                                waitqueue_active()
+		 *
+		 * Notably, it must not be possible to see
+		 * !futex_pivot_pending() && !waitqueue_active().
+		 */
+		smp_mb();
+
+		while (!futex_pivot_pending(mm) &&
+		       wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
+				  MAX_SCHEDULE_TIMEOUT))
+			/* empty */;
+
+		remove_wait_queue(__wq_head, &__wbq_entry.wq_entry);
 	}
 
 	scoped_guard(mutex, &mm->futex_hash_lock) {
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -5,6 +5,7 @@
  * (C) 2004 Nadia Yvette Chambers, Oracle
  */
 #include "sched.h"
+#include <linux/wait_bit.h>
 
 void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *key)
 {
@@ -463,3 +464,17 @@ int woken_wake_function(struct wait_queu
 	return default_wake_function(wq_entry, mode, sync, key);
 }
 EXPORT_SYMBOL(woken_wake_function);
+
+int woken_wake_bit_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *arg)
+{
+	struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
+	if (!key)
+		return 0;
+
+	/* Pairs with the smp_store_mb() in wait_woken(). */
+	smp_mb(); /* C */
+	wq_entry->flags |= WQ_FLAG_WOKEN;
+
+	return default_wake_function(wq_entry, mode, sync, key);
+}
+EXPORT_SYMBOL(woken_wake_bit_function);
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -167,9 +167,7 @@ wait_queue_head_t *__var_waitqueue(void
 }
 EXPORT_SYMBOL(__var_waitqueue);
 
-static int
-var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
-		  int sync, void *arg)
+struct wait_bit_key *__var_wake_key(struct wait_queue_entry *wq_entry, void *arg)
 {
 	struct wait_bit_key *key = arg;
 	struct wait_bit_queue_entry *wbq_entry =
@@ -177,6 +175,16 @@ var_wake_function(struct wait_queue_entr
 
 	if (wbq_entry->key.flags != key->flags ||
 	    wbq_entry->key.bit_nr != key->bit_nr)
+		return NULL;
+
+	return key;
+}
+
+static int var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
+			     int sync, void *arg)
+{
+	struct wait_bit_key *key = __var_wake_key(wq_entry, arg);
+	if (!key)
 		return 0;
 
 	return autoremove_wake_function(wq_entry, mode, sync, key);


