Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EB221D5BE;
	Tue, 20 May 2025 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750645; cv=none; b=P87NWRVLqywBi9YPDmdDUlMABT9V9+4ahfVuDsbezUA+3c6rulj/p96+S/xBgpKLgYVZBHMYVT7K+RBSziYPtf1YWkfW/KviardV6cU4UvIvba9WXAKplNl3mAPapD8c000RVFRfidwe4OAWTNaWGAwoNQOGJBfK2cqoc4n/oMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750645; c=relaxed/simple;
	bh=/+KwpTaFKcfNuNOYkUUDyw/aee0cmVaaG1McJ7Aa4YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClcyrESggAMNubtWq8QmcjlVt+/0Na+leyyhdktbg7M6e2nih2a+DTh2ePVsa0KrRB8/ilv2ohsrXCB7T6kiWfrkXBZMtNOpNLtZOkdVWyse28QdagUqn7jTh3r66fcPeWaH2Qt7IbIiILYUFqJqQW5Y229ygGdzhJX+fjWPYFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G24lAxtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G24lAxtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB70C4CEE9;
	Tue, 20 May 2025 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750645;
	bh=/+KwpTaFKcfNuNOYkUUDyw/aee0cmVaaG1McJ7Aa4YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G24lAxtV5sMLGg+kmB2tei3wIRgNr91FI9SvJnC+DTJwHHs81OZMGvXzIdWBuB27q
	 ho4MSYtgSAx9G+UR0x++5zn8Kej4QAc0r6ytCTyFjJW36q0PIbvNjlyoG8vSKSmuXh
	 ea3yVBTR8YnWmN8pcQO5KWv/g3kkTPj9I8an2Ry0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 074/145] LoongArch: uprobes: Remove redundant code about resume_era
Date: Tue, 20 May 2025 15:50:44 +0200
Message-ID: <20250520125813.483781795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 12614f794274f63fbdfe76771b2b332077d63848 upstream.

arch_uprobe_skip_sstep() returns true if instruction was emulated, that
is to say, there is no need to single step for the emulated instructions.
regs->csr_era will point to the destination address directly after the
exception, so the resume_era related code is redundant, just remove them.

Cc: stable@vger.kernel.org
Fixes: 19bc6cb64092 ("LoongArch: Add uprobes support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/uprobes.h |    1 -
 arch/loongarch/kernel/uprobes.c      |    7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/arch/loongarch/include/asm/uprobes.h
+++ b/arch/loongarch/include/asm/uprobes.h
@@ -15,7 +15,6 @@ typedef u32 uprobe_opcode_t;
 #define UPROBE_XOLBP_INSN	__emit_break(BRK_UPROBE_XOLBP)
 
 struct arch_uprobe {
-	unsigned long	resume_era;
 	u32	insn[2];
 	u32	ixol[2];
 	bool	simulate;
--- a/arch/loongarch/kernel/uprobes.c
+++ b/arch/loongarch/kernel/uprobes.c
@@ -52,11 +52,7 @@ int arch_uprobe_post_xol(struct arch_upr
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
-
-	if (auprobe->simulate)
-		instruction_pointer_set(regs, auprobe->resume_era);
-	else
-		instruction_pointer_set(regs, utask->vaddr + LOONGARCH_INSN_SIZE);
+	instruction_pointer_set(regs, utask->vaddr + LOONGARCH_INSN_SIZE);
 
 	return 0;
 }
@@ -86,7 +82,6 @@ bool arch_uprobe_skip_sstep(struct arch_
 
 	insn.word = auprobe->insn[0];
 	arch_simulate_insn(insn, regs);
-	auprobe->resume_era = regs->csr_era;
 
 	return true;
 }


