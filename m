Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF283A6B66;
	Thu, 17 Sep 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658821; cv=none; b=lnhmH7JcL6QKPmIFT+0OyIuZ2TrtaK+xtrMdBs/rtgwSkQUWLyWQUhR4xv3Bz1RzJqKWyUPoH9cZuaQk2bLn9IRoEGcveMebNlKZ/W+joK4aGMExsn8tmgZeJs+ZFi7nhD9uJwmZ4LEHrr7zS68otq16RWo2X6Ovg+bbXEF4juY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658821; c=relaxed/simple;
	bh=X49b+NE97QXPpesVO16BxOHSFQcs7Sh3CjvXpiw7qik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P27nogubjYWzqz9W5arnnt7pNegBo7oH3frr7/KL+ggllrda5yzurvlK5ivILx9y7Ti0dAz9XI6wLrOLwhnh98mnOJq9ETQiDQSXXClEvg5HKvx0rFg77bFYgSjr1hGwchny9NSo4GAcGlqWqFTtO9r/d6aJvFzpc4wB5na8ZZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePEcvGHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePEcvGHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC4C1F000FF;
	Thu, 17 Sep 2026 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658814;
	bh=b/MhsAW7bXltJQwDUXTdPWZbNwSVlGT2cpZWDpz8uGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePEcvGHKmiBdVy/PCDBJvbcS2bnAHD3XX1zJ/yTBHs8r1NLFZqPNjCUHLedBYEa/I
	 20JWX2P6i8bSEkuBoSfOVIg+DeN6yNz1lA6yUZ1uLaAhseYTk6On9JSjJmsoK0JqQI
	 EcOAFjJf4bOzaYQX/RtiGcUTjzSj5zPqx9ZHMtyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 049/733] bpf: check_cond_jmp_op(): properly infer if register is null
Date: Thu, 17 Sep 2026 16:05:57 +0100
Message-ID: <20260917151352.000589516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 03187bab806a7..59f12ba70eb6e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -370,6 +370,8 @@ static bool reg_not_null(struct bpf_verifier_env *env, const struct bpf_reg_stat
 	type = base_type(type);
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_XDP_SOCK ||
+		type == PTR_TO_BUF ||
 		type == PTR_TO_MAP_VALUE ||
 		type == PTR_TO_MAP_KEY ||
 		type == PTR_TO_SOCK_COMMON ||
@@ -16173,7 +16175,6 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	 */
 	if (!is_jmp32 && BPF_SRC(insn->code) == BPF_X &&
 	    __is_pointer_value(false, src_reg) && __is_pointer_value(false, dst_reg) &&
-	    type_may_be_null(src_reg->type) != type_may_be_null(dst_reg->type) &&
 	    base_type(src_reg->type) != PTR_TO_BTF_ID &&
 	    base_type(dst_reg->type) != PTR_TO_BTF_ID) {
 		eq_branch_regs = NULL;
@@ -16189,9 +16190,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 			break;
 		}
 		if (eq_branch_regs) {
-			if (type_may_be_null(src_reg->type))
+			/* src == dst && dst != NULL => src != NULL */
+			if (reg_not_null(env, dst_reg) && type_may_be_null(src_reg->type))
 				mark_ptr_not_null_reg(&eq_branch_regs[insn->src_reg]);
-			else
+			/* src == dst && src != NULL => dst != NULL */
+			if (reg_not_null(env, src_reg) && type_may_be_null(dst_reg->type))
 				mark_ptr_not_null_reg(&eq_branch_regs[insn->dst_reg]);
 		}
 	}
-- 
2.53.0



