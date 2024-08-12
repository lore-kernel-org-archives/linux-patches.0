Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FA915C127;
	Mon, 12 Aug 2024 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480580; cv=none; b=CIIR4OkFO6KPBZhVE0VvkSJfumWIwSrncDLVpU3mkBus43sImab3g5Avj7SUXd1/9UycQA7t6C2NTwMNO3VMmvqOOL4VElLnZwqIbGiB8+gQ5R8JJz2hkBREXvYA0Llo49aqRI8NVEWK7z3DuCSY5waAKCzyA/LDQ8jXqVgXyq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480580; c=relaxed/simple;
	bh=3sDICfwqOPc2774+Yw/bsYRwAjOjm+mDKDlIbZICblU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeCNsYM95Q+qV2cosVyT6yq1baXd5qhbHI4wfWtlAfJktchOdU7AwMfnJ3ronxuuXVioJygRfblokr5snXu3esDVesM3k2zGFIFYSMyYPuV/tpfBq8mAK9QL87HNVp3Vkv+Ag6uOYTHOaFj3aMOwnAi/4oLY0JCBHzNmGzaKzyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyuB7EXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyuB7EXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C70FC32782;
	Mon, 12 Aug 2024 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480580;
	bh=3sDICfwqOPc2774+Yw/bsYRwAjOjm+mDKDlIbZICblU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyuB7EXEKl/MRWtwOGzzlTzgH1J3/a6DYJAl9lEmeUKLsk8gK7mc0s3xPj8PoHOu9
	 mb1pspZCfuyxwl0gHEnJ+GyxYmWbRtJqQwCAxQlktMx4h05BK6z7CyxwAYIIM6GlF6
	 93IBU4Y68kmm3tb/nO0UWi59s4dv4zJ0t1ANyKo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 6.10 239/263] sched/smt: Fix unbalance sched_smt_present dec/inc
Date: Mon, 12 Aug 2024 18:04:00 +0200
Message-ID: <20240812160155.684829713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

commit e22f910a26cc2a3ac9c66b8e935ef2a7dd881117 upstream.

I got the following warn report while doing stress test:

jump label: negative count!
WARNING: CPU: 3 PID: 38 at kernel/jump_label.c:263 static_key_slow_try_dec+0x9d/0xb0
Call Trace:
 <TASK>
 __static_key_slow_dec_cpuslocked+0x16/0x70
 sched_cpu_deactivate+0x26e/0x2a0
 cpuhp_invoke_callback+0x3ad/0x10d0
 cpuhp_thread_fun+0x3f5/0x680
 smpboot_thread_fn+0x56d/0x8d0
 kthread+0x309/0x400
 ret_from_fork+0x41/0x70
 ret_from_fork_asm+0x1b/0x30
 </TASK>

Because when cpuset_cpu_inactive() fails in sched_cpu_deactivate(),
the cpu offline failed, but sched_smt_present is decremented before
calling sched_cpu_deactivate(), it leads to unbalanced dec/inc, so
fix it by incrementing sched_smt_present in the error path.

Fixes: c5511d03ec09 ("sched/smt: Make sched_smt_present track topology")
Cc: stable@kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Link: https://lore.kernel.org/r/20240703031610.587047-3-yangyingliang@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9768,6 +9768,7 @@ int sched_cpu_deactivate(unsigned int cp
 	sched_update_numa(cpu, false);
 	ret = cpuset_cpu_inactive(cpu);
 	if (ret) {
+		sched_smt_present_inc(cpu);
 		balance_push_set(cpu, false);
 		set_cpu_active(cpu, true);
 		sched_update_numa(cpu, true);


