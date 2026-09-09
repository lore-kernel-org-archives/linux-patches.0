Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B15D57D20A;
	Wed,  9 Sep 2026 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964495; cv=none; b=skIaQ6+Ugcz9fRd3G/8fi2jqoeIKCqeI8C8XvR4B/TEX+QuwWPWK+C0az9VY80XTdtcOZ5zKvD+SJisSp9QkoxrMh8FTMr2jB40HoaLhdfAihwGidYs0cDJN0GVUi9e40VZc0k1f/OIuUmBCT0ODtthMhvQcJAFDwH6v/saGfiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964495; c=relaxed/simple;
	bh=4bgnhyPSlP025Xkz358UOszXVEgFLVwZ/hj3AxjMfUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4YXTmvKlvStXcvJ/VkyLVWUcq3Fy0v5ovjKJJ+qRQGDXfiO/cd1FCt47VbPtiE37GzfF8GEI8srW0d3Q0vMI7QgLjPvNhiZ9Dwhli/frHCA7BMF2XZ6xR2pSOR6vffayGUxiYPL8LDHwfI+gP6GRLnpJ9/Hay6ju7P5FOPS6VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9MkhUrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9MkhUrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42991F00A3A;
	Wed,  9 Sep 2026 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964494;
	bh=B/cd6Z+qez7zPFLlA2HosG2WM0givNgogGR7qWMt11c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9MkhUrPvnBghI/kkOL8zDIAN76dAuOuOFFb9+78cDHqTe+0Y397NATMW428jDGlX
	 n+aXsfY5iV39/lM9uKIQBjfS7Bd12c5zG4F5OWrbaaPSSRheidMWsN09I9v5ecSW/y
	 haa+E1uYZp8jXfK9aQ9IXgl134tUuhUcTPoc/wOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 443/583] pidfs: simplify PIDFD_GET_<type>_NAMESPACE ioctls
Date: Wed,  9 Sep 2026 15:42:08 +0200
Message-ID: <20260909134253.324449429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a71e4f103aed69e7a11ea913312726bb194c76ee ]

We have reworked namespaces sufficiently that all this special-casing
shouldn't be needed anymore

Link: https://patch.msgid.link/20251117-eidesstattlich-apotheke-36d2e644079f@brauner
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 9688a4680293 ("pidfd: hold exec_update_lock around namespace ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |   75 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -456,7 +456,6 @@ static long pidfd_ioctl(struct file *fil
 	struct task_struct *task __free(put_task) = NULL;
 	struct nsproxy *nsp __free(put_nsproxy) = NULL;
 	struct ns_common *ns_common = NULL;
-	struct pid_namespace *pid_ns;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -498,66 +497,64 @@ static long pidfd_ioctl(struct file *fil
 	switch (cmd) {
 	/* Namespaces that hang of nsproxy. */
 	case PIDFD_GET_CGROUP_NAMESPACE:
-		if (IS_ENABLED(CONFIG_CGROUPS)) {
-			get_cgroup_ns(nsp->cgroup_ns);
-			ns_common = to_ns_common(nsp->cgroup_ns);
-		}
+		if (!ns_ref_get(nsp->cgroup_ns))
+			break;
+		ns_common = to_ns_common(nsp->cgroup_ns);
 		break;
 	case PIDFD_GET_IPC_NAMESPACE:
-		if (IS_ENABLED(CONFIG_IPC_NS)) {
-			get_ipc_ns(nsp->ipc_ns);
-			ns_common = to_ns_common(nsp->ipc_ns);
-		}
+		if (!ns_ref_get(nsp->ipc_ns))
+			break;
+		ns_common = to_ns_common(nsp->ipc_ns);
 		break;
 	case PIDFD_GET_MNT_NAMESPACE:
-		get_mnt_ns(nsp->mnt_ns);
+		if (!ns_ref_get(nsp->mnt_ns))
+			break;
 		ns_common = to_ns_common(nsp->mnt_ns);
 		break;
 	case PIDFD_GET_NET_NAMESPACE:
-		if (IS_ENABLED(CONFIG_NET_NS)) {
-			ns_common = to_ns_common(nsp->net_ns);
-			get_net_ns(ns_common);
-		}
+		if (!ns_ref_get(nsp->net_ns))
+			break;
+		ns_common = to_ns_common(nsp->net_ns);
 		break;
 	case PIDFD_GET_PID_FOR_CHILDREN_NAMESPACE:
-		if (IS_ENABLED(CONFIG_PID_NS)) {
-			get_pid_ns(nsp->pid_ns_for_children);
-			ns_common = to_ns_common(nsp->pid_ns_for_children);
-		}
+		if (!ns_ref_get(nsp->pid_ns_for_children))
+			break;
+		ns_common = to_ns_common(nsp->pid_ns_for_children);
 		break;
 	case PIDFD_GET_TIME_NAMESPACE:
-		if (IS_ENABLED(CONFIG_TIME_NS)) {
-			get_time_ns(nsp->time_ns);
-			ns_common = to_ns_common(nsp->time_ns);
-		}
+		if (!ns_ref_get(nsp->time_ns))
+			break;
+		ns_common = to_ns_common(nsp->time_ns);
 		break;
 	case PIDFD_GET_TIME_FOR_CHILDREN_NAMESPACE:
-		if (IS_ENABLED(CONFIG_TIME_NS)) {
-			get_time_ns(nsp->time_ns_for_children);
-			ns_common = to_ns_common(nsp->time_ns_for_children);
-		}
+		if (!ns_ref_get(nsp->time_ns_for_children))
+			break;
+		ns_common = to_ns_common(nsp->time_ns_for_children);
 		break;
 	case PIDFD_GET_UTS_NAMESPACE:
-		if (IS_ENABLED(CONFIG_UTS_NS)) {
-			get_uts_ns(nsp->uts_ns);
-			ns_common = to_ns_common(nsp->uts_ns);
-		}
+		if (!ns_ref_get(nsp->uts_ns))
+			break;
+		ns_common = to_ns_common(nsp->uts_ns);
 		break;
 	/* Namespaces that don't hang of nsproxy. */
 	case PIDFD_GET_USER_NAMESPACE:
-		if (IS_ENABLED(CONFIG_USER_NS)) {
-			rcu_read_lock();
-			ns_common = to_ns_common(get_user_ns(task_cred_xxx(task, user_ns)));
-			rcu_read_unlock();
+		scoped_guard(rcu) {
+			struct user_namespace *user_ns;
+
+			user_ns = task_cred_xxx(task, user_ns);
+			if (!ns_ref_get(user_ns))
+				break;
+			ns_common = to_ns_common(user_ns);
 		}
 		break;
 	case PIDFD_GET_PID_NAMESPACE:
-		if (IS_ENABLED(CONFIG_PID_NS)) {
-			rcu_read_lock();
+		scoped_guard(rcu) {
+			struct pid_namespace *pid_ns;
+
 			pid_ns = task_active_pid_ns(task);
-			if (pid_ns)
-				ns_common = to_ns_common(get_pid_ns(pid_ns));
-			rcu_read_unlock();
+			if (!ns_ref_get(pid_ns))
+				break;
+			ns_common = to_ns_common(pid_ns);
 		}
 		break;
 	default:


