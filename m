Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DA3258ED5;
	Wed, 25 Feb 2026 01:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982931; cv=none; b=jiK8rNBw8kACRQAIo1Wnvht2EHRkQWf3SgI3g+Xi+WUogfGnyw9Fy+C6cKbdpSXwtEOIMKQiv6H8rQO8jvoNtKGMv79daGYEGI9ikBEEHngClEl7+SBt1mq4c89Wc4nAGk25DIT2gEjhi+ugnVfUAynEGHYsYM2gzwtytuwpo0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982931; c=relaxed/simple;
	bh=q1Ht/6k+aBD9QPCzgXFUQfoH6ZX7WMMIxta5NZfQFkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkDvtVOAmU3u5NICO6oMEkqNIjNA0/G1xsOwhD6cBIU5LTqI3oq2+gM/4wfVZXM2z098Qrs8SGO7Uqd68b/ZErKbCliZzaTzFmpm3wb9EK4UdpOcV7+5U8xIynGaV1gnZiZ7l6Q/+xWPz/La7+tF7L6PcYuzXptPPel/kaaWzyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtOY2iNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtOY2iNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0934C2BC87;
	Wed, 25 Feb 2026 01:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982931;
	bh=q1Ht/6k+aBD9QPCzgXFUQfoH6ZX7WMMIxta5NZfQFkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtOY2iNxCWY4XY7LwLuKooMHcocz61m6Fm17E2D00BBRHCOUa+DbUzmE/l4QyCMnh
	 ceT19fEqUXuXB6sLhB+exKNq+WumB9SbI9R2HXaY3/C2RVfVoj7HJq/KwtCunTBE8S
	 0Y+eEDGeOTDeLNuIFCzEOEQDDZbp2HZQ16eX35o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <luis.gerhorst@fau.de>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 108/781] bpf: Fix verifier_bug_if to account for BPF_CALL
Date: Tue, 24 Feb 2026 17:13:37 -0800
Message-ID: <20260225012402.333499681@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Gerhorst <luis.gerhorst@fau.de>

[ Upstream commit cd3b6a3d49f8061d0c4c7e4226783051fe592ae7 ]

The BPF verifier assumes `insn_aux->nospec_result` is only set for
direct memory writes (e.g., `*(u32*)(r1+off) = r2`). However, the
assertion fails to account for helper calls (e.g.,
`bpf_skb_load_bytes_relative`) that perform writes to stack memory. Make
the check more precise to resolve this.

The problem is that `BPF_CALL` instructions have `BPF_CLASS(insn->code)
== BPF_JMP`, which triggers the warning check:

- Helpers like `bpf_skb_load_bytes_relative` write to stack memory
- `check_helper_call()` loops through `meta.access_size`, calling
  `check_mem_access(..., BPF_WRITE)`
- `check_stack_write()` sets `insn_aux->nospec_result = 1`
- Since `BPF_CALL` is encoded as `BPF_JMP | BPF_CALL`, the warning fires

Execution flow:

```
1. Drop capabilities → Enable Spectre mitigation
2. Load BPF program
   └─> do_check()
       ├─> check_cond_jmp_op() → Marks dead branch as speculative
       │   └─> push_stack(..., speculative=true)
       ├─> pop_stack() → state->speculative = 1
       ├─> check_helper_call() → Processes helper in dead branch
       │   └─> check_mem_access(..., BPF_WRITE)
       │       └─> insn_aux->nospec_result = 1
       └─> Checks: state->speculative && insn_aux->nospec_result
           └─> BPF_CLASS(insn->code) == BPF_JMP → WARNING
```

To fix the assert, it would be nice to be able to reuse
bpf_insn_successors() here, but bpf_insn_successors()->cnt is not
exactly what we want as it may also be 1 for BPF_JA. Instead, we could
check opcode_info.can_jump, but then we would have to share the table
between the functions. This would mean moving the table out of the
function and adding bpf_opcode_info(). As the verifier_bug_if() only
runs for insns with nospec_result set, the impact on verification time
would likely still be negligible. However, I assume sharing
bpf_opcode_info() between liveness.c and verifier.c will not be worth
it. It seems as only adjust_jmp_off() could also be simplified using it,
and there imm/off is touched. Thus it is maybe better to rely on exact
opcode/class matching there.

Therefore, to avoid this sharing only for a verifier_bug_if(), just
check the opcode. This should now cover all opcodes for which can_jump
in bpf_insn_successors() is true.

Parts of the description and example are taken from the bug report.

Fixes: dadb59104c64 ("bpf: Fix aux usage after do_check_insn()")
Signed-off-by: Luis Gerhorst <luis.gerhorst@fau.de>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Closes: https://lore.kernel.org/bpf/7678017d-b760-4053-a2d8-a6879b0dbeeb@hust.edu.cn/
Link: https://lore.kernel.org/r/20260127115912.3026761-2-luis.gerhorst@fau.de
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8678ce5c97c5a..c9e2e22da3309 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20615,17 +20615,19 @@ static int do_check(struct bpf_verifier_env *env)
 			 * may skip a nospec patched-in after the jump. This can
 			 * currently never happen because nospec_result is only
 			 * used for the write-ops
-			 * `*(size*)(dst_reg+off)=src_reg|imm32` which must
-			 * never skip the following insn. Still, add a warning
-			 * to document this in case nospec_result is used
-			 * elsewhere in the future.
+			 * `*(size*)(dst_reg+off)=src_reg|imm32` and helper
+			 * calls. These must never skip the following insn
+			 * (i.e., bpf_insn_successors()'s opcode_info.can_jump
+			 * is false). Still, add a warning to document this in
+			 * case nospec_result is used elsewhere in the future.
 			 *
 			 * All non-branch instructions have a single
 			 * fall-through edge. For these, nospec_result should
 			 * already work.
 			 */
-			if (verifier_bug_if(BPF_CLASS(insn->code) == BPF_JMP ||
-					    BPF_CLASS(insn->code) == BPF_JMP32, env,
+			if (verifier_bug_if((BPF_CLASS(insn->code) == BPF_JMP ||
+					     BPF_CLASS(insn->code) == BPF_JMP32) &&
+					    BPF_OP(insn->code) != BPF_CALL, env,
 					    "speculation barrier after jump instruction may not have the desired effect"))
 				return -EFAULT;
 process_bpf_exit:
-- 
2.51.0



