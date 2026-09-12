Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532232D23A6;
	Sat, 12 Sep 2026 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219564; cv=none; b=U0hOBK6UiTNHd1GN7gRC574gyr4/rj3s5EKxR65FoEG0MCk1Brg1mKAtp1jwLmH8rvIwuURewCNhufQF17ST2P/ZlawfRH8oskiWXKBO3WmbDUR1La8Gl1qZ1/ptAzqLJOUCEMuY/oO22wHn+MfaUzmfYzDTh0UlYHO7YxLO/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219564; c=relaxed/simple;
	bh=CY/DsgZXDIIfottKyQphLB+NoGRdtrcBjC3nGAcs/tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgUkYDwQrSXoJcenaQgfM0SABvER+FPQ7E63eQIYFBfqt/dVKzXj1SwI8BPMJkKI/iVx1FfA5sG/VKUrMvRkVn1nMCAbhb36D0fhb5QiK83faY4d0Fo4mJ0ZbJ+p/4JUi4H1dw5SRaSRApG1z2Tk3WCSZ8efrTCby+1XY2K/r+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGit0uOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGit0uOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54E61F000FF;
	Sat, 12 Sep 2026 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219562;
	bh=4uaFWbFbc87cGCwLrNal4krPjBxN67aBaK3zBJrfWio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGit0uOmWi8veMMNNVV0OuWWb1LlTVywCZsF57qzKOQI4qCWa1QI7X5BAnWf7LbEe
	 zR+Fe83WMhpqmDL9SQx/ruJtLpRvijmTbI13sMobmZbFivkwNf42fGUrIIMM0PL3t8
	 ajvtZpK6R++c9KWU5+2H+6hvUlbZJm+z+pAo/fMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.12 1375/1376] integrity: Eliminate weak definition of arch_get_secureboot()
Date: Sat, 12 Sep 2026 09:03:21 +0200
Message-ID: <20260912065638.179219974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 7caedbb5ade345df0eec0bf01035c780919a9f56 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/Kconfig                     |    3 +++
 arch/powerpc/Kconfig             |    1 +
 arch/s390/Kconfig                |    1 +
 arch/s390/kernel/ipl.c           |   10 +++++-----
 include/linux/secure_boot.h      |    4 ++++
 security/integrity/Makefile      |    2 +-
 security/integrity/secure_boot.c |   16 ----------------
 7 files changed, 15 insertions(+), 22 deletions(-)
 delete mode 100644 security/integrity/secure_boot.c

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1684,4 +1684,7 @@ config CC_HAS_SANE_FUNCTION_ALIGNMENT
 config ARCH_NEED_CMPXCHG_1_EMU
 	bool
 
+config HAVE_ARCH_GET_SECUREBOOT
+	def_bool EFI
+
 endmenu
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1044,6 +1044,7 @@ config PPC_SECURE_BOOT
 	depends on IMA_ARCH_POLICY
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	select PSERIES_PLPKS if PPC_PSERIES
+	select HAVE_ARCH_GET_SECUREBOOT
 	help
 	  Systems with firmware secure boot enabled need to define security
 	  policies to extend secure boot to the OS. This config allows a user
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -153,6 +153,7 @@ config S390
 	select GENERIC_IOREMAP if PCI
 	select HAVE_ALIGNED_STRUCT_PAGE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_GET_SECUREBOOT
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -2370,6 +2370,11 @@ void s390_reset_system(void)
 	diag_amode31_ops.diag308_reset();
 }
 
+bool arch_get_secureboot(void)
+{
+	return ipl_secure_flag;
+}
+
 #ifdef CONFIG_KEXEC_FILE
 
 int ipl_report_add_component(struct ipl_report *report, struct kexec_buf *kbuf,
@@ -2487,11 +2492,6 @@ out:
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
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
 
-integrity-y := iint.o secure_boot.o
+integrity-y := iint.o
 integrity-$(CONFIG_INTEGRITY_AUDIT) += integrity_audit.o
 integrity-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
 integrity-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
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


