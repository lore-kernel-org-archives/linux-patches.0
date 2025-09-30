Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C21266B65;
	Tue, 30 Sep 2025 15:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244873; cv=none; b=DS+2ELKYldj/MoqJ/NGCkyBq6l92ao/OOwUiAHH9JXQYOLcVc6uqDv+uuS0N3aP8MQjD58BuDR/AFVr+IxN3fI8nZfxSsbMLYYextrd8WEexzDhQ2/TjUNA7tP5FMnGi7tv7bFOWsQzYGaf20L4jLUE0khWbRovlmlF85fJccU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244873; c=relaxed/simple;
	bh=uxVb6r/5c4Ur1qiWLzB577U1bDX4F0zNIGDt7qfHpGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLhAln+ZhuIl2l0aOUw9DR1nOkYvcWxNlN75BM5lrATl+6J5PNRA1gFhKahYAOsjx8/fLQNUnwz2wLLrPvbjXsEIfX44X6SRAwXoUFlEISE9xzYhdFPvwbGfs4l+9u3ClGCxwT6yvpJEemDks42zwEMek6aiUaKsljBWJNNVYWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJkFWIlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJkFWIlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FFBC4CEF0;
	Tue, 30 Sep 2025 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244872;
	bh=uxVb6r/5c4Ur1qiWLzB577U1bDX4F0zNIGDt7qfHpGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJkFWIlHPBcTQRFYODh3Y0j9+9sBBYTD9TDuFYljA5sxuaseoJwoyz35V/A5hnsxa
	 GCiyJDmWtoHKfS0sv//PFrgoFdspjWdS+qyLhc/Ea2DurVg4nIie/P1ZMFpg7y/ED0
	 tPbvZORvyIlCJl9+YG7Sw6OgiO7bK0m8+Soj3vuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.16 140/143] sched_ext: idle: Handle migration-disabled tasks in BPF code
Date: Tue, 30 Sep 2025 16:47:44 +0200
Message-ID: <20250930143836.817290142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 55ed11b181c43d81ce03b50209e4e7c4a14ba099 upstream.

When scx_bpf_select_cpu_dfl()/and() kfuncs are invoked outside of
ops.select_cpu() we can't rely on @p->migration_disabled to determine if
migration is disabled for the task @p.

In fact, migration is always disabled for the current task while running
BPF code: __bpf_prog_enter() disables migration and __bpf_prog_exit()
re-enables it.

To handle this, when @p->migration_disabled == 1, check whether @p is
the current task. If so, migration was not disabled before entering the
callback, otherwise migration was disabled.

This ensures correct idle CPU selection in all cases. The behavior of
ops.select_cpu() remains unchanged, because this callback is never
invoked for the current task and migration-disabled tasks are always
excluded.

Example: without this change scx_bpf_select_cpu_and() called from
ops.enqueue() always returns -EBUSY; with this change applied, it
correctly returns idle CPUs.

Fixes: 06efc9fe0b8de ("sched_ext: idle: Handle migration-disabled tasks in idle selection")
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Changwoo Min <changwoo@igalia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext_idle.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -870,6 +870,32 @@ static bool check_builtin_idle_enabled(v
 	return false;
 }
 
+/*
+ * Determine whether @p is a migration-disabled task in the context of BPF
+ * code.
+ *
+ * We can't simply check whether @p->migration_disabled is set in a
+ * sched_ext callback, because migration is always disabled for the current
+ * task while running BPF code.
+ *
+ * The prolog (__bpf_prog_enter) and epilog (__bpf_prog_exit) respectively
+ * disable and re-enable migration. For this reason, the current task
+ * inside a sched_ext callback is always a migration-disabled task.
+ *
+ * Therefore, when @p->migration_disabled == 1, check whether @p is the
+ * current task or not: if it is, then migration was not disabled before
+ * entering the callback, otherwise migration was disabled.
+ *
+ * Returns true if @p is migration-disabled, false otherwise.
+ */
+static bool is_bpf_migration_disabled(const struct task_struct *p)
+{
+	if (p->migration_disabled == 1)
+		return p != current;
+	else
+		return p->migration_disabled;
+}
+
 static s32 select_cpu_from_kfunc(struct task_struct *p, s32 prev_cpu, u64 wake_flags,
 				 const struct cpumask *allowed, u64 flags)
 {
@@ -913,7 +939,7 @@ static s32 select_cpu_from_kfunc(struct
 	 * selection optimizations and simply check whether the previously
 	 * used CPU is idle and within the allowed cpumask.
 	 */
-	if (p->nr_cpus_allowed == 1 || is_migration_disabled(p)) {
+	if (p->nr_cpus_allowed == 1 || is_bpf_migration_disabled(p)) {
 		if (cpumask_test_cpu(prev_cpu, allowed ?: p->cpus_ptr) &&
 		    scx_idle_test_and_clear_cpu(prev_cpu))
 			cpu = prev_cpu;


