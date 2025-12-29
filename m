Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954F41B6D08;
	Mon, 29 Dec 2025 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025503; cv=none; b=b1fCadIGmq98CiAT5FXHg+udJ+LnFdBmKbUUfX3EPabP2hgk5/szQ3V/vPhymiOHI/rNzQrBRcuW0IPzRfzL2zJmikLaVRMQwggXacuTyt+nIkP88TRfKayB1L2K2MiK6Tp2ryJpBflXhTBpA1QbOjKuY8ZMH9PVa/1Dqp9b05U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025503; c=relaxed/simple;
	bh=d9N7qF4Qtev3ICrbSvz7utvKr6+AF28B9VmoA6YSbiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI3zCc9CrLpT3Zn2iafbrjUXBSKS7jaEJfGDdiw6Rzu9MsPYmF++b4VjgtV8xMw1eQ57sGHHPcYTl5V2tsO8B+G3TybPB07gDUMTnMLmxXryKZa3ab2+03Qty9AmKJemLC6YrHgXEkV9w3ZsZB6AVKjyiGHFBGoY43Jce9iAk+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gq6GXAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gq6GXAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19099C4CEF7;
	Mon, 29 Dec 2025 16:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025503;
	bh=d9N7qF4Qtev3ICrbSvz7utvKr6+AF28B9VmoA6YSbiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gq6GXALveCSN67NAPw3s6i61IOKywwTBniXi6rHXnZai6s53LOnhYSblRQQY2Y3X
	 kgqojSNuPH48R9yx3pY9065X0k3Y7l0NmSQYyWkbjOC00Dx7lFIPQeLXLqJpHgaiEX
	 TuBDFn6+lWzWXlqM4mjCy4IujhJdsoZICgYXrXJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 235/430] sched_ext: Fix bypass depth leak on scx_enable() failure
Date: Mon, 29 Dec 2025 17:10:37 +0100
Message-ID: <20251229160733.002512420@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit 9f769637a93fac81689b80df6855f545839cf999 upstream.

scx_enable() calls scx_bypass(true) to initialize in bypass mode and then
scx_bypass(false) on success to exit. If scx_enable() fails during task
initialization - e.g. scx_cgroup_init() or scx_init_task() returns an error -
it jumps to err_disable while bypass is still active. scx_disable_workfn()
then calls scx_bypass(true/false) for its own bypass, leaving the bypass depth
at 1 instead of 0. This causes the system to remain permanently in bypass mode
after a failed scx_enable().

Failures after task initialization is complete - e.g. scx_tryset_enable_state()
at the end - already call scx_bypass(false) before reaching the error path and
are not affected. This only affects a subset of failure modes.

Fix it by tracking whether scx_enable() called scx_bypass(true) in a bool and
having scx_disable_workfn() call an extra scx_bypass(false) to clear it. This
is a temporary measure as the bypass depth will be moved into the sched
instance, which will make this tracking unnecessary.

Fixes: 8c2090c504e9 ("sched_ext: Initialize in bypass mode")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Chris Mason <clm@meta.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/stable/286e6f7787a81239e1ce2989b52391ce%40kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -40,6 +40,13 @@ static bool scx_init_task_enabled;
 static bool scx_switching_all;
 DEFINE_STATIC_KEY_FALSE(__scx_switched_all);
 
+/*
+ * Tracks whether scx_enable() called scx_bypass(true). Used to balance bypass
+ * depth on enable failure. Will be removed when bypass depth is moved into the
+ * sched instance.
+ */
+static bool scx_bypassed_for_enable;
+
 static atomic_long_t scx_nr_rejected = ATOMIC_LONG_INIT(0);
 static atomic_long_t scx_hotplug_seq = ATOMIC_LONG_INIT(0);
 
@@ -4051,6 +4058,11 @@ static void scx_disable_workfn(struct kt
 	scx_dsp_max_batch = 0;
 	free_kick_pseqs();
 
+	if (scx_bypassed_for_enable) {
+		scx_bypassed_for_enable = false;
+		scx_bypass(false);
+	}
+
 	mutex_unlock(&scx_enable_mutex);
 
 	WARN_ON_ONCE(scx_set_enable_state(SCX_DISABLED) != SCX_DISABLING);
@@ -4676,6 +4688,7 @@ static int scx_enable(struct sched_ext_o
 	 * Init in bypass mode to guarantee forward progress.
 	 */
 	scx_bypass(true);
+	scx_bypassed_for_enable = true;
 
 	for (i = SCX_OPI_NORMAL_BEGIN; i < SCX_OPI_NORMAL_END; i++)
 		if (((void (**)(void))ops)[i])
@@ -4780,6 +4793,7 @@ static int scx_enable(struct sched_ext_o
 	scx_task_iter_stop(&sti);
 	percpu_up_write(&scx_fork_rwsem);
 
+	scx_bypassed_for_enable = false;
 	scx_bypass(false);
 
 	if (!scx_tryset_enable_state(SCX_ENABLED, SCX_ENABLING)) {


