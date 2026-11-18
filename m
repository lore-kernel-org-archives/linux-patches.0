Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026119;
	b=rjV+gB51Iz/3kQkRqnhZoE7MIY63zFpD0TBMgTsJnu8aWeg0Yv8vIPTyC59QvC3rrdqa
	 5HELm+qGFCYnVn3Qpnx+GEIZUbj+qL5QGgCN57GAlOM7WD24+B/yilJrdzjEiMqJHjslC
	 GaYSyxZlkh9ecLmp6nfgG8jUR8zFRjijjO3pnYiAm/YCPZuYQxlIkL/tFwS0uz0TFDOuM
	 ATmWqZ7QbHOXC8n33vxixzCEXmEFFREgtuFFzFSHr/SKTR6nRhkFpjzHJxYnWLG3KQkdt
	 jwwZloWUOLX3Y3kYVeTWWjUps5rNGSYxFqABoyP/upCLKHXTEo/hfsQhQI9NQeRKuig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jBSRNQL1xa3IcD/8KDXdpXn2DDjg1AE/eoxovUSffRQ=;
	b=xufKo7zzfpbNNJY9JWz8G9GVzjQD0V7zFA755RCmRQz6fpNjrEG0HguSsxBwq/TIUaLS
	 1yGid2VvU7ikzxAAdP+fdUE+U1RGhhwntqr4K5P8hHcLLRhioBe6xJxmLs1uFAb5eNFdU
	 h8nlMRxvVU97RU5aLZH3uY9dAwzed4NUR7c6/pGC8p9IfloI4oCM6TVW6VnP5wdj4Y1Id
	 5w2oi28PUMMJTuspNObpIHST4NIwXdy4ellfozL8UY1rNW4ffPGJaOZe94sKiom/B45XA
	 oprV5KDNqzoBWPf6Y1modmbIzSh5YOD/L06Mp9+sywcvlk9mXePmqzn74i1NAKnyfug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUzjm0sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28588606A320;
	Wed, 18 Nov 2026 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUzjm0sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751B11F000D0;
	Wed, 18 Nov 2026 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026119;
	bh=jBSRNQL1xa3IcD/8KDXdpXn2DDjg1AE/eoxovUSffRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUzjm0smibgD1tLqZdMwQIT7FyPOXHKxSICb21xiPXyp3kF76K8A7KE6g3U9yrWRg
	 9ocX0oR5T6QyLKFKHzz+hoMxx6BgfDW7fdBi/T7n6BIOIOjOUzjw6Ut+NbcUOtzC8+
	 rWxA3uAbSWYkC6le2s2RjF1/aD7lYpvX2wYK4J1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1320/2151] bpf, riscv: Fix stack-passed arguments for indirect trampolines
Date: Wed, 18 Nov 2026 15:50:55 +0100
Message-ID: <20261118150210.174805727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit b4a1ecae94ae803fcd75fb16a7653ff86b64ed8b ]

store_args() reads stack-passed arguments relative to FP assuming the
trampoline was entered through the fentry call from a traced function. In
that path, the trampoline pushes the parent frame before establishing its
final FP, so the incoming stack arguments start at FP + 16.

An indirect trampoline for a struct_ops callback is called through a
function pointer. Its prologue allocates only the trampoline frame and sets
FP to the incoming SP. The RISC-V ABI places the first stack argument at
that incoming SP, so the arguments start at FP, not FP + 16. Every
stack-passed argument of a callback with more than eight argument slots is
therefore read two slots late.

Pass the prologue-dependent offset to store_args(), using zero for a direct
struct_ops trampoline and 16 for the fentry path.

Fixes: 6801b0aef79d ("riscv, bpf: Add 12-argument support for RV64 bpf trampoline")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260930083522.1914145-2-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 3e4eea261ab96..480a5262f1477 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -883,7 +883,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 	return ret;
 }
 
-static void store_args(int nr_arg_slots, int args_off, struct rv_jit_context *ctx)
+static void store_args(int nr_arg_slots, int args_off, int stack_args_off,
+		       struct rv_jit_context *ctx)
 {
 	int i;
 
@@ -891,8 +892,8 @@ static void store_args(int nr_arg_slots, int args_off, struct rv_jit_context *ct
 		if (i < RV_MAX_REG_ARGS) {
 			emit_sd(RV_REG_FP, -args_off, RV_REG_A0 + i, ctx);
 		} else {
-			/* skip slots for T0 and FP of traced function */
-			emit_ld(RV_REG_T1, 16 + (i - RV_MAX_REG_ARGS) * 8, RV_REG_FP, ctx);
+			emit_ld(RV_REG_T1, stack_args_off +
+				(i - RV_MAX_REG_ARGS) * 8, RV_REG_FP, ctx);
 			emit_sd(RV_REG_FP, -args_off, RV_REG_T1, ctx);
 		}
 		args_off -= 8;
@@ -1127,7 +1128,12 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	emit_li(RV_REG_T1, nr_arg_slots, ctx);
 	emit_sd(RV_REG_FP, -nregs_off, RV_REG_T1, ctx);
 
-	store_args(nr_arg_slots, args_off, ctx);
+	/*
+	 * A direct struct_ops call has its first stack argument at the incoming
+	 * SP, which the trampoline keeps as FP. The fentry path pushes the
+	 * parent frame first, so its incoming stack arguments start at FP + 16.
+	 */
+	store_args(nr_arg_slots, args_off, is_struct_ops ? 0 : 16, ctx);
 
 	/* skip to actual body of traced function */
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
-- 
2.53.0



