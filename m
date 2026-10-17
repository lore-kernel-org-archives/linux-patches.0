Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A363A7F54;
	Sat, 17 Oct 2026 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258659; cv=none; b=h4Vqk+jG1vC8RN7zf3Sj8w31Lbzm+ZkHHRKn6tUm2A2cNkM1LbeXXSyVQH3seZTqzQb/9jEuA84W9Hnnr8FiWn34MjOJSiAXmDnLJgeOb/0gg7XF40cL22l17T5Q6j2tM3APHot2nVjDl0AvskpoHy9j3dVPug56+8P0xbxwlnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258659; c=relaxed/simple;
	bh=kIRz3y4bjd2tcZkm3/Ihlb9L2guIhfMxA0e323zoBXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6XUDv8pVX6bEnXL7rqheaxsFvuzHeJMPYe0hQ+1t6BzGKXtnfuHm3aozVEs9YeiGh5k+spUUjQAu5r9FCIAnm4OzT2ismgkA7PSe64KqX/gHPm4ijLVFmsOKFZd0AqzLQKoGFnQ9fV/BetQRB0Ot0Y60O0pWPWlJSNR3DKfzx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFc44J4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFc44J4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22FA1F000C4;
	Sat, 17 Oct 2026 17:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258658;
	bh=H0IWS4MCLtnRm/xLinLPQfOn6Tt6I1+ujQLDdWznea8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFc44J4CPHqCVhErsQ5EZow64xGTFz3gxUmDJaAo5T5QE6nzdvJ68EqUbMg1IkIIp
	 v8i0eZgH31zSw7Z1hBTrGTOQVe+qcnodN2Nm+TGL1E+sSbyc/HGtH5DKLd5OqN/rT2
	 mKIH5o5lhG0PB/vB09NaYrTtV57ux7YoMLfdhdiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Rothwell <sfr@rothwell.id.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0930/1674] arch: turn off -Werror for architectures with known warnings
Date: Sat, 17 Oct 2026 17:53:22 +0200
Message-ID: <20261017160455.006540294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0f0d2871e78db648a2578abbeb9103f484f9b754 ]

A couple of architectures enable -Werror for their own files regardless of
CONFIG_WERROR but also have known warnings that fail the build with
-Wmissing-prototypes enabled by default:

