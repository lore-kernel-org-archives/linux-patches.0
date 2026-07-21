Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441A46D57C;
	Tue, 21 Jul 2026 18:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659097; cv=none; b=N7F1Sr6ElftppZNZboEtVq8fUKxQeCFrT27701XDMNLWuqRuzWmoatwWhYX7XFwUxRhNIctduB//8jcYxoYAFbTgSy20L9tW3nqg0MxZsyWcmROwBzBjXZXYzZBxq+XOTrgUi4JLa9G7hLCdihV3OQ3ZAdwz4UgC7UJlNGi4FNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659097; c=relaxed/simple;
	bh=uxfV/hvoQtv2lLb+YkdMcZGQJoCfTCCAl0SDNJ70qOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEcjrSjZcMqRNCSempC7ROd765dIImFmEBct5wL6yk9Y6dGDYhkDJbnnREQttXni3s2PlTSdpfQGvOZJIqtdHthbcSVATiSS4UE5bgTeI2PY6izXZzeblhg6cJ30MuMwK1FgELwAcpFZUOvA7ldPOPW5JjDtW8dkriQYLFk5jsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkmMJ4jt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkmMJ4jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F72C1F000E9;
	Tue, 21 Jul 2026 18:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659086;
	bh=wvJnj0Nu+vvOdj5hxyk31s35opsD2HCq43iwPxsmK4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkmMJ4jtnJcZUGGRaV7AZIFNWLjR7h0V6n7QlRyn1sWocNOh9L2OLIQ8kyvuxegCA
	 vmu+KDeXbIYsCoF4gLIRKKNPJ0avXxdL17CQb1MVKWE5WYgGVYr5qQNYyANq5HDqfg
	 4+pIusC7L3I2bYeL4K/rpBNLT+yJevdcQ3cDoDPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XIAO WU <xiaowu.417@qq.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 1386/1611] tracing/user_events: Fix use-after-free in user_event_mm_dup()
Date: Tue, 21 Jul 2026 17:25:02 +0200
Message-ID: <20260721152546.616829845@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 50fd6dd755c6e48a38af2fa4621167eea56829c2 upstream.

user_event_mm_dup() walks the parent mm's enabler list locklessly under
rcu_read_lock() during fork() (from copy_process()); it does not take
event_mutex:

	rcu_read_lock();
	list_for_each_entry_rcu(enabler, &old_mm->enablers, mm_enablers_link)
		enabler->event = user_event_get(orig->event);

user_event_enabler_destroy() removes an enabler from that list with
list_del_rcu() and then, without waiting for a grace period, drops the
enabler's user_event reference with user_event_put() and frees the enabler
with kfree(). A reader that loaded the enabler before the list_del_rcu()
can still be walking it, which leads to two use-after-frees:

 - kfree(enabler) frees the enabler while that reader dereferences
   enabler->event.

 - user_event_put() may drop the last reference to the user_event, which
   is then freed (via delayed_destroy_user_event() on a work queue), while
   the same reader does user_event_get(orig->event) on it.

Both are reachable by an unprivileged task that can open user_events_data:
one multithreaded process that registers an enabler and then concurrently
unregisters it and calls fork() triggers the race. KASAN reports a
slab-use-after-free in user_event_mm_dup() during clone(), with a
"refcount_t: addition on 0" warning when the user_event is freed.

The enabler use-after-free was found first; the user_event one was reported
by XIAO WU, and the earlier enabler-only fix did not address it.

Defer both the user_event_put() and the kfree(enabler) to a work item
queued with queue_rcu_work(), so they run only after an RCU grace period,
once all readers walking the enabler list have finished. The put must run
in process context because user_event_put() takes event_mutex on the last
reference, so a work queue is used rather than call_rcu(). The now-unlocked
put lets the locked argument of user_event_enabler_destroy() be removed;
all callers are updated.

