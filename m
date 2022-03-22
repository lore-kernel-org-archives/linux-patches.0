Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2C26465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4868CC340EE;
	Tue, 22 Mar 2022 21:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985703;
	bh=Z+in6z7I+vTIn+ymFgxwN19wkjdS6edefn4YcYFMOZM=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=x8QvN7mdjlevad1xqvmGgN/eB9zeQoVTS9s1Z7AVaQqbFj/9iLBHFMtOy2pOuZA65
	 NlcCvRkkNzx+kPjjflLl4jn4/0jOKzMBVW/5G7XcrSOfrHFyiFL4hTJ+7ZytPguLcC
	 4Q7CQIIfdGN4tsT5muOCY8rPUFEkAKwOrVWO3B08=
Date: Tue, 22 Mar 2022 14:48:22 -0700
To: wangkefeng.wang@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,dlatypov@google.com,davidgow@google.com,brendanhiggins@google.com,liupeng256@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 194/227] kfence: test: try to avoid test_gfpzero trigger rcu_stall
Message-Id: <20220322214823.4868CC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Peng Liu <liupeng256@huawei.com>
Subject: kfence: test: try to avoid test_gfpzero trigger rcu_stall

When CONFIG_KFENCE_NUM_OBJECTS is set to a big number, kfence
kunit-test-case test_gfpzero will eat up nearly all the CPU's resources
and rcu_stall is reported as the following log which is cut from a
physical server.

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: 	68-....: (14422 ticks this GP) idle=6ce/1/0x4000000000000002
  softirq=592/592 fqs=7500 (t=15004 jiffies g=10677 q=20019)
  Task dump for CPU 68:
  task:kunit_try_catch state:R  running task
  stack:    0 pid: 9728 ppid:     2 flags:0x0000020a
  Call trace:
   dump_backtrace+0x0/0x1e4
   show_stack+0x20/0x2c
   sched_show_task+0x148/0x170
   ...
   rcu_sched_clock_irq+0x70/0x180
   update_process_times+0x68/0xb0
   tick_sched_handle+0x38/0x74
   ...
   gic_handle_irq+0x78/0x2c0
   el1_irq+0xb8/0x140
   kfree+0xd8/0x53c
   test_alloc+0x264/0x310 [kfence_test]
   test_gfpzero+0xf4/0x840 [kfence_test]
   kunit_try_run_case+0x48/0x20c
   kunit_generic_run_threadfn_adapter+0x28/0x34
   kthread+0x108/0x13c
   ret_from_fork+0x10/0x18

To avoid rcu_stall and unacceptable latency, a schedule point is
added to test_gfpzero.

Link: https://lkml.kernel.org/r/20220309083753.1561921-4-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/kfence_test.c~kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall
+++ a/mm/kfence/kfence_test.c
@@ -627,6 +627,7 @@ static void test_gfpzero(struct kunit *t
 			kunit_warn(test, "giving up ... cannot get same object back\n");
 			return;
 		}
+		cond_resched();
 	}
 
 	for (i = 0; i < size; i++)
_
