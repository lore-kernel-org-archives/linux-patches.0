Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063443;
	b=kITYmlSMK8ageKCyV69btHs+9zpUNIx18OTcxUquLMdAoZ9rMgI7jOSHbWhEV3Y4TN7D
	 kzJpSNJvh/SvmfClZPk7/yGcfCDJK3EoEmCXXgd7/y8Dh9BHCwngaikmQKdslQck3G0Y+
	 DBV4CBNzrDmqOO82jSpBiZng1n03sSxGT/ppKdqfHsmWg3bLM6S+oErbZ3r7LSoebGeFA
	 TvMl1vbzzYLE7PcIcDr+lVFnjQmdbIAxmmb8kR40oXl4sRK08lD2QCljP1ekqWjZHl5Rb
	 UfXHkNuKtUVsuug240I5yReB608gvtVuD/Fc1hJS3AVzBiA28102KzIza4D2jGWDonQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hASc/Cybq/UUSktcvk3gwrEE5yWkw3H3cu5c/DVAb+M=;
	b=EHJIXgS/kqlxidmu6iGhsG1RRA+GYPmDni7UxnT2XsMWZVYCjTZj/6KDABVmGmYror97
	 ZAK7DnxeIUxtR9GYTC6VCwxCjwOKT+Ql8/x4/ApBZgMf2oK5viH/1lLyO0Vm9lpdN0lpD
	 H6AFCMz933La3qZ62vCuhnW9s4uN6y6j6LB8FMpQek+nFbd/7rO6PHy7w+NtkRl26rRyV
	 MY1Y2AFiuErd7fQ2Tsa9I1LdUvD2fnP3bEvo1W1+YknOy/ncncEM66qf245S8bZvMU1nP
	 Ekbg6jjtv3UFOIvJvinCXka4z69ddWxpOpOIXLAtKu6JTjC0rJg9Vik0kXkKz4EnlIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iilUQVUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E90606A337;
	Sat,  7 Nov 2026 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iilUQVUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754821F008A5;
	Sat,  7 Nov 2026 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063442;
	bh=hASc/Cybq/UUSktcvk3gwrEE5yWkw3H3cu5c/DVAb+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iilUQVUZ4j+b/H45I2RTOCfOCwGnv/p0rv0ZjFlh8i/VOTI1xiAM7TJD26/E20lEZ
	 7BotzMExxTI9N+z+o3UISQeO6cdtb5dQ1p4w1C778zHfS7Inrxo7Ves8cWbjouUZa+
	 6BmT4pb4+wdG04+0V/f2NE+U7B6E3sEK6sZJr1/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/869] ARM: 9491/1: alignment: restore uaccess state on emulation fault
Date: Sat,  7 Nov 2026 08:53:59 -0500
Message-ID: <20261107134912.216599210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 80dafbcb705cead6d25cb821cf29c47da8860c8c ]

The alignment handlers enable access to user memory while emulating
unaligned instructions. If a checked access faults, its exception table
fixup jumps to the handler's fault label and bypasses uaccess_restore().
This leaves DOMAIN_USER as DOMAIN_CLIENT with SW domain PAN, or leaves
TTBR0 page table walks enabled with TTBR0 PAN, while the fault is handled.

An ARM926 QEMU test using LDMIA across an unmapped page boundary reports
DOMAIN_USER=1 at TYPE_FAULT before this change and DOMAIN_USER=0 after it.
SW domain PAN is the default on ARMv5, ARMv6, and non-LPAE ARMv7 builds.

Keep the saved uaccess state at function scope and track whether it was
saved. Restore it at the fault label only when needed. Paths that did not
enable user access continue to skip the restore.

Assisted-by: Codex:gpt-5.6-sol

Fixes: 274e91b81ed2 ("ARM: alignment: fix alignment handling for uaccess changes")
Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/alignment.c | 51 ++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 812380f30ae36..2b470a419dda3 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -341,6 +341,8 @@ static int
 do_alignment_ldrhstrh(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd = RD_BITS(instr);
+	unsigned int ua_flags;
+	bool ua_saved = false;
 
 	ai_half += 1;
 
@@ -364,10 +366,11 @@ do_alignment_ldrhstrh(unsigned long addr, u32 instr, struct pt_regs *regs)
  user:
 	if (LDST_L_BIT(instr)) {
 		unsigned long val;
-		unsigned int __ua_flags = uaccess_save_and_enable();
 
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		get16t_unaligned_check(val, addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 
 		/* signed half-word? */
 		if (instr & 0x40)
@@ -375,14 +378,17 @@ do_alignment_ldrhstrh(unsigned long addr, u32 instr, struct pt_regs *regs)
 
 		regs->uregs[rd] = val;
 	} else {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		put16t_unaligned_check(regs->uregs[rd], addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	}
 
 	return TYPE_LDST;
 
  fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	return TYPE_FAULT;
 }
 
@@ -391,6 +397,8 @@ do_alignment_ldrdstrd(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd = RD_BITS(instr);
 	unsigned int rd2;
+	unsigned int ua_flags;
+	bool ua_saved = false;
 	int load;
 
 	if ((instr & 0xfe000000) == 0xe8000000) {
@@ -425,26 +433,30 @@ do_alignment_ldrdstrd(unsigned long addr, u32 instr, struct pt_regs *regs)
  user:
 	if (load) {
 		unsigned long val, val2;
-		unsigned int __ua_flags = uaccess_save_and_enable();
 
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		get32t_unaligned_check(val, addr);
 		get32t_unaligned_check(val2, addr + 4);
 
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 
 		regs->uregs[rd] = val;
 		regs->uregs[rd2] = val2;
 	} else {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		put32t_unaligned_check(regs->uregs[rd], addr);
 		put32t_unaligned_check(regs->uregs[rd2], addr + 4);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	}
 
 	return TYPE_LDST;
  bad:
 	return TYPE_ERROR;
  fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	return TYPE_FAULT;
 }
 
@@ -452,6 +464,8 @@ static int
 do_alignment_ldrstr(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd = RD_BITS(instr);
+	unsigned int ua_flags;
+	bool ua_saved = false;
 
 	ai_word += 1;
 
@@ -469,18 +483,22 @@ do_alignment_ldrstr(unsigned long addr, u32 instr, struct pt_regs *regs)
  trans:
 	if (LDST_L_BIT(instr)) {
 		unsigned int val;
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		get32t_unaligned_check(val, addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 		regs->uregs[rd] = val;
 	} else {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		put32t_unaligned_check(regs->uregs[rd], addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	}
 	return TYPE_LDST;
 
  fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	return TYPE_FAULT;
 }
 
@@ -502,6 +520,8 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd, rn, correction, nr_regs, regbits;
 	unsigned long eaddr, newaddr;
+	unsigned int ua_flags;
+	bool ua_saved = false;
 
 	if (LDM_S_BIT(instr))
 		goto bad;
@@ -547,7 +567,8 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 #endif
 
 	if (user_mode(regs)) {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		for (regbits = REGMASK_BITS(instr), rd = 0; regbits;
 		     regbits >>= 1, rd += 1)
 			if (regbits & 1) {
@@ -559,7 +580,7 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 					put32t_unaligned_check(regs->uregs[rd], eaddr);
 				eaddr += 4;
 			}
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	} else {
 		for (regbits = REGMASK_BITS(instr), rd = 0; regbits;
 		     regbits >>= 1, rd += 1)
@@ -581,6 +602,8 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 	return TYPE_DONE;
 
 fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	regs->ARM_pc -= correction;
 	return TYPE_FAULT;
 
-- 
2.53.0



