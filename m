Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216509;
	b=dUkGmIsrZLUKI1xKtVCfSRT1ipjG6P7OEup13L6zmj+unLLH1+66H3MiyrYGKPbh7vav
	 Wt1kECPtmLCVAjzKvmJuRzpaNIkkBZD6OfgVtyk4KZTPXGqUHCIW7XGfQ1NjcAXKb0vWO
	 oZj7GNn+5rpK01AfZ6tQEvmfLR0hW8K/Cj0RICdWV5P2tw+u7BEazRv2pN9VpSDeSFpvT
	 FR38qXme/+hrjn/5nYpl5pCSZW6rctFPgtt+/OsuP7oURwTnEOMnsF4cZsegAm2eCDmD4
	 Pm/PgHrKlKtgoaiiZWoLo6YRHVWmHPVtmkRjRrXe0jMnCGYHX2Fldp1LmVq4EDIAWxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uiRsXAaIUULPYdiyvaASB+bOZyHyhD7TIa5L4EiDfKk=;
	b=dgqt/YXqn0PW1ygeKsSdT/P2fkIbcyasTuIDSe51p5o1nc2sBtMsHAtq5kzcKTf4ru8y
	 j6sDJbuHx1t5GasBTucVm5Si84YqUIwYn0H0bQzMQcPUPYvVtmUp3Dph303mYMaXY1n2p
	 5/8U54S0UAgZ+eWhQwPWP8wxuXOHn1+Q9vlAyK7FXtvWbjvymaBEwK91/31Wtuq0zU7Gl
	 ifK1JI8uarLW6R0TBVcL7ewPXvDhKbd5AKp8LUGRUv9O6jsUPz6MkHcwbcPUedwvaA2Ud
	 rsThfGI7cuheKbxgBbq7XwikjpAqEHjxj+4GR5ZSFF6y4bpbomUpbrhTg3O8a6FMLBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ja0/19tX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0172A606A31A;
	Wed, 28 Oct 2026 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ja0/19tX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D871F01825;
	Wed, 28 Oct 2026 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216508;
	bh=uiRsXAaIUULPYdiyvaASB+bOZyHyhD7TIa5L4EiDfKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ja0/19tX9JpNwZBVGIOY3NR/40jQBXaaGv9L9h59OQNL3NDozlqTPVYlilzZiUyu3
	 9dq3oHTTYexcioH7VUk4GTjF4Nz8gXr+NeNoArK03oYW+ZoMJ6MT/vBMchDzRd40ka
	 +oClSQpOxBlXd/Uahw1DQVixjFRuJUtERtfMefGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1580/1887] bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed
Date: Wed, 28 Oct 2026 18:01:16 +0100
Message-ID: <20261028170535.421869151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/bpf/cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 3771a041d9de5..3140fb0950771 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -630,8 +630,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_cgroup_storage *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_prog *new_prog = prog ? : link->link.prog;
 	enum cgroup_bpf_attach_type atype;
+	u32 old_flags;
 	struct bpf_prog_list *pl;
 	struct hlist_head *progs;
 	int err;
@@ -677,6 +679,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
 	if (pl) {
 		old_prog = pl->prog;
+		bpf_cgroup_storages_assign(old_storage, pl->storage);
 	} else {
 		struct hlist_node *last = NULL;
 
@@ -699,6 +702,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	pl->prog = prog;
 	pl->link = link;
 	bpf_cgroup_storages_assign(pl->storage, storage);
+	old_flags = cgrp->bpf.flags[atype];
 	cgrp->bpf.flags[atype] = saved_flags;
 
 	if (type == BPF_LSM_CGROUP) {
@@ -729,12 +733,14 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (old_prog) {
 		pl->prog = old_prog;
 		pl->link = NULL;
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



