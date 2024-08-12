Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89A186295;
	Mon, 12 Aug 2024 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479182; cv=none; b=d65EyMEZaf5MBi1qash67f/xhmPSFNN4eXHNtBrfKDCEigBq1ISTo9rbUjLi4/TLR6UyMm5sWB1gjRzMYrvnHDPDCC5K/ICKCvkdSFwcHEm8hk1vCihO8EOla4qBu23gVmso4MjfHphhXRtgA4E8DNtWKnLBA8hAEKTL295y8Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479182; c=relaxed/simple;
	bh=MCtJFa6GHyTyNaktMbWIDTPDjnCON0l424VwO7vJBiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUuczXRoQADVc0hUy3/N+MNPlfi7xtt7xv7BBpq5gV9fdnMRvROL7eILWtnI+kGnNNiRrRxhHJHoQx+WNZcTHqaD3Cqx0QDWe5J7Z5UVwjRwxD8FzbxNipxaEAB4lbwgd5dpPXxzfmn3oXk0OGyOL29vM7spAOdbH44WFHcLk9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPTj/ng2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPTj/ng2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF394C32782;
	Mon, 12 Aug 2024 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479182;
	bh=MCtJFa6GHyTyNaktMbWIDTPDjnCON0l424VwO7vJBiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPTj/ng2RAcatFliKmZifoMDk2TQda+UnBJirGGuiL6axRa4qELzFLuEEIowHvfdS
	 JLEz7x+rmGe15jbuL4oeaPnhv+yEjcwt2RIrVPxIP/b8sMGfjxwUA5fBu0TGqocqAh
	 pqFyuKUlv4TSNmGgtWNHJdjhZvfVSuBDUNK/boBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 6.1 123/150] sched/smt: Fix unbalance sched_smt_present dec/inc
Date: Mon, 12 Aug 2024 18:03:24 +0200
Message-ID: <20240812160129.909287082@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9513,6 +9513,7 @@ int sched_cpu_deactivate(unsigned int cp
 	sched_update_numa(cpu, false);
 	ret = cpuset_cpu_inactive(cpu);
 	if (ret) {
+		sched_smt_present_inc(cpu);
 		balance_push_set(cpu, false);
 		set_cpu_active(cpu, true);
 		sched_update_numa(cpu, true);


