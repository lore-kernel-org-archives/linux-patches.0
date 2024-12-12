Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7C2223E6C;
	Thu, 12 Dec 2024 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025565; cv=none; b=FOUteMvKhewLqWwMu6Im/4zOjfjJ5wMraVuLoxsAtY/HG+Y4Y9uqtNKuBUdFBLJj8bSsMHjYw6acxP4lxa42rmqeTriboWFLiaPO5oGd5BN6vREQeLADpBSXTxk9q1V4ScBuE7H0i1u2ZilhVQbuFoiv4cMWOKi707gobBFjYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025565; c=relaxed/simple;
	bh=DybWwqa8HbOJZ7+lX8wKsessFmtM7dG72bngJrv/bhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUbBjYNfAV8XdPzS/JkTuJhkwJRVlUCGtJ/GdXIf8F6qVKWBfrIoyN/hyr3SqFCaVxgt+7T699BqGbgwSEefUq06u/VPjgZEj2fIJkDv2RSSuqaaU/3SW1RKdaSrOSoLp1AUA/dR3sWYEY/4czy+3p5EwxGrbneYRAfO8TeljWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZ5J9IYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ5J9IYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB6AC4CECE;
	Thu, 12 Dec 2024 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025565;
	bh=DybWwqa8HbOJZ7+lX8wKsessFmtM7dG72bngJrv/bhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZ5J9IYHRAzfQOWTDsAi3pf/dP9u3bqztGuwqkUDIDOwvGLf2Y5N6gPOwjMWbVqGd
	 DBecyeCMNuXb4+Q+VzLfrQjB1RkSVBOwmDaUv33nmhUn8GpjZVNASzuDhtP8C6+NtE
	 SyVU9O2f78yoCOCHseoZo7PhGwRaj+8/06H3VsEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <dima@arista.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/321] um: add show_stack_loglvl()
Date: Thu, 12 Dec 2024 16:01:39 +0100
Message-ID: <20241212144237.139282867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit 1ad87824f4cf16a7f381e1f94943a96bb7a99062 ]

Currently, the log-level of show_stack() depends on a platform
realization.  It creates situations where the headers are printed with
lower log level or higher than the stacktrace (depending on a platform or
user).

Furthermore, it forces the logic decision from user to an architecture
side.  In result, some users as sysrq/kdb/etc are doing tricks with
temporary rising console_loglevel while printing their messages.  And in
result it not only may print unwanted messages from other CPUs, but also
omit printing at all in the unlucky case where the printk() was deferred.

Introducing log-level parameter and KERN_UNSUPPRESSED [1] seems an easier
approach than introducing more printk buffers.  Also, it will consolidate
printings with headers.

Introduce show_stack_loglvl(), that eventually will substitute
show_stack().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/20200418201944.482088-37-dima@arista.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 0f659ff362ea ("um: Always dump trace for specified task in show_stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index c831a1c2eb94a..1b54b6431499b 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -17,7 +17,9 @@
 
 static void _print_addr(void *data, unsigned long address, int reliable)
 {
-	pr_info(" [<%08lx>] %s%pS\n", address, reliable ? "" : "? ",
+	const char *loglvl = data;
+
+	printk("%s [<%08lx>] %s%pS\n", loglvl, address, reliable ? "" : "? ",
 		(void *)address);
 }
 
@@ -25,7 +27,8 @@ static const struct stacktrace_ops stackops = {
 	.address = _print_addr
 };
 
-void show_stack(struct task_struct *task, unsigned long *stack)
+void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
+		       const char *loglvl)
 {
 	struct pt_regs *segv_regs = current->thread.segv_regs;
 	int i;
@@ -39,17 +42,22 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	if (!stack)
 		stack = get_stack_pointer(task, segv_regs);
 
-	pr_info("Stack:\n");
+	printk("%sStack:\n", loglvl);
 	for (i = 0; i < 3 * STACKSLOTS_PER_LINE; i++) {
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			pr_cont("\n");
+			printk("%s\n", loglvl);
 		pr_cont(" %08lx", *stack++);
 	}
-	pr_cont("\n");
+	printk("%s\n", loglvl);
+
+	printk("%sCall Trace:\n", loglvl);
+	dump_trace(current, &stackops, (void *)loglvl);
+	printk("%s\n", loglvl);
+}
 
-	pr_info("Call Trace:\n");
-	dump_trace(current, &stackops, NULL);
-	pr_info("\n");
+void show_stack(struct task_struct *task, unsigned long *stack)
+{
+	show_stack_loglvl(task, stack, KERN_INFO);
 }
-- 
2.43.0



