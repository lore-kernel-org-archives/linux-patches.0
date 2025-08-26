Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4CE17332C;
	Tue, 26 Aug 2025 11:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207479; cv=none; b=iRCyAHj/uRsh8GV9RVQQJlPv8zpcXj7eDmPUf3d60oMK+SCjkuJomchSrEWA6wzU23P2PUy8iOZC9/Bcn0Qm56Rzwg8Fc6SwHelUoy0HBK/M28EMEttTmK+sygBqNNpuMcUgHYRlWcfbldlON0td860Gz9JoVPlzv0hsdgnnb88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207479; c=relaxed/simple;
	bh=miJtgJphrAv4Raw0EkNHF87mGQ7meAl2FUxBB4EsFVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6DUIKVjez4kqcuPseoB7NXHvc4x5GkimZenqE+zEFl55eOE1bdxQIq/JBKR5ij82n0rb1WApjUtfFeDb0ZEjhIktvv4iOBS0tsYzo39y3krOCZQitx5IeQWBhQWkzGBaV3/cT4XcmVRFFXi8SV8tNHuWJDB2yCDDY+P4r7UHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQU2kSsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQU2kSsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AABC4CEF4;
	Tue, 26 Aug 2025 11:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207478;
	bh=miJtgJphrAv4Raw0EkNHF87mGQ7meAl2FUxBB4EsFVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQU2kSsJNUaMoYwNk6imBqxxWBTiswDET4wFmLY992G0kno2q+kCyXDsrhvHRks0l
	 w0Y0vOj8haYbF/E4Diz0V65y4r1751BYc9noauYJtUkZ9yL3zPTXYZ9seWSFTUCNAF
	 coS9sYapcj0NLej9LsWRYrhhCNg/WbjOcIFaYYv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.16 198/457] sched/ext: Fix invalid task state transitions on class switch
Date: Tue, 26 Aug 2025 13:08:02 +0200
Message-ID: <20250826110942.261044559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

commit ddf7233fcab6c247379d0928d46cc316ee122229 upstream.

When enabling a sched_ext scheduler, we may trigger invalid task state
transitions, resulting in warnings like the following (which can be
easily reproduced by running the hotplug selftest in a loop):

 sched_ext: Invalid task state transition 0 -> 3 for fish[770]
 WARNING: CPU: 18 PID: 787 at kernel/sched/ext.c:3862 scx_set_task_state+0x7c/0xc0
 ...
 RIP: 0010:scx_set_task_state+0x7c/0xc0
 ...
 Call Trace:
  <TASK>
  scx_enable_task+0x11f/0x2e0
  switching_to_scx+0x24/0x110
  scx_enable.isra.0+0xd14/0x13d0
  bpf_struct_ops_link_create+0x136/0x1a0
  __sys_bpf+0x1edd/0x2c30
  __x64_sys_bpf+0x21/0x30
  do_syscall_64+0xbb/0x370
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

This happens because we skip initialization for tasks that are already
dead (with their usage counter set to zero), but we don't exclude them
during the scheduling class transition phase.

Fix this by also skipping dead tasks during class swiching, preventing
invalid task state transitions.

Fixes: a8532fac7b5d2 ("sched_ext: TASK_DEAD tasks must be switched into SCX on ops_enable")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5694,6 +5694,9 @@ static int scx_enable(struct sched_ext_o
 			__setscheduler_class(p->policy, p->prio);
 		struct sched_enq_and_set_ctx ctx;
 
+		if (!tryget_task_struct(p))
+			continue;
+
 		if (old_class != new_class && p->se.sched_delayed)
 			dequeue_task(task_rq(p), p, DEQUEUE_SLEEP | DEQUEUE_DELAYED);
 
@@ -5706,6 +5709,7 @@ static int scx_enable(struct sched_ext_o
 		sched_enq_and_set_task(&ctx);
 
 		check_class_changed(task_rq(p), p, old_class, p->prio);
+		put_task_struct(p);
 	}
 	scx_task_iter_stop(&sti);
 	percpu_up_write(&scx_fork_rwsem);