Fixes: 7235759084a4 ("tracing/user_events: Use remote writes for event enablement")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260707165912.2560537-2-michael.bommarito@gmail.com
Reported-by: XIAO WU <xiaowu.417@qq.com>
Closes: https://lore.kernel.org/all/tencent_89647CE40DC452B891C65C94D1B271DE8E07@qq.com/
Suggested-by: Beau Belgrave <beaub@linux.microsoft.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_user.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -109,6 +109,9 @@ struct user_event_enabler {
 
 	/* Track enable bit, flags, etc. Aligned for bitops. */
 	unsigned long		values;
+
+	/* Defer the event put and enabler free past an RCU grace period. */
+	struct rcu_work		put_rwork;
 };
 
 /* Bits 0-5 are for the bit to update upon enable/disable (0-63 allowed) */
@@ -396,17 +399,39 @@ error:
 	return NULL;
 };
 
-static void user_event_enabler_destroy(struct user_event_enabler *enabler,
-				       bool locked)
+static void delayed_user_event_enabler_put(struct work_struct *work)
 {
-	list_del_rcu(&enabler->mm_enablers_link);
+	struct user_event_enabler *enabler = container_of(to_rcu_work(work),
+			struct user_event_enabler, put_rwork);
 
 	/* No longer tracking the event via the enabler */
-	user_event_put(enabler->event, locked);
+	user_event_put(enabler->event, false);
 
+	/* Run from queue_rcu_work(), the RCU grace period has elapsed */
 	kfree(enabler);
 }
 
+static void user_event_enabler_destroy(struct user_event_enabler *enabler)
+{
+	list_del_rcu(&enabler->mm_enablers_link);
+
+	/*
+	 * The enabler is removed from an RCU-traversed list
+	 * (user_event_mm_dup() walks mm->enablers under rcu_read_lock() only),
+	 * and readers there dereference enabler->event and take a new ref on
+	 * it. Both the put of that event reference and the free of the enabler
+	 * therefore have to wait for a grace period so no reader can be looking
+	 * at the enabler or racing the last put of its event.
+	 *
+	 * The put itself must not run in RCU context: when it drops the last
+	 * reference user_event_put() takes event_mutex, which cannot be taken
+	 * from a softirq/RCU callback. Defer both to a work item scheduled
+	 * after a grace period via queue_rcu_work().
+	 */
+	INIT_RCU_WORK(&enabler->put_rwork, delayed_user_event_enabler_put);
+	queue_rcu_work(system_percpu_wq, &enabler->put_rwork);
+}
+
 static int user_event_mm_fault_in(struct user_event_mm *mm, unsigned long uaddr,
 				  int attempt)
 {
@@ -464,7 +489,7 @@ static void user_event_enabler_fault_fix
 
 	/* User asked for enabler to be removed during fault */
 	if (test_bit(ENABLE_VAL_FREEING_BIT, ENABLE_BITOPS(enabler))) {
-		user_event_enabler_destroy(enabler, true);
+		user_event_enabler_destroy(enabler);
 		goto out;
 	}
 
@@ -764,7 +789,7 @@ static void user_event_mm_destroy(struct
 	struct user_event_enabler *enabler, *next;
 
 	list_for_each_entry_safe(enabler, next, &mm->enablers, mm_enablers_link)
-		user_event_enabler_destroy(enabler, false);
+		user_event_enabler_destroy(enabler);
 
 	mmdrop(mm->mm);
 	kfree(mm);
@@ -2655,7 +2680,7 @@ static long user_events_ioctl_unreg(unsi
 			flags |= enabler->values & ENABLE_VAL_COMPAT_MASK;
 
 			if (!test_bit(ENABLE_VAL_FAULTING_BIT, ENABLE_BITOPS(enabler)))
-				user_event_enabler_destroy(enabler, true);
+				user_event_enabler_destroy(enabler);
 
 			/* Removed at least one */
 			ret = 0;


