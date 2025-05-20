Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330A71D8E07;
	Tue, 20 May 2025 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749808; cv=none; b=ULvkZmaEGXMuLmVM13zI9muZ9Qac5kfPJfUr646BwRMzWQNjZgfnLm9G3LJdob3/iLpvU1VLARgJ26wcgGCpBPnSPe87phKI/PU2uarytKeayJZwaUlQLi6OEVOHKH3L3IkZJph3/KBvZ1OER6z2Z/Drh58w2FdTnVx7MJhS++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749808; c=relaxed/simple;
	bh=W81/0/9W1q5vm6073iwDaj9kMlzfwTTT3c6fU9O1E4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3D/Ydwoyc3kOjOZjJeah6saa5XnpKM0lvhXBlAaLVulLxJyV4olt+/Rme35tQpwgBEx/zN6VCnzO/AsKNGJuUL+9SJF27ppgafcnWb2VGcLzjonQbzN6PNmgQYQslRpu1K18mMeeBj0NKyVnv2ll0hSZFQe84h0YKYSNtApLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gl5HsXHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gl5HsXHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95137C4CEEA;
	Tue, 20 May 2025 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749808;
	bh=W81/0/9W1q5vm6073iwDaj9kMlzfwTTT3c6fU9O1E4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gl5HsXHFX+HFc5P6UFObcjq0jkBwxBeDgQgig5foRvCPf7jIwP1znqjLCDDV/rAvM
	 7WwBIWmzRFB9s5WkUus4WKc7kIuhOpbzEaVpzrn8e7HpC+9JBSRwVPnuVh6regwtd1
	 wF8i+/QhyFbuSJRiCFTCpNDUGaAVG60gpUdMHFcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 067/117] LoongArch: uprobes: Remove redundant code about resume_era
Date: Tue, 20 May 2025 15:50:32 +0200
Message-ID: <20250520125806.652028981@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 #define UPROBE_XOLBP_INSN	larch_insn_gen_break(BRK_UPROBE_XOLBP)
 
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


