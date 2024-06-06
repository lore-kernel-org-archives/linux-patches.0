Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18883196DA8;
	Thu,  6 Jun 2024 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683300; cv=none; b=nVBr9xv6UmcxjSphtYkcabSE3cQ7WJg6Genr7Q4w6XigdDwRuBZkNZkugdj18FuY2Jms1uyqvVVIZA+eQN3M2zdHhhoBi6MIfA2rniwn+wrgbPmEbH6vldKErQLPbeQXZ17lrVos83ujeTRJ1cclmzBR0fitPAB2ifsmGQkiUvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683300; c=relaxed/simple;
	bh=9MPj+djPZQSxKl+rnvbYERtbhDjagy4Z41Kj9QLliCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMI/PflooX6m4ecoaSMCJ0YX7bIu+R7DGuQOtQn1eLvoL+oyi79I0nJsc79fglH/FdgzKCFvAxLANnHi9+TTuz62U2NnYoFbybDyIsB6FqSt8WKyXgs/mxdc6CJEtTfk0Bj5/R/eJyFriEek3hKJwcR7Q6PIob6Uf7ZYWcv0+ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oobLVul9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oobLVul9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A054CC32781;
	Thu,  6 Jun 2024 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683299;
	bh=9MPj+djPZQSxKl+rnvbYERtbhDjagy4Z41Kj9QLliCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oobLVul9cnUPoOHSWvqVh4AqvM3t1hc6YHlCJCcyWXrFYnC/BmYJovmktGtYYw6iA
	 AVrznVCZk1db/t1kFhCERX7D07O64Q6Q2WilpnlIj99pUkCMmddYvXTTO/eetJVj07
	 Eqs+PBCabs03a3TM1vz0kLwYxV5RTRNkMCn0qkc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay12@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/473] s390/bpf: Emit a barrier for BPF_FETCH instructions
Date: Thu,  6 Jun 2024 16:01:49 +0200
Message-ID: <20240606131705.881350928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 68378982f0b21de02ac3c6a11e2420badefcb4bc ]

BPF_ATOMIC_OP() macro documentation states that "BPF_ADD | BPF_FETCH"
should be the same as atomic_fetch_add(), which is currently not the
case on s390x: the serialization instruction "bcr 14,0" is missing.
This applies to "and", "or" and "xor" variants too.

s390x is allowed to reorder stores with subsequent fetches from
different addresses, so code relying on BPF_FETCH acting as a barrier,
for example:

  stw [%r0], 1
  afadd [%r1], %r2
  ldxw %r3, [%r4]

may be broken. Fix it by emitting "bcr 14,0".

Note that a separate serialization instruction is not needed for
BPF_XCHG and BPF_CMPXCHG, because COMPARE AND SWAP performs
serialization itself.

Fixes: ba3b86b9cef0 ("s390/bpf: Implement new atomic ops")
Reported-by: Puranjay Mohan <puranjay12@gmail.com>
Closes: https://lore.kernel.org/bpf/mb61p34qvq3wf.fsf@kernel.org/
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20240507000557.12048-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index fbdba4c306bea..8623863935576 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1207,8 +1207,12 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 	EMIT6_DISP_LH(0xeb000000, is32 ? (op32) : (op64),		\
 		      (insn->imm & BPF_FETCH) ? src_reg : REG_W0,	\
 		      src_reg, dst_reg, off);				\
-	if (is32 && (insn->imm & BPF_FETCH))				\
-		EMIT_ZERO(src_reg);					\
+	if (insn->imm & BPF_FETCH) {					\
+		/* bcr 14,0 - see atomic_fetch_{add,and,or,xor}() */	\
+		_EMIT2(0x07e0);						\
+		if (is32)                                               \
+			EMIT_ZERO(src_reg);				\
+	}								\
 } while (0)
 		case BPF_ADD:
 		case BPF_ADD | BPF_FETCH:
-- 
2.43.0



