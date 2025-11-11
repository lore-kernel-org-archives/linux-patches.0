Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174D1248883;
	Tue, 11 Nov 2025 01:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822851; cv=none; b=eDAiXWM90GH9nJGWez+sOCs0oTgEX/C/z/y15qmQGpxGRplBh4Iu3lSY6QpF4Vww9NSkX0YpdpvwLdedUbCbhaVLi7wuiwIqcCarsb0A4adTZ3Kb1OpFnYtHtxwthC/v6C78MDUO3IR6eegtB0000uMO/kOSN3na3Y9VFSkG1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822851; c=relaxed/simple;
	bh=mEeo1wPsmBoGJRcQSLv+gK8bYz+bN/ck4QJ8FO4q4Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4WUt8ecazcrzWHDqHXDAe1UcuJIH4kqS1MP5UJ8EoWMrC3So7XAQ9WzeOjUWVJIXk0bJ+Ykcjl/BUyEQSBpbdjhZTnO208+E4WCDoRjcvS72dUVNAztLRkwVkONbXEx/vqUxoSs461zq3u7WkAxY94F0uVUq1CUYYvBsRDJFOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFz6cdYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFz6cdYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47F8C4CEF5;
	Tue, 11 Nov 2025 01:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822850;
	bh=mEeo1wPsmBoGJRcQSLv+gK8bYz+bN/ck4QJ8FO4q4Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFz6cdYOo0SdugZxlleZTadiadHSjt5LxUENNQ1Rkxc5p0si9GFQs+cVZkDN2LtRO
	 VGWLNGgUQOJeZA/kiz4fT5nxDgxW6DyOO83YG5Fkx8ICyB6XhT/3zs7b4PYjzzWK86
	 kqAAZk51sIQXT3bAD75IZEVczJH/awAu2+IIPVzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Schatzberg <dschatzberg@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 183/849] bpf: Do not limit bpf_cgroup_from_id to currents namespace
Date: Tue, 11 Nov 2025 09:35:53 +0900
Message-ID: <20251111004540.853545540@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b18fb5fcb38e2..b08c8e62881cd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -650,6 +650,7 @@ static inline void cgroup_kthread_ready(void)
 }
 
 void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
+struct cgroup *__cgroup_get_from_id(u64 id);
 struct cgroup *cgroup_get_from_id(u64 id);
 #else /* !CONFIG_CGROUPS */
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a12f4fa444086..3eb02ce0dba3b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2537,7 +2537,7 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 {
 	struct cgroup *cgrp;
 
-	cgrp = cgroup_get_from_id(cgid);
+	cgrp = __cgroup_get_from_id(cgid);
 	if (IS_ERR(cgrp))
 		return NULL;
 	return cgrp;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 77d02f87f3f12..c62b98f027f99 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6373,15 +6373,15 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
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
@@ -6403,6 +6403,22 @@ struct cgroup *cgroup_get_from_id(u64 id)
 
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



