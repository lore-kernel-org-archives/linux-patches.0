Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245CB3A542B;
	Sat, 17 Oct 2026 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260772; cv=none; b=hn6oSkml8dj4hZEeuv81WSD0jPNzSGKLd0hYkTPKDP+1IzOyItHKgJm80hQRIPIlaiuM8pA4OdBkHkHHe3ZRQJwFYw6OFG63oyWMWP1eLkKpAGold/Wvryr3UjqdMbhcHyD4SeWX3QjLMFaoBqTuimXnHMFZZPZ1zm0Tlg+L1sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260772; c=relaxed/simple;
	bh=xOQkmA3di/YLCudxAs/7r+DaKwqa0HsC8o1DCFeYT84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjaZU6K18M+hlZ0A+yvQpNW9jJ+hdeT8Zs7Y4Of4CfyWwa8JQU25By0sbeHOPyecZLy6X7MFj1SqDdD+Ko5j/QbOGXO2UebJfJbSRL7yoEYJZeUxxRxtkfAXPbrQP2NiX6oKGjxmq+X0BXKCb/6FE423ZFHA19Vn6EBsAJXtI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZturCDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZturCDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EC51F000C4;
	Sat, 17 Oct 2026 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260771;
	bh=WVpvvhYVZdSDBQCcHw0tkDXKX1PpeGd8tv7jihGpmUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZturCDQocV45YI9ZCGvHQsWnas619qtFdEWbx7+WNCknEmYYHiYTOOMS9O8oZ9e3
	 ve/eyjhZKZrVp/B2vm7lYi2oICNiv15tLz23tfi+6FudRaBwMR1S1XJAnIKgTQL84U
	 dfCJQ5Cyhj49oVHuD+8fQEPPGVVcvw8FRgJAjH/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1655/1674] bpf: check_cond_jmp_op(): properly infer if register is null
Date: Sat, 17 Oct 2026 18:05:27 +0200
Message-ID: <20261017160513.553511369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit d3ef6c097ba078e1f8c7239d76a0ce8b61e75095 ]

Nicholas Carlini reported a bug when verifier can incorrectly infer
that a pointer is non-null. The bug occurs when two pointers are
compared and one of them has a type w/o PTR_MAYBE_NULL flag,
but which allows a value to be NULL at runtime.
Here is an example:

  // `a` is PTR_TO_MEM | MEM_RDONLY | PTR_UNTRUSTED
  // `a` is 0 at runtime.
  // `b` is PTR_TO_MAP_VALUE | PTR_MAYBE_NULL
  void *a = bpf_rdonly_cast(0, 0);
  int  *b = bpf_map_lookup_elem(...);

  if (a == b)
    *b = 42;  // verifier does not catch null pointer dereference

This happens because of a special case in check_cond_jmp_op(),
which attempts to strip PTR_MAYBE_NULL flags from pointer types,
when processing comparisons like `rA == rB`, if either rA or rB can't
be null.

The non-null property is derived based on the absence of
PTR_MAYBE_NULL flag on rA's or rB's type. But that is not sufficient
for types like PTR_TO_MEM, as in the example.

This patch replaces type_may_be_null() call with reg_not_null(),
which contains an allowlist of types for which absence of
PTR_MAYBE_NULL actually means that the value can't be NULL at runtime.

At the moment, the list in the reg_not_null() omits two types for
which PTR_MAYBE_NULL is applicable: PTR_TO_XDP_SOCK and PTR_TO_BUF.
In order to remain backward compatible, and assuming that only
comparison between pointers of the same type makes sense,
this commit extends reg_not_null(). W/o such an extension e.g.
verifier_jeq_infer_not_null/null_ptr_to_map_value fails.

reg_not_null() can be extended further, but I deem that out of scope
for the fix at hand. Explicit base_type(...) != PTR_TO_BTF_ID
checks in the check_cond_jmp_op() can be removed with migration to
reg_not_null(), but that is a behavioural change, as the special case
would start matching for PTR_TO_BTF_ID that is also is_trusted_reg().
I omit the behavioural change from this commit.

Fixes: befae75856ab ("bpf: propagate nullness information for reg to reg comparisons")
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260826-bug-029-bad-non-null-inference-v2-1-136789ace9e9@localhost
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b49de1b31a3e3..07c1ec4ec4286 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -463,6 +463,8 @@ static bool reg_not_null(const struct bpf_reg_state *reg)
 	type = base_type(type);
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_XDP_SOCK ||
+		type == PTR_TO_BUF ||
 		type == PTR_TO_MAP_VALUE ||
 		type == PTR_TO_MAP_KEY ||
 		type == PTR_TO_SOCK_COMMON ||
@@ -14992,7 +14994,6 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	 */
 	if (!is_jmp32 && BPF_SRC(insn->code) == BPF_X &&
 	    __is_pointer_value(false, src_reg) && __is_pointer_value(false, dst_reg) &&
-	    type_may_be_null(src_reg->type) != type_may_be_null(dst_reg->type) &&
 	    base_type(src_reg->type) != PTR_TO_BTF_ID &&
 	    base_type(dst_reg->type) != PTR_TO_BTF_ID) {
 		eq_branch_regs = NULL;
@@ -15008,9 +15009,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 			break;
 		}
 		if (eq_branch_regs) {
-			if (type_may_be_null(src_reg->type))
+			/* src == dst && dst != NULL => src != NULL */
+			if (reg_not_null(dst_reg) && type_may_be_null(src_reg->type))
 				mark_ptr_not_null_reg(&eq_branch_regs[insn->src_reg]);
-			else
+			/* src == dst && src != NULL => dst != NULL */
+			if (reg_not_null(src_reg) && type_may_be_null(dst_reg->type))
 				mark_ptr_not_null_reg(&eq_branch_regs[insn->dst_reg]);
 		}
 	}
-- 
2.53.0



