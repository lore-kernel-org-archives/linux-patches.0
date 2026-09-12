Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1979DA;
	Sat, 12 Sep 2026 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201741; cv=none; b=YHt49YoEUnFfZ6Da079l+LgSEdtvVvCJZii//0bccyutkIc2t2KQGqZq2Skk9DwXSjDRB4SCvRHwgcJvD3HrkOaQmE73l3KFHG/4t0OqtlJUetwktYly6njmwcwjAZenY3NwZsdReXmgGyNvOS0HNc3uXREzsxmqylq7TrsMLSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201741; c=relaxed/simple;
	bh=EP/LqYoYLQdLusZ+FLIh4/x0RTJp4rteI6nNClWoFtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLg5jYRoPgZS0rrLmmEp0/lV808QpPnBJg8n0c9ndGDzctIE/Z0Ia61em+ayyJaA8EqgcwaKM3imAOp8/9EoqGIw+VnSFhhOp0TGG9xRJsNyOTp7salX0DDZllcMBF3/QPwFN3HKwrv+ue9spz83iw1akyuKlyReH+I1P9XrH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LF/8Bhzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LF/8Bhzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD101F000FF;
	Sat, 12 Sep 2026 08:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201740;
	bh=g1IHbxMuswqtsmnf/3x5d14gCS7bA4fAKtvszRwndRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LF/8BhzuiEZygxWp6IohMiPaPsEaASC+PwsFU7QGnaXSYvj2W9gncLva9jzVXn3LI
	 Pm5bPU+MU13SRrSJ4dE3Q/gJhq+FkbeBpkvamSvksXhzTL7iRz6eR0OgjGM/0UXomv
	 o+yCKekCZChaINlyl5QA6Fl1rvgZEH179yBmPIPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1059/1815] bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed
Date: Sat, 12 Sep 2026 08:46:49 +0200
Message-ID: <20260912065713.878769063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 6655c409707ec8ce9ce0850ffe4fe02331fd4d9c ]

A potential invalid storage access issue can occur after replacing a
cgroup bpf prog.

This occurs in the following scenario:
1. prog1 with storage is attached to a cgroup in multi-attach mode.
2. prog1 is replaced with prog2 using BPF_F_REPLACE in multi-attach
   mode, but fails midway (e.g. in bpf_trampoline_link_cgroup_shim or
   update_effective_progs).
3. A new prog3 is attached to the cgroup in multi-attach mode.

The reason is that __cgroup_bpf_attach overwrites pl->storage with the
new storage prior to attachment completion. When attachment fails
midway, the cleanup path calls bpf_cgroup_storages_free(new_storage) to
free the newly allocated storage, but fails to restore pl->storage back
to old_storage.

Consequently, the still-active prog1 holds invalid or dangling storage
pointers, leading to an invalid memory access when prog1 executes and
calls bpf_get_local_storage. Additionally, original pl->flags and
cgrp->bpf.flags[atype] are left unrestored.

Fix this by saving old_pl_flags, old_storage, and old_flags prior to the
update, and properly restoring all of them in the cleanup path on error.

Fixes: 7d9c3427894f ("bpf: Make cgroup storages shared between programs on the same cgroup")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260803013934.4036646-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 4355ccb78a9c6..57fd1d784e440 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -813,8 +813,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_cgroup_storage *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_prog *new_prog = prog ? : link->link.prog;
 	enum cgroup_bpf_attach_type atype;
+	u32 old_flags, old_pl_flags;
 	struct bpf_prog_list *pl;
 	struct hlist_head *progs;
 	int err;
@@ -865,6 +867,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
 	if (pl) {
 		old_prog = pl->prog;
+		old_pl_flags = pl->flags;
+		bpf_cgroup_storages_assign(old_storage, pl->storage);
 	} else {
 		pl = kmalloc_obj(*pl);
 		if (!pl) {
@@ -884,6 +888,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	pl->link = link;
 	pl->flags = flags;
 	bpf_cgroup_storages_assign(pl->storage, storage);
+	old_flags = cgrp->bpf.flags[atype];
 	cgrp->bpf.flags[atype] = saved_flags;
 
 	if (type == BPF_LSM_CGROUP) {
@@ -915,12 +920,15 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (old_prog) {
 		pl->prog = old_prog;
 		pl->link = NULL;
+		pl->flags = old_pl_flags;
+		bpf_cgroup_storages_assign(pl->storage, old_storage);
 	}
 	bpf_cgroup_storages_free(new_storage);
 	if (!old_prog) {
 		hlist_del(&pl->node);
 		kfree(pl);
 	}
+	cgrp->bpf.flags[atype] = old_flags;
 	return err;
 }
 
-- 
2.53.0



