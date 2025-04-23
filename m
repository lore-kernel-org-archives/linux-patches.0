Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5AC283C81;
	Wed, 23 Apr 2025 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422209; cv=none; b=Nkqdba3xzOace/HJ0ZfGd/ZuoAJXxJy+rMnI28gjnylxZS73yT2EnrmWuok+hcCagVvrGvAczGtt4s2EG6fNFvPaxwTK9SJAf7tdeLHCvVJtTzgyZp/m+PcR9qslYXDd5aQtVu0itP9csTMs0Rz6URkt5jELJB7PFfz+x4N/8OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422209; c=relaxed/simple;
	bh=lpIRE/HQvgr+yQIrLIuP0iuNVlySFc8lrRDy7HEADYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poagGgT2cOO5QvLA8jVhBT/eivghieTyiA0bmJaQ1NIyCp3AkG/hfsjwJdCCWnVZK3UrmIwbzXCtR6fm4Qk7I5D54emIyQgPeogvMMFPXk2gJ7a2xzf2Cu0CH7O1tVakDiAPsIAMxbb7yGFbba1z5J8jeY4Hs+oO5aBQpDt4Tzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9ueNw53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9ueNw53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEDFC4CEE2;
	Wed, 23 Apr 2025 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422209;
	bh=lpIRE/HQvgr+yQIrLIuP0iuNVlySFc8lrRDy7HEADYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9ueNw53MLgfkTMP59mQ7kjYVCk24zwo5mZs5dQH4md06MF7+XBcAvUc0+LFAmvVj
	 q9YlH2m6qRRfTCJXpTOxaTSgoOMGEWkSvmQk82NI5uzFMZt86w+x5wa8ytbZ6JsxKK
	 nC2SAoM27n1ZHeX8mNd92reKpVothoiESDpb2Obc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	WangYuli <wangyuli@uniontech.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/393] riscv: KGDB: Do not inline arch_kgdb_breakpoint()
Date: Wed, 23 Apr 2025 16:43:13 +0200
Message-ID: <20250423142655.609142775@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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



