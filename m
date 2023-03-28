Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A698BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4280C433D2;
	Tue, 28 Mar 2023 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015580;
	bh=80Mseo0q45mvjqk1imPxIxXna6YySEIBIg0bNuP8Ek0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FggGc3T+oV33um4YlkzgGv2xcssnKShNATVKVwlptmtW5HPtbGoWMuMivdzXP4ua4
	 d2LshyXQ8tS9bieisMIypZhnJDg9e4mY+Zdgwenia3XwDa0jZxBYYJ9Z0kczEuglFt
	 rKS02AdACUloq31Z0wQxea481hKo6NjF22D4DPuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/224] entry/rcu: Check TIF_RESCHED _after_ delayed RCU wake-up
Date: Tue, 28 Mar 2023 16:41:36 +0200
Message-Id: <20230328142621.512822187@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit b416514054810cf2d2cc348ae477cea619b64da7 ]

RCU sometimes needs to perform a delayed wake up for specific kthreads
handling offloaded callbacks (RCU_NOCB).  These wakeups are performed
by timers and upon entry to idle (also to guest and to user on nohz_full).

However the delayed wake-up on kernel exit is actually performed after
the thread flags are fetched towards the fast path check for work to
do on exit to user. As a result, and if there is no other pending work
to do upon that kernel exit, the current task will resume to userspace
with TIF_RESCHED set and the pending wake up ignored.

Fix this with fetching the thread flags _after_ the delayed RCU-nocb
kthread wake-up.

Fixes: 47b8ff194c1f ("entry: Explicitly flush pending rcuog wakeup before last rescheduling point")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230315194349.10798-3-joel@joelfernandes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 1314894d2efad..be61332c66b54 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -192,13 +192,14 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 
 static void exit_to_user_mode_prepare(struct pt_regs *regs)
 {
-	unsigned long ti_work = read_thread_flags();
+	unsigned long ti_work;
 
 	lockdep_assert_irqs_disabled();
 
 	/* Flush pending rcuog wakeup before the last need_resched() check */
 	tick_nohz_user_enter_prepare();
 
+	ti_work = read_thread_flags();
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
-- 
2.39.2



