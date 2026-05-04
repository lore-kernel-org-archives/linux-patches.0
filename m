Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E63DEAD3;
	Mon,  4 May 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904795; cv=none; b=bZAxzUcxHuReCBmZ8FXxV4RxEc2nceKw12qmZiV49hBQSlzBuXHmVDqGxTtUDe3IR17larvLJYMa9kp8j54jya122jBe5BLZEtyU5IIO+HqBcXTKlZP9dj/f+5gODFJdfQDvxAZoGpUDZK4aIWh61p/yRIWSb26WWMFFa6QApYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904795; c=relaxed/simple;
	bh=jXWpQgccxca/1JZ37xyH/8yD+O8bejF4wc5nP7K9/xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9cixLHgJhtzySwarHfmGRxUU8s1+0nb5l8wk9PraaKWTs1ZIHhrT+XYFdZLAMtZQDuTEY5GXzXpCYssdsXn/cOKd/pdK+lg4XE/E9cFJMQqYFy4D7mISvz4OPX/2OaBS1pZUCtZDsF4h342j6zii2eRsq4fpcWTg8TfFdL5INE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaiwC2DK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaiwC2DK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309CEC2BCB8;
	Mon,  4 May 2026 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904795;
	bh=jXWpQgccxca/1JZ37xyH/8yD+O8bejF4wc5nP7K9/xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaiwC2DKaeeyee2rXWFPNzunkj72X7xMtiJPCKCDxJ3AZfiZVXK+nLcw7lVHbiras
	 3zWZTROfgGxjLe7l4N1ArNrzh1Gj8LnlsW+YahnyUzIp+ojT619+cIT1UjbJLzM5Zf
	 wnuhmH8FPlnvAuFUmHAsQOTzdGRQKKgDx8kF4uow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Keenan Dong <keenanat2000@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 170/215] rtmutex: Use waiter::task instead of current in remove_waiter()
Date: Mon,  4 May 2026 15:53:09 +0200
Message-ID: <20260504135136.394866572@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1531,20 +1531,23 @@ static bool rtmutex_spin_on_owner(struct
  *
  * Must be called with lock->wait_lock held and interrupts disabled. It must
  * have just failed to try_to_take_rt_mutex().
+ *
+ * When invoked from rt_mutex_start_proxy_lock() waiter::task != current !
  */
 static void __sched remove_waiter(struct rt_mutex_base *lock,
 				  struct rt_mutex_waiter *waiter)
 {
 	bool is_top_waiter = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
+	struct task_struct *waiter_task = waiter->task;
 	struct rt_mutex_base *next_lock;
 
 	lockdep_assert_held(&lock->wait_lock);
 
-	raw_spin_lock(&current->pi_lock);
-	rt_mutex_dequeue(lock, waiter);
-	current->pi_blocked_on = NULL;
-	raw_spin_unlock(&current->pi_lock);
+	scoped_guard(raw_spinlock, &waiter_task->pi_lock) {
+		rt_mutex_dequeue(lock, waiter);
+		waiter_task->pi_blocked_on = NULL;
+	}
 
 	/*
 	 * Only update priority if the waiter was the highest priority
@@ -1580,7 +1583,7 @@ static void __sched remove_waiter(struct
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
-				   next_lock, NULL, current);
+				   next_lock, NULL, waiter_task);
 
 	raw_spin_lock_irq(&lock->wait_lock);
 }


