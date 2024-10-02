Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886C01D04B4;
	Wed,  2 Oct 2024 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876036; cv=none; b=Spr8QugyDYT2a+EIyQTGzhSabELQzGKAo9pjwtEeQoS3QmaqV63qJ0QySMAowzxrgdF95DAgyRlIZ8BhCnSfl1Hnltr9q4pI50OQ+yCeNd06/zh9q3uc82vGb2fiVw0WD1IcGBdHF/NDncF+NMom1SQNzchCgivIvT0JWTPC2NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876036; c=relaxed/simple;
	bh=YuB9nZfX40b25zvNjrD99XiOwR5bpp2Xr9hPOAjh/gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAhXcVzMVValGrLy/CQ5xWE7oyrX4y/KRgzZWHOjhzbvFDp/y199HyEuToDJ4IOJ4BLv/MugWEFlFxmp5Rv0vTDnN2nL5qTAB0LuV5ILZA1MhGRJSUCzN1t5BrXz0dGKHx9IqF2RabDBC3coyE4m9ZnkCKZm7HB2Bhgvg89U6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqCHVHyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqCHVHyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E49C4CEC5;
	Wed,  2 Oct 2024 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876036;
	bh=YuB9nZfX40b25zvNjrD99XiOwR5bpp2Xr9hPOAjh/gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqCHVHyCyXfYjmlPzVga3F8CJaNKGIwTt9Ms3EQfc3fsO3K8t2UU89ufLt5rVj93P
	 VTYfY3bqlnshcntJXTu7tqBH4hKJdjyje43eAARC8HCPzeJ1Qen/Nxo3t9l7oVWnyN
	 522ltlLldEY0ftvaZ5epV2k7PlgfNr7GJwVXDdKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 289/695] s390/entry: Make early program check handler relocated lowcore aware
Date: Wed,  2 Oct 2024 14:54:47 +0200
Message-ID: <20241002125833.977276102@linuxfoundation.org>
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

[ Upstream commit f101b305a7b9513a8042a2cf09018de4ff371af2 ]

Add the missing pieces so the early program check handler also works
with a relocated lowcore. Right now the result of an early program
check in case of a relocated lowcore would be a program check loop.

Fixes: 8f1e70adb1a3 ("s390/boot: Add cmdline option to relocate lowcore")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c |  7 +++++--
 arch/s390/kernel/entry.S | 11 ++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 14d324865e33f..ee051ad81c711 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -183,12 +183,15 @@ void __do_early_pgm_check(struct pt_regs *regs)
 
 static noinline __init void setup_lowcore_early(void)
 {
+	struct lowcore *lc = get_lowcore();
 	psw_t psw;
 
 	psw.addr = (unsigned long)early_pgm_check_handler;
 	psw.mask = PSW_KERNEL_BITS;
-	get_lowcore()->program_new_psw = psw;
-	get_lowcore()->preempt_count = INIT_PREEMPT_COUNT;
+	lc->program_new_psw = psw;
+	lc->preempt_count = INIT_PREEMPT_COUNT;
+	lc->return_lpswe = gen_lpswe(__LC_RETURN_PSW);
+	lc->return_mcck_lpswe = gen_lpswe(__LC_RETURN_MCCK_PSW);
 }
 
 static __init void detect_diag9c(void)
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index b01f4ac43f729..6539ec4800cd1 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -600,18 +600,19 @@ SYM_CODE_START(restart_int_handler)
 SYM_CODE_END(restart_int_handler)
 
 SYM_CODE_START(early_pgm_check_handler)
-	stmg	%r8,%r15,__LC_SAVE_AREA_SYNC
+	STMG_LC %r8,%r15,__LC_SAVE_AREA_SYNC
+	GET_LC	%r13
 	aghi	%r15,-(STACK_FRAME_OVERHEAD+__PT_SIZE)
 	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	stmg	%r0,%r7,__PT_R0(%r11)
-	mvc	__PT_PSW(16,%r11),__LC_PGM_OLD_PSW
-	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_SYNC
+	mvc	__PT_PSW(16,%r11),__LC_PGM_OLD_PSW(%r13)
+	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA_SYNC(%r13)
 	lgr	%r2,%r11
 	brasl	%r14,__do_early_pgm_check
-	mvc	__LC_RETURN_PSW(16),STACK_FRAME_OVERHEAD+__PT_PSW(%r15)
+	mvc	__LC_RETURN_PSW(16,%r13),STACK_FRAME_OVERHEAD+__PT_PSW(%r15)
 	lmg	%r0,%r15,STACK_FRAME_OVERHEAD+__PT_R0(%r15)
-	lpswe	__LC_RETURN_PSW
+	LPSWEY	__LC_RETURN_PSW,__LC_RETURN_LPSWE
 SYM_CODE_END(early_pgm_check_handler)
 
 	.section .kprobes.text, "ax"
-- 
2.43.0



