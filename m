Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268203F1AAD;
	Sat, 12 Sep 2026 08:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202440; cv=none; b=iLY6C9J+SsOyApSmYirL6puSXgGP2oOpv26a6X+1oacjsGJJLeSV1+QpM6u34jjpEqX3cxV7OQlwr48vNMdJ379PcAk0BBUpHzcTgjJmxcuj6u/zfNrYQYUZohomLkvg90giASHq0wyTEwMXLjpVJS7/Q+Cfvylf9uAMn1FukMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202440; c=relaxed/simple;
	bh=fmiDuOuccXwRYv+Sxi4ESxLRMOvrZGF2cpPGv30juV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz/4jVXDIfQFW/9jDE1gi0Y36CPhLmR2RCI7AoyP5xI0h53/uXCPtMpQidCqogkJlpM1hi0gKLY/Veiatq2r8b7nqkLePOsjruoWxGahOyChZVeq0HpFo42FlRNXKlvTGgII5zwRidaYP3QeFIK3GeDwG9IcgLXQBq6xM7yQGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7FOPHxM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7FOPHxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30DE1F000FF;
	Sat, 12 Sep 2026 08:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202439;
	bh=kx4XA/3JFKfXW5NhmAZ+Hp3Z7FuIkYGtAkxtyKDt6rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7FOPHxMw0ODGNKhlsG5j5Ryvc0RrrfINFGy2mxOYqkYKCKsTNrqdhvWRKgxm5q8N
	 2/oH9+k5d/UN6gI7TvDdyW9l2kx4DGiJveXsogWmJ/emP0y1Tp2rVeowi2P3yoND/r
	 wG4C11QlI/PAdNb0wZrhK9wG0J0mtl0xqbeoikT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1204/1815] bpf, arm64: Fix exception table metadata for arena load-acquire
Date: Sat, 12 Sep 2026 08:49:14 +0200
Message-ID: <20260912065717.273969394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit af22d273aa1f61fb86ec712b3ed785da73c3296e ]

Same problem as on x86-64: add_exception_handler() decides whether an
instruction is a load by its class, and a load-acquire is of BPF_STX
class even though it reads from src_reg into dst_reg. As a result ...

  if (BPF_CLASS(insn->code) != BPF_LDX)
          dst_reg = DONT_CLEAR;

... drops the register to clear, and ...

  if (BPF_CLASS(insn->code) == BPF_LDX)
          arena_reg = bpf2a64[insn->src_reg];
  else
          arena_reg = bpf2a64[insn->dst_reg];

... hands ex_handler_bpf() the value register instead of the address
register. A load-acquire from an arena pointer that faults on an
unmapped page is therefore reported as a WRITE at a bogus address,
and dst_reg keeps its previous value instead of being cleared to 0.

Note that emit_atomic_ld_st() already picks src_reg as the address
for BPF_LOAD_ACQ, so only the exception table metadata was out of sync
with the emitted access.

Same as on x86-64, use bpf_atomic_is_load_acq() so a load-acquire takes
the load path.

Fixes: 9bb12368d539 ("bpf, arm64: Support load-acquire and store-release instructions")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/bpf/20260806201047.333389-4-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index b0075ece4a6e7..8bc604dd9aab8 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1178,7 +1178,12 @@ static int add_exception_handler(const struct bpf_insn *insn,
 
 	ex->insn = ins_offset;
 
-	if (BPF_CLASS(insn->code) != BPF_LDX)
+	/*
+	 * A load-acquire is of BPF_STX class, but reads from src_reg into
+	 * dst_reg like a BPF_LDX does, hence it must not be treated as a store
+	 * here.
+	 */
+	if (BPF_CLASS(insn->code) != BPF_LDX && !bpf_atomic_is_load_acq(insn))
 		dst_reg = DONT_CLEAR;
 
 	ex->fixup = FIELD_PREP(BPF_FIXUP_REG_MASK, dst_reg);
@@ -1193,7 +1198,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
 		 * memory access. Pass the reg holding the unmodified 32-bit address to
 		 * ex_handler_bpf.
 		 */
-		if (BPF_CLASS(insn->code) == BPF_LDX)
+		if (BPF_CLASS(insn->code) == BPF_LDX || bpf_atomic_is_load_acq(insn))
 			arena_reg = bpf2a64[insn->src_reg];
 		else
 			arena_reg = bpf2a64[insn->dst_reg];
-- 
2.53.0



