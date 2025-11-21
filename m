Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E83F343D67;
	Fri, 21 Nov 2025 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732353; cv=none; b=dNf7r5ahJkbCkyTCdTPbmjKXO2LRHS4zPtGfpLqA/GGTxTBxeTZ8zKUnXmPu356yph5w0Ini5HARvoI8Ad98Qu9ZgLoHQC8aKbR+XngCJGsHaIYpHK7Fa31Mq6QIDRF6a1DOBKqYnYpkZVK5nfWzUL5AFV9xxKKRnzJefTXUsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732353; c=relaxed/simple;
	bh=/hk3Th95ze73wNc1K9I7mL143K58Of+kElEtahUyGvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Rwex5jpyLASg0ReFGe03mmkWfzDN1iD/LiT26tlCOV/DGhN/bCrm2CdKjjIyxmi3sIg3lb8PCubEj6Ih1TtPhMc2f/uwG/k5IGVEyW85ItQvmX6xHWfpsAF9QjRb+yR1KYo+/choBwheVqBYEP6Uq4nUreF8/LTgPbdNhFW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afa9+arM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afa9+arM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A9FC4CEF1;
	Fri, 21 Nov 2025 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732353;
	bh=/hk3Th95ze73wNc1K9I7mL143K58Of+kElEtahUyGvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afa9+arMoGH+y8RF0Jz8tTgTgkEkN0Iyyz1jNqf9l7CnP9PjAW0riWmCnnVl2aS8S
	 zRKGf6pU1hUjPWaIR80A1fAMCREjx7OU7yRG4itEDK2iDtV+bB79IEzfPk2DRCA3Vw
	 5Vnxgd+I1PsN/zrw/1D6tRsc7J2u8sAjJc48b2IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Schatzberg <dschatzberg@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/529] bpf: Do not limit bpf_cgroup_from_id to currents namespace
Date: Fri, 21 Nov 2025 14:06:29 +0100
Message-ID: <20251121130234.231179109@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 2c895133950646f45e5cf3900b168c952c8dbee8 ]

The bpf_cgroup_from_id kfunc relies on cgroup_get_from_id to obtain the
cgroup corresponding to a given cgroup ID. This helper can be called in
a lot of contexts where the current thread can be random. A recent
example was its use in sched_ext's ops.tick(), to obtain the root cgroup
pointer. Since the current task can be whatever random user space task
preempted by the timer tick, this makes the behavior of the helper
unreliable.

Refactor out __cgroup_get_from_id as the non-namespace aware version of
cgroup_get_from_id, and change bpf_cgroup_from_id to make use of it.

There is no compatibility breakage here, since changing the namespace
against which the lookup is being done to the root cgroup namespace only
permits a wider set of lookups to succeed now. The cgroup IDs across
namespaces are globally unique, and thus don't need to be retranslated.

Reported-by: Dan Schatzberg <dschatzberg@meta.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250915032618.1551762-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup.h |  1 +
 kernel/bpf/helpers.c   |  2 +-
 kernel/cgroup/cgroup.c | 24 ++++++++++++++++++++----
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b307013b9c6c9..fa87b6a15082c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -633,6 +633,7 @@ static inline void cgroup_kthread_ready(void)
 }
 
 void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
+struct cgroup *__cgroup_get_from_id(u64 id);
 struct cgroup *cgroup_get_from_id(u64 id);
 #else /* !CONFIG_CGROUPS */
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 90c281e1379ee..2cfbc48b82425 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2276,7 +2276,7 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 {
 	struct cgroup *cgrp;
 
-	cgrp = cgroup_get_from_id(cgid);
+	cgrp = __cgroup_get_from_id(cgid);
 	if (IS_ERR(cgrp))
 		return NULL;
 	return cgrp;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5135838b5899f..476be99dbcf1b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6220,15 +6220,15 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 }
 
 /*
- * cgroup_get_from_id : get the cgroup associated with cgroup id
+ * __cgroup_get_from_id : get the cgroup associated with cgroup id
  * @id: cgroup id
  * On success return the cgrp or ERR_PTR on failure
- * Only cgroups within current task's cgroup NS are valid.
+ * There are no cgroup NS restrictions.
  */
-struct cgroup *cgroup_get_from_id(u64 id)
+struct cgroup *__cgroup_get_from_id(u64 id)
 {
 	struct kernfs_node *kn;
-	struct cgroup *cgrp, *root_cgrp;
+	struct cgroup *cgrp;
 
 	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
@@ -6250,6 +6250,22 @@ struct cgroup *cgroup_get_from_id(u64 id)
 
 	if (!cgrp)
 		return ERR_PTR(-ENOENT);
+	return cgrp;
+}
+
+/*
+ * cgroup_get_from_id : get the cgroup associated with cgroup id
+ * @id: cgroup id
+ * On success return the cgrp or ERR_PTR on failure
+ * Only cgroups within current task's cgroup NS are valid.
+ */
+struct cgroup *cgroup_get_from_id(u64 id)
+{
+	struct cgroup *cgrp, *root_cgrp;
+
+	cgrp = __cgroup_get_from_id(id);
+	if (IS_ERR(cgrp))
+		return cgrp;
 
 	root_cgrp = current_cgns_cgroup_dfl();
 	if (!cgroup_is_descendant(cgrp, root_cgrp)) {
-- 
2.51.0



