Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC1F21CC55;
	Mon, 18 Aug 2025 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525388; cv=none; b=sDRJUIAStPLAcpYw+xlGAbT5QnZ3L80bYRaFy8EYP5GvrC2uQ9M9giNgsrR4EAItQjJcCcAfOzN/2ZHydpUhaDkWG26jHg6TEFCOUBQF2s2GbF7EKJKNy2+PvWzxAiCQtawAbXPHw6IGcnRh/Ok17FOJHmwnk970/5MgYo3kTBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525388; c=relaxed/simple;
	bh=8XHhEGYx7500E6zDJn9wz5WtFydVcvQWPQBVovaSJZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjwtan0uHTiu0JLkaTrjz10NDHs/bVyDQLuEKNipZNuw+bDnSnDyIxkv5et8sQWPUZN6AEc78C6HW6DAui9NEmLrhbg8x8mON7kjFuGkcEZeeAtvAlkkTdRuEnZCjXdSdUcpbn/QYvE/95M1zI5bbd//OogtiotFEIMShMaFntg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UB1ndWz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UB1ndWz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE73C4CEEB;
	Mon, 18 Aug 2025 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525387;
	bh=8XHhEGYx7500E6zDJn9wz5WtFydVcvQWPQBVovaSJZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UB1ndWz1H9Ljl1g7QFqUfuB8mRAahpxyAbdoONsA/yvpflek/pjIvJ6WWMNLKKYeE
	 PHrI4PS3Wt4AyKC8hP9+VY0E7MjQbY7nMEBQBG4XiTpdtFZYYtH6XAn7oFeR3Dg5Cj
	 8u/lakxVGDspSLC56cF+CgbI9tEheiOYbnTvdIxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 248/570] sched/deadline: Fix accounting after global limits change
Date: Mon, 18 Aug 2025 14:43:55 +0200
Message-ID: <20250818124515.372335225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 440989c10f4e32620e9e2717ca52c3ed7ae11048 ]

A global limits change (sched_rt_handler() logic) currently leaves stale
and/or incorrect values in variables related to accounting (e.g.
extra_bw).

Properly clean up per runqueue variables before implementing the change
and rebuild scheduling domains (so that accounting is also properly
restored) after such a change is complete.

Reported-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk> # nuc & rock5b
Link: https://lore.kernel.org/r/20250627115118.438797-4-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 4 +++-
 kernel/sched/rt.c       | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 65f3b2cc891d..d86b211f2c14 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3249,6 +3249,9 @@ void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	for_each_possible_cpu(cpu)
+		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
+
 	for_each_possible_cpu(cpu) {
 		rcu_read_lock_sched();
 
@@ -3264,7 +3267,6 @@ void sched_dl_do_global(void)
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
 		rcu_read_unlock_sched();
-		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
 	}
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e40422c37033..507707653312 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2951,6 +2951,12 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
 	sched_domains_mutex_unlock();
 	mutex_unlock(&mutex);
 
+	/*
+	 * After changing maximum available bandwidth for DEADLINE, we need to
+	 * recompute per root domain and per cpus variables accordingly.
+	 */
+	rebuild_sched_domains();
+
 	return ret;
 }
 
-- 
2.39.5



