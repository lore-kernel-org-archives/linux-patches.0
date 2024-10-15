Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15081E6339;
	Tue, 15 Oct 2024 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993500; cv=none; b=orrHY+QGCNGWp3Zz8/2rFQMZyBy5etL5R+An0ncYpIi8GPQA4Xljzr7/6gc4betY7b9TOw36Xo5WCADAlzIJhPe+rjInzj0p0TVuJO8ABLusJGL3NX/IKQHeiAI016ywuP479M8vFyaFBxrcp/eVYWXWK1R5eoMZOT/mLDY6pFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993500; c=relaxed/simple;
	bh=iEKcoisCVGaVckO40cIoOHd3up3/PFPaJ+7TYTTjBUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7JHIuKeFyP9SDTi4YHPqtWsNlB1CqvP2Sdog52WFnFoXbBWzg7ixFDKLUebQIUIuxGQGK66I/wU22pwRlj6bDCv4J9aBlPga2kO2cVbXV9uXCIn+BX/xwfkS/3tX7SRExPMnFhaWWUr5Ega8/p5KuyHC+5GaIMdZYGdi9mabnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSechahP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSechahP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC97C4CEC6;
	Tue, 15 Oct 2024 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993500;
	bh=iEKcoisCVGaVckO40cIoOHd3up3/PFPaJ+7TYTTjBUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSechahPrzRcJAMdHfzTG5IDAB0XbQsAEcDfXeZFOeBxYJXzNrtRgVD9jGJ6YxUOL
	 P8k9Cgpvocz7fuoLOOUMgaDLxM58ISjls+qNjc/C0xrroCIbP0WBlyQkYAEewjVQ7b
	 GL7AL+YorEgt/Rd+jk3NNMzzEcyElXvH59byT0W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Jeff Xu <jeffxu@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/691] proc: add config & param to block forcing mem writes
Date: Tue, 15 Oct 2024 13:26:19 +0200
Message-ID: <20241015112457.448557919@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ratiu <adrian.ratiu@collabora.com>

[ Upstream commit 41e8149c8892ed1962bd15350b3c3e6e90cba7f4 ]

This adds a Kconfig option and boot param to allow removing
the FOLL_FORCE flag from /proc/pid/mem write calls because
it can be abused.

The traditional forcing behavior is kept as default because
it can break GDB and some other use cases.

Previously we tried a more sophisticated approach allowing
distributions to fine-tune /proc/pid/mem behavior, however
that got NAK-ed by Linus [1], who prefers this simpler
approach with semantics also easier to understand for users.

Link: https://lore.kernel.org/lkml/CAHk-=wiGWLChxYmUA5HrT5aopZrB7_2VTa0NLZcxORgkUe5tEQ@mail.gmail.com/ [1]
Cc: Doug Anderson <dianders@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
Link: https://lore.kernel.org/r/20240802080225.89408-1-adrian.ratiu@collabora.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         | 10 +++
 fs/proc/base.c                                | 61 ++++++++++++++++++-
 security/Kconfig                              | 32 ++++++++++
 3 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c22a8ee02e73b..ede522c60ac4f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4333,6 +4333,16 @@
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
+	proc_mem.force_override= [KNL]
+			Format: {always | ptrace | never}
+			Traditionally /proc/pid/mem allows memory permissions to be
+			overridden without restrictions. This option may be set to
+			restrict that. Can be one of:
+			- 'always': traditional behavior always allows mem overrides.
+			- 'ptrace': only allow mem overrides for active ptracers.
+			- 'never':  never allow mem overrides.
+			If not specified, default is the CONFIG_PROC_MEM_* choice.
+
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
 			max_cstate=9 overrides any DMI blacklist limit.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index e5d7a5a75aff9..d0414e566d30a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -86,6 +86,7 @@
 #include <linux/elf.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/fs_parser.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
