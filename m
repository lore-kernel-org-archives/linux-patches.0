Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D12080FC;
	Thu, 12 Dec 2024 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016000; cv=none; b=AFmNHaFoBeltjvYZ1khUkFSENcqh4HZREy3moqvsLF0p29Ya+fM3PqB5aywztn6PCPp0sOy629H8N169sU8QTn/UM3klqXfCz3MPH/ZytnQp4DgJRaO+mKTZHvuBj03973DprtA8VjXpVa8HXSgxTc2EWojli38jkm7diPavXSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016000; c=relaxed/simple;
	bh=2uj8AG09spTGXiH43jDwPzVrDJ2ihccrvNXyY8TFg8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWEmr8B2OKawoqf51In7Mp7+Yr3IBPyKDzckzNR/+e6t7trQDp+FXbpqLig+gC+DNLh2fWuEK9nEbGZuDPhBANNwBPppuo35jLXIEjKJRuuWCmbg2pagRo3MFAJsYE3qhrzoRsk0uQsqG47teuszsdXXPAoD4Rb02CS3aJoTBUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ist5mTE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ist5mTE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC498C4CED4;
	Thu, 12 Dec 2024 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016000;
	bh=2uj8AG09spTGXiH43jDwPzVrDJ2ihccrvNXyY8TFg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ist5mTE4Z1BGOBKbRSAYwfCKNHZ4+GjWQk61Z3ArHBHIEaGFUMAJPWXs3cyMqbrYi
	 xcqRYKdpavnvvwuY+xHYJMSQM4x7s3yKpYx9LTzre5Q8KQIHY6FF4MUZBGH/RGO/pr
	 +GILyPN3PmGvvbPW4MBHczi/5+aPTBA6D6TyxgrY=
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
Subject: [PATCH 6.12 104/466] bpf: Fix narrow scalar spill onto 64-bit spilled scalar slots
Date: Thu, 12 Dec 2024 15:54:33 +0100
Message-ID: <20241212144310.921494711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cdf8ce1e2cc4f..b2008076df9c2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4649,6 +4649,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	 */
 	if (!env->allow_ptr_leaks &&
 	    is_spilled_reg(&state->stack[spi]) &&
+	    !is_spilled_scalar_reg(&state->stack[spi]) &&
 	    size != BPF_REG_SIZE) {
 		verbose(env, "attempt to corrupt spilled pointer on stack\n");
 		return -EACCES;
-- 
2.43.0



