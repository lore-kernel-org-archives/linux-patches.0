Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996BD748A;
	Thu, 12 Dec 2024 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017311; cv=none; b=TV+pwd1LenMUOVVP7OPIV0XgSITTc4jM7jQdGDMKQz19crp5yjTMS/2bLT3yAYrsTb31lkI2mn4BAycaSaPgDLYipIVQlM7s5N6aa8aQezkZwJ3nedmoneUtZlPEnKHHSQ5Rg2q4HeAE0TMy+F2+67Pv42cJaEamZ85gBX3MQmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017311; c=relaxed/simple;
	bh=jo+soLT40rXgf1Qn0g60kPv7F3PTkDyA51ojdrN9RF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewMD7ttJ7O0V+SaRCfEppliaJmvuLpKi/LTT/ejE8bpjMNl2UHMAYqKROWdx/6pvPFsy+/W7w2M/1SIuX69EINaNndfeQFG5Gz1kGdK6N4cx0XyqdMXjwXLiUAhrjkf6qKyqAguGrwLaHa5H4sP3d1SmVmUTlK3x1Inh6O+BHE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEGP+sib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEGP+sib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D567C4CECE;
	Thu, 12 Dec 2024 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017311;
	bh=jo+soLT40rXgf1Qn0g60kPv7F3PTkDyA51ojdrN9RF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEGP+sibIOhhDZFj0fm8Zyed7gYxDvPg5xU36vWlhzkW5NynMS9IyxXKGKADQwfo9
	 fksmxubuTCAZruGpZiwj0uPhpRd2lm2V8RAoRfpMn2XRKG3q56hFP+nc/+Kw7W78Xo
	 U2OcE239b1C1q0qR2oBVX2aWtTyofnUX6g7ybVuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 443/466] sched/deadline: Fix warning in migrate_enable for boosted tasks
Date: Thu, 12 Dec 2024 16:00:12 +0100
Message-ID: <20241212144324.358551206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 0664e2c311b9fa43b33e3e81429cd0c2d7f9c638 ]

When running the following command:

while true; do
    stress-ng --cyclic 30 --timeout 30s --minimize --quiet
done

a warning is eventually triggered:

WARNING: CPU: 43 PID: 2848 at kernel/sched/deadline.c:794
setup_new_dl_entity+0x13e/0x180
...
Call Trace:
 <TASK>
 ? show_trace_log_lvl+0x1c4/0x2df
 ? enqueue_dl_entity+0x631/0x6e0
 ? setup_new_dl_entity+0x13e/0x180
 ? __warn+0x7e/0xd0
 ? report_bug+0x11a/0x1a0
 ? handle_bug+0x3c/0x70
 ? exc_invalid_op+0x14/0x70
 ? asm_exc_invalid_op+0x16/0x20
 enqueue_dl_entity+0x631/0x6e0
 enqueue_task_dl+0x7d/0x120
 __do_set_cpus_allowed+0xe3/0x280
 __set_cpus_allowed_ptr_locked+0x140/0x1d0
 __set_cpus_allowed_ptr+0x54/0xa0
 migrate_enable+0x7e/0x150
 rt_spin_unlock+0x1c/0x90
 group_send_sig_info+0xf7/0x1a0
 ? kill_pid_info+0x1f/0x1d0
 kill_pid_info+0x78/0x1d0
 kill_proc_info+0x5b/0x110
 __x64_sys_kill+0x93/0xc0
 do_syscall_64+0x5c/0xf0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
 RIP: 0033:0x7f0dab31f92b

This warning occurs because set_cpus_allowed dequeues and enqueues tasks
with the ENQUEUE_RESTORE flag set. If the task is boosted, the warning
is triggered. A boosted task already had its parameters set by
rt_mutex_setprio, and a new call to setup_new_dl_entity is unnecessary,
hence the WARN_ON call.

Check if we are requeueing a boosted task and avoid calling
setup_new_dl_entity if that's the case.

Fixes: 295d6d5e3736 ("sched/deadline: Fix switching to -deadline")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20240724142253.27145-2-wander@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index be1b917dc8ce4..40a1ad4493b4d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2042,6 +2042,7 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 	} else if (flags & ENQUEUE_REPLENISH) {
 		replenish_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_RESTORE) &&
+		   !is_dl_boosted(dl_se) &&
 		   dl_time_before(dl_se->deadline, rq_clock(rq_of_dl_se(dl_se)))) {
 		setup_new_dl_entity(dl_se);
 	}
-- 
2.43.0



