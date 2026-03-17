Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2A73EE1F3;
	Tue, 17 Mar 2026 16:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765888; cv=none; b=WJ3g7rdAEbZi4uQRWRqv2jeZRzB/vMTDhBi9UaeiSXkO8EAyVhXloXGubrrregMZsdw7xo2TB5WBYUAWy+sXebmVuhb/78ITB5NPXROqsoUZIsfBGNYqreWg2znu59jdZJIR4rQd3AiAFt+iEIjaldoSfjSMbt6egqirdoUihgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765888; c=relaxed/simple;
	bh=yHJb/SJNvGoQrXP597EolvGeHroQEV+/NzSe5sCY/D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgH0e0S1XUKb/v4KhWfIxx0DrZs4l+dFkKJnaUSycsIRBSmIwP+K1VCvLaa5a2rpCHwy53N5+/Xgsgf0AqHP/tXF42lFKGdDifQzW0iyCGKmmDry+xsJ80junwl+58z0mtqTeY78bMQeSCjUVrS1LpkVjYGpNcHwh4Z/3zQFc8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNcAq8ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNcAq8ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CE6C4CEF7;
	Tue, 17 Mar 2026 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765888;
	bh=yHJb/SJNvGoQrXP597EolvGeHroQEV+/NzSe5sCY/D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNcAq8ESHo5vy1wVmvvjd+WSm1+eyY2u9l8JFs5fm31X00lt/iQ4HsCrOQ8daeH0n
	 n3EjKBAM31B9XT31VxQfEEBvNVX6zYs9SvmoMQI4eAw2WIxWg4FKI84EWxTri4mpru
	 9iVvoIcPxICZZ3upBYNM7mKwDIlznfRdr/sEWoiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.19 117/378] cgroup: Dont expose dead tasks in cgroup
Date: Tue, 17 Mar 2026 17:31:14 +0100
Message-ID: <20260317163011.321522918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit a72f73c4dd9b209c53cf8b03b6e97fcefad4262c upstream.

Once a task exits it has its state set to TASK_DEAD and then it is
removed from the cgroup it belonged to. The last step happens on the task
gets out of its last schedule() invocation and is delayed on PREEMPT_RT
due to locking constraints.

As a result it is possible to receive a pid via waitpid() of a task
which is still listed in cgroup.procs for the cgroup it belonged
to. This is something that systemd does not expect and as a result it
waits for its exit until a time out occurs.
This can also be reproduced on !PREEMPT_RT kernel with a significant
delay in do_exit() after exit_notify().

Hide the task from the output which have PF_EXITING set which is done
before the parent is notified. Keeping zombies with live threads
shouldn't break anything (suggested by Tejun).

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/all/20260219164648.3014-1-spasswolf@web.de/
Tested-by: Bert Karwatzki <spasswolf@web.de>
Fixes: 9311e6c29b34 ("cgroup: Fix sleeping from invalid context warning on PREEMPT_RT")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index be1d71dda317..01fc2a93f3ef 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5109,6 +5109,12 @@ static void css_task_iter_advance(struct css_task_iter *it)
 		return;
 
 	task = list_entry(it->task_pos, struct task_struct, cg_list);
+	/*
+	 * Hide tasks that are exiting but not yet removed. Keep zombie
+	 * leaders with live threads visible.
+	 */
+	if ((task->flags & PF_EXITING) && !atomic_read(&task->signal->live))
+		goto repeat;
 
 	if (it->flags & CSS_TASK_ITER_PROCS) {
 		/* if PROCS, skip over tasks which aren't group leaders */
-- 
2.53.0



