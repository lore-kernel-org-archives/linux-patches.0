Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625285;
	b=yI/fEEzWjV3M+oUkRzULtvqf4ERRz+zG7lv6CpRbxAgTLk1Qru6zHEMUzlXY/xf+cf3N
	 WOg5cuvPEWEPhM9vcNfjFUUiW7HdPoGvTDkALmyKISYdL4EiEHaBKs/0IFY3NiqxWfqgN
	 +oHd/twCK2+FO+1SQfQnO6I6lRmcYy6GI244YfM6UbHTOUZQy/9ERMkHcQz3nc6IP+E9j
	 COcJC2Xu6BlTjp721CuPA0ATTyCGRfsvQGgD3eL15fpZQUn+3MhHBEfMf9cwH60jdTID4
	 resDfm91dwmxdi8LBmW9+n+HD48Wq3o492fRJgJ04KUc72V79SZF88YqNwELaMlQqhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGJ3AQs3KaK6/9JxSEAGOF3b+aGVmNmUlUqyKv4aJMQ=;
	b=smz2QG3+Bsn52JvJu9KlzSi9B2w9zU0ii5dJp6T5hG2IMFzLHHxOgMhqeg3pJpPefxe2
	 5JtVvdXowFf0lBsrq7kwF2CZg/9EOY5fbHov1+uqzBCPdGU5FwayflXqITZIAdDCGDKUL
	 uyAtooI8y2cSk/MiopQooc83uwM3HCByC8qm4dQyzVlunuVWliN3Z1tehrkSUAbgDZv5M
	 T86wDhZo2S68hCMFNvOoae+52WfpMN1oOLMRgF0Zrbtlp2bb3EKfDyMZZ4Iu7eKWhtkMn
	 NaOyA/eS0elrqFFlPklGpVa8A5vQyg9UT0awVxhKuKde9XHV5x4x4Yl2EKVqtMTn27g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5pqq4+s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE4B606A336;
	Wed, 25 Nov 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5pqq4+s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089001F000D1;
	Wed, 25 Nov 2026 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625284;
	bh=UGJ3AQs3KaK6/9JxSEAGOF3b+aGVmNmUlUqyKv4aJMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5pqq4+sAxozDyhLlQIV9ze8gBaYMLn6+pOI7KzmBnguhSma1HUgamzqTpq+6qTA3
	 vhNu4sHFbJWU4ul4APvpC3gKIUzXUTqhdieSQbmidnn1bHv3qNJkZpISTfeZWBfW3L
	 TpG6nKroGWUxUgq2YVhjvk5brRQSITRm4/KZtrC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/816] bpf: Check fastcall stack contract once for all stack accesses
Date: Wed, 25 Nov 2026 15:32:49 +0100
Message-ID: <20261125143858.941951815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit ec3a69e7c021cd826be8886ba6af4ee3147788fb ]

When the verifier inlines a bpf_fastcall helper or kfunc, it removes the
spill/fill pairs that clang emitted around the call and lowers the
subprogram's stack depth so that their slots are no longer part of the
frame. This is only safe if nothing else accesses those slots or any slot
below them. check_fastcall_stack_contract() enforces this: an access to
that region from outside a fastcall pattern disables the rewrite for the
subprogram. It is called from the four stack load and store paths, and
two kinds of access escape it.

Stack buffers passed to helpers and kfuncs are validated by
check_stack_range_initialized(), which does not call it. If such a buffer
is the only other access to the region, the rewrite is still applied, the
JIT reserves a frame that does not contain the buffer, and the helper
reads or writes live kernel stack below the program's frame. For example,
without CAP_PERFMON:

	*(u64 *)(r10 - 8) = r1;
	call bpf_get_smp_processor_id;
	r1 = *(u64 *)(r10 - 8);
	r2 = 0;
	r3 = r10;
	r3 += -64;
	r4 = 8;
	call bpf_skb_load_bytes;

is accepted with a stack depth of 0 instead of 64.

