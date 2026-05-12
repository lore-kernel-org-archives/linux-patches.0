Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A7F3EDE53;
	Tue, 12 May 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608768; cv=none; b=XvKoixFpQNPcGnovVvrF1ZH0gz8hhqmxmLyrJkI2cqQMRk3S3PkQukmek/z42jI6DvID8bbxXYpBlm7FfrHaoBq/zdYwPguVXaU3sBS+Th9wnxw8onNWBrRefPHdA+8b4YFrnhKIuzBYHBHGE+V9v6h8ajzIx0miB236i3ZLt38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608768; c=relaxed/simple;
	bh=zEOd1SNMzFoE9/0RgMeoL4hT4hcI8HmM/xLAx6Z/ujs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpKxceggYEDTzwMq1tqQpzdNk2NePsPla7QcvlK0vfIojLE9rS3Kkpw9uKkn8S06Bihgmdg8wrBkD/NJZZ/kAp7Bj/osCpGMaTYtmWfh1M3mo/hvf5d08r8P3lm+DoBzySo8JYztCxbrac5PDagaFrWXwv5Rb2RRxz4Gijrx8ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byEytRD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byEytRD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A4BC2BCB0;
	Tue, 12 May 2026 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608767;
	bh=zEOd1SNMzFoE9/0RgMeoL4hT4hcI8HmM/xLAx6Z/ujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byEytRD9f1ln29Dk44bCaXNvXPuWSaIbgGJrUwwZTeBLYIPFgBi+BI2IFvI0w7dec
	 lR7aqloMOaN8LR9IEY/i4SpMGgUsJfxLtIerrP7ScshcrP2mfOjWcfVxbVTCzRVHsy
	 qSxJEEyEfFPfhlyPrUPtZFiH5PFVhZSvUwvQpIMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Claude <noreply@anthropic.com>
Subject: [PATCH 6.18 205/270] sched_ext: idle: Recheck prev_cpu after narrowing allowed mask
Date: Tue, 12 May 2026 19:40:06 +0200
Message-ID: <20260512173942.766336095@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit b34c82777a2c0648ee053595f4b290fd5249b093 upstream.

scx_select_cpu_dfl() narrows @allowed to @cpus_allowed & @p->cpus_ptr
when the BPF caller supplies a @cpus_allowed that differs from
@p->cpus_ptr and @p doesn't have full affinity. However,
@is_prev_allowed was computed against the original (wider)
@cpus_allowed, so the prev_cpu fast paths could pick a @prev_cpu that
is in @cpus_allowed but not in @p->cpus_ptr, violating the intended
invariant that the returned CPU is always usable by @p. The kernel
masks this via the SCX_EV_SELECT_CPU_FALLBACK fallback, but the
behavior contradicts the documented contract.

Move the @is_prev_allowed evaluation past the narrowing block so it
tests against the final @allowed mask.

Fixes: ee9a4e92799d ("sched_ext: idle: Properly handle invalid prev_cpu during idle selection")
Cc: stable@vger.kernel.org # v6.16+
Assisted-by: Claude <noreply@anthropic.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext_idle.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -460,12 +460,6 @@ s32 scx_select_cpu_dfl(struct task_struc
 	preempt_disable();
 
 	/*
-	 * Check whether @prev_cpu is still within the allowed set. If not,
-	 * we can still try selecting a nearby CPU.
-	 */
-	is_prev_allowed = cpumask_test_cpu(prev_cpu, allowed);
-
-	/*
 	 * Determine the subset of CPUs usable by @p within @cpus_allowed.
 	 */
 	if (allowed != p->cpus_ptr) {
@@ -482,6 +476,12 @@ s32 scx_select_cpu_dfl(struct task_struc
 	}
 
 	/*
+	 * Check whether @prev_cpu is still within the allowed set. If not,
+	 * we can still try selecting a nearby CPU.
+	 */
+	is_prev_allowed = cpumask_test_cpu(prev_cpu, allowed);
+
+	/*
 	 * This is necessary to protect llc_cpus.
 	 */
 	rcu_read_lock();


