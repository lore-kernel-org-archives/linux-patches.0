Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D092248F50;
	Tue, 20 May 2025 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750303; cv=none; b=r/fVR/VxW83iAP3x+WRE7AGoCgRN3A5gboR/5m6zpa3GNFrR86nO/XBvmApJxdB26PQWeHSZYOQDjRmPDG6YXo56PGK1+w7M+X42ijrq2gvtxEAwjYNbmMbCvlx+7lKwGSNu5cZnOViFGTruPJBcHU10Wh7OZpzPH3tVhgHno8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750303; c=relaxed/simple;
	bh=hTGYU0BezZpSEG4Ut0muPhLtue5SD8VdXoGW1LiAe6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiwHhDLDJMDUmvjoY9HID+2mvck3KFHJU25c3A0YoDabtu9msUNFuc5nqlnw/45IC4BVsDf6SvVA25tVfixawfm7Z0yPIkXHw0bFuLXcg1VCafjo3doeNEl+kOuG6UIxQGFUgCa7kuusIZVjPkRzSqezMUuahrN8S0Bc4XBTeMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iV2I5mAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iV2I5mAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90E5C4CEFC;
	Tue, 20 May 2025 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750303;
	bh=hTGYU0BezZpSEG4Ut0muPhLtue5SD8VdXoGW1LiAe6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iV2I5mADR6APeMF1nY8NXx8rZvl05fpfBoTRlSqR1KEeCbcqpsYzqO2A1tx/X4qCG
	 rPtYEWSskmPtpXu/PFrFFZwLCG7BC6xxRG05pZEcaW+0RXNU+cTD8a+OWjmqa0JOp4
	 gKx5ZdDPGYrml4xAFemBM79dRflSrHqq8CGrgF3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 078/143] LoongArch: uprobes: Remove redundant code about resume_era
Date: Tue, 20 May 2025 15:50:33 +0200
Message-ID: <20250520125813.134195852@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


