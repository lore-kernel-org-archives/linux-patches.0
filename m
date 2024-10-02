Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EA61D04A9;
	Wed,  2 Oct 2024 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876004; cv=none; b=mwZPM61+7xjsy3jaMZNs02nozjcbV+AOJ++LkovFqsnAsIkm7HQCuFQ1/1Rn7gcw/6gHGW8STB0kzHXm6U6So/oZiJWOTY8UIuk5z6TzlJ7s2VovANc/T96kpIxG0KV9Pjot2rguWKhmKEsqTsr562KLhG7SIRVeJOVT8cwEwXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876004; c=relaxed/simple;
	bh=xtb1fncPVD31x0hhJYBlQl8iprtewKcJkLxlIr2wz18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1CwU3oBIXoiRjwRncnYJcOQUs6Rl6Z46VNWm/zNkaNHUQ1MQ1Y/Bd/Fxk7v4SfXDHyMgssNPNfYqt8dAqzeMhJ+sK1TbtTAqUrRE+FiyuDd5gsxu9BwZpdODjugCb+rPMiEo17S5+ERQxMKAtRDfM3gNAL4S44szzOWgtznNuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhazE0wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhazE0wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16D3C4CECE;
	Wed,  2 Oct 2024 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876004;
	bh=xtb1fncPVD31x0hhJYBlQl8iprtewKcJkLxlIr2wz18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhazE0wjWWZhbZXJV4LWuOx0FCZWUQPc/PQ4cVzYTfDy/8KDE8KhOmNmqzaKfvnXz
	 i3rj2Yf3bkLQ9zPk9w/K5CtI+4ozszUczLKPYlC7+wiy4uzaBJt/vDDzHUKV9O22JT
	 tt4S7m8hrSrqvpvOCcF16xdJvnAPwe059wcyhCqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 288/695] s390/entry: Move early program check handler to entry.S
Date: Wed,  2 Oct 2024 14:54:46 +0200
Message-ID: <20241002125833.938441639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f2bb5b97b51ce5425e8f59f899643ce4eadba667 ]

Have all program check handlers in one file to make future changes easy.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: f101b305a7b9 ("s390/entry: Make early program check handler relocated lowcore aware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/Makefile   |  2 +-
 arch/s390/kernel/earlypgm.S | 23 -----------------------
 arch/s390/kernel/entry.S    | 15 +++++++++++++++
 3 files changed, 16 insertions(+), 24 deletions(-)
 delete mode 100644 arch/s390/kernel/earlypgm.S

diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index e47a4be54ff8e..a70f25e9c17da 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -36,7 +36,7 @@ CFLAGS_stacktrace.o	+= -fno-optimize-sibling-calls
 CFLAGS_dumpstack.o	+= -fno-optimize-sibling-calls
 CFLAGS_unwind_bc.o	+= -fno-optimize-sibling-calls
 
-obj-y	:= head64.o traps.o time.o process.o earlypgm.o early.o setup.o idle.o vtime.o
+obj-y	:= head64.o traps.o time.o process.o early.o setup.o idle.o vtime.o
 obj-y	+= processor.o syscall.o ptrace.o signal.o cpcmd.o ebcdic.o nmi.o
 obj-y	+= debug.o irq.o ipl.o dis.o diag.o vdso.o cpufeature.o
 obj-y	+= sysinfo.o lgr.o os_info.o ctlreg.o
diff --git a/arch/s390/kernel/earlypgm.S b/arch/s390/kernel/earlypgm.S
deleted file mode 100644
index c634871f0d905..0000000000000
--- a/arch/s390/kernel/earlypgm.S
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- *    Copyright IBM Corp. 2006, 2007
- *    Author(s): Michael Holzheu <holzheu@de.ibm.com>
- */
-
-#include <linux/linkage.h>
-#include <asm/asm-offsets.h>
-
-SYM_CODE_START(early_pgm_check_handler)
-	stmg	%r8,%r15,__LC_SAVE_AREA_SYNC
-	aghi	%r15,-(STACK_FRAME_OVERHEAD+__PT_SIZE)
-	la	%r11,STACK_FRAME_OVERHEAD(%r15)
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
-	stmg	%r0,%r7,__PT_R0(%r11)
-	mvc	__PT_PSW(16,%r11),__LC_PGM_OLD_PSW
-	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_SYNC
-	lgr	%r2,%r11
-	brasl	%r14,__do_early_pgm_check
-	mvc	__LC_RETURN_PSW(16),STACK_FRAME_OVERHEAD+__PT_PSW(%r15)
-	lmg	%r0,%r15,STACK_FRAME_OVERHEAD+__PT_R0(%r15)
-	lpswe	__LC_RETURN_PSW
-SYM_CODE_END(early_pgm_check_handler)
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 749410cfdbc07..b01f4ac43f729 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -599,6 +599,21 @@ SYM_CODE_START(restart_int_handler)
 3:	j	3b
 SYM_CODE_END(restart_int_handler)
 
+SYM_CODE_START(early_pgm_check_handler)
+	stmg	%r8,%r15,__LC_SAVE_AREA_SYNC
+	aghi	%r15,-(STACK_FRAME_OVERHEAD+__PT_SIZE)
+	la	%r11,STACK_FRAME_OVERHEAD(%r15)
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+	stmg	%r0,%r7,__PT_R0(%r11)
+	mvc	__PT_PSW(16,%r11),__LC_PGM_OLD_PSW
+	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_SYNC
+	lgr	%r2,%r11
+	brasl	%r14,__do_early_pgm_check
+	mvc	__LC_RETURN_PSW(16),STACK_FRAME_OVERHEAD+__PT_PSW(%r15)
+	lmg	%r0,%r15,STACK_FRAME_OVERHEAD+__PT_R0(%r15)
+	lpswe	__LC_RETURN_PSW
+SYM_CODE_END(early_pgm_check_handler)
+
 	.section .kprobes.text, "ax"
 
 #if defined(CONFIG_CHECK_STACK) || defined(CONFIG_VMAP_STACK)
-- 
2.43.0



