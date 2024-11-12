Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12821CF9F;
	Tue, 12 Nov 2024 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407813; cv=none; b=rnPFov7Bg9SOYE5opHhagqbXrq7PUn++eX9WkM5GHOS/l/zpehNExXpyHA1cMJfATFPAYKVsXrgUkpemXqnD/hj+U7zBbbmFhte/j4xSoVnmOT0ZGWqBT4ZJ1tlRpd6Ei9oWoEmQGW9E65bwmMGghv6bvIJVn4+IkexRYCszgZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407813; c=relaxed/simple;
	bh=qX5moUBfOkM+l/FtQeys0BmlA54s75//kuatHNj+rI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDL87RsMJmhCdZQpil/+Z5qvlG+3ALBmFaE29lXYJpTLVa9qO8Ng6Y2sB99EimYIxaqkeSI1lDOA6PjgjrIk3ojzE09G0YyK7eqLOi2ULObkCImgwo+SR7RJstOsSvscclnnOzfVm35uhtklmrEq23o+rtidT45NwXzhShHQcEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5aoSt9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5aoSt9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A86C4CED6;
	Tue, 12 Nov 2024 10:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407813;
	bh=qX5moUBfOkM+l/FtQeys0BmlA54s75//kuatHNj+rI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5aoSt9qCtt9Ok81hifFa4ZZD8k25VZA6a3XUjL0x8TYs9flgFTNYo1tGUxuaiwrZ
	 GtygEKV95MHH6HGSIdKDTSRjY03LKPz6QbIEzLCJIQF5SSR/L7ZwqIwXHJ5Fa1TreF
	 9bLx9wAKkE8adtqvLqXX6ojpNHe7j9uUwJXZH51k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/119] posix-cpu-timers: Clear TICK_DEP_BIT_POSIX_TIMER on clone
Date: Tue, 12 Nov 2024 11:21:37 +0100
Message-ID: <20241112101852.115382532@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Benjamin Segall <bsegall@google.com>

[ Upstream commit b5413156bad91dc2995a5c4eab1b05e56914638a ]

When cloning a new thread, its posix_cputimers are not inherited, and
are cleared by posix_cputimers_init(). However, this does not clear the
tick dependency it creates in tsk->tick_dep_mask, and the handler does
not reach the code to clear the dependency if there were no timers to
begin with.

Thus if a thread has a cputimer running before clone/fork, all
descendants will prevent nohz_full unless they create a cputimer of
their own.

Fix this by entirely clearing the tick_dep_mask in copy_process().
(There is currently no inherited state that needs a tick dependency)

Process-wide timers do not have this problem because fork does not copy
signal_struct as a baseline, it creates one from scratch.

Fixes: b78783000d5c ("posix-cpu-timers: Migrate to use new tick dependency mask model")
Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/xm26o737bq8o.fsf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tick.h | 8 ++++++++
 kernel/fork.c        | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 9459fef5b8573..9701c571a5cfe 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -252,12 +252,19 @@ static inline void tick_dep_set_task(struct task_struct *tsk,
 	if (tick_nohz_full_enabled())
 		tick_nohz_dep_set_task(tsk, bit);
 }
+
 static inline void tick_dep_clear_task(struct task_struct *tsk,
 				       enum tick_dep_bits bit)
 {
 	if (tick_nohz_full_enabled())
 		tick_nohz_dep_clear_task(tsk, bit);
 }
+
+static inline void tick_dep_init_task(struct task_struct *tsk)
+{
+	atomic_set(&tsk->tick_dep_mask, 0);
+}
+
 static inline void tick_dep_set_signal(struct task_struct *tsk,
 				       enum tick_dep_bits bit)
 {
@@ -291,6 +298,7 @@ static inline void tick_dep_set_task(struct task_struct *tsk,
 				     enum tick_dep_bits bit) { }
 static inline void tick_dep_clear_task(struct task_struct *tsk,
 				       enum tick_dep_bits bit) { }
+static inline void tick_dep_init_task(struct task_struct *tsk) { }
 static inline void tick_dep_set_signal(struct task_struct *tsk,
 				       enum tick_dep_bits bit) { }
 static inline void tick_dep_clear_signal(struct signal_struct *signal,
diff --git a/kernel/fork.c b/kernel/fork.c
index 9098284720e38..23efaa2c42e4f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -99,6 +99,7 @@
 #include <linux/stackprotector.h>
 #include <linux/user_events.h>
 #include <linux/iommu.h>
+#include <linux/tick.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -2418,6 +2419,7 @@ __latent_entropy struct task_struct *copy_process(
 	acct_clear_integrals(p);
 
 	posix_cputimers_init(&p->posix_cputimers);
+	tick_dep_init_task(p);
 
 	p->io_context = NULL;
 	audit_set_context(p, NULL);
-- 
2.43.0



