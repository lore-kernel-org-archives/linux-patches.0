Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A1A4086A;
	Tue, 11 Nov 2025 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822948; cv=none; b=LSq17XH+DhGlQlPkrbGjXlOHbDlcPCy5+4LzKWqEkIH80bWZkD1acu1UtSWubdoA9fCTkZ3jgatdg4cj9klOfzO6IYuWP0DbpmRJ6LKqI7SBF/r2/n/fgP/4sr/PBtsXzPZKPx3M4NPx8/aZ/Ly67H+AGibVE1jqdi02crJTkdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822948; c=relaxed/simple;
	bh=I9SSFnzPZDk9B2w4fWArs4Jw6Ew/GXjKH4HCaGXtBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkQ1+bVNPK3FEdL/hKmQDkaUxx1Z7M4i8Fv0p/2U6hQRukKe4KIEcDqBSwzObNnA/Ma2FdhV2AAOWalHoNcenemeaRj9PgOwOrh4Dl9KAfWyWKEKcXDVoTid33bvMtC/kSrrr8bNEHW2iY9Fq6jPVQvdOQ5FRuYcGUDZ8mafob4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ+GF0BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ+GF0BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4990C19421;
	Tue, 11 Nov 2025 01:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822948;
	bh=I9SSFnzPZDk9B2w4fWArs4Jw6Ew/GXjKH4HCaGXtBQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZ+GF0BDoK+EURY+TXSp0wLxAUV4xYXMtYkCbJfXWREpsVMOKJ2+TyF9C3buInM9V
	 SPlaunqa7z9Q0DTJMZxwRweG1mFVgoTB434iJerExfzgHmjDLnM3NVb/3C1HBQsHTV
	 Zh89XT6sD5Vrxu53k8lCRwxlCOzzQ7v79JnoAOxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Schatzberg <dschatzberg@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/565] bpf: Do not limit bpf_cgroup_from_id to currents namespace
Date: Tue, 11 Nov 2025 09:39:55 +0900
Message-ID: <20251111004530.070808871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index fc1324ed597d6..2a510dbbfe623 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -631,6 +631,7 @@ static inline void cgroup_kthread_ready(void)
 }
 
 void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
+struct cgroup *__cgroup_get_from_id(u64 id);
 struct cgroup *cgroup_get_from_id(u64 id);
 #else /* !CONFIG_CGROUPS */
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a0bf39b7359aa..db4739951702e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2455,7 +2455,7 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 {
 	struct cgroup *cgrp;
 
-	cgrp = cgroup_get_from_id(cgid);
+	cgrp = __cgroup_get_from_id(cgid);
 	if (IS_ERR(cgrp))
 		return NULL;
 	return cgrp;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5fc2801ee921c..b8cde3d1cb7bc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6343,15 +6343,15 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
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
@@ -6373,6 +6373,22 @@ struct cgroup *cgroup_get_from_id(u64 id)
 
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



