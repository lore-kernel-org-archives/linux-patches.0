Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73853FF1A2;
	Fri, 15 May 2026 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860474; cv=none; b=CuW33ryIlus6KeJj75UDtM+t5d9KY2Wj5ssHWGqrnk1aFHH+2TUbTEQcIWIIcAfPBaQ8jPOdGPtx1mW36EPjBxo+AGZBumoM3M5ckEy4qq/V70rBP8fnv/WPVJz0khpSfie+iAiCrZU6dJnz5G0K7WQjxs/HPC0NMCjnqHtjY/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860474; c=relaxed/simple;
	bh=e9aDpsWz5dG0aH4MU0ej6j08vswzxNgURvu5SQSRGjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf1+BXqq16u9ScwziKSmOTVmFmgVMm6LbPUl17iaTLnTEWPpPsnn1Hope3nJfmOMHKfYV1z7ztoHIhA4qcDDqwFgUHCCeKmD7p9dG4XSagN7VagCk0eLDTvDCI1e0IaKihekYyO1GLsaKzf/ULT6MiMx/9UP9Xzc06cjknjBWX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKPcNg+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKPcNg+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D250C2BCB0;
	Fri, 15 May 2026 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860474;
	bh=e9aDpsWz5dG0aH4MU0ej6j08vswzxNgURvu5SQSRGjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKPcNg+9DDKIqSyQ1Ynwd1tNbFSDfH5/IHlihjR09nztDy/wvJcANvfCGw3v3qbsE
	 DmNJxeTc/9SawOi87fCmGOjqf+q5B7gRNVfebC+ziWcUkLgNFBgt7nmW1JDkI6/M/R
	 FK0tOuYUqYKJJ0YQg6hL+OE1bXzidOepMgL+IAQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 6.12 101/144] sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation
Date: Fri, 15 May 2026 17:48:47 +0200
Message-ID: <20260515154655.843155146@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 6ae315d37924435516d697ea7dde0b799a5928e0 upstream.

scx_enable() refuses to attach a BPF scheduler when isolcpus=domain is
in effect by comparing housekeeping_cpumask(HK_TYPE_DOMAIN) against
cpu_possible_mask.

Since commit 27c3a5967f05 ("sched/isolation: Convert housekeeping
cpumasks to rcu pointers"), HK_TYPE_DOMAIN's cpumask is RCU protected
and dereferencing it requires either RCU read lock, the cpu_hotplug
write lock, or the cpuset lock; scx_enable() holds none of these, so
booting with isolcpus=domain and attaching any BPF scheduler triggers
the following lockdep splat:

  =============================
  WARNING: suspicious RCU usage
  -----------------------------
  kernel/sched/isolation.c:60 suspicious rcu_dereference_check() usage!

  1 lock held by scx_flash/281:
   #0: ffffffff8379fce0 (update_mutex){+.+.}-{4:4}, at:
       bpf_struct_ops_link_create+0x134/0x1c0

  Call Trace:
   dump_stack_lvl+0x6f/0xb0
   lockdep_rcu_suspicious.cold+0x37/0x70
   housekeeping_cpumask+0xcd/0xe0
   scx_enable.isra.0+0x17/0x120
   bpf_scx_reg+0x5e/0x80
   bpf_struct_ops_link_create+0x151/0x1c0
   __sys_bpf+0x1e4b/0x33c0
   __x64_sys_bpf+0x21/0x30
   do_syscall_64+0x117/0xf80
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

In addition, commit 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask
from cpuset") made HK_TYPE_DOMAIN include cpuset isolated partitions as
well, which means the current check also rejects BPF schedulers when a
cpuset partition is active. That contradicts the original intent of
commit 9f391f94a173 ("sched_ext: Disallow loading BPF scheduler if
isolcpus= domain isolation is in effect"), which explicitly noted that
cpuset partitions are honored through per-task cpumasks and should not
be rejected.

Switch to housekeeping_enabled(HK_TYPE_DOMAIN_BOOT), which reads only
the housekeeping flag bit (no RCU dereference) and reflects exactly the
boot-time isolcpus= configuration that the error message refers to.

Fixes: 27c3a5967f05 ("sched/isolation: Convert housekeeping cpumasks to rcu pointers")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5521,8 +5521,7 @@ static int scx_ops_enable(struct sched_e
 	static DEFINE_MUTEX(helper_mutex);
 	struct scx_enable_cmd cmd;
 
-	if (!cpumask_equal(housekeeping_cpumask(HK_TYPE_DOMAIN),
-			   cpu_possible_mask)) {
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
 		pr_err("sched_ext: Not compatible with \"isolcpus=\" domain isolation\n");
 		return -EINVAL;
 	}


