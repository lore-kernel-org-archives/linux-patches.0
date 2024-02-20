Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96E76C9C;
	Tue, 20 Feb 2024 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463467; cv=none; b=tbQ2hpEXTJ8jrhD1sSFpSVIRbZVkuq6aZC/ylf5sogqst+nugPSyqUTPDQA3VnoUYlu/WfAqfyPgCw0bQ0BBRUP9xqWpY5al9IRq5NR1pbkn2mgboKhmDv/peM1pt1tS6GJgabQUWAXsw/J5ANnWzvwrM3Phc15sVi0XlGGgWZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463467; c=relaxed/simple;
	bh=kCjWIY3mh00uSZ2e/Y5Mq+0XyrFlSSu8kLW0qAcIucM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwG3Wd0IZpXT5m3YNcbmHX3RuiNKy5Xaw0RmOFrJuttbhorCSaJTWjIO8MVnrzHPo9Wblh0Y+UJTMgOWsHht6CsTZ+hQHJr9hPtdCWKnHPnXJ4/9BBTqsOm73zrKjk7V3xv7jolvrbOSQ1HBysRKhJadaSka4tNH6v9wG1LSj+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAstRjon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAstRjon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E39CC433C7;
	Tue, 20 Feb 2024 21:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463466;
	bh=kCjWIY3mh00uSZ2e/Y5Mq+0XyrFlSSu8kLW0qAcIucM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAstRjon64LQn3hAypZgbsWGbnF/F8H0mr5EoOko7rX2lmyuAC83DaAjCkj3NbJnv
	 39S9zy5kXoixOKZtS0gO8w7UMfLXAA1hitGiVGS1MAwjwssIl6+n737M/eCvgmmEFZ
	 lORcJ05L9bs2jZ4eGySFjiqWCsx9M1cEa3gJlP4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/331] ptrace: Introduce exception_ip arch hook
Date: Tue, 20 Feb 2024 21:52:47 +0100
Message-ID: <20240220205639.199752579@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 11ba1728be3edb6928791f4c622f154ebe228ae6 ]

On architectures with delay slot, architecture level instruction
pointer (or program counter) in pt_regs may differ from where
exception was triggered.

Introduce exception_ip hook to invoke architecture code and determine
actual instruction pointer to the exception.

Link: https://lore.kernel.org/lkml/00d1b813-c55f-4365-8d81-d70258e10b16@app.fastmail.com/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 8fa507083388 ("mm/memory: Use exception ip to search exception tables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ptrace.h | 2 ++
 arch/mips/kernel/ptrace.c      | 7 +++++++
 include/linux/ptrace.h         | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index daf3cf244ea9..701a233583c2 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -154,6 +154,8 @@ static inline long regs_return_value(struct pt_regs *regs)
 }
 
 #define instruction_pointer(regs) ((regs)->cp0_epc)
+extern unsigned long exception_ip(struct pt_regs *regs);
+#define exception_ip(regs) exception_ip(regs)
 #define profile_pc(regs) instruction_pointer(regs)
 
 extern asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall);
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index d9df543f7e2c..59288c13b581 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -31,6 +31,7 @@
 #include <linux/seccomp.h>
 #include <linux/ftrace.h>
 
+#include <asm/branch.h>
 #include <asm/byteorder.h>
 #include <asm/cpu.h>
 #include <asm/cpu-info.h>
@@ -48,6 +49,12 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
 
+unsigned long exception_ip(struct pt_regs *regs)
+{
+	return exception_epc(regs);
+}
+EXPORT_SYMBOL(exception_ip);
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index eaaef3ffec22..90507d4afcd6 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -393,6 +393,10 @@ static inline void user_single_step_report(struct pt_regs *regs)
 #define current_user_stack_pointer() user_stack_pointer(current_pt_regs())
 #endif
 
+#ifndef exception_ip
+#define exception_ip(x) instruction_pointer(x)
+#endif
+
 extern int task_current_syscall(struct task_struct *target, struct syscall_info *info);
 
 extern void sigaction_compat_abi(struct k_sigaction *act, struct k_sigaction *oact);
-- 
2.43.0



