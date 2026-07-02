Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92333F5BE;
	Thu,  2 Jul 2026 16:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011156; cv=none; b=hQgrudMXwRe9YTFgQf2+l+Z1lQtFjJ1iCbfkYjx/Qy2fMIswc24IKX3b3vdAEonGfBeLgiCQ0/k0O8ac1Ul13XWBWg0j0PRfq+NB96hFY0dmRqHEfYPHOt7ZIavaZmX9MP8prmpCF0g6qDmGCrBDD2k7jCj5bqUR1cqxMENudRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011156; c=relaxed/simple;
	bh=F588xhKrTouEC5H1ZGz5IbS3Dre1cdoGzKac/InHX5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp2NIqxQn/RvsFNMkHFz38vyIcPJMaRBBUiar2roKpACjZKJspicyxFmPtvx2aVx8nhXYJaFADieGoOClywYN5gYZa9RsKzz9E1ab31RX71ibTOCjhwBTgXhhtRtkQKCBumQRLkSjyIubPqlq9iNogJlT7k4o1+TK8QqOwzb/UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrAoUCbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrAoUCbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718461F000E9;
	Thu,  2 Jul 2026 16:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011154;
	bh=hj0I7vbi/cdjVAgiyjAJn5EQobM/OHUfLn+llHSY1jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrAoUCbNMEXvK+tNMZzU0C+BYuPp+GfRfvGBsLKOENFHEl3UcRgBnP9s7M3Au2wSE
	 CS3UZf7kTbEvMO5Ugc4i8DTTaIS7Deb5h8yJkNow1PmJjc9BFb7yEPh4wHJz59imKj
	 Bsg3bZtxGPmSo0qsbYP+0r/zkYY3CU9gCuX/d/SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 143/175] MIPS: DEC: Prevent initial console buffer from landing in XKPHYS
Date: Thu,  2 Jul 2026 18:20:44 +0200
Message-ID: <20260702155118.819633251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 7fb13fd35110ebe95eb053faf79d018f51144d85 upstream.

In 64-bit configurations calling the initial console output handler from
a kernel thread other than the initial one will result in a situation
where the stack has been placed in the XKPHYS 64-bit memory segment and
consequently so has been the buffer allocated there that is used as the
argument corresponding to the `%s' output conversion specifier for the
firmware's printf() entry point.

This 64-bit address will then be truncated by 32-bit firmware, resulting
in an attempt to access the wrong memory location, which in turn will
cause all kinds of unpredictable behaviour, such as a kernel crash:

  Console: colour dummy device 160x64
  Calibrating delay loop... 49.36 BogoMIPS (lpj=192512)
  pid_max: default: 32768 minimum: 301
  CPU 0 Unable to handle kernel paging request at virtual address 000000000203bd00, epc == ffffffffbfc08364, ra == ffffffffbfc08800
  Oops[#1]:
  CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0-rc2-00254-gfb649bda6f56-dirty #121
  $ 0   : 0000000000000000 0000000000000001 0000000000000023 ffffffff80684ba0
  $ 4   : 000000000203bd00 ffffffffbfc0f3b4 ffffffffffffffff 0000000000000073
  $ 8   : 0a303d7469000000 0000000000000000 0000000000000073 ffffffffbfc0f473
  $12   : 0000000000000002 0000000000000000 ffffffff80684c1c 0000000000000000
  $16   : 0000000000000000 ffffffff80596dc9 0000000000000000 ffffffffbfc09240
  $20   : ffffffff80684c40 ffffffffbfc0f400 000000000000002d 000000000000002b
  $24   : ffffffffffffffbf 000000000203bd00
  $28   : ffffffff805f0000 ffffffff80684b58 0000000000000030 ffffffffbfc08800
  Hi    : 0000000000000000
  Lo    : 0000000000000aa8
  epc   : ffffffffbfc08364 0xffffffffbfc08364
  ra    : ffffffffbfc08800 0xffffffffbfc08800
  Status: 140120e2        KX SX UX KERNEL EXL
  Cause : 00000008 (ExcCode 02)
  BadVA : 000000000203bd00
  PrId  : 00000430 (R4000SC)
  Modules linked in:
  Process swapper (pid: 0, threadinfo=(____ptrval____), task=(____ptrval____), tls=0000000000000000)
  Stack : 0000000000000000 0000000000000000 0000000000000000 0000004d0000004d
          80684cc0806a2a40 80596dc80000004d 8061000000000000 bfc0850c80684c38
          0000000000000000 000000000203bd00 0000000000000000 0000000000000000
          0000000000000000 00000000bfc0f3b4 0000000000000000 0000000000000000
          0000000000000000 0000000000000000 0000000000000000 0000000000000000
          0000000000000000 0000000000000000 0000000000000000 0000000000000000
          0000002500000000 0000000000000000 0000000000000000 802c1a7400000000
          0203bd0080596dc8 0203bd4d69000000 6c61632000000018 5f746567646e6172
          6c616320625f6d6f 5f736e5f6d6f7266 206361323778302b 303d74696e726320
          806a0a38806b0000 806a0a38806b0000 00000000806b0000 80683c58806b0000
          ...
  Call Trace:

  Code: a082ffff  03e00008  00601021 <80820000> 00001821  10400005  24840001  80820000  24630001

  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Fatal exception in interrupt

  KN04 V2.1k    (PC: 0xa0026768, SP: 0x806848e8)
  >>

In this case the pointer in $4 was truncated from 0x980000000203bd00 to
0x000000000203bd00.

This may happen when no final console driver has been enabled in the
configuration and consequently the initial console continues being used
late into bootstrap or with an upcoming change that will switch the zs
driver to use a platform device, which in turn will make the console
handover happen only after other kernel threads have already been
started.

Fix the issue by making the buffer static and initdata, and therefore
placed in the CKSEG0 32-bit compatibility segment, observing that the
console output handler is called with the console lock held, implying
no need for this code to be reentrant.  Add an assertion to verify the
buffer actually has been placed in a compatibility segment.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.12+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/dec/prom/console.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/mips/dec/prom/console.c
+++ b/arch/mips/dec/prom/console.c
@@ -2,8 +2,9 @@
 /*
  *	DECstation PROM-based early console support.
  *
- *	Copyright (C) 2004, 2007  Maciej W. Rozycki
+ *	Copyright (C) 2004, 2007, 2026  Maciej W. Rozycki
  */
+#include <linux/bug.h>
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -14,9 +15,11 @@
 static void __init prom_console_write(struct console *con, const char *s,
 				      unsigned int c)
 {
-	char buf[81];
+	static char buf[81] __initdata = { 0 };
 	unsigned int chunk = sizeof(buf) - 1;
 
+	BUG_ON((long)buf != (int)(long)buf);
+
 	while (c > 0) {
 		if (chunk > c)
 			chunk = c;


