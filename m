Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5CF331220;
	Wed, 20 May 2026 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297529; cv=none; b=qO61luPHZl+REoYFv8Depyemm6TytU8w3Ruhc1UC17fsgMMIA3PRvtCkTDJM0X/QcL560OWL0h/qowDEwT49OycqRi3fDv6C36zDkUEJgz898au8qNmxesIe6W32PFKZVuPUGKHzj4GTqPuSIHhuOGFWy7YPtQ4wpHMIEcKeR5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297529; c=relaxed/simple;
	bh=nsBHbCdsvE3Dk1MYqGppT9iUaxRxLJ9D2w3KSerjTn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfpDT8TuaKdJhP3KT2X1+DlLxBpvRUaYlOXsiYxiAiJyJ+mMaRtvNUMbCZ0YyOT0QAWcDhn0psSeI2rOsouyy4HNnb3cnY9tKOFX8UvtGXyyqaRQjzah3QQHGa4PMyXlzXR8B+V5/1YrM0FcQzhdRPTwhvXY9llE5SwEnbH0Uys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1d3cvmM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1d3cvmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979B91F00894;
	Wed, 20 May 2026 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297527;
	bh=gmXpJeTHOGs/DCm2bB+uJke9sxnMoWV8/sdg6y4YjAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1d3cvmMr26vkk2EyIkUwrlcewhy4dSEByJLk2npZLeQv5KOl6AgwBM0n+lBZCKwB
	 /0bUm0rb+pevjEBWuVjb1qVHWVNzsAV0nLIktGbP6a8i1cTh7dFV1wmG0gir3VgYIm
	 gAzwNgfLlPLRflfC7vZ3zZYxqZwU/C9qgKErHXsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/957] s390/bpf: Zero-extend bpf prog return values and kfunc arguments
Date: Wed, 20 May 2026 18:09:08 +0200
Message-ID: <20260520162135.972925432@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 202e42e4aa890172366354b233c42c73107a3f59 ]

s390x ABI requires callers to zero-extend unsigned arguments and
sign-extend signed arguments, and callees to zero-extend unsigned
return values and sign-extend signed return values.

s390 BPF JIT currently implements only sign extension. Fix this
omission and implement zero extension too.

Fixes: 528eb2cb87bc ("s390/bpf: Implement arch_prepare_bpf_trampoline()")
Reported-by: Hari Bathini <hbathini@linux.ibm.com>
Closes: https://lore.kernel.org/bpf/20260312080113.843408-1-hbathini@linux.ibm.com/
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260313174807.581826-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 39 ++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index cf461d76e9da3..d7cdd907ac797 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -831,25 +831,34 @@ static int bpf_jit_probe_post(struct bpf_jit *jit, struct bpf_prog *fp,
 }
 
 /*
- * Sign-extend the register if necessary
+ * Sign- or zero-extend the register if necessary
  */
-static int sign_extend(struct bpf_jit *jit, int r, u8 size, u8 flags)
+static int sign_zero_extend(struct bpf_jit *jit, int r, u8 size, u8 flags)
 {
-	if (!(flags & BTF_FMODEL_SIGNED_ARG))
-		return 0;
-
 	switch (size) {
 	case 1:
-		/* lgbr %r,%r */
-		EMIT4(0xb9060000, r, r);
+		if (flags & BTF_FMODEL_SIGNED_ARG)
+			/* lgbr %r,%r */
+			EMIT4(0xb9060000, r, r);
+		else
+			/* llgcr %r,%r */
+			EMIT4(0xb9840000, r, r);
 		return 0;
 	case 2:
-		/* lghr %r,%r */
-		EMIT4(0xb9070000, r, r);
+		if (flags & BTF_FMODEL_SIGNED_ARG)
+			/* lghr %r,%r */
+			EMIT4(0xb9070000, r, r);
+		else
+			/* llghr %r,%r */
+			EMIT4(0xb9850000, r, r);
 		return 0;
 	case 4:
-		/* lgfr %r,%r */
-		EMIT4(0xb9140000, r, r);
+		if (flags & BTF_FMODEL_SIGNED_ARG)
+			/* lgfr %r,%r */
+			EMIT4(0xb9140000, r, r);
+		else
+			/* llgfr %r,%r */
+			EMIT4(0xb9160000, r, r);
 		return 0;
 	case 8:
 		return 0;
@@ -1799,9 +1808,9 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 				return -1;
 
 			for (j = 0; j < m->nr_args; j++) {
-				if (sign_extend(jit, BPF_REG_1 + j,
-						m->arg_size[j],
-						m->arg_flags[j]))
+				if (sign_zero_extend(jit, BPF_REG_1 + j,
+						     m->arg_size[j],
+						     m->arg_flags[j]))
 					return -1;
 			}
 		}
@@ -2555,7 +2564,7 @@ static int invoke_bpf_prog(struct bpf_tramp_jit *tjit,
 	EMIT6_PCREL_RILB_PTR(0xc0050000, REG_14, p->bpf_func);
 	/* stg %r2,retval_off(%r15) */
 	if (save_ret) {
-		if (sign_extend(jit, REG_2, m->ret_size, m->ret_flags))
+		if (sign_zero_extend(jit, REG_2, m->ret_size, m->ret_flags))
 			return -1;
 		EMIT6_DISP_LH(0xe3000000, 0x0024, REG_2, REG_0, REG_15,
 			      tjit->retval_off);
-- 
2.53.0



