Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A0F2584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83790C433EF;
	Thu, 23 Feb 2023 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157903;
	bh=/iEHLs0KpQuGAnTWn65nnYL9Uq7x7kyb4KgUxDjd1CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sA4M8OsZAu+j0nlRG0Vgf8V75H/E96qX3TY8c+mcpPn3w6G2V0w9lZXJaapfHRXV
	 90UUeMDO8LA2wm2eZ5FOb7cSOAsmqGAnLJeYmN7+FC0Tl6ByBedk+xbWx5aDaZMKJA
	 Nws2rxFPPhMk1ChfuMZcavDX9FnbU6FAsiwtvr5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/36] powerpc/vmlinux.lds: Add an explicit symbol for the SRWX boundary
Date: Thu, 23 Feb 2023 14:06:54 +0100
Message-Id: <20230223130429.924214142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit b150a4d12b919baf956b807aa305cf78df03d0fe ]

Currently __init_begin is used as the boundary for strict RWX between
executable/read-only text and data, and non-executable (after boot) code
and data.

But that's a little subtle, so add an explicit symbol to document that
the SRWX boundary lies there, and add a comment making it clear that
__init_begin must also begin there.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220916131422.318752-2-mpe@ellerman.id.au
Stable-dep-of: 111bcb373853 ("powerpc/64s/radix: Fix RWX mapping with relocated kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/sections.h      | 1 +
 arch/powerpc/kernel/vmlinux.lds.S        | 9 +++++++--
 arch/powerpc/mm/book3s32/mmu.c           | 2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c | 4 ++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
index 79cb7a25a5fb6..e92d39c0cd1d9 100644
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -9,6 +9,7 @@
 #include <asm-generic/sections.h>
 
 extern char __head_end[];
+extern char __srwx_boundary[];
 
 #ifdef __powerpc64__
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index bcbe41c6998ca..a664d0c4344a9 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -208,11 +208,16 @@ SECTIONS
 	}
 #endif
 
+	/*
+	 * Various code relies on __init_begin being at the strict RWX boundary.
+	 */
+	. = ALIGN(STRICT_ALIGN_SIZE);
+	__srwx_boundary = .;
+	__init_begin = .;
+
 /*
  * Init sections discarded at runtime
  */
-	. = ALIGN(STRICT_ALIGN_SIZE);
-	__init_begin = .;
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
 		INIT_TEXT
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index bfca0afe91126..692c336e4f55b 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -159,7 +159,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 {
 	unsigned long done;
-	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
+	unsigned long border = (unsigned long)__srwx_boundary - PAGE_OFFSET;
 	unsigned long size;
 
 	size = roundup_pow_of_two((unsigned long)_einittext - PAGE_OFFSET);
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index a339cb5de5dd1..52e27fd995da7 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -260,8 +260,8 @@ print_mapping(unsigned long start, unsigned long end, unsigned long size, bool e
 static unsigned long next_boundary(unsigned long addr, unsigned long end)
 {
 #ifdef CONFIG_STRICT_KERNEL_RWX
-	if (addr < __pa_symbol(__init_begin))
-		return __pa_symbol(__init_begin);
+	if (addr < __pa_symbol(__srwx_boundary))
+		return __pa_symbol(__srwx_boundary);
 #endif
 	return end;
 }
-- 
2.39.0



