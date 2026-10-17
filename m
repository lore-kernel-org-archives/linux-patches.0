Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0AB3AEB29;
	Sat, 17 Oct 2026 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255550; cv=none; b=Cj8J3/XPCmigqbZQHgExLAVwHJDlvskOfHCe3ozGeANgGIlN20oyEf6XAke8gR2v4CxI962V+XSaHo9E65sN5PWy2u0uaTmrxf17wQsoKEx0dPMITtiGctth8vrOrSiiHJI0Hm8xI0TZ1AK0ywUGCzib0lbkZm5Qv19geEcV5DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255550; c=relaxed/simple;
	bh=MwC9HzBxB+8cdY+GpH0jKRhFUIjD7V2OIxqOTRnjGG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8HaYlBqDkkN/B4E2KZDGi20ro4T9pDhYodXjO20S9t9QRpic4VZpyNTe7wlRw8+9TFYeMq16VkeTgQdJCiGVo1lxC72dClNY81BNOg749D9oT7YMykvw6LXsUZIfXbcVVQQrDGcSKFXngMaK5As/6UxJLnCnZoxxXgnKDMpRIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b016j+er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b016j+er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB21F000C4;
	Sat, 17 Oct 2026 16:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255549;
	bh=EGnM35zbCZOhZUP9PCGkFe5oeOtFvtQ3Ax/KfY63Sxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b016j+ermNQQL+SdeA+Gu7u94o32m+Pm3icSlpC7A5btQBNl66GKIO6ScbmnXQFcn
	 2dTuS6Z5ZWGDe56jSN55uHRT4G6G0g2S2Ghxe3Gvsyss92Ce+lXGMXTLUpDTaP2qtI
	 GkZFt8vPQZDziG58x3tCxTq8V2tKbI4sBEJSqS8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 813/869] bpf: Clear rb node linkage when freeing bpf_rb_root
Date: Sat, 17 Oct 2026 18:00:54 +0200
Message-ID: <20261017160057.737708626@linuxfoundation.org>
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

From: Kaitao Cheng <chengkaitao@kylinos.cn>

[ Upstream commit 4a7910ee060d8ce55612f5b3cc267f3a265a3cec ]

bpf_rb_root_free() detaches the root by copying the current rb_root_cached
and then replacing the live root with RB_ROOT_CACHED. It then walks the
copied root and drops each object contained in the tree.

This leaves the rb node state intact while dropping the object. If the
object is refcounted and survives the drop, its bpf_rb_node_kern still
contains an owner pointer to the freed root and stale rb tree linkage. If
a later bpf_rb_root allocation reuses the same address, bpf_rbtree_remove()
can incorrectly pass the owner check and call rb_erase_cached() on a node
whose rb pointers belong to the old tree.

Mirror the list draining behavior by marking nodes as busy while the root
is being detached, then clear the rb node and release the owner before
dropping the containing object. This makes surviving nodes unowned and
safe to reject from remove or accept for a later add.

Fixes: 9c395c1b99bd ("bpf: Add basic bpf_rb_{root,node} support")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260605094143.5509-1-kaitao.cheng@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index e8417cd67decb..617f1b8c36703 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2121,6 +2121,7 @@ void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
 		      struct bpf_spin_lock *spin_lock)
 {
 	struct rb_root_cached orig_root, *root = rb_root;
+	struct bpf_rb_node_kern *node;
 	struct rb_node *pos, *n;
 	void *obj;
 
@@ -2129,14 +2130,20 @@ void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
 
 	__bpf_spin_lock_irqsave(spin_lock);
 	orig_root = *root;
+	bpf_rbtree_postorder_for_each_entry_safe(pos, n, &orig_root.rb_root) {
+		node = rb_entry(pos, struct bpf_rb_node_kern, rb_node);
+		WRITE_ONCE(node->owner, BPF_PTR_POISON);
+	}
 	*root = RB_ROOT_CACHED;
 	__bpf_spin_unlock_irqrestore(spin_lock);
 
 	bpf_rbtree_postorder_for_each_entry_safe(pos, n, &orig_root.rb_root) {
 		obj = pos;
 		obj -= field->graph_root.node_offset;
-
-
+		node = rb_entry(pos, struct bpf_rb_node_kern, rb_node);
+		RB_CLEAR_NODE(pos);
+		/* Ensure __bpf_rbtree_add() sees the node as unlinked. */
+		smp_store_release(&node->owner, NULL);
 		__bpf_obj_drop_impl(obj, field->graph_root.value_rec, false);
 	}
 }
-- 
2.53.0



