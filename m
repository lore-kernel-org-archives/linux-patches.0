Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7CA4F218;
	Thu, 12 Dec 2024 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018676; cv=none; b=YhN21ZnLgGpWr6LH6LNLeqVcTUUb59otilBWJcJNIoVkJMrWDsT74XCOxtoKj/COsavmZTM7ki/omheprf97CIC0/TxAasCdLS87CxQrL7SIOjBgk9huq2CvOuQ3X8FAJe+OhXnH7LLSL87AHBc0JKIDzTuNxC0XfCKMGtwD2uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018676; c=relaxed/simple;
	bh=WeIFl99f5cteLA1czzNjHW+DRDkSV7D3rsOX7D/AVUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkxMGXfRL+r3Lo3Qn0XEVZPazNjfZFFsb5tOymTIeFGIqVv8lqYqk6LTIcN/97O6eZY87Ma+GVh6K4+cBH4v2zq1ZgxdaP1UdhFiNfZdvAktn+1CPuY1DAUZbD1zqgQ0CljUPWQLz3Bp0KSxohhUrUME1FdbCkblryK6NP1CGx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gKCYWgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gKCYWgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659ADC4CECE;
	Thu, 12 Dec 2024 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018675;
	bh=WeIFl99f5cteLA1czzNjHW+DRDkSV7D3rsOX7D/AVUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gKCYWgGjN76qjKOJoS8frosMRdXFcjvqgG69zLKH4Q2S4gHrQiHf+69suREECQo2
	 CTOG8krvsmBscKZe3LrJ+VJtCnTvQ2suNU78gpUNgIM2SYJ6BJx/uDDXEUOmcEijj3
	 aHaMbsGBad3w2ymAkWJsC+6jHI3PALim5uLQi0/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/356] sched: Unify more update_curr*()
Date: Thu, 12 Dec 2024 16:00:47 +0100
Message-ID: <20241212144257.521999286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c708a4dc5ab547edc3d6537233ca9e79ea30ce47 ]

Now that trace_sched_stat_runtime() no longer takes a vruntime
argument, the task specific bits are identical between
update_curr_common() and update_curr().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 0664e2c311b9 ("sched/deadline: Fix warning in migrate_enable for boosted tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 062447861d8e6..3b2cfdb8d788d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1173,6 +1173,13 @@ static s64 update_curr_se(struct rq *rq, struct sched_entity *curr)
 	return delta_exec;
 }
 
+static inline void update_curr_task(struct task_struct *p, s64 delta_exec)
+{
+	trace_sched_stat_runtime(p, delta_exec);
+	account_group_exec_runtime(p, delta_exec);
+	cgroup_account_cputime(p, delta_exec);
+}
+
 /*
  * Used by other classes to account runtime.
  */
@@ -1182,12 +1189,8 @@ s64 update_curr_common(struct rq *rq)
 	s64 delta_exec;
 
 	delta_exec = update_curr_se(rq, &curr->se);
-	if (unlikely(delta_exec <= 0))
-		return delta_exec;
-
-	trace_sched_stat_runtime(curr, delta_exec);
-	account_group_exec_runtime(curr, delta_exec);
-	cgroup_account_cputime(curr, delta_exec);
+	if (likely(delta_exec > 0))
+		update_curr_task(curr, delta_exec);
 
 	return delta_exec;
 }
@@ -1211,13 +1214,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	update_deadline(cfs_rq, curr);
 	update_min_vruntime(cfs_rq);
 
-	if (entity_is_task(curr)) {
-		struct task_struct *curtask = task_of(curr);
-
-		trace_sched_stat_runtime(curtask, delta_exec);
-		cgroup_account_cputime(curtask, delta_exec);
-		account_group_exec_runtime(curtask, delta_exec);
-	}
+	if (entity_is_task(curr))
+		update_curr_task(task_of(curr), delta_exec);
 
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
-- 
2.43.0



