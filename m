Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8749D58C;
	Thu, 17 Sep 2026 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671484; cv=none; b=O/HQAKuE7PeDGVvz0TWydhj2ddUE5R9XOUFD0NxtkQ1FtS1nZ9naLXsbIIOusobHO1WufrW3tuOuRsUGPMKe+il5tliN36h9xb1OWAhlbDkZ/FZ6xqbvAmb1/oCdUQz6dr6xV0VImBKC75mwv7Tu0BpnlxzD+73Ommxxxgs0VtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671484; c=relaxed/simple;
	bh=LDFw92S3k7OurSrGpDIbkQSXlnSqz5aoTWaZKdJPfXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQvkrDX5IQXg6shEanqlyoLY+WQm19H8Tcg3lK8RbqwQ82p+37vTm5hJ6nuEtLBaCRAdW6kfdGxnmzo1KcOpYBwz0LPnK2mP7r2gHp1oSgKWHb9clxGXM+h9LQP5pA3GDmHjlM11OVdlUo6sJRuZoPiDzUFy/H+pm4+9QPRkO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGOdehkb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGOdehkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16401F000FF;
	Thu, 17 Sep 2026 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671483;
	bh=dFzaQRimnhd0LOEwmT2ebk/hbLiY3H8fKVT8BMTPMIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGOdehkbp7spuADjN5BjMdpf7NJ1yUjKI0tr2SvVjqmJoY0l1G4uUbRd+D5mWBdlP
	 aR3Gmx4X0p/oSmASodTNrO2IP7pDK2DuRxeyOLgGUF6q90qhSfOO44Iu0a/94eFCBK
	 6aDeMNcZDd6Up57Tqw/PSykj7SEyt2WA0nMow6oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0991/1102] nscommon: simplify initialization
Date: Thu, 17 Sep 2026 16:15:34 +0100
Message-ID: <20260917151605.594963317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 5612ff3ec588be09f11a9424db6d1186bcdeb3fa ]

There's a lot of information that namespace implementers don't need to
know about at all. Encapsulate this all in the initialization helper.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>

[ sashal: Reduced backport -- upstream 5612ff3ec588b touches 10 file(s), this
  backport carries 1. Not backported here:
  fs/namespace.c
  include/linux/ns_common.h
  ipc/namespace.c
  kernel/cgroup/namespace.c
  kernel/nscommon.c
  kernel/pid_namespace.c
  kernel/time/namespace.c
  kernel/user_namespace.c
  ... and 2 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 9688a4680293 ("pidfd: hold exec_update_lock around namespace ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -115,21 +115,27 @@ static __poll_t pidfd_poll(struct file *
 	return poll_flags;
 }
 
+#define pidfs_ioctl_valid(cmd) \
+	(_IOC_TYPE(cmd) == PIDFS_IOCTL_MAGIC && _IOC_DIR(cmd) == _IOC_NONE && \
+	 _IOC_NR(cmd) >= _IOC_NR(PIDFD_GET_CGROUP_NAMESPACE) && \
+	 _IOC_NR(cmd) <= _IOC_NR(PIDFD_GET_UTS_NAMESPACE))
+
 static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct task_struct *task __free(put_task) = NULL;
 	struct nsproxy *nsp __free(put_nsproxy) = NULL;
-	struct pid *pid = pidfd_pid(file);
 	struct ns_common *ns_common = NULL;
-	struct pid_namespace *pid_ns;
 
-	if (arg)
-		return -EINVAL;
+	if (!pidfs_ioctl_valid(cmd))
+		return -ENOIOCTLCMD;
 
-	task = get_pid_task(pid, PIDTYPE_PID);
+	task = get_pid_task(pidfd_pid(file), PIDTYPE_PID);
 	if (!task)
 		return -ESRCH;
 
+	if (arg)
+		return -EINVAL;
+
 	scoped_guard(task_lock, task) {
 		nsp = task->nsproxy;
 		if (nsp)
@@ -202,13 +208,17 @@ static long pidfd_ioctl(struct file *fil
 		}
 		break;
 	case PIDFD_GET_PID_NAMESPACE:
-		if (IS_ENABLED(CONFIG_PID_NS)) {
+#ifdef CONFIG_PID_NS
+		{
+			struct pid_namespace *pid_ns;
+
 			rcu_read_lock();
 			pid_ns = task_active_pid_ns(task);
 			if (pid_ns)
 				ns_common = to_ns_common(get_pid_ns(pid_ns));
 			rcu_read_unlock();
 		}
+#endif
 		break;
 	default:
 		return -ENOIOCTLCMD;


