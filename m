Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD2268C79;
	Tue,  8 Apr 2025 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110377; cv=none; b=jYORnNwn3OwCuitejQDIw6/5g7YVD54XPU/O2JhkpKWgs4LEudw/BDCtBMUu06pvXV7F4VFByDJ4IB52l05dNmCItBjAjQ3OYjjxYs54ar6BuwNUVIuH1mIV7oYwj4D9KE9lixVzKIEao6QXCIRcNT5RI/yEs/kTzJxmOyRpZBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110377; c=relaxed/simple;
	bh=FctcGfYDh0uP4IT7WNNSNGv4KhR1/ZQZoJkaWy/8a8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DnrJfFI3UFt2u55HdgO0fTRdE9uMKRa75fQ8CIQCxewhWmMejRUQwDCmCxBR5CGiqWmyVduYEAitSh/7a1xMY6g6Jn90exqVAkH5Y5fsR4kMOe+mxpKULP688LIsy0wHJVi+0VCEQpmcbCzvCCkCz4wOouXhJqy7Fp5M5E736mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVkbReA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVkbReA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F28C4CEE5;
	Tue,  8 Apr 2025 11:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110377;
	bh=FctcGfYDh0uP4IT7WNNSNGv4KhR1/ZQZoJkaWy/8a8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVkbReA7+XZ07g1YrPs+wniFkmGWPrUy+bN1KoOLdOvrkagrPJJcbqnmv3kxyJ+e2
	 JwidmAkp+I4d44NycY19WA1I8O0yOry0ILsuRt6GEPrkmUA8/Kyhb3Oj+GJ8vtzXkv
	 FZM7XEOYDyNBzcJ5PaakZnT7t7o6JSJGyiFH8qQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 005/731] m68k: sun3: Fix DEBUG_MMU_EMU build
Date: Tue,  8 Apr 2025 12:38:22 +0200
Message-ID: <20250408104914.383514768@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 723be3c6ab31b320afe0075e2eb9b8dd41f3b6d1 ]

With DEBUG_MMU_EMU enabled:

    arch/m68k/sun3/mmu_emu.c: In function ‘mmu_emu_handle_fault’:
    arch/m68k/sun3/mmu_emu.c:420:38: error: implicit declaration of function ‘get_fs’; did you mean ‘sget_fc’? [-Werror=implicit-function-declaration]
      420 |         pr_info("seg:%ld crp:%p ->", get_fs().seg, crp);
	  |                                      ^~~~~~

    [...]

    arch/m68k/sun3/mmu_emu.c:420:46: error: request for member ‘seg’ in something not a structure or union
      420 |         pr_info("seg:%ld crp:%p ->", get_fs().seg, crp);
	  |                                              ^

Fix this by reintroducing and using a helper to retrieve the current
value of the DFC register.

While at it, replace "%p" by "%px", as there is no point in printing
obfuscated pointers during debugging.

Fixes: 9fde0348640252c7 ("m68k: Remove set_fs()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/b1d12a1d24b4aea9f98d905383ba932b2dc382e6.1737387419.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/processor.h | 14 ++++++++++++++
 arch/m68k/sun3/mmu_emu.c          |  4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
index 8f2676c3a9882..3c43c09d44894 100644
--- a/arch/m68k/include/asm/processor.h
+++ b/arch/m68k/include/asm/processor.h
@@ -95,10 +95,24 @@ static inline void set_fc(unsigned long val)
 			      "movec %0,%/dfc\n\t"
 			      : /* no outputs */ : "r" (val) : "memory");
 }
+
+static inline unsigned long get_fc(void)
+{
+	unsigned long val;
+
+	__asm__ ("movec %/dfc,%0" : "=r" (val) : );
+
+	return val;
+}
 #else
 static inline void set_fc(unsigned long val)
 {
 }
+
+static inline unsigned long get_fc(void)
+{
+	return USER_DATA;
+}
 #endif /* CONFIG_CPU_HAS_ADDRESS_SPACES */
 
 struct thread_struct {
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 7b15cc12637bf..b39fc3717d8ea 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -371,7 +371,7 @@ int mmu_emu_handle_fault (unsigned long vaddr, int read_flag, int kernel_fault)
 	}
 
 #ifdef DEBUG_MMU_EMU
-	pr_info("%s: vaddr=%lx type=%s crp=%p\n", __func__, vaddr,
+	pr_info("%s: vaddr=%lx type=%s crp=%px\n", __func__, vaddr,
 		str_read_write(read_flag), crp);
 #endif
 
@@ -418,7 +418,7 @@ int mmu_emu_handle_fault (unsigned long vaddr, int read_flag, int kernel_fault)
 		pte_val (*pte) |= SUN3_PAGE_ACCESSED;
 
 #ifdef DEBUG_MMU_EMU
-	pr_info("seg:%ld crp:%p ->", get_fs().seg, crp);
+	pr_info("seg:%ld crp:%px ->", get_fc(), crp);
 	print_pte_vaddr (vaddr);
 	pr_cont("\n");
 #endif
-- 
2.39.5



