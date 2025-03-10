Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB24022D4C3;
	Mon, 10 Mar 2025 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628630; cv=none; b=uKY6qOfRI4EOk2qurLcM+yyrLix0KX/ZgK4AKbuuIiN260ttNOpMemlIhKYz4BPnK/ZB454tXLSqOaIqyICofXfyEeak9RSm+YqFkBZsfYI6EsCdBcukPdeBgwolueJPRIwh2J+MFJ71Cjx/c/c3Lzo1bpq3Ldfn80ViN+l7IiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628630; c=relaxed/simple;
	bh=emW5Pdd4hpvQ2U2lZSoefwLSN3snJfMu61bkhyWMf08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CENGbeThayXTJQdUYr64KlxwgfE9+T0SCux/yKL1sOpGM8eKSBHJeHuUn25qPcmBVbIDeYTyXcS3NDOef4a9sVGyhUebd1gyLQTJghu2TaxvLVViJJzZYVxaPrzxwY2suNK1sn8d6kaFZRPGKWbWKktc7yFhIzb8ZIppzsmIg78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVU/7QbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVU/7QbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE626C4CEE5;
	Mon, 10 Mar 2025 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628630;
	bh=emW5Pdd4hpvQ2U2lZSoefwLSN3snJfMu61bkhyWMf08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVU/7QbPeYgZ9IVQVC3+cAnqs+167ArXCtxpdRFMG3pI4/QRqEJ+5Y8yNL3mRa9wP
	 Senw4MJOQ5ruemi9xlH0XJ9qastBLHjWX4TwDEITJETSkv8WSLtGKWZS3fAxY/4xeX
	 AjRCMbnQ2hbs0fGO2Ce77GmmGX9K5UxEsKchmZfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Eric Biederman <ebiederm@xmission.com>,
	Iurii Zaikin <yzaikin@google.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Lukas Middendorf <kernel@tuxforce.de>,
	Stephen Kitt <steve@sk2.org>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/620] fs: move fs stat sysctls to file_table.c
Date: Mon, 10 Mar 2025 17:57:33 +0100
Message-ID: <20250310170545.864971959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 204d5a24e15562b2816825c0f9b49d26814b77be ]

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we
just care about the core logic.

We can create the sysctl dynamically on early init for fs stat to help
with this clutter.  This dusts off the fs stat syctls knobs and puts
them into where they are declared.

Link: https://lkml.kernel.org/r/20211129205548.605569-3-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: d727935cad9f ("fs: fix proc_handler for sysctl_nr_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c    | 47 ++++++++++++++++++++++++++++++++++++++--------
 include/linux/fs.h |  3 ---
 kernel/sysctl.c    | 25 ------------------------
 3 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 6f297f9782fc5..a8d4a2fb9c67f 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -33,7 +33,7 @@
 #include "internal.h"
 
 /* sysctl tunables... */
-struct files_stat_struct files_stat = {
+static struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
@@ -75,22 +75,53 @@ unsigned long get_max_files(void)
 }
 EXPORT_SYMBOL_GPL(get_max_files);
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+
 /*
  * Handle nr_files sysctl
  */
-#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
-int proc_nr_files(struct ctl_table *table, int write,
-                     void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_nr_files(struct ctl_table *table, int write, void *buffer,
+			 size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
-#else
-int proc_nr_files(struct ctl_table *table, int write,
-                     void *buffer, size_t *lenp, loff_t *ppos)
+
+static struct ctl_table fs_stat_sysctls[] = {
+	{
+		.procname	= "file-nr",
+		.data		= &files_stat,
+		.maxlen		= sizeof(files_stat),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_files,
+	},
+	{
+		.procname	= "file-max",
+		.data		= &files_stat.max_files,
+		.maxlen		= sizeof(files_stat.max_files),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= SYSCTL_LONG_ZERO,
+		.extra2		= SYSCTL_LONG_MAX,
+	},
+	{
+		.procname	= "nr_open",
+		.data		= &sysctl_nr_open,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &sysctl_nr_open_min,
+		.extra2		= &sysctl_nr_open_max,
+	},
+	{ }
+};
+
+static int __init init_fs_stat_sysctls(void)
 {
-	return -ENOSYS;
+	register_sysctl_init("fs", fs_stat_sysctls);
+	return 0;
 }
+fs_initcall(init_fs_stat_sysctls);
 #endif
 
 static struct file *__alloc_file(int flags, const struct cred *cred)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2af01758a1abf..d011dc742e3ef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -78,7 +78,6 @@ extern void __init inode_init_early(void);
 extern void __init files_init(void);
 extern void __init files_maxfiles_init(void);
 
-extern struct files_stat_struct files_stat;
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
 extern int leases_enable, lease_break_time;
@@ -3669,8 +3668,6 @@ ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
 				 size_t len, loff_t *ppos);
 
 struct ctl_table;
-int proc_nr_files(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_dentry(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a491d145acc31..eaf9dd6a2f12f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -3116,31 +3116,6 @@ static struct ctl_table vm_table[] = {
 };
 
 static struct ctl_table fs_table[] = {
-	{
-		.procname	= "file-nr",
-		.data		= &files_stat,
-		.maxlen		= sizeof(files_stat),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_files,
-	},
-	{
-		.procname	= "file-max",
-		.data		= &files_stat.max_files,
-		.maxlen		= sizeof(files_stat.max_files),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= SYSCTL_LONG_ZERO,
-		.extra2		= SYSCTL_LONG_MAX,
-	},
-	{
-		.procname	= "nr_open",
-		.data		= &sysctl_nr_open,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &sysctl_nr_open_min,
-		.extra2		= &sysctl_nr_open_max,
-	},
 	{
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,
-- 
2.39.5



