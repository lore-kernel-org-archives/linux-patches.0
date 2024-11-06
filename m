Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1281E0E1F;
	Wed,  6 Nov 2024 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897619; cv=none; b=B4P9Pj+hUU/FwiyjnbXQxJo7vrHVgZ2iHrn2NL8GO+pdDXe9qCwtX/ZY99iAOOojdh6PmZm7psKj+IbhacaRIAapmquzmlErUp4swBjQ7mJeV7+PN6MCHVZPKHdrg7VhjtL6SLtOpt6qSvI4OPnSHgaAlhGj7qkVb8MUXasu1Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897619; c=relaxed/simple;
	bh=7ifTCB3M6HrjVXWuHTztjoX24kKCNIDImunVzeO/vCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNizgnUGHPvnSeHP2PZd5YJzdIQVikOxF9yt2loPDZI2TCsxRqFNJVsjpKJfrQ4KwOj7xOxOq4y7OCju1syBZ2x+MFa01ZE+sBXVAXePS5MjEkKwHPUVhKd72qowR6y9Lol2jb8+A7iRhzqxmd8ilxHQm8YK92WPoU55fGWe5sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtQHSoWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtQHSoWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFF0C4CECD;
	Wed,  6 Nov 2024 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897618;
	bh=7ifTCB3M6HrjVXWuHTztjoX24kKCNIDImunVzeO/vCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtQHSoWCcKgZ1t3rf/GiX/50RIxoSv1IiWlXIuXqYKAuliURnAMyUSfftJzP/x3OO
	 DT2dlDDmTZtpHXtkqzNnsH5LWnKA4y2kM4eRnZ0moP7ReQ3w5UNuXEo+j4208ew7R7
	 eLNU2GNjIfxEUZRh04I19hVG74gH8hxwjEWGM9Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/151] rcu-tasks: Initialize data to eliminate RCU-tasks/do_exit() deadlocks
Date: Wed,  6 Nov 2024 13:04:26 +0100
Message-ID: <20241106120311.000301310@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 46faf9d8e1d52e4a91c382c6c72da6bd8e68297b ]

Holding a mutex across synchronize_rcu_tasks() and acquiring
that same mutex in code called from do_exit() after its call to
exit_tasks_rcu_start() but before its call to exit_tasks_rcu_stop()
results in deadlock.  This is by design, because tasks that are far
enough into do_exit() are no longer present on the tasks list, making
it a bit difficult for RCU Tasks to find them, let alone wait on them
to do a voluntary context switch.  However, such deadlocks are becoming
more frequent.  In addition, lockdep currently does not detect such
deadlocks and they can be difficult to reproduce.

In addition, if a task voluntarily context switches during that time
(for example, if it blocks acquiring a mutex), then this task is in an
RCU Tasks quiescent state.  And with some adjustments, RCU Tasks could
just as well take advantage of that fact.

This commit therefore initializes the data structures that will be needed
to rely on these quiescent states and to eliminate these deadlocks.

Link: https://lore.kernel.org/all/20240118021842.290665-1-chenzhongjin@huawei.com/

Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reported-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Yang Jihong <yangjihong1@huawei.com>
Tested-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: fd70e9f1d85f ("rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/init_task.c   | 1 +
 kernel/fork.c      | 1 +
 kernel/rcu/tasks.h | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/init/init_task.c b/init/init_task.c
index ff6c4b9bfe6b1..fd9e27185e23a 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -152,6 +152,7 @@ struct task_struct init_task
 	.rcu_tasks_holdout = false,
 	.rcu_tasks_holdout_list = LIST_HEAD_INIT(init_task.rcu_tasks_holdout_list),
 	.rcu_tasks_idle_cpu = -1,
+	.rcu_tasks_exit_list = LIST_HEAD_INIT(init_task.rcu_tasks_exit_list),
 #endif
 #ifdef CONFIG_TASKS_TRACE_RCU
 	.trc_reader_nesting = 0,
diff --git a/kernel/fork.c b/kernel/fork.c
index 32ffbc1c96bae..9098284720e38 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1973,6 +1973,7 @@ static inline void rcu_copy_process(struct task_struct *p)
 	p->rcu_tasks_holdout = false;
 	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
 	p->rcu_tasks_idle_cpu = -1;
+	INIT_LIST_HEAD(&p->rcu_tasks_exit_list);
 #endif /* #ifdef CONFIG_TASKS_RCU */
 #ifdef CONFIG_TASKS_TRACE_RCU
 	p->trc_reader_nesting = 0;
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 7ac3c8af075fc..4eae3b1bda70e 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -277,6 +277,8 @@ static void cblist_init_generic(struct rcu_tasks *rtp)
 		rtpcp->rtpp = rtp;
 		if (!rtpcp->rtp_blkd_tasks.next)
 			INIT_LIST_HEAD(&rtpcp->rtp_blkd_tasks);
+		if (!rtpcp->rtp_exit_list.next)
+			INIT_LIST_HEAD(&rtpcp->rtp_exit_list);
 	}
 
 	pr_info("%s: Setting shift to %d and lim to %d rcu_task_cb_adjust=%d.\n", rtp->name,
-- 
2.43.0



