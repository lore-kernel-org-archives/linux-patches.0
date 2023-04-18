Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B562572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D98C433EF;
	Tue, 18 Apr 2023 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821656;
	bh=RESM5sRyCRV1MtcyIY+rAu/env00VQhbSL6eg2cYeLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjPRgO4IkVRqJHhyQ5FAOFOxd5OqUSS21nvEVFS+HUULQUIK0AXLXylm9ketD6yIr
	 8NpeUZI+bu8shYYHWMt2Y5CxP/njgz1ZzXGiSQJL7pgJDGH1YlwpEo4LSVM4F3peU4
	 tChsQ9tnuOUfKshMrgDgVyga5fOfUXD/8mzHbhno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 84/91] cgroup/cpuset: Skip spread flags update on v2
Date: Tue, 18 Apr 2023 14:22:28 +0200
Message-Id: <20230418120308.475525213@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

[ Upstream commit 18f9a4d47527772515ad6cbdac796422566e6440 ]

Cpuset v2 has no spread flags to set. So we can skip spread
flags update if cpuset v2 is being used. Also change the name to
cpuset_update_task_spread_flags() to indicate that there are multiple
spread flags.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 42a11bf5c543 ("cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fb895eaf3a7c3..3d254498eb275 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -450,11 +450,15 @@ static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 /*
  * update task's spread flag if cpuset's page/slab spread flag is set
  *
- * Call with callback_lock or cpuset_rwsem held.
+ * Call with callback_lock or cpuset_rwsem held. The check can be skipped
+ * if on default hierarchy.
  */
-static void cpuset_update_task_spread_flag(struct cpuset *cs,
+static void cpuset_update_task_spread_flags(struct cpuset *cs,
 					struct task_struct *tsk)
 {
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+		return;
+
 	if (is_spread_page(cs))
 		task_set_spread_page(tsk);
 	else
@@ -1941,7 +1945,7 @@ static void update_tasks_flags(struct cpuset *cs)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
-		cpuset_update_task_spread_flag(cs, task);
+		cpuset_update_task_spread_flags(cs, task);
 	css_task_iter_end(&it);
 }
 
@@ -2274,7 +2278,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
-		cpuset_update_task_spread_flag(cs, task);
+		cpuset_update_task_spread_flags(cs, task);
 	}
 
 	/*
-- 
2.39.2



