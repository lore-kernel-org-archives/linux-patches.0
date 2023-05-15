Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9213FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510C6C433EF;
	Mon, 15 May 2023 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171959;
	bh=4kk/zNZc2OrVB84yJRNEDoIy3nnVw2F+f3/dgGyEIJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+TMMVMXvMYuv7gvKT498HmrEBYdl2n6mbu/nVcZnFujUPwejftx5Wqoaf16ZiaEc
	 EOlamRje3+r2S3HspCA2AgPDZYB8TqZqYEigTi2ybL0ZYMxCxmXuINyWsNi9hPi5JR
	 rwhvZ4QOa+Om9Z82SvFUdnA5JWcmxPm9FjiTHBh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15 133/134] RISC-V: Fix up a cherry-pick warning in setup_vm_final()
Date: Mon, 15 May 2023 18:30:10 +0200
Message-Id: <20230515161707.610511632@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


This triggers a -Wdeclaration-after-statement as the code has changed a
bit since upstream.  It might be better to hoist the whole block up, but
this is a smaller change so I went with it.

arch/riscv/mm/init.c:755:16: warning: mixing declarations and code is a C99 extension [-Wdeclaration-after-statement]
             unsigned long idx = pgd_index(__fix_to_virt(FIX_FDT));
                           ^
     1 warning generated.

Fixes: bbf94b042155 ("riscv: Move early dtb mapping into the fixmap region")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304300429.SXZOA5up-lkp@intel.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -714,6 +714,7 @@ static void __init setup_vm_final(void)
 {
 	uintptr_t va, map_size;
 	phys_addr_t pa, start, end;
+	unsigned long idx __maybe_unused;
 	u64 i;
 
 	/**
@@ -733,7 +734,7 @@ static void __init setup_vm_final(void)
 	 * directly in swapper_pg_dir in addition to the pgd entry that points
 	 * to fixmap_pte.
 	 */
-	unsigned long idx = pgd_index(__fix_to_virt(FIX_FDT));
+	idx = pgd_index(__fix_to_virt(FIX_FDT));
 
 	set_pgd(&swapper_pg_dir[idx], early_pg_dir[idx]);
 #endif


