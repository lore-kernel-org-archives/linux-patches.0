Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8A5BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95484C433EF;
	Tue,  7 Mar 2023 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209667;
	bh=X2nMGih5WkK6wKg3VvnJU4I4t0Soc0rVQmG4ecRSmUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oc7pck1u/pzDeLu5rFBWVdJLzdBYk7c9GRIsST5SnS1kbwG1Ddu3NwvA2Rya1RoDc
	 WFv+OqPgi0PBn29kw1Qzsivk9jz0OxJpAEKedQ/6vKWT7ZO7zc6CuKUpuaZPVpERJz
	 vF2CsVkLuaXptt+tdbUm4u3PH4IHgQADvYGsodxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0261/1001] s390/boot: cleanup decompressor header files
Date: Tue,  7 Mar 2023 17:50:33 +0100
Message-Id: <20230307170033.062836456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 9c3205b2b062420c26b33924b910880889acf832 ]

Move declarations to appropriate header files. Instead of cryptic
casting directly assign struct vmlinux_info type to _vmlinux_info
linker script variable - wich it actually is.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 22476f47b6b7 ("s390/boot: fix mem_detect extended area allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/boot.h         | 24 ++++++++++++++++++++++--
 arch/s390/boot/decompressor.c |  1 +
 arch/s390/boot/decompressor.h | 26 --------------------------
 3 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/arch/s390/boot/boot.h b/arch/s390/boot/boot.h
index 70418389414d3..f6e82cf7851e2 100644
--- a/arch/s390/boot/boot.h
+++ b/arch/s390/boot/boot.h
@@ -8,10 +8,26 @@
 
 #ifndef __ASSEMBLY__
 
+struct vmlinux_info {
+	unsigned long default_lma;
+	void (*entry)(void);
+	unsigned long image_size;	/* does not include .bss */
+	unsigned long bss_size;		/* uncompressed image .bss size */
+	unsigned long bootdata_off;
+	unsigned long bootdata_size;
+	unsigned long bootdata_preserved_off;
+	unsigned long bootdata_preserved_size;
+	unsigned long dynsym_start;
+	unsigned long rela_dyn_start;
+	unsigned long rela_dyn_end;
+	unsigned long amode31_size;
+};
+
 void startup_kernel(void);
 unsigned long detect_memory(void);
 bool is_ipl_block_dump(void);
 void store_ipl_parmblock(void);
+unsigned long read_ipl_report(unsigned long safe_offset);
 void setup_boot_command_line(void);
 void parse_boot_command_line(void);
 void verify_facilities(void);
@@ -20,6 +36,7 @@ void sclp_early_setup_buffer(void);
 void print_pgm_check_info(void);
 unsigned long get_random_base(unsigned long safe_addr);
 void __printf(1, 2) decompressor_printk(const char *fmt, ...);
+void error(char *m);
 
 /* Symbols defined by linker scripts */
 extern const char kernel_version[];
@@ -31,8 +48,11 @@ extern char __boot_data_start[], __boot_data_end[];
 extern char __boot_data_preserved_start[], __boot_data_preserved_end[];
 extern char _decompressor_syms_start[], _decompressor_syms_end[];
 extern char _stack_start[], _stack_end[];
-
-unsigned long read_ipl_report(unsigned long safe_offset);
+extern char _end[];
+extern unsigned char _compressed_start[];
+extern unsigned char _compressed_end[];
+extern struct vmlinux_info _vmlinux_info;
+#define vmlinux _vmlinux_info
 
 #endif /* __ASSEMBLY__ */
 #endif /* BOOT_BOOT_H */
diff --git a/arch/s390/boot/decompressor.c b/arch/s390/boot/decompressor.c
index b519a1f045d8f..d762733a07530 100644
--- a/arch/s390/boot/decompressor.c
+++ b/arch/s390/boot/decompressor.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <asm/page.h>
 #include "decompressor.h"
+#include "boot.h"
 
 /*
  * gzip declarations
diff --git a/arch/s390/boot/decompressor.h b/arch/s390/boot/decompressor.h
index f75cc31a77dd9..92b81d2ea35d6 100644
--- a/arch/s390/boot/decompressor.h
+++ b/arch/s390/boot/decompressor.h
@@ -2,37 +2,11 @@
 #ifndef BOOT_COMPRESSED_DECOMPRESSOR_H
 #define BOOT_COMPRESSED_DECOMPRESSOR_H
 
-#include <linux/stddef.h>
-
 #ifdef CONFIG_KERNEL_UNCOMPRESSED
 static inline void *decompress_kernel(void) { return NULL; }
 #else
 void *decompress_kernel(void);
 #endif
 unsigned long mem_safe_offset(void);
-void error(char *m);
-
-struct vmlinux_info {
-	unsigned long default_lma;
-	void (*entry)(void);
-	unsigned long image_size;	/* does not include .bss */
-	unsigned long bss_size;		/* uncompressed image .bss size */
-	unsigned long bootdata_off;
-	unsigned long bootdata_size;
-	unsigned long bootdata_preserved_off;
-	unsigned long bootdata_preserved_size;
-	unsigned long dynsym_start;
-	unsigned long rela_dyn_start;
-	unsigned long rela_dyn_end;
-	unsigned long amode31_size;
-};
-
-/* Symbols defined by linker scripts */
-extern char _end[];
-extern unsigned char _compressed_start[];
-extern unsigned char _compressed_end[];
-extern char _vmlinux_info[];
-
-#define vmlinux (*(struct vmlinux_info *)_vmlinux_info)
 
 #endif /* BOOT_COMPRESSED_DECOMPRESSOR_H */
-- 
2.39.2



