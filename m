Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450E43E07B;
	Tue, 21 Jul 2026 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674274; cv=none; b=mBFb2ST3vih5OGAgdsCsTe31IrUv/+z+cY94SkJV1CASE3FJK4vX6ctoTdhv987jg1v0lXSL0PdaXmpkrIZTOEmGG/9P91hn7EJVBdX0piVBl2ccRD7F88XnOlZBxuBGP75hMLOCc0zz27dDBFsQif9U1j+aL+yMS1Hv6cd/fVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674274; c=relaxed/simple;
	bh=lGacNeN8nwkrQ0crwcohoDihanKr/HCEOpRpZyILb6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwylWbbf1Ag3bxqtnGoCfPowzVAYdU259pwWetfdn5R0Ioc2gnv0/EtBuUccxVxs7NJFv4+BfM7M93QELXj/AUxD5H1z9EY0Ft6vV1Jf72Ti0aRAvWpyxr9mUJCOz7kP4LiDTR4Rt2vvXbS3+86yhVCoM+Zs/U6OepvC9qc0yA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTynTBMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTynTBMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52571F00A3A;
	Tue, 21 Jul 2026 22:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674271;
	bh=4PVPOPIppHsJFdGNlBShsVr9IszD5VFD6zpEgLiocjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTynTBMKH7f7eUTB2Dg9RchrGE94qLzxK9/P24gjnZZ0cvkVjR71VnWA8SkW/TDss
	 4L+LAaqdI7Gx5zy4VcAWtoTJ5WqlXTDhblD1mbWoGjUC13npJ0V7Txxilb0s12M1Nv
	 Sy6OPCwZnmmhr9H4hNTBCcdmDiKZkvgtNaWh2Rqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 478/699] MIPS: DEC: Ensure 32-bit stack location for o32 prom_printf()
Date: Tue, 21 Jul 2026 17:23:57 +0200
Message-ID: <20260721152406.481941888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 5ff79e8bdc75db51e30298a75939e2308e7658e0 upstream.

In 64-bit configurations calling any firmware entry points from a kernel
thread other than the initial one will result in a situation where the
stack has been placed in the XKPHYS 64-bit memory segment.

Consequently the stack pointer is no longer a 32-bit value and when the
32-bit firmware code called uses 32-bit ALU operations to manipulate the
stack pointer, the calculated result is incorrect (in fact in the 64-bit
MIPS ISA almost all 32-bit ALU operations will produce an unpredictable
result when executed on 64-bit data) and control goes astray.

This may happen when no final console driver has been enabled in the
configuration and consequently the initial console continues being used
late into bootstrap, or with an upcoming change that will switch the zs
driver to use a platform device, which in turn will make the console
handover happen only after other kernel threads have already been
started, and the kernel will hang at:

  pid_max: default: 32768 minimum: 301

or somewhat later, but always before:

  cblist_init_generic: Setting adjustable number of callback queues.

has been printed.

It seems that only the prom_printf() entry point is affected.  Of all
the other entry points wired only rex_slot_address() and rex_gettcinfo()
are called from a kernel thread other than the initial one, specifically
kernel_init(), and they are leaf functions that do no business with the
stack, having worked with no issue ever since 64-bit support was added
for the platform back in 2002.

To address this issue then, arrange for the stack to be switched in the
o32 wrapper as required for prom_printf() only, by supplying call_o32()
with a pointer to a chunk of initdata space, which is placed in the
CKSEG0 32-bit compatibility segment, observing that prom_printf() is
only called from console output handler and therefore with the console
lock held, implying no need for this code to be reentrant.

Other firmware entry points may be called with interrupts enabled and no
lock held, and may therefore require that call_o32() be reentrant.  They
trigger no issue at this point and "if it ain't broke, don't fix it," so
just leave them alone.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.12+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/dec/prom/init.c        |    6 +++++-
 arch/mips/include/asm/dec/prom.h |   15 +++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/arch/mips/dec/prom/init.c
+++ b/arch/mips/dec/prom/init.c
@@ -3,7 +3,7 @@
  * init.c: PROM library initialisation code.
  *
  * Copyright (C) 1998 Harald Koerfgen
- * Copyright (C) 2002, 2004  Maciej W. Rozycki
+ * Copyright (C) 2002, 2004, 2026  Maciej W. Rozycki
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -20,6 +20,10 @@
 #include <asm/dec/prom.h>
 
 
+#ifdef CONFIG_64BIT
+unsigned long o32_stk[O32_STK_SIZE] __initdata = { 0 };
+#endif
+
 int (*__rex_bootinit)(void);
 int (*__rex_bootread)(void);
 int (*__rex_getbitmap)(memmap *);
--- a/arch/mips/include/asm/dec/prom.h
+++ b/arch/mips/include/asm/dec/prom.h
@@ -4,7 +4,7 @@
  *
  *	DECstation PROM interface.
  *
- *	Copyright (C) 2002  Maciej W. Rozycki
+ *	Copyright (C) 2002, 2026  Maciej W. Rozycki
  *
  *	Based on arch/mips/dec/prom/prom.h by the Anonymous.
  */
@@ -97,6 +97,17 @@ extern int (*__pmax_close)(int);
 
 #ifdef CONFIG_64BIT
 
+#define O32_STK_SIZE 512
+extern unsigned long o32_stk[];
+
+/* Switch the stack if outside the 32-bit address space.  */
+static inline unsigned long *o32_get_stk(void)
+{
+	long fp = (long)__builtin_frame_address(0);
+
+	return fp != (int)fp ? o32_stk + O32_STK_SIZE : NULL;
+}
+
 /*
  * On MIPS64 we have to call PROM functions via a helper
  * dispatcher to accommodate ABI incompatibilities.
@@ -128,7 +139,7 @@ int __DEC_PROM_O32(_prom_printf, (int (*
 
 #define prom_getchar()		_prom_getchar(__prom_getchar, NULL)
 #define prom_getenv(x)		_prom_getenv(__prom_getenv, NULL, x)
-#define prom_printf(x...)	_prom_printf(__prom_printf, NULL, x)
+#define prom_printf(x...)	_prom_printf(__prom_printf, o32_get_stk(), x)
 
 #else /* !CONFIG_64BIT */
 


