Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D644427F4CA;
	Wed, 23 Apr 2025 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419926; cv=none; b=HbnFirFnynFahA2/JXRG+WwnuER8WO6jWJ33iv37w1oSa2YDKjkitalK739569Y5MMpQp0IJkTGTvZbZf4kd6EbSY1UMJo285AmY5Ce+VTefFNDQZAihqUaGP9eunV7+h59cHHUS+GFcfAf1FvPh31GBbL3vdWQkSM4GXS/2njw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419926; c=relaxed/simple;
	bh=arHg+RNvgwdynUqfpv6dWMEB+pR/6rgy6MZKDZDBsC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ny6QnnBVolhNWDrky+w7nJgA0gSGQTgumRK4P2Pb6HFbkoieY0dS0I2asB3zaexVhjXGyd8mXW8H6wQc037U0yQqVDwZNxdZWY30wa9daBTF+Tam3fZmPBa62qKI+1sKea5xeMF0PTLZP1gikOlQ40D84rnw4NnLRBfdUKtC7yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwNTgAmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwNTgAmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C58C4CEE2;
	Wed, 23 Apr 2025 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419926;
	bh=arHg+RNvgwdynUqfpv6dWMEB+pR/6rgy6MZKDZDBsC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwNTgAmV6s5nnq1nASzQILt6LHR2vqzMBfudVy6WunsB9u/qbJY1xVTew7OPeYp+G
	 ejs9IDsk2fw3Ja51cOh5ZNEZkd2cx2HBTIAMKyhlbgDXKJUupMJropA+k1BQitSLcR
	 9OpdufnqHaaXMpPKfACX946iWbso8VrjW3SDIePU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	WangYuli <wangyuli@uniontech.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/223] riscv: KGDB: Do not inline arch_kgdb_breakpoint()
Date: Wed, 23 Apr 2025 16:42:32 +0200
Message-ID: <20250423142620.383817838@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 3af4bec9c1db3f003be4d5ae09b6a737e4be1612 ]

The arch_kgdb_breakpoint() function defines the kgdb_compiled_break
symbol using inline assembly.

There's a potential issue where the compiler might inline
arch_kgdb_breakpoint(), which would then define the kgdb_compiled_break
symbol multiple times, leading to fail to link vmlinux.o.

This isn't merely a potential compilation problem. The intent here
is to determine the global symbol address of kgdb_compiled_break,
and if this function is inlined multiple times, it would logically
be a grave error.

Link: https://lore.kernel.org/all/4b4187c1-77e5-44b7-885f-d6826723dd9a@sifive.com/
Link: https://lore.kernel.org/all/5b0adf9b-2b22-43fe-ab74-68df94115b9a@ghiti.fr/
Link: https://lore.kernel.org/all/23693e7f-4fff-40f3-a437-e06d827278a5@ghiti.fr/
Fixes: fe89bd2be866 ("riscv: Add KGDB support")
Co-developed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/F22359AFB6FF9FD8+20250411073222.56820-1-wangyuli@uniontech.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kgdb.h | 9 +--------
 arch/riscv/kernel/kgdb.c      | 8 ++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/kgdb.h b/arch/riscv/include/asm/kgdb.h
index 46677daf708bd..cc11c4544cffd 100644
--- a/arch/riscv/include/asm/kgdb.h
+++ b/arch/riscv/include/asm/kgdb.h
@@ -19,16 +19,9 @@
 
 #ifndef	__ASSEMBLY__
 
+void arch_kgdb_breakpoint(void);
 extern unsigned long kgdb_compiled_break;
 
-static inline void arch_kgdb_breakpoint(void)
-{
-	asm(".global kgdb_compiled_break\n"
-	    ".option norvc\n"
-	    "kgdb_compiled_break: ebreak\n"
-	    ".option rvc\n");
-}
-
 #endif /* !__ASSEMBLY__ */
 
 #define DBG_REG_ZERO "zero"
diff --git a/arch/riscv/kernel/kgdb.c b/arch/riscv/kernel/kgdb.c
index 2e0266ae6bd72..5d1ce8dacaf58 100644
--- a/arch/riscv/kernel/kgdb.c
+++ b/arch/riscv/kernel/kgdb.c
@@ -254,6 +254,14 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
 	regs->epc = pc;
 }
 
+noinline void arch_kgdb_breakpoint(void)
+{
+	asm(".global kgdb_compiled_break\n"
+	    ".option norvc\n"
+	    "kgdb_compiled_break: ebreak\n"
+	    ".option rvc\n");
+}
+
 void kgdb_arch_handle_qxfer_pkt(char *remcom_in_buffer,
 				char *remcom_out_buffer)
 {
-- 
2.39.5



