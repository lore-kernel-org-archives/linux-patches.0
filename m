Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2961E8332;
	Tue, 17 Jun 2025 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174401; cv=none; b=GadV2GiEEvlRjbQ8KyaiFe5/R8DTpUYwpR13zwK4gXjosdc+gXeCHVlRbn52C8FJcJNPK6pxasWXrrKX5Kz19krgFbGXLpREko4PtVQx1OLaHcZGR7D+N0EqW0yXoIcfYN0YypiZs0FjeHUW6ao02nvFD9WzHBVOlGZUGaHgTMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174401; c=relaxed/simple;
	bh=IKSs0I3EX58+8NhWsJZit5dUyIq9eN3pEdbeielj4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3wVRCBiZUrUGGUUlnXTfg55J8G1F/CEDzDw+NzDr0/Fs6UySMZk9Ozcy/9qEe69bwIoCSqOFaRDjc6LC0wTNJFS6bI/Si1/UfjofpZ7LA7jtc/IjiFmbxW/yQyTsyOk6Pwd6wasqzPiGrWvb2txiWTXAYDNWSz+WVKrURYwuSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIeVfRP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIeVfRP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E02FC4CEE3;
	Tue, 17 Jun 2025 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174401;
	bh=IKSs0I3EX58+8NhWsJZit5dUyIq9eN3pEdbeielj4L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIeVfRP/IDkUnLiwG+w7OvD4PMDNtNI9uP7l1C+WYYq053FUxvSTGIn+gUq95lwa4
	 ORdeeDl2XuBxEmX1hFsupOKnaAehplTIYpQm9Gh/jKkN/rrK/EelrOENoVq/BvLfrH
	 6d2LkK9R5wgBP4AmWl2K2Xt58tiqHm8OgQ59cAAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	peter-yc.chang@mediatek.com,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/512] sched/core: Tweak wait_task_inactive() to force dequeue sched_delayed tasks
Date: Tue, 17 Jun 2025 17:19:40 +0200
Message-ID: <20250617152420.103801005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

[ Upstream commit b7ca5743a2604156d6083b88cefacef983f3a3a6 ]

It was reported that in 6.12, smpboot_create_threads() was
taking much longer then in 6.6.

I narrowed down the call path to:
 smpboot_create_threads()
 -> kthread_create_on_cpu()
    -> kthread_bind()
       -> __kthread_bind_mask()
          ->wait_task_inactive()

Where in wait_task_inactive() we were regularly hitting the
queued case, which sets a 1 tick timeout, which when called
multiple times in a row, accumulates quickly into a long
delay.

I noticed disabling the DELAY_DEQUEUE sched feature recovered
the performance, and it seems the newly create tasks are usually
sched_delayed and left on the runqueue.

So in wait_task_inactive() when we see the task
p->se.sched_delayed, manually dequeue the sched_delayed task
with DEQUEUE_DELAYED, so we don't have to constantly wait a
tick.

Fixes: 152e11f6df29 ("sched/fair: Implement delayed dequeue")
Reported-by: peter-yc.chang@mediatek.com
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lkml.kernel.org/r/20250429150736.3778580-1-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 814abc7ad994a..51f36de5990a3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2229,6 +2229,12 @@ unsigned long wait_task_inactive(struct task_struct *p, unsigned int match_state
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &rf);
+		/*
+		 * If task is sched_delayed, force dequeue it, to avoid always
+		 * hitting the tick timeout in the queued case
+		 */
+		if (p->se.sched_delayed)
+			dequeue_task(rq, p, DEQUEUE_SLEEP | DEQUEUE_DELAYED);
 		trace_sched_wait_task(p);
 		running = task_on_cpu(rq, p);
 		queued = task_on_rq_queued(p);
-- 
2.39.5



