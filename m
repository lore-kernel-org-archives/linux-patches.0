Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203AF3AF663;
	Mon, 23 Mar 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276922; cv=none; b=tbncVeypo2U3T1V4kmASBZBySoFKsGTpa8jBFQOjn6KlkGuwwnUMmpLJMyjjchh353NVsUQLhVDOvTJ/n2B419zVEPGUWaHGrs8OMUZYmphp6elCKTHOJXq9WUePesrDG9mK+qtj6+edq9Y49ZZjwEqHvHI/2K/QvEHfQTZhqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276922; c=relaxed/simple;
	bh=oDZaVU/0tPFimNYgiZbL83GhW5WELR77ywn/FxFoklU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHml1ZW/adUWsdB04xD+3K/lC6TjDm1jmNKBTar5f9av88ODX0n6oxXz4dLbIoCWNo+Z0Jxuw4c63pA7ATa/NYJqTqccIYq7IWYc3E3yML1wRxkha06ZT08xar4SuVY15qKH8FFrVyJ1aJb/uz+JZ/y2Leu93r3g5jc31qtXRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kl48hgx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kl48hgx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE37C4CEF7;
	Mon, 23 Mar 2026 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276922;
	bh=oDZaVU/0tPFimNYgiZbL83GhW5WELR77ywn/FxFoklU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kl48hgx5PmLTtqM8tVMHxe8HgqCtdT2uG84TUyDKM2b0PX4fYp3PhlOtITO53GNEN
	 byIqKwM94cXyvE+2ZK+lArpRAx1iDRqm96Dw5eB6qr9jR+GYb7ttZqwioPyNN36IBK
	 6ymK4GOOmt6zr03vOdFQKHrLaoGn6v6ioyG8oeJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/460] sched_ext: Fix starvation of scx_enable() under fair-class saturation
Date: Mon, 23 Mar 2026 14:44:12 +0100
Message-ID: <20260323134532.781223608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
[ adapted per-scheduler scx_sched struct references to globals ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   64 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 10 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5166,19 +5166,29 @@ static int validate_ops(const struct sch
 	return 0;
 }
 
-static int scx_ops_enable(struct sched_ext_ops *ops, struct bpf_link *link)
+/*
+ * scx_ops_enable() is offloaded to a dedicated system-wide RT kthread to avoid
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
+static void scx_ops_enable_workfn(struct kthread_work *work)
 {
+	struct scx_enable_cmd *cmd =
+		container_of(work, struct scx_enable_cmd, work);
+	struct sched_ext_ops *ops = cmd->ops;
 	struct scx_task_iter sti;
 	struct task_struct *p;
 	unsigned long timeout;
 	int i, cpu, node, ret;
 
-	if (!cpumask_equal(housekeeping_cpumask(HK_TYPE_DOMAIN),
-			   cpu_possible_mask)) {
-		pr_err("sched_ext: Not compatible with \"isolcpus=\" domain isolation\n");
-		return -EINVAL;
-	}
-
 	mutex_lock(&scx_ops_enable_mutex);
 
 	if (!scx_ops_helper) {
@@ -5445,7 +5455,8 @@ static int scx_ops_enable(struct sched_e
 
 	atomic_long_inc(&scx_enable_seq);
 
-	return 0;
+	cmd->ret = 0;
+	return;
 
 err_del:
 	kobject_del(scx_root_kobj);
@@ -5458,7 +5469,8 @@ err:
 	}
 err_unlock:
 	mutex_unlock(&scx_ops_enable_mutex);
-	return ret;
+	cmd->ret = ret;
+	return;
 
 err_disable_unlock_all:
 	scx_cgroup_unlock();
@@ -5477,7 +5489,39 @@ err_disable:
 	 */
 	scx_ops_error("scx_ops_enable() failed (%d)", ret);
 	kthread_flush_work(&scx_ops_disable_work);
-	return 0;
+	cmd->ret = 0;
+}
+
+static int scx_ops_enable(struct sched_ext_ops *ops, struct bpf_link *link)
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
+			helper = scx_create_rt_helper("scx_ops_enable_helper");
+			if (!helper) {
+				mutex_unlock(&helper_mutex);
+				return -ENOMEM;
+			}
+		}
+		mutex_unlock(&helper_mutex);
+	}
+
+	kthread_init_work(&cmd.work, scx_ops_enable_workfn);
+	cmd.ops = ops;
+
+	kthread_queue_work(READ_ONCE(helper), &cmd.work);
+	kthread_flush_work(&cmd.work);
+	return cmd.ret;
 }
 
 


