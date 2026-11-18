Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019456;
	b=Aa4Xy6FiwcdSKIOHFitDK6zZFgSh5ihcj2mMbFlYv5qijNEQzVg0S1HixVhVW/GUzp6t
	 iJaJ8fVdU5Uy1BWkldO/Qa7Env2aOSgQZP9Y1DqXkYPFPY7b80805MIt8kIDSJ4PlEfLr
	 /ty5b8q2nMZDWYkZ+ABN3Pt07A3WDtBqW93/sWoFcBmPdIdLTk9xq1zSXDR3v/zHkJ1DJ
	 B0vxla6YI8ZqdGlxPBUngiYQmUxesT6pXGL76b28glUWpsZ1nPxsX3ePfo2Pe1/lzCHIl
	 YFtDEBQuIPYfdReTx9bGdbJ+vZHHhlRbq0rhZo7a9DyltQOTp+ybKe2l6mCaQSWeFSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W2O5BSvP0bHx33IFdd9umxL1rs7FOvnByRGjkJB7rYA=;
	b=Ram9udjTSLfRzx5yhE6AibiefPHr0qQWNRCU1gTvT3GOjkf+OzZqrXtpq0KIM3PeeFCF
	 TQXS7mLbiZZWCGoxSa8LWwjcQG2famWXr5SsxEjCVEwT48S2eNFzq58Vw3BT2I5CdR+gj
	 +mZOLPbTtglxFUDigIfGH9Gt1M0ZkUniTHpJDwXLDbfZnXs1gfb89lCOSsCB/KvAqw6hI
	 NMxG9F+0BCKBECrKL6nqflUfgNNREG87rziXen0H6EeSUOiH+2MmiPsyLq9CI3TVMrx8p
	 yigXFDkaaIj8wh/IOw3a3SWLcBygiz1h819muho+RIQPDSQBcf3nQkCSC9fjdwck3vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+jT7LNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BF2606A335;
	Wed, 18 Nov 2026 16:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+jT7LNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726061F000C4;
	Wed, 18 Nov 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019455;
	bh=W2O5BSvP0bHx33IFdd9umxL1rs7FOvnByRGjkJB7rYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+jT7LNE9I7v15NXkTHQvzNfjqPORJs1WbNppU7d6djMjWOzCDw1+4T52iqUhAXw8
	 ejkFr76+5EtgAr4bi2IgmS4VJBWI/+i/BJyqhn42frycsIsTdLdoEHmN9YOZv7kra5
	 ie7mEXJvGtLi8YMRBYx9OH8O4hpQmLcy77Bm2RJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1601/2651] bpf, riscv: Fix stack-passed arguments for indirect trampolines
Date: Wed, 18 Nov 2026 15:47:21 +0100
Message-ID: <20261118150345.490743881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 01fe66774f029..33322764234c1 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -875,7 +875,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
 	return ret;
 }
 
-static void store_args(int nr_arg_slots, int args_off, struct rv_jit_context *ctx)
+static void store_args(int nr_arg_slots, int args_off, int stack_args_off,
+		       struct rv_jit_context *ctx)
 {
 	int i;
 
@@ -883,8 +884,8 @@ static void store_args(int nr_arg_slots, int args_off, struct rv_jit_context *ct
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
@@ -1179,7 +1180,12 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	func_meta = nr_arg_slots;
 	emit_store_stack_imm64(RV_REG_T1, -func_meta_off, func_meta, ctx);
 
-	store_args(nr_arg_slots, args_off, ctx);
+	/*
+	 * A direct struct_ops call has its first stack argument at the incoming
+	 * SP, which the trampoline keeps as FP. The fentry path pushes the
+	 * parent frame first, so its incoming stack arguments start at FP + 16.
+	 */
+	store_args(nr_arg_slots, args_off, is_struct_ops ? 0 : 16, ctx);
 
 	if (bpf_fsession_cnt(tnodes)) {
 		/* clear all session cookies' value */
-- 
2.53.0



