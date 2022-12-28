Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8992A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BCDC433F0;
	Wed, 28 Dec 2022 14:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239140;
	bh=Q+y8zfkE5LlwwWBG4QK6ErHAQ+c8JfDt/6uVSPdlxsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixyRTmOYMQk6/4/3jfHeAE3c+0DQe7xSDus5dtYB7289mny+dQsmB5QuoyiFekPHo
	 Ji4tTh66KQ/MtAruj2x1MQ+Wh77eUH3mAfyh4Ic/5bVHXeVcMl8gqYPft3rAUtcY04
	 pqun82uYDoaCOTShsqvd8r7+fgj3zH+lbeQwWlIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Izbyshev <izbyshev@ispras.ru>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/731] futex: Resend potentially swallowed owner death notification
Date: Wed, 28 Dec 2022 15:33:44 +0100
Message-Id: <20221228144259.944302153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Izbyshev <izbyshev@ispras.ru>

[ Upstream commit 90d758896787048fa3d4209309d4800f3920e66f ]

Commit ca16d5bee598 ("futex: Prevent robust futex exit race") addressed
two cases when tasks waiting on a robust non-PI futex remained blocked
despite the futex not being owned anymore:

* if the owner died after writing zero to the futex word, but before
  waking up a waiter

* if a task waiting on the futex was woken up, but died before updating
  the futex word (effectively swallowing the notification without acting
  on it)

In the second case, the task could be woken up either by the previous
owner (after the futex word was reset to zero) or by the kernel (after
the OWNER_DIED bit was set and the TID part of the futex word was reset
to zero) if the previous owner died without the resetting the futex.

Because the referenced commit wakes up a potential waiter only if the
whole futex word is zero, the latter subcase remains unaddressed.

Fix this by looking only at the TID part of the futex when deciding
whether a wake up is needed.

Fixes: ca16d5bee598 ("futex: Prevent robust futex exit race")
Signed-off-by: Alexey Izbyshev <izbyshev@ispras.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221111215439.248185-1-izbyshev@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index f9bc9aa0ce1e..764e73622b38 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -3632,6 +3632,7 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 			      bool pi, bool pending_op)
 {
 	u32 uval, nval, mval;
+	pid_t owner;
 	int err;
 
 	/* Futex address must be 32bit aligned */
@@ -3653,6 +3654,10 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 	 * 2. A woken up waiter is killed before it can acquire the
 	 *    futex in user space.
 	 *
+	 * In the second case, the wake up notification could be generated
+	 * by the unlock path in user space after setting the futex value
+	 * to zero or by the kernel after setting the OWNER_DIED bit below.
+	 *
 	 * In both cases the TID validation below prevents a wakeup of
 	 * potential waiters which can cause these waiters to block
 	 * forever.
@@ -3661,24 +3666,27 @@ static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
 	 *
 	 *	1) task->robust_list->list_op_pending != NULL
 	 *	   @pending_op == true
-	 *	2) User space futex value == 0
+	 *	2) The owner part of user space futex value == 0
 	 *	3) Regular futex: @pi == false
 	 *
 	 * If these conditions are met, it is safe to attempt waking up a
 	 * potential waiter without touching the user space futex value and
-	 * trying to set the OWNER_DIED bit. The user space futex value is
-	 * uncontended and the rest of the user space mutex state is
-	 * consistent, so a woken waiter will just take over the
-	 * uncontended futex. Setting the OWNER_DIED bit would create
-	 * inconsistent state and malfunction of the user space owner died
-	 * handling.
+	 * trying to set the OWNER_DIED bit. If the futex value is zero,
+	 * the rest of the user space mutex state is consistent, so a woken
+	 * waiter will just take over the uncontended futex. Setting the
+	 * OWNER_DIED bit would create inconsistent state and malfunction
+	 * of the user space owner died handling. Otherwise, the OWNER_DIED
+	 * bit is already set, and the woken waiter is expected to deal with
+	 * this.
 	 */
-	if (pending_op && !pi && !uval) {
+	owner = uval & FUTEX_TID_MASK;
+
+	if (pending_op && !pi && !owner) {
 		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
 		return 0;
 	}
 
-	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(curr))
+	if (owner != task_pid_vnr(curr))
 		return 0;
 
 	/*
-- 
2.35.1



