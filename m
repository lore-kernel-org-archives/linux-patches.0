Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125D54BAB1;
	Mon,  8 Jan 2024 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/il3M1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46873C433C8;
	Mon,  8 Jan 2024 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726791;
	bh=9h4QNBY+ydhVERcGkUAdQGtsJ9+LiU5R2dfsP5PoPxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/il3M1CEAPK9PAISx2jvCLUk26GjU8He18TMI6HTeT+jzyx8RwRSRiwokbV8ZU56
	 opXiPAO8n3JWI0bdr2+kpthxDpS57faEB0MG6q2ZO2FCF6JFNqQZhzWNlmpKH4lkVC
	 gNeAJbxF58ZEmYp7QpdB+H2u4L0dTumxkWvkgve8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/124] rcu: Introduce rcu_cpu_online()
Date: Mon,  8 Jan 2024 16:08:25 +0100
Message-ID: <20240108150606.603987829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 2be4686d866ad5896f2bb94d82fe892197aea9c7 ]

Export the RCU point of view as to when a CPU is considered offline
(ie: when does RCU consider that a CPU is sufficiently down in the
hotplug process to not feature any possible read side).

This will be used by RCU-tasks whose vision of an offline CPU should
reasonably match the one of RCU core.

Fixes: cff9b2332ab7 ("kernel/sched: Modify initial boot task idle setup")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcu.h  | 2 ++
 kernel/rcu/tree.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 98e13be411afd..3d1851f82dbb6 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -493,6 +493,7 @@ static inline void rcu_expedite_gp(void) { }
 static inline void rcu_unexpedite_gp(void) { }
 static inline void rcu_async_hurry(void) { }
 static inline void rcu_async_relax(void) { }
+static inline bool rcu_cpu_online(int cpu) { return true; }
 #else /* #ifdef CONFIG_TINY_RCU */
 bool rcu_gp_is_normal(void);     /* Internal RCU use. */
 bool rcu_gp_is_expedited(void);  /* Internal RCU use. */
@@ -502,6 +503,7 @@ void rcu_unexpedite_gp(void);
 void rcu_async_hurry(void);
 void rcu_async_relax(void);
 void rcupdate_announce_bootup_oddness(void);
+bool rcu_cpu_online(int cpu);
 #ifdef CONFIG_TASKS_RCU_GENERIC
 void show_rcu_tasks_gp_kthreads(void);
 #else /* #ifdef CONFIG_TASKS_RCU_GENERIC */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 92a090e161865..9af42eae1ba38 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4139,6 +4139,13 @@ static bool rcu_rdp_cpu_online(struct rcu_data *rdp)
 	return !!(rdp->grpmask & rcu_rnp_online_cpus(rdp->mynode));
 }
 
+bool rcu_cpu_online(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
+
+	return rcu_rdp_cpu_online(rdp);
+}
+
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
 /*
-- 
2.43.0