Some buffers got the check indirectly. For constant-sized outputs in raw
mode, mark_raw_stack() marks the buffer initialized through ordinary
byte stores, which call the check. Commit 5da4a9f26fca ("bpf: Preserve
stack initialization for generic output buffers") limited raw mode to
programs that may read uninitialized stack, so outputs of programs
without CAP_PERFMON lost the check, as in the example above. Buffers
that never used raw mode have lacked the check since fastcall support
was added: helper inputs such as a map key whose only store is a fastcall
spill, variable-sized outputs, and buffers at a variable stack offset.

check_stack_read_fixed_off() applies the check to the current frame,
even when the pointer targets a caller's stack. A callee can therefore
read a caller's fastcall spill slot without disabling the caller's
rewrite:

	caller:
	r1 = 1;
	*(u64 *)(r10 - 8) = r1;
	call bpf_get_smp_processor_id;
	r1 = *(u64 *)(r10 - 8);
	r1 = r10;
	r1 += -8;
	call callee;

	callee:
	r0 = *(u64 *)(r1 + 0);

The caller's spill and fill are removed and its stack depth drops to 0,
but the verifier still tracks the slot as holding the spilled constant.
The callee's load then reads kernel stack outside the caller's frame,
while the verifier assumes r0 is 1.

Every stack access first goes through check_stack_access_within_bounds():
loads and stores from check_mem_access(), helper and kfunc buffers from
check_stack_range_initialized(), and the dynptr, iterator and irq flag
slots that kfuncs initialize, whose handlers use check_mem_access(). It
resolves the frame that owns the slots and the lowest offset the access
can touch, and it is the only place where a frame's stack depth grows.
Check the contract there, once for every access, and drop the calls from
the stack read and write paths. Zero-sized buffers touch no stack and
leave the rewrite enabled.

Fixes: 5b5f51bff1b6 ("bpf: no_caller_saved_registers attribute for helper calls")
Fixes: 5da4a9f26fca ("bpf: Preserve stack initialization for generic output buffers")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/85f9995a43edb70c76615280e103dc5325742e88330f36c97962ee35f17e3e32@mail.kernel.org
Link: https://patch.msgid.link/20260924075352.2343553-2-memxor@gmail.com
[ sashal: Removed the four per-path fastcall stack contract calls and added one check in the stack bounds function, with context adjusted since the surrounding verifier code differs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e6e31bddb56a6..85f6f6b121dd6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4853,7 +4853,6 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
-	check_fastcall_stack_contract(env, state, insn_idx, off);
 	mark_stack_slot_scratched(env, spi);
 	if (reg && !(off % BPF_REG_SIZE) && reg->type == SCALAR_VALUE && env->bpf_capable) {
 		bool reg_value_fits;
@@ -4983,7 +4982,6 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 			return err;
 	}
 
-	check_fastcall_stack_contract(env, state, insn_idx, min_off);
 	/* Variable offset writes destroy any spilled pointers in range. */
 	for (i = min_off; i < max_off; i++) {
 		u8 new_type, *stype;
@@ -5127,7 +5125,6 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 	reg = &reg_state->stack[spi].spilled_ptr;
 
 	mark_stack_slot_scratched(env, spi);
-	check_fastcall_stack_contract(env, state, env->insn_idx, off);
 
 	if (is_spilled_reg(&reg_state->stack[spi])) {
 		u8 spill_size = 1;
@@ -5288,7 +5285,6 @@ static int check_stack_read_var_off(struct bpf_verifier_env *env,
 	min_off = reg->smin_value + off;
 	max_off = reg->smax_value + off;
 	mark_reg_stack_read(env, ptr_state, min_off, max_off + size, dst_regno);
-	check_fastcall_stack_contract(env, ptr_state, env->insn_idx, min_off);
 	return 0;
 }
 
@@ -7228,6 +7224,15 @@ static int check_stack_access_within_bounds(
 		return err;
 	}
 
+	/*
+	 * Every stack access passes through here, including buffers passed to
+	 * helpers and kfuncs and accesses into a caller's frame, so check the
+	 * fastcall contract of the frame that owns the slots once for all of
+	 * them. Zero-sized accesses touch no stack and keep the rewrite enabled.
+	 */
+	if (access_size)
+		check_fastcall_stack_contract(env, state, env->insn_idx, min_off);
+
 	/* Note that there is no stack access with offset zero, so the needed stack
 	 * size is -min_off, not -min_off+1.
 	 */
-- 
2.53.0



