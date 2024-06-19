Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF414601E;
	Wed, 19 Jun 2024 13:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803651; cv=none; b=H7P177mHUgowjoP0+sr0TqHuT2UA56Os7+vyp7nqlSPXSuiPV6hUaOkFoyxS6s9+pJjvTIoJT8gQ7phMIj6N8P4Omuy/MxNBxzzV4ytCV7gTsZo8dIdk9B73dZjSsmmDZt1R6rYDIlMGMFxs+BW7wz9w1xbV8kI4GnRZCU9jcAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803651; c=relaxed/simple;
	bh=w/uCawQGf1An2rBL8Chcrr6z/sSBfn46q6Zmio6SOek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uayiZj6Y1JKJyvyor1wrD0mAq/xsA30hVr7sMy3iQKU1cYSC4oRlfbT03835qPa9b7xhjtr3QGm6OzAhJtPsp52JeWNdzmkD5BpneTtYJPKocVsFANl4B4/yKTdWe2VqzB5zQ4fp2AqFOOZr25gbCfSkVdcyjwhCGQLrO4WF3/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usmdNISm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usmdNISm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BC4C2BBFC;
	Wed, 19 Jun 2024 13:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803651;
	bh=w/uCawQGf1An2rBL8Chcrr6z/sSBfn46q6Zmio6SOek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usmdNISmls/B0SNRZFM89hG7Spy/ZH6fHIJVe2qv5S4QlbfKSfEPYDDUoqKpMO6eE
	 WFP2Uyhzev4rU9eJ7RlESVmy25D43uvatB5kiaXhyiixOLfGkvISp18iBWG6DIkXUJ
	 5UI3hvRMLTf14OZ/Kuv9wJlO5PAqZl7tde259UiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/217] xtensa: fix MAKE_PC_FROM_RA second argument
Date: Wed, 19 Jun 2024 14:55:00 +0200
Message-ID: <20240619125558.880097334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 0e60f0b75884677fb9f4f2ad40d52b43451564d5 ]

Xtensa has two-argument MAKE_PC_FROM_RA macro to convert a0 to an actual
return address because when windowed ABI is used call{,x}{4,8,12}
opcodes stuff encoded window size into the top 2 bits of the register
that becomes a return address in the called function. Second argument of
that macro is supposed to be an address having these 2 topmost bits set
correctly, but the comment suggested that that could be the stack
address. However the stack doesn't have to be in the same 1GByte region
as the code, especially in noMMU XIP configurations.

Fix the comment and use either _text or regs->pc as the second argument
for the MAKE_PC_FROM_RA macro.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/include/asm/processor.h | 8 ++++----
 arch/xtensa/include/asm/ptrace.h    | 2 +-
 arch/xtensa/kernel/process.c        | 5 +++--
 arch/xtensa/kernel/stacktrace.c     | 3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/xtensa/include/asm/processor.h b/arch/xtensa/include/asm/processor.h
index 228e4dff5fb2d..ab555a980147b 100644
--- a/arch/xtensa/include/asm/processor.h
+++ b/arch/xtensa/include/asm/processor.h
@@ -113,9 +113,9 @@
 #define MAKE_RA_FOR_CALL(ra,ws)   (((ra) & 0x3fffffff) | (ws) << 30)
 
 /* Convert return address to a valid pc
- * Note: We assume that the stack pointer is in the same 1GB ranges as the ra
+ * Note: 'text' is the address within the same 1GB range as the ra
  */
-#define MAKE_PC_FROM_RA(ra,sp)    (((ra) & 0x3fffffff) | ((sp) & 0xc0000000))
+#define MAKE_PC_FROM_RA(ra, text) (((ra) & 0x3fffffff) | ((unsigned long)(text) & 0xc0000000))
 
 #elif defined(__XTENSA_CALL0_ABI__)
 
@@ -125,9 +125,9 @@
 #define MAKE_RA_FOR_CALL(ra, ws)   (ra)
 
 /* Convert return address to a valid pc
- * Note: We assume that the stack pointer is in the same 1GB ranges as the ra
+ * Note: 'text' is not used as 'ra' is always the full address
  */
-#define MAKE_PC_FROM_RA(ra, sp)    (ra)
+#define MAKE_PC_FROM_RA(ra, text)  (ra)
 
 #else
 #error Unsupported Xtensa ABI
diff --git a/arch/xtensa/include/asm/ptrace.h b/arch/xtensa/include/asm/ptrace.h
index 308f209a47407..17c5cbd1832e7 100644
--- a/arch/xtensa/include/asm/ptrace.h
+++ b/arch/xtensa/include/asm/ptrace.h
@@ -87,7 +87,7 @@ struct pt_regs {
 # define user_mode(regs) (((regs)->ps & 0x00000020)!=0)
 # define instruction_pointer(regs) ((regs)->pc)
 # define return_pointer(regs) (MAKE_PC_FROM_RA((regs)->areg[0], \
-					       (regs)->areg[1]))
+					       (regs)->pc))
 
 # ifndef CONFIG_SMP
 #  define profile_pc(regs) instruction_pointer(regs)
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 68e0e2f06d660..3138f72dcbe2e 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -47,6 +47,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/regs.h>
 #include <asm/hw_breakpoint.h>
+#include <asm/sections.h>
 #include <asm/traps.h>
 
 extern void ret_from_fork(void);
@@ -379,7 +380,7 @@ unsigned long __get_wchan(struct task_struct *p)
 	int count = 0;
 
 	sp = p->thread.sp;
-	pc = MAKE_PC_FROM_RA(p->thread.ra, p->thread.sp);
+	pc = MAKE_PC_FROM_RA(p->thread.ra, _text);
 
 	do {
 		if (sp < stack_page + sizeof(struct task_struct) ||
@@ -391,7 +392,7 @@ unsigned long __get_wchan(struct task_struct *p)
 
 		/* Stack layout: sp-4: ra, sp-3: sp' */
 
-		pc = MAKE_PC_FROM_RA(SPILL_SLOT(sp, 0), sp);
+		pc = MAKE_PC_FROM_RA(SPILL_SLOT(sp, 0), _text);
 		sp = SPILL_SLOT(sp, 1);
 	} while (count++ < 16);
 	return 0;
diff --git a/arch/xtensa/kernel/stacktrace.c b/arch/xtensa/kernel/stacktrace.c
index dcba743305efe..b69044893287f 100644
--- a/arch/xtensa/kernel/stacktrace.c
+++ b/arch/xtensa/kernel/stacktrace.c
@@ -13,6 +13,7 @@
 #include <linux/stacktrace.h>
 
 #include <asm/ftrace.h>
+#include <asm/sections.h>
 #include <asm/stacktrace.h>
 #include <asm/traps.h>
 #include <linux/uaccess.h>
@@ -189,7 +190,7 @@ void walk_stackframe(unsigned long *sp,
 		if (a1 <= (unsigned long)sp)
 			break;
 
-		frame.pc = MAKE_PC_FROM_RA(a0, a1);
+		frame.pc = MAKE_PC_FROM_RA(a0, _text);
 		frame.sp = a1;
 
 		if (fn(&frame, data))
-- 
2.43.0



