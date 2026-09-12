Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FB71D7E5C;
	Sat, 12 Sep 2026 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224917; cv=none; b=pu3b7HvKm4yyBlCBpnaarSyAt9dx9OAncu5udbj+YI1bDZQIJBHbMOruhn07X1SKAljvuU3B0KbUnG747/vEpHpd44mcjz3i8X8MK2/neMt6VHWys/rocihGnRII7JIG7GV1BoucswMlGWqE6qz2JkaBfr6U/q24zUVf4Iz/hjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224917; c=relaxed/simple;
	bh=q/Q0foL0PWOzhiWa1mpcVN3qp6drYJZoFGxDcerF4m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q86D7SnLBekKFFKFZCsO5NL02rTvSq6BK35uII4l8axswxLic2GTsrdghPd1OGh/Ab1SS8GWK2hw3tlThTszDvQqV7/nKp3o7KOyPpPpVUTgJ6knH3evI1oWML8w7yGIh+HtMq3kxStmULwCOAnaji6RCIvfK/QbyuIY2ZwNGRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUViazsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUViazsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF83F1F000FF;
	Sat, 12 Sep 2026 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224916;
	bh=7a1g3iG952fkTAoianIKJkMIAIjrVTE5FUK2Q6sucw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUViazsb1gmOt9PeOlB+jq5hlaNSph5ik2aRBNJPjNyL65mkqo+NoZRWPAx4rEgAU
	 b1cpHRG/1g4dR0UTjtM65PVnptY3orG52BZ58Xmv3+ICSobSiAVSOZXR6qcZWQbcz3
	 xyBA1/Hq7A74VNeZA7vpvJ/QYYZDT+okszZb/T0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1049/1424] bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed
Date: Sat, 12 Sep 2026 08:58:01 +0200
Message-ID: <20260912065630.797765109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index edf38cbe9228d..0455c481bf008 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -646,8 +646,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
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
@@ -693,6 +695,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
 	if (pl) {
 		old_prog = pl->prog;
+		old_pl_flags = pl->flags;
+		bpf_cgroup_storages_assign(old_storage, pl->storage);
 	} else {
 		struct hlist_node *last = NULL;
 
@@ -716,6 +720,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	pl->link = link;
 	pl->flags = flags;
 	bpf_cgroup_storages_assign(pl->storage, storage);
+	old_flags = cgrp->bpf.flags[atype];
 	cgrp->bpf.flags[atype] = saved_flags;
 
 	if (type == BPF_LSM_CGROUP) {
@@ -746,12 +751,15 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
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



