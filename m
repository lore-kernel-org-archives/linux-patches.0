Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F633323D
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0DFC4339B;
	Mon, 30 Jan 2023 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088265;
	bh=Vlm9FSomxMHts0rg8IrPhJoQiFNsSsSHxlAo+WKjF6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpLo2L8uwwHKK8ZZEv0YA07l4NSCXxF71J1RS8UXPpeOyB+J2tJWaSgJvRB7L5X+8
	 bCf6WmnqildfRp68m2UgrYYh7N5b+FDnKeCMX/f+StuYwJ9jlSkqEvT276qnpXP7WE
	 heIa5vvUpze3Z1YD8FGVOmiJX5MiEwJRIQAbN9Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	tangmeng <tangmeng@uniontech.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/204] panic: Expose "warn_count" to sysfs
Date: Mon, 30 Jan 2023 14:51:45 +0100
Message-Id: <20230130134322.699099933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

commit 8b05aa26336113c4cea25f1c333ee8cd4fc212a6 upstream.

Since Warn count is now tracked and is a fairly interesting signal, add
the entry /sys/kernel/warn_count to expose it to userspace.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-6-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-kernel-warn_count       |  6 +++++
 kernel/panic.c                                | 22 +++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-warn_count

diff --git a/Documentation/ABI/testing/sysfs-kernel-warn_count b/Documentation/ABI/testing/sysfs-kernel-warn_count
new file mode 100644
index 000000000000..08f083d2fd51
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/oops_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Warned since last boot.
diff --git a/kernel/panic.c b/kernel/panic.c
index 604d7ad77042..4aef355e9a5d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -32,6 +32,7 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <linux/sysfs.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -105,6 +106,25 @@ static __init int kernel_panic_sysctls_init(void)
 late_initcall(kernel_panic_sysctls_init);
 #endif
 
+static atomic_t warn_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_SYSFS
+static ssize_t warn_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *page)
+{
+	return sysfs_emit(page, "%d\n", atomic_read(&warn_count));
+}
+
+static struct kobj_attribute warn_count_attr = __ATTR_RO(warn_count);
+
+static __init int kernel_panic_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &warn_count_attr.attr, NULL);
+	return 0;
+}
+late_initcall(kernel_panic_sysfs_init);
+#endif
+
 static long no_blink(int state)
 {
 	return 0;
@@ -203,8 +223,6 @@ static void panic_print_sys_info(void)
 
 void check_panic_on_warn(const char *origin)
 {
-	static atomic_t warn_count = ATOMIC_INIT(0);
-
 	if (panic_on_warn)
 		panic("%s: panic_on_warn set ...\n", origin);
 
-- 
2.39.0



