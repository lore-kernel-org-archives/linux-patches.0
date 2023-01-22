Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC02590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A34C433EF;
	Sun, 22 Jan 2023 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401211;
	bh=694T3fnNM6TLDM0z6g97R2YJfGt5FwwHYM50F/dyqvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfNQebvqE9hEkEQ1NxkW19YqicL/GbKijvavsGp0xLqkXV0DLfNPfY7y6BvZGkw3x
	 x5KdkmbSK+2YJsK3Ba/+juIKFTJGeR1F/p3xdvJti3NE7qLpfG6wWndbFX79atZuRR
	 tWKP/+qDHa4AySPVQorwYDxuwQxuVJJ+/Gw42BmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 152/193] exit: Expose "oops_count" to sysfs
Date: Sun, 22 Jan 2023 16:04:41 +0100
Message-Id: <20230122150253.336833341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit 9db89b41117024f80b38b15954017fb293133364 upstream.

Since Oops count is now tracked and is a fairly interesting signal, add
the entry /sys/kernel/oops_count to expose it to userspace.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-3-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-kernel-oops_count |    6 ++++++
 MAINTAINERS                                       |    1 +
 kernel/exit.c                                     |   22 ++++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-oops_count

--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-oops_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/oops_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Oopsed since last boot.
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11112,6 +11112,7 @@ M:	Kees Cook <keescook@chromium.org>
 L:	linux-hardening@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/hardening
+F:	Documentation/ABI/testing/sysfs-kernel-oops_count
 F:	include/linux/overflow.h
 F:	include/linux/randomize_kstack.h
 F:	mm/usercopy.c
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -67,6 +67,7 @@
 #include <linux/io_uring.h>
 #include <linux/kprobes.h>
 #include <linux/rethook.h>
+#include <linux/sysfs.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -99,6 +100,25 @@ static __init int kernel_exit_sysctls_in
 late_initcall(kernel_exit_sysctls_init);
 #endif
 
+static atomic_t oops_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_SYSFS
+static ssize_t oops_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *page)
+{
+	return sysfs_emit(page, "%d\n", atomic_read(&oops_count));
+}
+
+static struct kobj_attribute oops_count_attr = __ATTR_RO(oops_count);
+
+static __init int kernel_exit_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &oops_count_attr.attr, NULL);
+	return 0;
+}
+late_initcall(kernel_exit_sysfs_init);
+#endif
+
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
@@ -901,8 +921,6 @@ void __noreturn do_exit(long code)
 
 void __noreturn make_task_dead(int signr)
 {
-	static atomic_t oops_count = ATOMIC_INIT(0);
-
 	/*
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.


