Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0216088F;
	Wed,  6 Nov 2024 12:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896321; cv=none; b=mjcFTErsgxirM2wBTrQI97T2BN8evKldxlV7RiNckgUDfPvXqQVtbYwU8BggVVM8tt7d6FEJzChk3pR1uV3xtRC6o3rkqMg7clNxFXnd/lPHr9HavLNhYudCKIGLzGUFGJe4SgoEz2exAHW3XjQdQg7YkYZcumVwy5vT9QD/VIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896321; c=relaxed/simple;
	bh=32Xkm0kEa02eyNZOR08qX0HpV2RVP7W2Srr1PieYNMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8quDqqAaFTo5nHV4XTbWVX/nQjFLDbBuaOPhd2ixSa9j8O6rhJOX/aF9m5Ol0MAc7DEKF922sOZfttkkhnq21h+5bmqoba6oflPvYpTddxMPWogue93df6WkPAHDkswgtYd6967kMDOW+QNBRS3pQV9ujktobH4e1GEckvEWPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CpE2vUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CpE2vUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448DDC4CECD;
	Wed,  6 Nov 2024 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896321;
	bh=32Xkm0kEa02eyNZOR08qX0HpV2RVP7W2Srr1PieYNMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CpE2vUb58Ypx1ZKo6ZiTFFYONm5I+0CcC/OsIfngMHx/63GjgpH2g1RvZIxUpakY
	 UXdCoKo4Km6xLDt7N+nQmM6VTX+CR6pG3zr6J6qQXH6yhdx06v0Iq2Ud3cVFUPjVsi
	 Dkb9M3IqTJDSWWvkG7utoxKeLrFPpmypqQcWgK8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 165/245] posix-cpu-timers: Clear TICK_DEP_BIT_POSIX_TIMER on clone
Date: Wed,  6 Nov 2024 13:03:38 +0100
Message-ID: <20241106120323.298359694@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 72744638c5b0f..99c9c5a7252aa 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -251,12 +251,19 @@ static inline void tick_dep_set_task(struct task_struct *tsk,
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
@@ -290,6 +297,7 @@ static inline void tick_dep_set_task(struct task_struct *tsk,
 				     enum tick_dep_bits bit) { }
 static inline void tick_dep_clear_task(struct task_struct *tsk,
 				       enum tick_dep_bits bit) { }
+static inline void tick_dep_init_task(struct task_struct *tsk) { }
 static inline void tick_dep_set_signal(struct task_struct *tsk,
 				       enum tick_dep_bits bit) { }
 static inline void tick_dep_clear_signal(struct signal_struct *signal,
diff --git a/kernel/fork.c b/kernel/fork.c
index 6b97fb2ac4af5..dbf3c5d81df3b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -104,6 +104,7 @@
 #include <linux/rseq.h>
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
+#include <linux/tick.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -2290,6 +2291,7 @@ __latent_entropy struct task_struct *copy_process(
 	acct_clear_integrals(p);
 
 	posix_cputimers_init(&p->posix_cputimers);
+	tick_dep_init_task(p);
 
 	p->io_context = NULL;
 	audit_set_context(p, NULL);
-- 
2.43.0



