Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9AB3B27FB;
	Mon, 23 Mar 2026 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274587; cv=none; b=EQmmyacEfgeBEnc66I/K1tJ/E+oSCl8HiL4L5DSeYUnUdPQkiXUHqjvCrInGJVVXy3/pt3bXi4wUi6IRE0hnkVVW/Qu51oDRsFKid+yY+BRepd/9/MXF/9ehuJQv8FBdsPWgTkhSfjT2hpVVcmMMo74oyCkLrNG2ER4oagFS95s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274587; c=relaxed/simple;
	bh=V4m2wKHCm7HLn2PQLYraIo9oPGErUOUtq3Ysgra3DCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO3Wr8BQ+Drq80Z8sf+iK9q3wmSE2DI49o79GRCr+hbn/rwRXkckHDAoSiewv1ludlWb54NYL33P6yOcw8yiw+iqJOYQkBKGkiWiEzgXpd06h+uhby3aW1K7dUphv44kaSupl5tQl+272mbjVJCWlcNVr/VLWizFNWSxJxZf+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y49nD/y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y49nD/y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9843C4CEF7;
	Mon, 23 Mar 2026 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274587;
	bh=V4m2wKHCm7HLn2PQLYraIo9oPGErUOUtq3Ysgra3DCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y49nD/y/I8Joj09o8fPZBPSy6pvxRmDdc1fIRp3Q95VlGtXXPMqqHrN6A4N51zsee
	 hkG6UFePNUzD0DeCCJw1MQYctqLB9P+yqUnQyQoPmYxrkrlQ3vHLgVH5whZd0BrIIi
	 IdTs+YylIhzDLP9EJglPL9YMZzZ8gWgc69+gj2Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/212] sched_ext: Fix starvation of scx_enable() under fair-class saturation
Date: Mon, 23 Mar 2026 14:44:26 +0100
Message-ID: <20260323134505.190598580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

[ Upstream commit b06ccbabe2506fd70b9167a644978b049150224a ]

During scx_enable(), the READY -> ENABLED task switching loop changes the
calling thread's sched_class from fair to ext. Since fair has higher
priority than ext, saturating fair-class workloads can indefinitely starve
the enable thread, hanging the system. This was introduced when the enable
path switched from preempt_disable() to scx_bypass() which doesn't protect
against fair-class starvation. Note that the original preempt_disable()
protection wasn't complete either - in partial switch modes, the calling
thread could still be starved after preempt_enable() as it may have been
switched to ext class.

Fix it by offloading the enable body to a dedicated system-wide RT
(SCHED_FIFO) kthread which cannot be starved by either fair or ext class
tasks. scx_enable() lazily creates the kthread on first use and passes the
ops pointer through a struct scx_enable_cmd containing the kthread_work,
then synchronously waits for completion.

The workfn runs on a different kthread from sch->helper (which runs
disable_work), so it can safely flush disable_work on the error path
without deadlock.

Fixes: 8c2090c504e9 ("sched_ext: Initialize in bypass mode")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   66 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 10 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4598,20 +4598,30 @@ static int validate_ops(struct scx_sched
 	return 0;
 }
 
-static int scx_enable(struct sched_ext_ops *ops, struct bpf_link *link)
+/*
+ * scx_enable() is offloaded to a dedicated system-wide RT kthread to avoid
+ * starvation. During the READY -> ENABLED task switching loop, the calling
+ * thread's sched_class gets switched from fair to ext. As fair has higher
+ * priority than ext, the calling thread can be indefinitely starved under
+ * fair-class saturation, leading to a system hang.
+ */
+struct scx_enable_cmd {
+	struct kthread_work	work;
+	struct sched_ext_ops	*ops;
+	int			ret;
+};
+
+static void scx_enable_workfn(struct kthread_work *work)
 {
+	struct scx_enable_cmd *cmd =
+		container_of(work, struct scx_enable_cmd, work);
+	struct sched_ext_ops *ops = cmd->ops;
 	struct scx_sched *sch;
 	struct scx_task_iter sti;
 	struct task_struct *p;
 	unsigned long timeout;
 	int i, cpu, ret;
 
-	if (!cpumask_equal(housekeeping_cpumask(HK_TYPE_DOMAIN),
-			   cpu_possible_mask)) {
-		pr_err("sched_ext: Not compatible with \"isolcpus=\" domain isolation\n");
-		return -EINVAL;
-	}
-
 	mutex_lock(&scx_enable_mutex);
 
 	if (scx_enable_state() != SCX_DISABLED) {
@@ -4828,13 +4838,15 @@ static int scx_enable(struct sched_ext_o
 
 	atomic_long_inc(&scx_enable_seq);
 
-	return 0;
+	cmd->ret = 0;
+	return;
 
 err_free_pseqs:
 	free_kick_pseqs();
 err_unlock:
 	mutex_unlock(&scx_enable_mutex);
-	return ret;
+	cmd->ret = ret;
+	return;
 
 err_disable_unlock_all:
 	scx_cgroup_unlock();
@@ -4853,7 +4865,41 @@ err_disable:
 	 */
 	scx_error(sch, "scx_enable() failed (%d)", ret);
 	kthread_flush_work(&sch->disable_work);
-	return 0;
+	cmd->ret = 0;
+}
+
+static int scx_enable(struct sched_ext_ops *ops, struct bpf_link *link)
+{
+	static struct kthread_worker *helper;
+	static DEFINE_MUTEX(helper_mutex);
+	struct scx_enable_cmd cmd;
+
+	if (!cpumask_equal(housekeeping_cpumask(HK_TYPE_DOMAIN),
+			   cpu_possible_mask)) {
+		pr_err("sched_ext: Not compatible with \"isolcpus=\" domain isolation\n");
+		return -EINVAL;
+	}
+
+	if (!READ_ONCE(helper)) {
+		mutex_lock(&helper_mutex);
+		if (!helper) {
+			helper = kthread_run_worker(0, "scx_enable_helper");
+			if (IS_ERR_OR_NULL(helper)) {
+				helper = NULL;
+				mutex_unlock(&helper_mutex);
+				return -ENOMEM;
+			}
+			sched_set_fifo(helper->task);
+		}
+		mutex_unlock(&helper_mutex);
+	}
+
+	kthread_init_work(&cmd.work, scx_enable_workfn);
+	cmd.ops = ops;
+
+	kthread_queue_work(READ_ONCE(helper), &cmd.work);
+	kthread_flush_work(&cmd.work);
+	return cmd.ret;
 }
 
 


