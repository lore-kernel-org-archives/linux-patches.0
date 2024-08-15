Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23F419F49A;
	Thu, 15 Aug 2024 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730562; cv=none; b=My+ym9BF3gAcx9alpqufWOdShWBxszN+XniWFsF9qQm8OkIPhJqk3E/Tk4m++5ctAY/ca8NwKR9M5TRSCH3q6zQVh5Cn3cJ9hbKgYv8qkGYm4BhMgzmhi76ftUeQNMYCDPPuBjxfXgdIFglWCTCuBapT+fZl1bt24afn1VwKUSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730562; c=relaxed/simple;
	bh=/1IN5a6R0N+HqjqfI0Kb+2CiLR0oznnInf8uMeUgj3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLftbU0wHuTmKC4FG/SiPJ6qjO0Yjfd9hIxU0OfrAxtlMerx1krGMmaxnDMvqdJHszMCsvvOaWJcHjGL+ym+30J4FbQSZOVl/VFUhMPyY1jzU5bej32etGSsOl4MFHst73au1eDQzVIde4quVFTtNxKvs8aLbX7b8OOaDmF6s/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNIRCpF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNIRCpF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009C2C32786;
	Thu, 15 Aug 2024 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730562;
	bh=/1IN5a6R0N+HqjqfI0Kb+2CiLR0oznnInf8uMeUgj3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNIRCpF6MN1xbiP5t1tGD4Jj3dWEbG8T2Kb5YMN3BNt7Y5Eshbppk3hEmMWft5qpo
	 8/cRyJH980xgMspwBxBEIkGiKv7Uh0IAhc8FSyEA7f9HQ5vVmOK77DJcjsLhBu79cB
	 GNa7gFPwRO2+0fhxzZL6mhZ+iLxe5dUn7URA/PJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 5.15 448/484] sched/smt: Fix unbalance sched_smt_present dec/inc
Date: Thu, 15 Aug 2024 15:25:06 +0200
Message-ID: <20240815131958.763700108@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9214,6 +9214,7 @@ int sched_cpu_deactivate(unsigned int cp
 
 	ret = cpuset_cpu_inactive(cpu);
 	if (ret) {
+		sched_smt_present_inc(cpu);
 		balance_push_set(cpu, false);
 		set_cpu_active(cpu, true);
 		return ret;


