Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892A19883B;
	Thu,  6 Jun 2024 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683313; cv=none; b=c6v263KBt6FQUe+98sgvmNx95MiALFViOocbfTTI/SyfmDiJd6kyEK/h+6ZOhRJsoSAvo1eM6AHzhGRcZVRlqKeheAnbxUIyCvvwLR2F43HEXZGNwjgQjuaHDEXLe4oCzuVeWfvjsa8Sbk94jTselxEedGVyx5hdTPmwDd4mTuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683313; c=relaxed/simple;
	bh=WWR9XduRrxt6TrAf9GjoywQNrM4qgy/T4/fkRKozIws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcwJEBvC8LvCBdVTLeEWHX0XGffKpZDYzS4ajX1pjXchFjG29ozlIIHeI4dtRu32pICYrgg0PS8HgiB5bfqfaj8QbAHp2Bv62xaLzMtDm8vlu9nXQ2rOJbbSI+hP2Ht7xPYTREBrJ9QJ6xSl6ll95ZvAtKYxm8ODAX7dBhmX/5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hx1/f9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hx1/f9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954C5C2BD10;
	Thu,  6 Jun 2024 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683313;
	bh=WWR9XduRrxt6TrAf9GjoywQNrM4qgy/T4/fkRKozIws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hx1/f9boyLRUCnaXaAFCL2o57cy0a1HqZqW/XkenyZNDsX2Sz3B1Vho1JL9DQ6a/
	 uhHE+hlXUcZ/a1jSlf/vCbix3/F7m1pNf8Yl2OkGqHhnlaF0CpWTVHNO30DflpoGaP
	 GdRc42NgRKHk8bUpxlrrTttMcYCGkgth7XGhOTnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/744] riscv, bpf: make some atomic operations fully ordered
Date: Thu,  6 Jun 2024 15:58:46 +0200
Message-ID: <20240606131740.547670962@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index b3990874e4818..2f041b5cea970 100644
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



