Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A2B15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963EBC433C8;
	Wed,  9 Aug 2023 10:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578111;
	bh=HrlcznPUuesblsN4lOcCOJN0KJIc0hSH0DpbLASXFak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iUswpED5Yg03OjQt8i3ukuQMmTK9FAzuS1Epz/1bQTEKynfa/CpSR0vqRY3HVBUI
	 40ZOdmjxu76VaUCxSeKRo3H34+r0Oj8JaukLLVJv59hC/xtQeKOOV7D4WKq0VcYRLC
	 0Dk3fCI4ZHG1kYqK13niJGJkyRQAmYDvJT6GW+24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <suagrfillet@gmail.com>,
	=?UTF-8?q?Xianting=20Tian=C2=A0?= <xianting.tian@linux.alibaba.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.4 110/165] riscv: Export va_kernel_pa_offset in vmcoreinfo
Date: Wed,  9 Aug 2023 12:40:41 +0200
Message-ID: <20230809103646.387491921@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Shuai <suagrfillet@gmail.com>

commit fbe7d19d2b7fcbd38905ba9f691be8f245c6faa6 upstream.

Since RISC-V Linux v6.4, the commit 3335068f8721 ("riscv: Use
PUD/P4D/PGD pages for the linear mapping") changes phys_ram_base
from the physical start of the kernel to the actual start of the DRAM.

The Crash-utility's VTOP() still uses phys_ram_base and kernel_map.virt_addr
to translate kernel virtual address, that failed the Crash with Linux v6.4 [1].

Export kernel_map.va_kernel_pa_offset in vmcoreinfo to help Crash translate
the kernel virtual address correctly.

Fixes: 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear mapping")
Link: https://lore.kernel.org/linux-riscv/20230724040649.220279-1-suagrfillet@gmail.com/ [1]
Signed-off-by: Song Shuai <suagrfillet@gmail.com>
Reviewed-by: Xianting Tian  <xianting.tian@linux.alibaba.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230724100917.309061-1-suagrfillet@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/crash_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/crash_core.c b/arch/riscv/kernel/crash_core.c
index b351a3c01355..55f1d7856b54 100644
--- a/arch/riscv/kernel/crash_core.c
+++ b/arch/riscv/kernel/crash_core.c
@@ -18,4 +18,6 @@ void arch_crash_save_vmcoreinfo(void)
 	vmcoreinfo_append_str("NUMBER(MODULES_END)=0x%lx\n", MODULES_END);
 #endif
 	vmcoreinfo_append_str("NUMBER(KERNEL_LINK_ADDR)=0x%lx\n", KERNEL_LINK_ADDR);
+	vmcoreinfo_append_str("NUMBER(va_kernel_pa_offset)=0x%lx\n",
+						kernel_map.va_kernel_pa_offset);
 }
-- 
2.41.0



