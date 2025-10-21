Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F07350A0D;
	Tue, 21 Oct 2025 20:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077482; cv=none; b=PipTrTHmbUG6tm2bVqHc/ctriD1wqMy0dVyF1HScNAXZftVEBV9/FkljyvYWV6RFokEOHtQrNnAmBDIhEzo5pBwKUM+MdOSgaLfog6N5rNV8xsL5/qmjZXG0pDCfDA6grql27n1Y+bBtYNFDILjwadWX00jVGLa7Ml2UFGo0s8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077482; c=relaxed/simple;
	bh=yxhrysYiiKpcsRKpGj3P1kZLEnPd6gu4HH59ADawmQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDSBUEOjsd2VlqHtbbnOChOsIUOG0MH0AEvSR62C1Sq/iOvmr39qYp0tLk9lZqtUrl5/mMLDqoLC2o2HRTwoCxqW6AkZyEnLakV2k1jZqjMALrsx3ocEdfpoR6+qPKGDUkQL5hjdUmLByMAl/CFYYozZSzEiJF8F+Lm+KGc/ePo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ds75icmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ds75icmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5693AC4CEF1;
	Tue, 21 Oct 2025 20:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077481;
	bh=yxhrysYiiKpcsRKpGj3P1kZLEnPd6gu4HH59ADawmQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ds75icmFRMwQeG8yG+kBE5Xt4Axw6w2RC0uyL/G8a1K+yTZ5Z2WbMfllwLdPhfhz8
	 EZ3Iavza1EKJOHeAs+MZYbHvcj2eYtV3Yqon09iVfqtLLh5XMskZGA3Sqn+a+3/B0z
	 lVlhR5V18LUuiAVqOxx4LcbA5/bnm0jgqUw+hBHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 118/159] sched/deadline: Stop dl_server before CPU goes offline
Date: Tue, 21 Oct 2025 21:51:35 +0200
Message-ID: <20251021195045.999678507@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra (Intel) <peterz@infradead.org>

[ Upstream commit ee6e44dfe6e50b4a5df853d933a96bdff5309e6e ]

IBM CI tool reported kernel warning[1] when running a CPU removal
operation through drmgr[2]. i.e "drmgr -c cpu -r -q 1"

WARNING: CPU: 0 PID: 0 at kernel/sched/cpudeadline.c:219 cpudl_set+0x58/0x170
NIP [c0000000002b6ed8] cpudl_set+0x58/0x170
LR [c0000000002b7cb8] dl_server_timer+0x168/0x2a0
Call Trace:
[c000000002c2f8c0] init_stack+0x78c0/0x8000 (unreliable)
[c0000000002b7cb8] dl_server_timer+0x168/0x2a0
[c00000000034df84] __hrtimer_run_queues+0x1a4/0x390
[c00000000034f624] hrtimer_interrupt+0x124/0x300
[c00000000002a230] timer_interrupt+0x140/0x320

Git bisects to: commit 4ae8d9aa9f9d ("sched/deadline: Fix dl_server getting stuck")

This happens since:
- dl_server hrtimer gets enqueued close to cpu offline, when
  kthread_park enqueues a fair task.
- CPU goes offline and drmgr removes it from cpu_present_mask.
- hrtimer fires and warning is hit.

Fix it by stopping the dl_server before CPU is marked dead.

[1]: https://lore.kernel.org/all/8218e149-7718-4432-9312-f97297c352b9@linux.ibm.com/
[2]: https://github.com/ibm-power-utilities/powerpc-utils/tree/next/src/drmgr

[sshegde: wrote the changelog and tested it]
Fixes: 4ae8d9aa9f9d ("sched/deadline: Fix dl_server getting stuck")
Closes: https://lore.kernel.org/all/8218e149-7718-4432-9312-f97297c352b9@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     | 2 ++
 kernel/sched/deadline.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ccba6fc3c3fed..8575d67cbf738 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8603,10 +8603,12 @@ int sched_cpu_dying(unsigned int cpu)
 	sched_tick_stop(cpu);
 
 	rq_lock_irqsave(rq, &rf);
+	update_rq_clock(rq);
 	if (rq->nr_running != 1 || rq_has_pinned_tasks(rq)) {
 		WARN(true, "Dying CPU not properly vacated!");
 		dump_rq_tasks(rq, KERN_WARNING);
 	}
+	dl_server_stop(&rq->fair_server);
 	rq_unlock_irqrestore(rq, &rf);
 
 	calc_load_migrate(rq);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 615411a0a8813..7b7671060bf9e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1582,6 +1582,9 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 	if (!dl_server(dl_se) || dl_se->dl_server_active)
 		return;
 
+	if (WARN_ON_ONCE(!cpu_online(cpu_of(rq))))
+		return;
+
 	dl_se->dl_server_active = 1;
 	enqueue_dl_entity(dl_se, ENQUEUE_WAKEUP);
 	if (!dl_task(dl_se->rq->curr) || dl_entity_preempt(dl_se, &rq->curr->dl))
-- 
2.51.0



