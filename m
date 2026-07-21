Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA0546DFE5;
	Tue, 21 Jul 2026 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656372; cv=none; b=ZzvK9t15aOVLedEnyPjSSsPNjftxDdcf5lcNbS/v7Mv1lSUkEND9F7koNh0h7SBu1NYKuBFpjw+dso1dwhbWYfRnpeiDDS2d8teJVTZ2OYDbNJRomG4DZ6PZXYShdysOSS6zY5gdTw/XrkoWxYXlzSv3EWu6ZSNGSJyPkE76iWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656372; c=relaxed/simple;
	bh=9O3FW3VPI2w6XG8f2WKhTO890+2qB3Pz7AZqReUyI3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2f5RksxW8Zat6uM9n3RDrOGpL/9fCNi+JvYIDT0lEyx+jYH3waOLxHYej4EoPE8BxsMnuoXKKb72Qa+DaJUcUTfDFrlsIeArUnzBkQ/zpdNQ52vTy19MtRAacttvPG+mtbUAA4uOk3cg+GEzQhSe0xlFV8Z+JGJDkIbUTlU0G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijAON4x3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijAON4x3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01021F00A3A;
	Tue, 21 Jul 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656371;
	bh=BnotPkRBr2WYybpnRFcrIZde3ISGCCCkWwJvKXN7Zv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijAON4x36+xADcj2E2CxVP8v4XK8DxEYe+p4YULrDc6/j+7J587UcLS2cie0JTZZK
	 iSV+VSwtJHSIOGniZ7H8UOsd+pxXtoJB00bGBZv1UE4zhu7ii0If+D4pRHHcaaIO8F
	 d5r6C8lWRlMvuwJA9sU2pBOl7pmgFvv4H7ipW8kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0361/1611] bpf: Clear rb node linkage when freeing bpf_rb_root
Date: Tue, 21 Jul 2026 17:07:57 +0200
Message-ID: <20260721152523.272528468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index b5964524244814..a62cbdf5a3cde5 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2178,6 +2178,7 @@ void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
 		      struct bpf_spin_lock *spin_lock)
 {
 	struct rb_root_cached orig_root, *root = rb_root;
+	struct bpf_rb_node_kern *node;
 	struct rb_node *pos, *n;
 	void *obj;
 
@@ -2186,14 +2187,20 @@ void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
 
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



