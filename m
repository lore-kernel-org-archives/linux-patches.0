Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECCA1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDA5C433C8;
	Mon, 11 Sep 2023 14:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442107;
	bh=imaKPJQO5/J4reW2CGAVltD3XLwVzM9mOk8s/bFsPXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=demS73melVbi30LJWE48XmiDYhQSGQXXmimruCmgL5/tIL5HAA+A/5Pney4A6s+lf
	 1a5pxlUFOJBVyw14ES2Pk/sth5I3OJFQVg/mi6JkuYavggUF0cHgsU+VWdbxAVCW+/
	 VZUEdzrIFHkYVWf7qLrqppdCoo7sL4OTk/c3y95o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yu Liao <liaoyu15@huawei.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 6.5 649/739] cpu/hotplug: Prevent self deadlock on CPU hot-unplug
Date: Mon, 11 Sep 2023 15:47:28 +0200
Message-ID: <20230911134709.232054777@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 2b8272ff4a70b866106ae13c36be7ecbef5d5da2 upstream.

Xiongfeng reported and debugged a self deadlock of the task which initiates
and controls a CPU hot-unplug operation vs. the CFS bandwidth timer.

    CPU1      			                 	 CPU2

T1 sets cfs_quota
   starts hrtimer cfs_bandwidth 'period_timer'
T1 is migrated to CPU2
						T1 initiates offlining of CPU1
Hotplug operation starts
  ...
'period_timer' expires and is re-enqueued on CPU1
  ...
take_cpu_down()
  CPU1 shuts down and does not handle timers
  anymore. They have to be migrated in the
  post dead hotplug steps by the control task.

						T1 runs the post dead offline operation
					      	T1 is scheduled out
						T1 waits for 'period_timer' to expire

T1 waits there forever if it is scheduled out before it can execute the hrtimer
offline callback hrtimers_dead_cpu().

Cure this by delegating the hotplug control operation to a worker thread on
an online CPU. This takes the initiating user space task, which might be
affected by the bandwidth timer, completely out of the picture.

Reported-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Yu Liao <liaoyu15@huawei.com>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/8e785777-03aa-99e1-d20e-e956f5685be6@huawei.com
Link: https://lore.kernel.org/r/87h6oqdq0i.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1467,8 +1467,22 @@ out:
 	return ret;
 }
 
+struct cpu_down_work {
+	unsigned int		cpu;
+	enum cpuhp_state	target;
+};
+
+static long __cpu_down_maps_locked(void *arg)
+{
+	struct cpu_down_work *work = arg;
+
+	return _cpu_down(work->cpu, 0, work->target);
+}
+
 static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
 {
+	struct cpu_down_work work = { .cpu = cpu, .target = target, };
+
 	/*
 	 * If the platform does not support hotplug, report it explicitly to
 	 * differentiate it from a transient offlining failure.
@@ -1477,7 +1491,15 @@ static int cpu_down_maps_locked(unsigned
 		return -EOPNOTSUPP;
 	if (cpu_hotplug_disabled)
 		return -EBUSY;
-	return _cpu_down(cpu, 0, target);
+
+	/*
+	 * Ensure that the control task does not run on the to be offlined
+	 * CPU to prevent a deadlock against cfs_b->period_timer.
+	 */
+	cpu = cpumask_any_but(cpu_online_mask, cpu);
+	if (cpu >= nr_cpu_ids)
+		return -EBUSY;
+	return work_on_cpu(cpu, __cpu_down_maps_locked, &work);
 }
 
 static int cpu_down(unsigned int cpu, enum cpuhp_state target)