@@ -116,6 +117,40 @@
 static u8 nlink_tid __ro_after_init;
 static u8 nlink_tgid __ro_after_init;
 
+enum proc_mem_force {
+	PROC_MEM_FORCE_ALWAYS,
+	PROC_MEM_FORCE_PTRACE,
+	PROC_MEM_FORCE_NEVER
+};
+
+static enum proc_mem_force proc_mem_force_override __ro_after_init =
+	IS_ENABLED(CONFIG_PROC_MEM_NO_FORCE) ? PROC_MEM_FORCE_NEVER :
+	IS_ENABLED(CONFIG_PROC_MEM_FORCE_PTRACE) ? PROC_MEM_FORCE_PTRACE :
+	PROC_MEM_FORCE_ALWAYS;
+
+static const struct constant_table proc_mem_force_table[] __initconst = {
+	{ "always", PROC_MEM_FORCE_ALWAYS },
+	{ "ptrace", PROC_MEM_FORCE_PTRACE },
+	{ "never", PROC_MEM_FORCE_NEVER },
+	{ }
+};
+
+static int __init early_proc_mem_force_override(char *buf)
+{
+	if (!buf)
+		return -EINVAL;
+
+	/*
+	 * lookup_constant() defaults to proc_mem_force_override to preseve
+	 * the initial Kconfig choice in case an invalid param gets passed.
+	 */
+	proc_mem_force_override = lookup_constant(proc_mem_force_table,
+						  buf, proc_mem_force_override);
+
+	return 0;
+}
+early_param("proc_mem.force_override", early_proc_mem_force_override);
+
 struct pid_entry {
 	const char *name;
 	unsigned int len;
@@ -835,6 +870,28 @@ static int mem_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
+{
+	struct task_struct *task;
+	bool ptrace_active = false;
+
+	switch (proc_mem_force_override) {
+	case PROC_MEM_FORCE_NEVER:
+		return false;
+	case PROC_MEM_FORCE_PTRACE:
+		task = get_proc_task(file_inode(file));
+		if (task) {
+			ptrace_active =	READ_ONCE(task->ptrace) &&
+					READ_ONCE(task->mm) == mm &&
+					READ_ONCE(task->parent) == current;
+			put_task_struct(task);
+		}
+		return ptrace_active;
+	default:
+		return true;
+	}
+}
+
 static ssize_t mem_rw(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos, int write)
 {
@@ -855,7 +912,9 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	if (!mmget_not_zero(mm))
 		goto free;
 
-	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
+	flags = write ? FOLL_WRITE : 0;
+	if (proc_mem_foll_force(file, mm))
+		flags |= FOLL_FORCE;
 
 	while (count > 0) {
 		size_t this_len = min_t(size_t, count, PAGE_SIZE);
diff --git a/security/Kconfig b/security/Kconfig
index 5d412b3ddc496..6c9b5869e675a 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -19,6 +19,38 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
+choice
+	prompt "Allow /proc/pid/mem access override"
+	default PROC_MEM_ALWAYS_FORCE
+	help
+	  Traditionally /proc/pid/mem allows users to override memory
+	  permissions for users like ptrace, assuming they have ptrace
+	  capability.
+
+	  This allows people to limit that - either never override, or
+	  require actual active ptrace attachment.
+
+	  Defaults to the traditional behavior (for now)
+
+config PROC_MEM_ALWAYS_FORCE
+	bool "Traditional /proc/pid/mem behavior"
+	help
+	  This allows /proc/pid/mem accesses to override memory mapping
+	  permissions if you have ptrace access rights.
+
+config PROC_MEM_FORCE_PTRACE
+	bool "Require active ptrace() use for access override"
+	help
+	  This allows /proc/pid/mem accesses to override memory mapping
+	  permissions for active ptracers like gdb.
+
+config PROC_MEM_NO_FORCE
+	bool "Never"
+	help
+	  Never override memory mapping permissions
+
+endchoice
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
-- 
2.43.0