arch/alpha/lib/memcpy.c:153:8: error: no previous prototype for 'memcpy' [-Werror=missing-prototypes]
arch/alpha/kernel/irq.c:96:1: error: no previous prototype for 'handle_irq' [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:673:17: error: no previous prototype for ‘sys_rt_sigreturn’ [-Werror=missing-prototypes]
arch/mips/kernel/signal.c:636:17: error: no previous prototype for ‘sys_sigreturn’ [-Werror=missing-prototypes]
arch/mips/kernel/syscall.c:51:16: error: no previous prototype for ‘sysm_pipe’ [-Werror=missing-prototypes]
arch/mips/mm/fault.c:323:17: error: no previous prototype for ‘do_page_fault’ [-Werror=missing-prototypes]
arch/sparc/vdso/vma.c:246:12: warning: no previous prototype for ‘init_vdso_image’ [-Wmissing-prototypes]v
arch/sparc/vdso/vdso32/../vclock_gettime.c:343:1: warning: no previous prototype for ‘__vdso_gettimeofday_stick’ [-Wmissing-prototypes]
arch/sparc/vdso/vclock_gettime.c:343:1: warning: no previous prototype for ‘__vdso_gettimeofday_stick’ [-Wmissing-prototypes]
arch/sparc/prom/p1275.c:52:6: warning: no previous prototype for ‘prom_cif_init’ [-Wmissing-prototypes]
arch/sparc/prom/misc_64.c:165:5: warning: no previous prototype for ‘prom_get_mmu_ihandle’ [-Wmissing-prototypes]

This appears to be an artifact from the times when this architecture code
was better maintained that most device drivers and before CONFIG_WERROR
was added.  Now it just gets in the way, so remove all of these.

Powerpc and x86 both still have their own Kconfig options to enable
-Werror for some of their files.  These architectures are better
maintained than most and the options are easy to disable, so leave those
untouched.

Link: https://lkml.kernel.org/r/4be73872-c1f5-4c31-8201-712c19290a22@app.fastmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Stephen Rothwell <sfr@rothwell.id.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: dd5712f3379c ("alpha: fix user-space corruption during memory compaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/lib/Makefile    | 1 -
 arch/alpha/mm/Makefile     | 2 --
 arch/mips/Kbuild           | 6 ------
 arch/sparc/kernel/Makefile | 1 -
 arch/sparc/lib/Makefile    | 1 -
 arch/sparc/mm/Makefile     | 1 -
 arch/sparc/prom/Makefile   | 1 -
 7 files changed, 13 deletions(-)

diff --git a/arch/alpha/lib/Makefile b/arch/alpha/lib/Makefile
index 1cc74f7b50efb..6a779b9018fd1 100644
--- a/arch/alpha/lib/Makefile
+++ b/arch/alpha/lib/Makefile
@@ -4,7 +4,6 @@
 #
 
 asflags-y := $(KBUILD_CFLAGS)
-ccflags-y := -Werror
 
 # Many of these routines have implementations tuned for ev6.
 # Choose them iff we're targeting ev6 specifically.
diff --git a/arch/alpha/mm/Makefile b/arch/alpha/mm/Makefile
index bd770302eb824..101dbd06b4ceb 100644
--- a/arch/alpha/mm/Makefile
+++ b/arch/alpha/mm/Makefile
@@ -3,6 +3,4 @@
 # Makefile for the linux alpha-specific parts of the memory manager.
 #
 
-ccflags-y := -Werror
-
 obj-y	:= init.o fault.o
diff --git a/arch/mips/Kbuild b/arch/mips/Kbuild
index af2967bffb73d..e2d623621a00e 100644
--- a/arch/mips/Kbuild
+++ b/arch/mips/Kbuild
@@ -1,10 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-# Fail on warnings - also for files referenced in subdirs
-# -Werror can be disabled for specific files using:
-# CFLAGS_<file.o> := -Wno-error
-ifeq ($(W),)
-subdir-ccflags-y := -Werror
-endif
 
 # platform specific definitions
 include $(srctree)/arch/mips/Kbuild.platforms
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 0984bb6f0f17b..58ea4ef9b622b 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -5,7 +5,6 @@
 #
 
 asflags-y := -ansi
-ccflags-y := -Werror
 
 # Undefine sparc when processing vmlinux.lds - it is used
 # And teach CPP we are doing $(BITS) builds (for this case)
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 063556fe2cb1d..59669ebddd4e1 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 asflags-y := -ansi -DST_DIV0=0x02
-ccflags-y := -Werror
 
 lib-$(CONFIG_SPARC32) += ashrdi3.o
 lib-$(CONFIG_SPARC32) += memcpy.o memset.o
diff --git a/arch/sparc/mm/Makefile b/arch/sparc/mm/Makefile
index 871354aa3c002..809d993f6d888 100644
--- a/arch/sparc/mm/Makefile
+++ b/arch/sparc/mm/Makefile
@@ -3,7 +3,6 @@
 #
 
 asflags-y := -ansi
-ccflags-y := -Werror
 
 obj-$(CONFIG_SPARC64)   += ultra.o tlb.o tsb.o
 obj-y                   += fault_$(BITS).o
diff --git a/arch/sparc/prom/Makefile b/arch/sparc/prom/Makefile
index 397b79af77f7b..a1adc75d80551 100644
--- a/arch/sparc/prom/Makefile
+++ b/arch/sparc/prom/Makefile
@@ -3,7 +3,6 @@
 # Linux.
 #
 asflags := -ansi
-ccflags := -Werror
 
 lib-y                 := bootstr_$(BITS).o
 lib-y                 += init_$(BITS).o
-- 
2.53.0



