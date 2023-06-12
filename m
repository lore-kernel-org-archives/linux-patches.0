Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0182411CAD
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBC9C433D2;
	Mon, 12 Jun 2023 10:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567148;
	bh=mKEP1o6hoyQ7jtE6ZIM7YmZi0AbJPhv9YlwFtFzjkxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTmZmYjy8OLff/gRCoXv1G1wftAq12wpo0btnBiHjvAUgxFO2dbHluCc92tDxK79w
	 bn+VBDw2pkZOUt5DSEw9Sh7ZgGErJj38kFWFsalGcyIaTqKTpHHPwCxO9xBOjzys7B
	 P4vAJ6BzRwpHB9N0BUFSP32mS1eH/w6mx9iXsN0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsieh-Tseng Shen <woodrow.shen@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 141/160] riscv: mm: Ensure prot of VM_WRITE and VM_EXEC must be readable
Date: Mon, 12 Jun 2023 12:27:53 +0200
Message-ID: <20230612101721.523370385@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hsieh-Tseng Shen <woodrow.shen@sifive.com>

[ Upstream commit 6569fc12e442ea973d96db39e542aa19a7bc3a79 ]

Commit 8aeb7b17f04e ("RISC-V: Make mmap() with PROT_WRITE imply PROT_READ")
allows riscv to use mmap with PROT_WRITE only, and meanwhile mmap with w+x
is also permitted. However, when userspace tries to access this page with
PROT_WRITE|PROT_EXEC, which causes infinite loop at load page fault as
well as it triggers soft lockup. According to riscv privileged spec,
"Writable pages must also be marked readable". The fix to drop the
`PAGE_COPY_READ_EXEC` and then `PAGE_COPY_EXEC` would be just used instead.
This aligns the other arches (i.e arm64) for protection_map.

Fixes: 8aeb7b17f04e ("RISC-V: Make mmap() with PROT_WRITE imply PROT_READ")
Signed-off-by: Hsieh-Tseng Shen <woodrow.shen@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230425102828.1616812-1-woodrow.shen@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 3 +--
 arch/riscv/mm/init.c             | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index f641837ccf31d..05eda3281ba90 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -165,8 +165,7 @@ extern struct pt_alloc_ops pt_ops __initdata;
 					 _PAGE_EXEC | _PAGE_WRITE)
 
 #define PAGE_COPY		PAGE_READ
-#define PAGE_COPY_EXEC		PAGE_EXEC
-#define PAGE_COPY_READ_EXEC	PAGE_READ_EXEC
+#define PAGE_COPY_EXEC		PAGE_READ_EXEC
 #define PAGE_SHARED		PAGE_WRITE
 #define PAGE_SHARED_EXEC	PAGE_WRITE_EXEC
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index dc1793bf01796..309d685d70267 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -286,7 +286,7 @@ static const pgprot_t protection_map[16] = {
 	[VM_EXEC]					= PAGE_EXEC,
 	[VM_EXEC | VM_READ]				= PAGE_READ_EXEC,
 	[VM_EXEC | VM_WRITE]				= PAGE_COPY_EXEC,
-	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_READ_EXEC,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_EXEC,
 	[VM_SHARED]					= PAGE_NONE,
 	[VM_SHARED | VM_READ]				= PAGE_READ,
 	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
-- 
2.39.2



