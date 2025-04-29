Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196511FE468;
	Tue, 29 Apr 2025 17:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947716; cv=none; b=eYsd2tiB1buLKjdbIfACCuG+Qy8z/HnYXrT0nbABr5blo96r2e2dvpknVlqhCgGlwpaSzLZK2ImKNeaLLTUPmQ37N2sBPo3fxu6O4JRn2sDBn0srtOXuxETwpK+VByJEfF/uv+QohZ7z6UqdKaHvq6XW5tVNurYgd80M0GM+GHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947716; c=relaxed/simple;
	bh=LgX7wj89MXUGrknwgQY5Yp3wvqwTwGMxnnPTlyM2MIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z22zmF8mT4oFdwPNKyz0E1N+Ozi/jtsosYRYASTUkrD2c6jHrkNDDR5clUa4M67TrPeP5b9rEjx9ChbHrKDlw4nDpiA1q9pyIFq8dj0IypCvpP98XWiMpdlffoygSdLCGc3DZ/NhoXqbfyPy/sQotOO+juFoJ4vDfPDYWYF3PvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNGk+2+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNGk+2+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29E9C4CEE9;
	Tue, 29 Apr 2025 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947716;
	bh=LgX7wj89MXUGrknwgQY5Yp3wvqwTwGMxnnPTlyM2MIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNGk+2+xiLzsGC5Fuha15DGLSQT16oG72QCK2G79DCOj71SJrNaHexyGVlK3Kqhyz
	 TVtKZO8AEShXZ2gh+W0AY8qSEoW+JH6Hfg8fDf3p8uaTWn7zqrdGWZW2qjz6hxYIQl
	 1Nwe0TGkToBMZVDh5L4/L+q/KOXUbWjId7veL5fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/280] riscv: Replace function-like macro by static inline function
Date: Tue, 29 Apr 2025 18:40:25 +0200
Message-ID: <20250429161118.549291635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 121f34341d396b666d8a90b24768b40e08ca0d61 ]

The flush_icache_range() function is implemented as a "function-like
macro with unused parameters", which can result in "unused variables"
warnings.

Replace the macro with a static inline function, as advised by
Documentation/process/coding-style.rst.

Fixes: 08f051eda33b ("RISC-V: Flush I$ when making a dirty page executable")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20250419111402.1660267-1-bjorn@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/cacheflush.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index 8de73f91bfa37..b59ffeb668d6a 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -34,11 +34,6 @@ static inline void flush_dcache_page(struct page *page)
 	flush_dcache_folio(page_folio(page));
 }
 
-/*
- * RISC-V doesn't have an instruction to flush parts of the instruction cache,
- * so instead we just flush the whole thing.
- */
-#define flush_icache_range(start, end) flush_icache_all()
 #define flush_icache_user_page(vma, pg, addr, len)	\
 do {							\
 	if (vma->vm_flags & VM_EXEC)			\
@@ -78,6 +73,16 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
 
 #endif /* CONFIG_SMP */
 
+/*
+ * RISC-V doesn't have an instruction to flush parts of the instruction cache,
+ * so instead we just flush the whole thing.
+ */
+#define flush_icache_range flush_icache_range
+static inline void flush_icache_range(unsigned long start, unsigned long end)
+{
+	flush_icache_all();
+}
+
 extern unsigned int riscv_cbom_block_size;
 extern unsigned int riscv_cboz_block_size;
 void riscv_init_cbo_blocksizes(void);
-- 
2.39.5



