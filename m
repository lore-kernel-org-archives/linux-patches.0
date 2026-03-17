Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A5F3F0778;
	Tue, 17 Mar 2026 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766561; cv=none; b=j9frxDmLSDXsuiYRegMWvQgyl69HCfxwHZWvumDj1MnDn52d4xrg5n7eKh1uAbs0Boh2Wm0N467zj8pXTGFO8VxuN1Anq4dVsLhiJ6rNN1TxMCVYdPhnqb8ti1jfLEq3pFolXCzdtg39nNFSF7dtQt6+KaGJbUmmckMViqrLpDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766561; c=relaxed/simple;
	bh=AX+Z0EZJu3si1/IfEPPYxGyJ26rjVFafCO3PjtKQilE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovYEYY6Jmm3532KcGz/znTfvp24yMDiNv6zBNFoxCfHrt9l5++SLJZHe+SGEGOMs6v2TKhUrWlm6C44L9Eb9WdlMebOiBhNzhaKSCTIodSJsr9u0vF5KTpyx554azBA0emZcnYz8+60GD7yDSmxaZxznv5GZszvbm5AShwVlpZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZntN1JB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZntN1JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46F8C4CEF7;
	Tue, 17 Mar 2026 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766561;
	bh=AX+Z0EZJu3si1/IfEPPYxGyJ26rjVFafCO3PjtKQilE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZntN1JBubo6UN0y2grZMIJgFi0kSfbroJICrIQuE/WpDCMPZMHG7EqbHMSpZU9pm
	 Y5KLUO5we2EQ+9e2ZvyjYv7o2dnjUqX1/7QgYw+A9H+fYhIhYhQw5Qde9PYPpYn9NT
	 DkqJwfCBKw8cZV9wOsD2VWTLotzUmcNj9a+kL6sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.19 240/378] sched_ext: Fix starvation of scx_enable() under fair-class saturation
Date: Tue, 17 Mar 2026 17:33:17 +0100
Message-ID: <20260317163015.844144806@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit b06ccbabe2506fd70b9167a644978b049150224a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   66 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 10 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4935,20 +4935,30 @@ static int validate_ops(struct scx_sched
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
@@ -5165,13 +5175,15 @@ static int scx_enable(struct sched_ext_o
 
 	atomic_long_inc(&scx_enable_seq);
 
-	return 0;
+	cmd->ret = 0;
+	return;
 
 err_free_ksyncs:
 	free_kick_syncs();
 err_unlock:
 	mutex_unlock(&scx_enable_mutex);
-	return ret;
+	cmd->ret = ret;
+	return;
 
 err_disable_unlock_all:
 	scx_cgroup_unlock();
@@ -5190,7 +5202,41 @@ err_disable:
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
 
 


