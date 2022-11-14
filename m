Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93674C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2412BC433D6;
	Mon, 14 Nov 2022 12:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430190;
	bh=GNKrkb4rQzz5upXOm1VtJPsbBg0GYnqj8k2DxFpUYVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5dEmcFMD9AUedsh2HFNZk6dCvqrKT7O6i38l0oZt6+77Lg4Yy6dO2iKu6LOHHSTX
	 lmARsXA+cHR7VjCzz/L/zLAi/pul0x655IxEvkDc98mX+GTj5pSK5OtJhX544JCNeI
	 9PGISHvPAuvG6iFXrAZwDo7+bxkhbRKyyXfxBf30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atish.patra@wdc.com>,
	Greentime Hu <greentime.hu@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/95] riscv: Separate memory init from paging init
Date: Mon, 14 Nov 2022 13:45:47 +0100
Message-Id: <20221114124444.729669783@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit cbd34f4bb37d62d8a027f54205bff07e73340da4 ]

Currently, we perform some memory init functions in paging init. But,
that will be an issue for NUMA support where DT needs to be flattened
before numa initialization and memblock_present can only be called
after numa initialization.

Move memory initialization related functions to a separate function.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 50e63dd8ed92 ("riscv: fix reserved memory setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 1 +
 arch/riscv/kernel/setup.c        | 1 +
 arch/riscv/mm/init.c             | 6 +++++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 73e8b5e5bb65..b16304fdf448 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -470,6 +470,7 @@ extern void *dtb_early_va;
 extern uintptr_t dtb_early_pa;
 void setup_bootmem(void);
 void paging_init(void);
+void misc_mem_init(void);
 
 #define FIRST_USER_ADDRESS  0
 
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index cc85858f7fe8..57e1ab036edf 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -96,6 +96,7 @@ void __init setup_arch(char **cmdline_p)
 	else
 		pr_err("No DTB found in kernel mappings\n");
 #endif
+	misc_mem_init();
 
 #ifdef CONFIG_SWIOTLB
 	swiotlb_init(1);
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 56314e82f051..b6ab6a18dc1a 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -669,8 +669,12 @@ static void __init resource_init(void)
 void __init paging_init(void)
 {
 	setup_vm_final();
-	sparse_init();
 	setup_zero_page();
+}
+
+void __init misc_mem_init(void)
+{
+	sparse_init();
 	zone_sizes_init();
 	resource_init();
 }
-- 
2.35.1



