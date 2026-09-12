Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0155E386C21;
	Sat, 12 Sep 2026 11:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212725; cv=none; b=qPOzqN7u8Eg/WJYx3ecrQkwzXVfYwk9FFDY0qLFMK7YtLlJPEqgvryiDp4MklGB83xaFvZqaP1LT0UuIofcQGe95xKe50u7a+2VsksHrU17OPj8p4e4WdenhxFdLg5U8Ue4PnCUQR//0UTW2cocEEdwEl0D3y5B80JnLxSmGhV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212725; c=relaxed/simple;
	bh=x9jpKuh0amU8J3GuhREBas8v8b8nErWIEnbuTO618y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiMM372XMm5UHWwQfBegwxAmb6G/UdNhl1R1BZttMtczFg6i3cAUVaeWOpNNrOPiCinpxNgf/iBCZwo1CL2cHKlNzsuNcCnBmFf52OyecpLwoTt63NYZB6slvPdBQuJdPwq7J3Y5l/FVHbblham49v6XOaioTa2O9pt1yeUmDgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7PCQAO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7PCQAO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433351F000FF;
	Sat, 12 Sep 2026 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212716;
	bh=epiZ++welKB2P0R0ktwELjSMX+UTTd6mjVw9iRWqwDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7PCQAO6KAzQXmHR/f+emhUuX7iIE+EY03hHRpZnpWWY2Kb9Oj1c2MuowGFVRiK4E
	 tG/krtTsALZZy6livipuiFZVhieZPUnqDgPEVLFu8bC9Qssk1AYAiot4hp2HFDD8me
	 z/yc0AYhRP5Pni2pg2B9sAIveAsUIp5/NtlUv7Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1493/1518] integrity: Eliminate weak definition of arch_get_secureboot()
Date: Sat, 12 Sep 2026 09:01:02 +0200
Message-ID: <20260912065657.335707115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 7caedbb5ade345df0eec0bf01035c780919a9f56 ]

security/integrity/secure_boot.c contains a single __weak function,
which breaks recordmcount when building with clang:

  $ make -skj"$(nproc)" ARCH=powerpc LLVM=1 ppc64_defconfig security/integrity/secure_boot.o
  Cannot find symbol for section 2: .text.
  security/integrity/secure_boot.o: failed

Introduce a Kconfig symbol, CONFIG_HAVE_ARCH_GET_SECUREBOOT, to indicate
that an architecture provides a definition of arch_get_secureboot().
Provide a static inline stub when this symbol is not defined to achieve
the same effect as the __weak function, allowing secure_boot.c to be
removed altogether. Move the s390 definition of arch_get_secureboot()
out of the CONFIG_KEXEC_FILE block to ensure it is always available, as
it does not actually depend on KEXEC_FILE.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 31a6a07eefeb ("integrity: Make arch_ima_get_secureboot integrity-wide")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig                     |  3 +++
 arch/powerpc/Kconfig             |  1 +
 arch/s390/Kconfig                |  1 +
 arch/s390/kernel/ipl.c           | 10 +++++-----
 include/linux/secure_boot.h      |  4 ++++
 security/integrity/Makefile      |  2 +-
 security/integrity/secure_boot.c | 16 ----------------
 7 files changed, 15 insertions(+), 22 deletions(-)
 delete mode 100644 security/integrity/secure_boot.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 61130b88964b9..ee9fd0150f487 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1841,4 +1841,7 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
 config ARCH_HAS_CPU_ATTACK_VECTORS
 	bool
 
+config HAVE_ARCH_GET_SECUREBOOT
+	def_bool EFI
+
 endmenu
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9537a61ebae02..7b02fe19d26a9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1059,6 +1059,7 @@ config PPC_SECURE_BOOT
 	depends on IMA_ARCH_POLICY
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	select PSERIES_PLPKS if PPC_PSERIES
+	select HAVE_ARCH_GET_SECUREBOOT
 	help
 	  Systems with firmware secure boot enabled need to define security
 	  policies to extend secure boot to the OS. This config allows a user
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 719086bbfa477..7acd2618691fd 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -177,6 +177,7 @@ config S390
 	select GENERIC_IOREMAP if PCI
 	select HAVE_ALIGNED_STRUCT_PAGE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_GET_SECUREBOOT
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 2d01a17139387..3c346b02ceb95 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -2388,6 +2388,11 @@ void __no_stack_protector s390_reset_system(void)
 	diag_amode31_ops.diag308_reset();
 }
 
+bool arch_get_secureboot(void)
+{
+	return ipl_secure_flag;
+}
+
 #ifdef CONFIG_KEXEC_FILE
 
 int ipl_report_add_component(struct ipl_report *report, struct kexec_buf *kbuf,
@@ -2505,11 +2510,6 @@ void *ipl_report_finish(struct ipl_report *report)
 	return buf;
 }
 
-bool arch_get_secureboot(void)
-{
-	return ipl_secure_flag;
-}
-
 int ipl_report_free(struct ipl_report *report)
 {
 	struct ipl_report_component *comp, *ncomp;
diff --git a/include/linux/secure_boot.h b/include/linux/secure_boot.h
index 3ded3f03655c3..d17e923515672 100644
--- a/include/linux/secure_boot.h
+++ b/include/linux/secure_boot.h
@@ -10,10 +10,14 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_HAVE_ARCH_GET_SECUREBOOT
 /*
  * Returns true if the platform secure boot is enabled.
  * Returns false if disabled or not supported.
  */
 bool arch_get_secureboot(void);
+#else
+static inline bool arch_get_secureboot(void) { return false; }
+#endif
 
 #endif /* _LINUX_SECURE_BOOT_H */
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index 548665e2b702e..45dfdedbdad48 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
 
-integrity-y := iint.o secure_boot.o
+integrity-y := iint.o
 integrity-$(CONFIG_INTEGRITY_AUDIT) += integrity_audit.o
 integrity-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
 integrity-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
diff --git a/security/integrity/secure_boot.c b/security/integrity/secure_boot.c
deleted file mode 100644
index fc2693c286f8b..0000000000000
--- a/security/integrity/secure_boot.c
+++ /dev/null
@@ -1,16 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2026 Red Hat, Inc. All Rights Reserved.
- *
- * Author: Coiby Xu <coxu@redhat.com>
- */
-#include <linux/secure_boot.h>
-
-/*
- * Default weak implementation.
- * Architectures that support secure boot must override this.
- */
-__weak bool arch_get_secureboot(void)
-{
-	return false;
-}
-- 
2.53.0



