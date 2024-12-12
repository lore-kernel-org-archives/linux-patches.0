Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D792135C1;
	Thu, 12 Dec 2024 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017864; cv=none; b=u/eoCLz3igWpyEjWe1v61YPDBYqlPYNhtErlxI/Xh7sXAfKZeAVF1cvmPjkuSBWurA6Jnp1vPK4DKa7ueoM/puoGvFXZOdtPttAx0+Pfj7YAd7QCzdRAdZgEHrlf1UiVV7JSfHztjrac8CceLLORuz8AgPoLiH3eJ1loBgzQoZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017864; c=relaxed/simple;
	bh=xR/yaqnVmC80usuxZxqPu2j1ZdbVf1gUr7ABsHziH8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILe1zHksLpLbg8aPZmWYGGjUtBoaqUt8MPvwqs1ADDki+rFERmeCelqZYK4JL7LZs0rUvUEnJ5C22kysQOZESNiRKbxRVKueNJfCGURuOIPon98Iq9t7ZgQG11/fH7dNHCOCD8A7jm/41nBT2GEuZimFENpO54fMaWJKSKnYd+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JswwCHiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JswwCHiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CCBC4CECE;
	Thu, 12 Dec 2024 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017864;
	bh=xR/yaqnVmC80usuxZxqPu2j1ZdbVf1gUr7ABsHziH8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JswwCHiE3xoO39gwr2KWnuR8iD4d3jThHizEIPkmKzslir8sz3r+9+kj9D1b1oE5I
	 w5QCRbODlM+/dpUdnjdtxtM9xZuur/OYVf6lI49gWaf8Alebg0Te9kkjpAP7pJDh0F
	 rih0/oxJokn/G3MxO8SvgV17g351fW+E4cK/qoFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Tao Lyu <tao.lyu@epfl.ch>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/356] bpf: Fix narrow scalar spill onto 64-bit spilled scalar slots
Date: Thu, 12 Dec 2024 15:57:24 +0100
Message-ID: <20241212144249.587706711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tao Lyu <tao.lyu@epfl.ch>

[ Upstream commit b0e66977dc072906bb76555fb1a64261d7f63d0f ]

When CAP_PERFMON and CAP_SYS_ADMIN (allow_ptr_leaks) are disabled, the
verifier aims to reject partial overwrite on an 8-byte stack slot that
contains a spilled pointer.

However, in such a scenario, it rejects all partial stack overwrites as
long as the targeted stack slot is a spilled register, because it does
not check if the stack slot is a spilled pointer.

Incomplete checks will result in the rejection of valid programs, which
spill narrower scalar values onto scalar slots, as shown below.

0: R1=ctx() R10=fp0
; asm volatile ( @ repro.bpf.c:679
0: (7a) *(u64 *)(r10 -8) = 1          ; R10=fp0 fp-8_w=1
1: (62) *(u32 *)(r10 -8) = 1
attempt to corrupt spilled pointer on stack
processed 2 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0.

Fix this by expanding the check to not consider spilled scalar registers
when rejecting the write into the stack.

Previous discussion on this patch is at link [0].

  [0]: https://lore.kernel.org/bpf/20240403202409.2615469-1-tao.lyu@epfl.ch

Fixes: ab125ed3ec1c ("bpf: fix check for attempt to corrupt spilled pointer")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Tao Lyu <tao.lyu@epfl.ch>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241204044757.1483141-3-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5ca02af3a8728..3f47cfa17141a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4599,6 +4599,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	 */
 	if (!env->allow_ptr_leaks &&
 	    is_spilled_reg(&state->stack[spi]) &&
+	    !is_spilled_scalar_reg(&state->stack[spi]) &&
 	    size != BPF_REG_SIZE) {
 		verbose(env, "attempt to corrupt spilled pointer on stack\n");
 		return -EACCES;
-- 
2.43.0



