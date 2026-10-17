Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27B01E520A;
	Sat, 17 Oct 2026 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255444; cv=none; b=HgNnNBoVMaIRcg9tguFxenIm1bM6cXo89G+JekEz0P1vImgGOhy/ob57dStUvuNg5OruaOgm7u3fnAFCgrPrLVX2VXvMpCGW3H+ZCVfVBNogCcpyLTC1ADtCiFCouetJYRF9nzqNIG3OtJR4vsdFXSFqJcqQB4QBZOx9PdSn9rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255444; c=relaxed/simple;
	bh=sOLryARK5ZFpTF43otYM9gbvVhKpXRamAPifRDczINc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iti8+KJMw7ypfeMC0ktFyMWe3VuM7IsKgVtTEMMrEJ8R78+PFc0xxRrrSZ63g12uPfDLpQop+NdGgNmdMCudkJUIkG1OgNBO/oCDKFx4knOCMaHNtM8fQ1IBVsbNwIgLACrGh1vXdww5ChIj6W4sS4KejcbmX0AAdn37ivubTm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiOqJsHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiOqJsHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357AA1F000C4;
	Sat, 17 Oct 2026 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255443;
	bh=zZa+fw8bFRrv0au/1X6BvD0raRtN96XYxZJ43Ww2rG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiOqJsHMTROgK7cIHCRMOpucgnDyB5QHeNsWiNFzDWYlB31+0ZPXBDe4LQgYxUFxX
	 cV+VBUz6Za0Vfgjsl6labruAN0BfI6xa7SCPsPM5/+F/gQpQDljp2g5fGhC/kNw9Ea
	 BomVo3WwOtjves7jrv/3K0oh4WqmSIYzK9fqCcnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 777/869] bpf: Preserve inner map identity in callback frames
Date: Sat, 17 Oct 2026 18:00:18 +0200
Message-ID: <20261017160056.843272721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit b90c5d770dad910fb89e6c1b15052a8a1e8db752 ]

Callback frame constructors initialize map-typed argument registers with
__mark_reg_known_zero() and then restore map_ptr. This clears map_uid,
which is the only field distinguishing inner maps that share an
inner_map_meta template.

When a timer callback invokes bpf_for_each_map_elem() on a second inner
map, both the saved first map and the second map value can reach the nested
callback as the same template with map_uid zero. bpf_timer_init() then
accepts pairing the timer from the second map with the first map.

The runtime records the first map in the timer without taking a reference.
Freeing that map does not find the timer stored in the second map, so a
later timer callback dereferences the freed map.

Copy map_uid from the same caller register as map_ptr when constructing
for-each, timer/workqueue, and task-work callback arguments. The existing
identity check can then reject mismatched inner maps while allowing a
callback value to be paired with its actual map.

Fixes: 3e8ce29850f1 ("bpf: Prevent pointer mismatch in bpf_timer_init.")
Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Fixes: 5c8fd7e2b5b0 ("bpf: bpf task work plumbing")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904104203.345917-8-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 67a250c439035..75f8d73e6eb7d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10203,10 +10203,12 @@ int map_set_for_each_callback_args(struct bpf_verifier_env *env,
 	callee->regs[BPF_REG_2].type = PTR_TO_MAP_KEY;
 	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
 	callee->regs[BPF_REG_2].map_ptr = caller->regs[BPF_REG_1].map_ptr;
+	callee->regs[BPF_REG_2].map_uid = caller->regs[BPF_REG_1].map_uid;
 
 	callee->regs[BPF_REG_3].type = PTR_TO_MAP_VALUE;
 	__mark_reg_known_zero(&callee->regs[BPF_REG_3]);
 	callee->regs[BPF_REG_3].map_ptr = caller->regs[BPF_REG_1].map_ptr;
+	callee->regs[BPF_REG_3].map_uid = caller->regs[BPF_REG_1].map_uid;
 
 	/* pointer to stack or null */
 	callee->regs[BPF_REG_4] = caller->regs[BPF_REG_3];
@@ -10284,6 +10286,7 @@ static int set_timer_callback_state(struct bpf_verifier_env *env,
 				    int insn_idx)
 {
 	struct bpf_map *map_ptr = caller->regs[BPF_REG_1].map_ptr;
+	u32 map_uid = caller->regs[BPF_REG_1].map_uid;
 
 	/* bpf_timer_set_callback(struct bpf_timer *timer, void *callback_fn);
 	 * callback_fn(struct bpf_map *map, void *key, void *value);
@@ -10291,14 +10294,17 @@ static int set_timer_callback_state(struct bpf_verifier_env *env,
 	callee->regs[BPF_REG_1].type = CONST_PTR_TO_MAP;
 	__mark_reg_known_zero(&callee->regs[BPF_REG_1]);
 	callee->regs[BPF_REG_1].map_ptr = map_ptr;
+	callee->regs[BPF_REG_1].map_uid = map_uid;
 
 	callee->regs[BPF_REG_2].type = PTR_TO_MAP_KEY;
 	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
 	callee->regs[BPF_REG_2].map_ptr = map_ptr;
+	callee->regs[BPF_REG_2].map_uid = map_uid;
 
 	callee->regs[BPF_REG_3].type = PTR_TO_MAP_VALUE;
 	__mark_reg_known_zero(&callee->regs[BPF_REG_3]);
 	callee->regs[BPF_REG_3].map_ptr = map_ptr;
+	callee->regs[BPF_REG_3].map_uid = map_uid;
 
 	/* unused */
 	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
-- 
2.53.0



