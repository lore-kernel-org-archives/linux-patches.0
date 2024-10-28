Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1D218E05D;
	Mon, 28 Oct 2024 06:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098165; cv=none; b=jpRHZI74WzZZ+K8edv8FG0BCNodS0aaixFBo7JimQl3Yy5T7znZZsMOMPYqDiCrRhfv2xUcZQ44nk1kNaUr6q3iJ+Xf7WZIuYlaN0zEAhozRSZbot1HNmxTqBLc8xyd+lVSkQyTwhWYUZd1nrvaJeFr/cplPL6ryicSuu3gjuhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098165; c=relaxed/simple;
	bh=J4u6alkYhhTOMEg2QVKh3tWS5VRkrnfiSVAbdtGcYY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=am0Ujq4mTcCYJK21gdcMs2Go3bq0XZr7UCWp98rx5q9crReKlWu8+5XhZ3bOkZbNjWoSFtXJGkn7OywN175+LhsTuzrgTWBdimg7WaXNSQi335Mi4+obeKEtboWZMnBFCjbVSa9XbJ/7FRd7pLD3f6RCIpliQGbvpiQGXdfAPiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i86ODAPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i86ODAPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5248EC4CEC3;
	Mon, 28 Oct 2024 06:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098164;
	bh=J4u6alkYhhTOMEg2QVKh3tWS5VRkrnfiSVAbdtGcYY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i86ODAPvdBgdnyCMf1Xty9IbDznNnQdf8ThgHiZDbilAYLUZHONpVACIGl4LdTzrD
	 rpkMpHyPPS7O9YGvW0e+7QnQZFHxL6Fm5nT3rjWnEJYlPYyYSv4Sf2YBR6enMLSsqG
	 hL0POrkKzYzkICY0q58KS0BlSaZwFh21iFsGnXz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 106/261] riscv, bpf: Make BPF_CMPXCHG fully ordered
Date: Mon, 28 Oct 2024 07:24:08 +0100
Message-ID: <20241028062314.687837174@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit e59db0623f6955986d1be0880b351a1f56e7fd6d ]

According to the prototype formal BPF memory consistency model
discussed e.g. in [1] and following the ordering properties of
the C/in-kernel macro atomic_cmpxchg(), a BPF atomic operation
with the BPF_CMPXCHG modifier is fully ordered.  However, the
current RISC-V JIT lowerings fail to meet such memory ordering
property.  This is illustrated by the following litmus test:

BPF BPF__MP+success_cmpxchg+fence
{
 0:r1=x; 0:r3=y; 0:r5=1;
 1:r2=y; 1:r4=f; 1:r7=x;
}
 P0                               | P1                                         ;
 *(u64 *)(r1 + 0) = 1             | r1 = *(u64 *)(r2 + 0)                      ;
 r2 = cmpxchg_64 (r3 + 0, r4, r5) | r3 = atomic_fetch_add((u64 *)(r4 + 0), r5) ;
                                  | r6 = *(u64 *)(r7 + 0)                      ;
exists (1:r1=1 /\ 1:r6=0)

whose "exists" clause is not satisfiable according to the BPF
memory model.  Using the current RISC-V JIT lowerings, the test
can be mapped to the following RISC-V litmus test:

RISCV RISCV__MP+success_cmpxchg+fence
{
 0:x1=x; 0:x3=y; 0:x5=1;
 1:x2=y; 1:x4=f; 1:x7=x;
}
 P0                 | P1                          ;
 sd x5, 0(x1)       | ld x1, 0(x2)                ;
 L00:               | amoadd.d.aqrl x3, x5, 0(x4) ;
 lr.d x2, 0(x3)     | ld x6, 0(x7)                ;
 bne x2, x4, L01    |                             ;
 sc.d x6, x5, 0(x3) |                             ;
 bne x6, x4, L00    |                             ;
 fence rw, rw       |                             ;
 L01:               |                             ;
exists (1:x1=1 /\ 1:x6=0)

where the two stores in P0 can be reordered.  Update the RISC-V
JIT lowerings/implementation of BPF_CMPXCHG to emit an SC with
RELEASE ("rl") annotation in order to meet the expected memory
ordering guarantees.  The resulting RISC-V JIT lowerings of
BPF_CMPXCHG match the RISC-V lowerings of the C atomic_cmpxchg().

Other lowerings were fixed via 20a759df3bba ("riscv, bpf: make
some atomic operations fully ordered").

Fixes: dd642ccb45ec ("riscv, bpf: Implement more atomic operations for RV64")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lpc.events/event/18/contributions/1949/attachments/1665/3441/bpfmemmodel.2024.09.19p.pdf [1]
Link: https://lore.kernel.org/bpf/20241017143628.2673894-1-parri.andrea@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 91bd5082c4d8e..4cc631fa70391 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -550,8 +550,8 @@ static void emit_atomic(u8 rd, u8 rs, s16 off, s32 imm, bool is64,
 		     rv_lr_w(r0, 0, rd, 0, 0), ctx);
 		jmp_offset = ninsns_rvoff(8);
 		emit(rv_bne(RV_REG_T2, r0, jmp_offset >> 1), ctx);
-		emit(is64 ? rv_sc_d(RV_REG_T3, rs, rd, 0, 0) :
-		     rv_sc_w(RV_REG_T3, rs, rd, 0, 0), ctx);
+		emit(is64 ? rv_sc_d(RV_REG_T3, rs, rd, 0, 1) :
+		     rv_sc_w(RV_REG_T3, rs, rd, 0, 1), ctx);
 		jmp_offset = ninsns_rvoff(-6);
 		emit(rv_bne(RV_REG_T3, 0, jmp_offset >> 1), ctx);
 		emit(rv_fence(0x3, 0x3), ctx);
-- 
2.43.0



