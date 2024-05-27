Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E0917727;
	Mon, 27 May 2024 19:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838242; cv=none; b=bhPskBFm5fIIk4k+1gSG+i+6PfxvRXy40gqp85yLX+ArSGUMHBZvybO/89SzScpZ6YzyOqbHL8efB1D/KlUAj9VqS63uMYZqyI9j6B6E+9KxNID0D/H6msG32qQOB+Vq+9HB1sM5VXoVHaWXmhToOW7oyB4u9UOp1vgbNG06Grg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838242; c=relaxed/simple;
	bh=Ynj7gzcMHwIorxOSzXhZa1/ASWNG270OzG7BKaLPbRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKKZS8oVfBJ1b218JszbCBnppyn5hL6myKEr2sCK47kWavVzGmg01ZbdjxooCTnsaO755DswBomes/V/1EPBdD9eHkkRQah33MVTmhbU4zfFwvSaC3zJF2/PO+LP3GtQo2MkhWM+x32b/7w9KEWNBE5c43bgMZYpYeFW99JEoqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDW3oliQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDW3oliQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562AAC2BBFC;
	Mon, 27 May 2024 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838242;
	bh=Ynj7gzcMHwIorxOSzXhZa1/ASWNG270OzG7BKaLPbRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDW3oliQ7ULC06LS+a1jAQCWxttAL1JpWpRnoWSyXtNzGDQ/oxp2uy5+Ivj//yx0H
	 wxyi7cpsTbyhSAhK8bxX/lFLNLCPYEKFY1rDRKvv6ClGQ24/w8d08l45NtPCYNZ8wE
	 WfG2J7vrAYVcEtWhWW4bKrV0/3y6v20Tv/AA7tes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 320/493] riscv, bpf: make some atomic operations fully ordered
Date: Mon, 27 May 2024 20:55:22 +0200
Message-ID: <20240527185640.748055457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 20a759df3bba35bf5c3ddec0c02ad69b603b584c ]

The BPF atomic operations with the BPF_FETCH modifier along with
BPF_XCHG and BPF_CMPXCHG are fully ordered but the RISC-V JIT implements
all atomic operations except BPF_CMPXCHG with relaxed ordering.

Section 8.1 of the "The RISC-V Instruction Set Manual Volume I:
Unprivileged ISA" [1], titled, "Specifying Ordering of Atomic
Instructions" says:

| To provide more efficient support for release consistency [5], each
| atomic instruction has two bits, aq and rl, used to specify additional
| memory ordering constraints as viewed by other RISC-V harts.

and

| If only the aq bit is set, the atomic memory operation is treated as
| an acquire access.
| If only the rl bit is set, the atomic memory operation is treated as a
| release access.
|
| If both the aq and rl bits are set, the atomic memory operation is
| sequentially consistent.

Fix this by setting both aq and rl bits as 1 for operations with
BPF_FETCH and BPF_XCHG.

[1] https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf

Fixes: dd642ccb45ec ("riscv, bpf: Implement more atomic operations for RV64")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20240505201633.123115-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 0bd747d1d00fc..29f031f68f480 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -516,33 +516,33 @@ static void emit_atomic(u8 rd, u8 rs, s16 off, s32 imm, bool is64,
 		break;
 	/* src_reg = atomic_fetch_<op>(dst_reg + off16, src_reg) */
 	case BPF_ADD | BPF_FETCH:
-		emit(is64 ? rv_amoadd_d(rs, rs, rd, 0, 0) :
-		     rv_amoadd_w(rs, rs, rd, 0, 0), ctx);
+		emit(is64 ? rv_amoadd_d(rs, rs, rd, 1, 1) :
+		     rv_amoadd_w(rs, rs, rd, 1, 1), ctx);
 		if (!is64)
 			emit_zext_32(rs, ctx);
 		break;
 	case BPF_AND | BPF_FETCH:
-		emit(is64 ? rv_amoand_d(rs, rs, rd, 0, 0) :
-		     rv_amoand_w(rs, rs, rd, 0, 0), ctx);
+		emit(is64 ? rv_amoand_d(rs, rs, rd, 1, 1) :
+		     rv_amoand_w(rs, rs, rd, 1, 1), ctx);
 		if (!is64)
 			emit_zext_32(rs, ctx);
 		break;
 	case BPF_OR | BPF_FETCH:
-		emit(is64 ? rv_amoor_d(rs, rs, rd, 0, 0) :
-		     rv_amoor_w(rs, rs, rd, 0, 0), ctx);
+		emit(is64 ? rv_amoor_d(rs, rs, rd, 1, 1) :
+		     rv_amoor_w(rs, rs, rd, 1, 1), ctx);
 		if (!is64)
 			emit_zext_32(rs, ctx);
 		break;
 	case BPF_XOR | BPF_FETCH:
-		emit(is64 ? rv_amoxor_d(rs, rs, rd, 0, 0) :
-		     rv_amoxor_w(rs, rs, rd, 0, 0), ctx);
+		emit(is64 ? rv_amoxor_d(rs, rs, rd, 1, 1) :
+		     rv_amoxor_w(rs, rs, rd, 1, 1), ctx);
 		if (!is64)
 			emit_zext_32(rs, ctx);
 		break;
 	/* src_reg = atomic_xchg(dst_reg + off16, src_reg); */
 	case BPF_XCHG:
-		emit(is64 ? rv_amoswap_d(rs, rs, rd, 0, 0) :
-		     rv_amoswap_w(rs, rs, rd, 0, 0), ctx);
+		emit(is64 ? rv_amoswap_d(rs, rs, rd, 1, 1) :
+		     rv_amoswap_w(rs, rs, rd, 1, 1), ctx);
 		if (!is64)
 			emit_zext_32(rs, ctx);
 		break;
-- 
2.43.0



