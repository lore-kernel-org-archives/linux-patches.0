Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68D35A3AD;
	Mon,  4 May 2026 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903637; cv=none; b=F+dWI1sc2tgnOCJK9bHKoW6GJ89ELx9BTJwaBGo3LtMt9xQNeMLA6DGhDqkPA5XrDmMXL0nOuGePIacM/yeugs6ler37MHBv/6k4NnTHVwYwVj2T1ige8sYyBCDLOF1D3NQn8nUfg9/q4rz1Fk0XObJIM/V6IIBx2TzM7LJSL1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903637; c=relaxed/simple;
	bh=CfQckcrVFMyyDitjyj3XAUxNw/SCQuiapWo+WhoAtus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQn9SsV1No/zUelVt+q3ujqVX9Mg1C8gtm7QleneUbLjo5rNlsV0bVofxPMxAlJmry7l8waMY0LO8OISEMA6A1XzYRvAqh39objcqo3jBTd+e76thJDSy1X0AzWCslLUnzAXoON1CguGqjw44pLRIlxA9Xj+RxusNLYUn1wV3Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEfx8ejv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEfx8ejv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F7AC2BCB8;
	Mon,  4 May 2026 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903636;
	bh=CfQckcrVFMyyDitjyj3XAUxNw/SCQuiapWo+WhoAtus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEfx8ejvpC2bjKOpklF0W+i9FWtC+FyM/ouUYtogaTObGhNt/n+Bwrf7oLtKDFzCN
	 KAoalWyqXmmDzdNFIxbq7Vq4c5MHiAmQQqbUabBs/k3oCsER6OLtTEcXR+vL3s8ICj
	 FIR0MCbFW/SBeLmsoTD8sFRKq0yjqREMQb4j8lrU=
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
Subject: [PATCH 7.0 280/307] rtmutex: Use waiter::task instead of current in remove_waiter()
Date: Mon,  4 May 2026 15:52:45 +0200
Message-ID: <20260504135153.328066978@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1535,20 +1535,23 @@ static bool rtmutex_spin_on_owner(struct
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
@@ -1584,7 +1587,7 @@ static void __sched remove_waiter(struct
 	raw_spin_unlock_irq(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
-				   next_lock, NULL, current);
+				   next_lock, NULL, waiter_task);
 
 	raw_spin_lock_irq(&lock->wait_lock);
 }


