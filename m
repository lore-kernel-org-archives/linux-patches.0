Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED533375D5;
	Tue, 21 Jul 2026 22:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674441; cv=none; b=eZ1dAusuqH9EVSRw6LxtrFpKJIMrbPO7YeMOWwdWxfIwA+Swb5RqHjGI25nz6rB6zvex2uzmWsJaBACVudNwbsPrz0NrWF6ok9tGE8rMi1MbtfOIbh02XUQ8qf+wTIDecWQDB5o6G+YeqeyOLoH+axDrETDbTgp2A6oabXHf9go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674441; c=relaxed/simple;
	bh=fefFSNlyz5HX3v8hC4GZDVyC+R0xhHDlwszxX+TdXsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXr92wvkKSSs/hracYcg9J0ov21kic6C+QgfYVcb7EYrqkoilT3rMpbzuuAHTtWCfE6vlg+iitLeHXJZlL/t8hmXfQg+rnqWCLipXj10ypsMvxv/1Eg5/vd+tEpEFspvCxrx1i/gXshcyT3nYv/6xr0nj6gfqRymgag98UCdApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PA5PQF9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PA5PQF9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B411F000E9;
	Tue, 21 Jul 2026 22:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674439;
	bh=vFHXFPrcwtwll1AHWAbeJ6SO0P/xrSa1dn3pK/Qrq0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PA5PQF9Vo/mJJmwBOr6fiIwz68wEnZkuQ8Y1ipozfi4DQpM+a1+zrUb8iuzwFXXd8
	 56g1LTOta26fUDoevVuPGmfmNtwYh0NbGDk/pkbTFZwlfBtIVY7gOvuSegKOsoHvrR
	 NApJPKxCXmt8C+VqwccVqiFtwLbYwZxbsiyFuAaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Keenan Dong <keenanat2000@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 540/699] rtmutex: Use waiter::task instead of current in remove_waiter()
Date: Tue, 21 Jul 2026 17:24:59 +0200
Message-ID: <20260721152407.880328402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keenan Dong <keenanat2000@gmail.com>

commit 3bfdc63936dd4773109b7b8c280c0f3b5ae7d349 upstream.

remove_waiter() is used by the slowlock paths, but it is also used for
proxy-lock rollback in rt_mutex_start_proxy_lock() when invoked from
futex_requeue().

In the latter case waiter::task is not current, but remove_waiter()
operates on current for the dequeue operation. That results in several
problems:

  1) the rbtree dequeue happens without waiter::task::pi_lock being held

  2) the waiter task's pi_blocked_on state is not cleared, which leaves a
     dangling pointer primed for UAF around.

  3) rt_mutex_adjust_prio_chain() operates on the wrong top priority waiter
     task

Use waiter::task instead of current in all related operations in
remove_waiter() to cure those problems.

[ tglx: Fixup rt_mutex_adjust_prio_chain(), add a comment and amend the
  	changelog ]

Fixes: 8161239a8bcc ("rtmutex: Simplify PI algorithm and make highest prio task get lock")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
(cherry picked from commit d8cce4773c2b23d819baf5abedc62f7b430e8745)
[Lee: Backported to linux-5.10.y from linux-6.1.y]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1061,20 +1061,23 @@ static void mark_wakeup_next_waiter(stru
  *
  * Must be called with lock->wait_lock held and interrupts disabled. I must
  * have just failed to try_to_take_rt_mutex().
+ *
+ * When invoked from rt_mutex_start_proxy_lock() waiter::task != current !
  */
 static void remove_waiter(struct rt_mutex *lock,
 			  struct rt_mutex_waiter *waiter)
 {
 	bool is_top_waiter = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
+	struct task_struct *waiter_task = waiter->task;
 	struct rt_mutex *next_lock;
 
 	lockdep_assert_held(&lock->wait_lock);
 
-	raw_spin_lock(&current->pi_lock);
+	raw_spin_lock(&waiter_task->pi_lock);
 	rt_mutex_dequeue(lock, waiter);
-	current->pi_blocked_on = NULL;
-	raw_spin_unlock(&current->pi_lock);
+	waiter_task->pi_blocked_on = NULL;
+	raw_spin_unlock(&waiter_task->pi_lock);
 
 	/*
 	 * Only update priority if the waiter was the highest priority
@@ -1110,7 +1113,7 @@ static void remove_waiter(struct rt_mute
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
-				   next_lock, NULL, current);
+				   next_lock, NULL, waiter_task);
 
 	raw_spin_lock_irq(&lock->wait_lock);
 }


