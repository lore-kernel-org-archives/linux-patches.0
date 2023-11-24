Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F0321AD;
	Fri, 24 Nov 2023 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLVhnHhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E22C433C7;
	Fri, 24 Nov 2023 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850892;
	bh=DBdSeweK/FQwsQgXgH0K8GwZvexHGb5CyTVsBYGPcxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLVhnHhfFGY4x0kKhlzpMq3NjO5ZlhIrpxmn2lG3Zd/q8s6dZ0ytfdmw5CyD+0nPY
	 tyi7v1M4+iB21FQr7ILfnUL8L8OIP4opA5mf3rxKaAkctHg+8g6HFaxELlPW5kRETk
	 kgO6ukWXrmXUxCXS4JaAGq9P61J+JMKFmSqzNjCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.5 231/491] bpf: Fix check_stack_write_fixed_off() to correctly spill imm
Date: Fri, 24 Nov 2023 17:47:47 +0000
Message-ID: <20231124172031.497225055@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Sun <sunhao.th@gmail.com>

commit 811c363645b33e6e22658634329e95f383dfc705 upstream.

In check_stack_write_fixed_off(), imm value is cast to u32 before being
spilled to the stack. Therefore, the sign information is lost, and the
range information is incorrect when load from the stack again.

For the following prog:
0: r2 = r10
1: *(u64*)(r2 -40) = -44
2: r0 = *(u64*)(r2 - 40)
3: if r0 s<= 0xa goto +2
4: r0 = 1
5: exit
6: r0  = 0
7: exit

The verifier gives:
func#0 @0
0: R1=ctx(off=0,imm=0) R10=fp0
0: (bf) r2 = r10                      ; R2_w=fp0 R10=fp0
1: (7a) *(u64 *)(r2 -40) = -44        ; R2_w=fp0 fp-40_w=4294967252
2: (79) r0 = *(u64 *)(r2 -40)         ; R0_w=4294967252 R2_w=fp0
fp-40_w=4294967252
3: (c5) if r0 s< 0xa goto pc+2
mark_precise: frame0: last_idx 3 first_idx 0 subseq_idx -1
mark_precise: frame0: regs=r0 stack= before 2: (79) r0 = *(u64 *)(r2 -40)
3: R0_w=4294967252
4: (b7) r0 = 1                        ; R0_w=1
5: (95) exit
verification time 7971 usec
stack depth 40
processed 6 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

So remove the incorrect cast, since imm field is declared as s32, and
__mark_reg_known() takes u64, so imm would be correctly sign extended
by compiler.

Fixes: ecdf985d7615 ("bpf: track immediate values written to stack by BPF_ST instruction")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231101-fix-check-stack-write-v3-1-f05c2b1473d5@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4368,7 +4368,7 @@ static int check_stack_write_fixed_off(s
 		   insn->imm != 0 && env->bpf_capable) {
 		struct bpf_reg_state fake_reg = {};
 
-		__mark_reg_known(&fake_reg, (u32)insn->imm);
+		__mark_reg_known(&fake_reg, insn->imm);
 		fake_reg.type = SCALAR_VALUE;
 		save_register_state(state, spi, &fake_reg, size);
 	} else if (reg && is_spillable_regtype(reg->type)) {


