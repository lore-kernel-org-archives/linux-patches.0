Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430AF376;
	Wed,  2 Oct 2024 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876025; cv=none; b=uV/rj2KF+dulUOZUE1w9HQYvnRGCU83ZphXck2SWaV5UKdonPs3z5u5DwUE5LuaU0cp/bvIFPLENELq/gumiSgLde29kibktZDgsz0yrNaFUGv/8D3MNz2gErrSr776GDdaF92yJpbyBtEi6vcdgcuuOJVqJf/NUhXsm3W2rILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876025; c=relaxed/simple;
	bh=2+5bAMSOUO/57GxeqhAAjBs3E9kgmU9YHeYhstYQJnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyUNYQaJT/M94kCMAOtHnny+W0HmG8sjQ7ZhQh4bf4s35iVCrsKgMvskxslT85wWcd8MXukBX1egkbtT5cDCBC46sgk/rRTNhMFvkazmxc8S+jVMnPdFkE9or04gxDfwn4m/SLsGq5fX2RWOD2fpB3vvzbVCNxLxvvhsZgeMp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7pNG+TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7pNG+TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F019C4CEC5;
	Wed,  2 Oct 2024 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876024;
	bh=2+5bAMSOUO/57GxeqhAAjBs3E9kgmU9YHeYhstYQJnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7pNG+TUxFKpJsyhNItOI6MAEWSbc6nxpgiLHosH4MbEdOPzK+xYlViqtOF7NK9d1
	 GcUJZKKurkDMA41gkYqrcBmKZq3NqP4CSb5D+6cv7tABSMzt60/ZX9XB0km/uAeFC6
	 Bws7Q5cLmLkEcfgeBQX2+yztuXV08OaGLejevOpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	David Gow <davidgow@google.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 303/695] kthread: fix task state in kthread worker if being frozen
Date: Wed,  2 Oct 2024 14:55:01 +0200
Message-ID: <20241002125834.535950380@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit e16c7b07784f3fb03025939c4590b9a7c64970a7 ]

When analyzing a kernel waring message, Peter pointed out that there is a
race condition when the kworker is being frozen and falls into
try_to_freeze() with TASK_INTERRUPTIBLE, which could trigger a
might_sleep() warning in try_to_freeze().  Although the root cause is not
related to freeze()[1], it is still worthy to fix this issue ahead.

One possible race scenario:

        CPU 0                                           CPU 1
        -----                                           -----

        // kthread_worker_fn
        set_current_state(TASK_INTERRUPTIBLE);
                                                       suspend_freeze_processes()
                                                         freeze_processes
                                                           static_branch_inc(&freezer_active);
                                                         freeze_kernel_threads
                                                           pm_nosig_freezing = true;
        if (work) { //false
          __set_current_state(TASK_RUNNING);

        } else if (!freezing(current)) //false, been frozen

                      freezing():
                      if (static_branch_unlikely(&freezer_active))
                        if (pm_nosig_freezing)
                          return true;
          schedule()
	}

        // state is still TASK_INTERRUPTIBLE
        try_to_freeze()
          might_sleep() <--- warning

Fix this by explicitly set the TASK_RUNNING before entering
try_to_freeze().

Link: https://lore.kernel.org/lkml/Zs2ZoAcUsZMX2B%2FI@chenyu5-mobl2/ [1]
Link: https://lkml.kernel.org/r/20240827112308.181081-1-yu.c.chen@intel.com
Fixes: b56c0d8937e6 ("kthread: implement kthread_worker")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kthread.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index f7be976ff88af..db4ceb0f503cc 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -845,8 +845,16 @@ int kthread_worker_fn(void *worker_ptr)
 		 * event only cares about the address.
 		 */
 		trace_sched_kthread_work_execute_end(work, func);
-	} else if (!freezing(current))
+	} else if (!freezing(current)) {
 		schedule();
+	} else {
+		/*
+		 * Handle the case where the current remains
+		 * TASK_INTERRUPTIBLE. try_to_freeze() expects
+		 * the current to be TASK_RUNNING.
+		 */
+		__set_current_state(TASK_RUNNING);
+	}
 
 	try_to_freeze();
 	cond_resched();
-- 
2.43.0



