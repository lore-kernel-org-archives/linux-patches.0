Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D6C3A544C;
	Sat, 12 Sep 2026 08:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201399; cv=none; b=BWTzkx0YPDffSib9j0HxjJee7Osy+T9WRla8TQM5IVleJbJVW1UaYp1Fk+Iwh1m5zsFikr9KpQ6pm9qgkXAi5HP0IPLdYko5VWSqWHcw4J0jDjl6wpAsd3tMJ4xwtg4OUIVbk7gJg0ojKoQbF9iGk2vEfSXjtGzbL02sWWzFiik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201399; c=relaxed/simple;
	bh=igS2imwpUhnq2XxXbLRoas24wJ6qbLIkkQIFCjawfV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOVNcvG8/fwyjCMgeUHJ8itcf9f+dgxZmUBLZY/ph+RmlN+1aj/mA3UN9CaTmr+tUgqRSUi0rbSZr7lulBiiH7kDuY8kT1Uu3GYcUTULsFj05doaBO8yLhbDna+AkykYOLqT8VE8voBv+yO7r5fhFWylX1cmg0VNL2swWhM3xnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHl5DHwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHl5DHwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13E61F000FF;
	Sat, 12 Sep 2026 08:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201397;
	bh=0Tqnjn+aOiSpJ8soM0Q6wGjAKazlA6rlLFIYZW9uaIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHl5DHwRuSkCHb9iayP9iq8MM8TlRQ0Wmf8v9u7Wa50+ykSIyJe4Z/62mm0ePQYSg
	 tvPiSO58FDdzIQXhCZYSuXEUiMwIOMs06wAE+lQEYBev8k/FCrwZjMIES1RBneGxvP
	 Womvs6L2tGC54MTE+V2wm/6jbZt1EqzfJzeKLHjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0987/1815] powerpc64/bpf: Fix build break in bpf_jit_emit_func_call_rel()
Date: Sat, 12 Sep 2026 08:45:37 +0200
Message-ID: <20260912065712.165605053@linuxfoundation.org>
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

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit e8ee988c0087248324dbd3da486d22045e4a4079 ]

With CONFIG_PPC_KERNEL_PCREL enabled, build breaks with below error:

  CC      mm/dmapool.o
  CC      fs/readdir.o
arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_emit_func_call_rel':
arch/powerpc/net/bpf_jit_comp64.c:475:13: error: unused variable 'ret' [-Werror=unused-variable]
  475 |         int ret;
      |             ^~~

Commit b55b6b9ad76c ("powerpc64/bpf: Add powerpc64 JIT support for timed may_goto")
introduced "ret" at function scope, but it is only used within its
respective conditional blocks. Same holds true for reladdr. Move both
variable declarations to the scopes where they are actually used:
"reladdr" to the CONFIG_PPC_KERNEL_PCREL block and "ret" to the non-PCREL
else block.

Fixes: b55b6b9ad76c ("powerpc64/bpf: Add powerpc64 JIT support for timed may_goto")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/e8e582fb425db165a72f00e3337cdf4c6ae383ad.1785387718.git.skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index dab106cae22b5..fc9db691e8203 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -471,8 +471,6 @@ static int bpf_jit_emit_func_call(u32 *image, struct codegen_context *ctx, u64 f
 int bpf_jit_emit_func_call_rel(u32 *image, u32 *fimage, struct codegen_context *ctx, u64 func)
 {
 	unsigned long func_addr = func ? ppc_function_entry((void *)func) : 0;
-	long __maybe_unused reladdr;
-	int ret;
 
 	/* bpf to bpf call, func is not known in the initial pass. Emit 5 nops as a placeholder */
 	if (!func) {
@@ -487,6 +485,8 @@ int bpf_jit_emit_func_call_rel(u32 *image, u32 *fimage, struct codegen_context *
 	}
 
 #ifdef CONFIG_PPC_KERNEL_PCREL
+	long reladdr;
+
 	reladdr = func_addr - local_paca->kernelbase;
 
 	/*
@@ -525,7 +525,7 @@ int bpf_jit_emit_func_call_rel(u32 *image, u32 *fimage, struct codegen_context *
 	EMIT(PPC_RAW_BCTRL());
 #else
 	if (core_kernel_text(func_addr)) {
-		ret = bpf_jit_emit_func_call(image, ctx, func_addr, _R12);
+		int ret = bpf_jit_emit_func_call(image, ctx, func_addr, _R12);
 		if (ret)
 			return ret;
 	} else {
-- 
2.53.0



