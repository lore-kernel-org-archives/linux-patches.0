Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0B012D1F1;
	Tue, 30 Apr 2024 11:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475689; cv=none; b=OpBc+VLnJ5rHcxf4EvhgvvKKIuMKc8T0xO3uvTUM+ci+UJ4lbmSDrXyvBiQk1CJUwLt29FbQ3HXpg4b1ZItlopWpJwzEDhJjVjhxkCwhWIj34CZcighzaPaLSjJnfyiOUZ0+IHgC56Y7zjL1BVSYeekE5NLZP51KoDWcoOKMObM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475689; c=relaxed/simple;
	bh=WO1uyREcCV9ds+3P7pVWcznnHwJjePuGlLKlR8QifxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKMmnHC6xRrQ+V2e3so1/OXNPd8DrO2nPwh8Tps3QBKQ+AF5Ij6HuW4JLAsgxX1zgdxJmj521i+WityBz8/JHQPy/84ZZFc49uhY0301czyyh1h1xKjEZmEA+mCB//MNISozHlbZinwmKvYXx8SIkN7YX3JbV4RelWb1Xy6n3OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBrD+2xb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBrD+2xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3596DC2BBFC;
	Tue, 30 Apr 2024 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475688;
	bh=WO1uyREcCV9ds+3P7pVWcznnHwJjePuGlLKlR8QifxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBrD+2xbNDYGmhp189uQ3SlliPP8qKp6CtuJWdwIrLUyigAMshx5sGxdc87VDJ+fk
	 KBbeMBTWnUfP+M9WVKF5qE/CSPJPA/7GrtHw2+iaax35WbhwSnuyVg+MkuD77Io/Um
	 HkLati6lAGTHWNc9+3/1iPyl7DrbQEjOLj4njMYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/186] riscv: Fix loading 64-bit NOMMU kernels past the start of RAM
Date: Tue, 30 Apr 2024 12:40:26 +0200
Message-ID: <20240430103103.082778934@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit aea702dde7e9876fb00571a2602f25130847bf0f ]

commit 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear
mapping") added logic to allow using RAM below the kernel load address.
However, this does not work for NOMMU, where PAGE_OFFSET is fixed to the
kernel load address. Since that range of memory corresponds to PFNs
below ARCH_PFN_OFFSET, mm initialization runs off the beginning of
mem_map and corrupts adjacent kernel memory. Fix this by restoring the
previous behavior for NOMMU kernels.

Fixes: 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear mapping")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20240227003630.3634533-3-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/page.h | 2 +-
 arch/riscv/mm/init.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index 57e887bfa34cb..94b3d6930fc37 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -89,7 +89,7 @@ typedef struct page *pgtable_t;
 #define PTE_FMT "%08lx"
 #endif
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && defined(CONFIG_MMU)
 /*
  * We override this value as its generic definition uses __pa too early in
  * the boot process (before kernel_map.va_pa_offset is set).
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index b50faa232b5e9..ec02ea86aa39f 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -230,7 +230,7 @@ static void __init setup_bootmem(void)
 	 * In 64-bit, any use of __va/__pa before this point is wrong as we
 	 * did not know the start of DRAM before.
 	 */
-	if (IS_ENABLED(CONFIG_64BIT))
+	if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_MMU))
 		kernel_map.va_pa_offset = PAGE_OFFSET - phys_ram_base;
 
 	/*
-- 
2.43.0



