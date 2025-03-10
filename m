Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7982D22D4C3;
	Mon, 10 Mar 2025 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628627; cv=none; b=etLWqHRBptVJf6q3ShkuYItt/OZIB90JjBotYinf63eu3JANr58iBzeBvq0vyu4VByoj7EhUxW1OssdkIm1fZJD7I2ClLD8EZwivXEg8n9u0UMBhbUYskL+u+tathck/EKY0vmLK7+PtekNC/j0nuM9+BxZHkLymMje7sX592PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628627; c=relaxed/simple;
	bh=c6z7nfI4rZBxAF/CMH2lalOn3kbA71ttyHvKI/BTDlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHHS1pIQm/jXmLhsGBqTK4NlyKNTTZJboPsNMl+bCXc1w2mVnVww0JyLVMTFmvQ0oqniOUot1fDgHvEME0Sgi2njUYYefIJcB9q/PFxq9JRbM0xK0lPbIHxXUye9ANwIlu/F+UR17m3cB3/MU7quJ9Mx0Ii2lFVWwV09Iz6QTwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkQJ6FUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkQJ6FUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78ACC4CEE5;
	Mon, 10 Mar 2025 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628627;
	bh=c6z7nfI4rZBxAF/CMH2lalOn3kbA71ttyHvKI/BTDlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkQJ6FUuGBwIX87cDPuZLoGQQXICwjgyFiXks3q7IwZxtGVYzetCUaolG+jHfpz5F
	 xx7i005k074qTTT6nV8nNca8J9DTlSdSk3D3kv/JZmALCGdDP5UpU6YkPe1klCMVBg
	 R7ctHfvH9o7OlSWEaS/PouZbXhDRzdFu1htWM6uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Kees Cook <keescook@chromium.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Stephen Kitt <steve@sk2.org>,
	Lukas Middendorf <kernel@tuxforce.de>,
	Antti Palosaari <crope@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jeff Layton <jlayton@kernel.org>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/620] fs: move inode sysctls to its own file
Date: Mon, 10 Mar 2025 17:57:32 +0100
Message-ID: <20250310170545.825707528@linuxfoundation.org>
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

[ Upstream commit 1d67fe585049d3e2448b997af78c68cbf90ada09 ]

Patch series "sysctl: 4th set of kernel/sysctl cleanups".

This is slimming down the fs uses of kernel/sysctl.c to the point that
the next step is to just get rid of the fs base directory for it and
move that elsehwere, so that next patch series starts dealing with that
to demo how we can end up cleaning up a full base directory from
kernel/sysctl.c, one at a time.

This patch (of 9):

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we
just care about the core logic.

So move the inode sysctls to its own file.  Since we are no longer using
this outside of fs/ remove the extern declaration of its respective proc
helper.

We use early_initcall() as it is the earliest we can use.

[arnd@arndb.de: avoid unused-variable warning]
  Link: https://lkml.kernel.org/r/20211203190123.874239-1-arnd@kernel.org

Link: https://lkml.kernel.org/r/20211129205548.605569-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211129205548.605569-2-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: d727935cad9f ("fs: fix proc_handler for sysctl_nr_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c         | 39 ++++++++++++++++++++++++++++++++-------
 include/linux/fs.h |  3 ---
 kernel/sysctl.c    | 14 --------------
 3 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index c7ef50d0fe38b..0a3a14b9ee46f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -67,11 +67,6 @@ const struct address_space_operations empty_aops = {
 };
 EXPORT_SYMBOL(empty_aops);
 
-/*
- * Statistics gathering..
- */
-struct inodes_stat_t inodes_stat;
-
 static DEFINE_PER_CPU(unsigned long, nr_inodes);
 static DEFINE_PER_CPU(unsigned long, nr_unused);
 
@@ -106,13 +101,43 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
-int proc_nr_inodes(struct ctl_table *table, int write,
-		   void *buffer, size_t *lenp, loff_t *ppos)
+/*
+ * Statistics gathering..
+ */
+static struct inodes_stat_t inodes_stat;
+
+static int proc_nr_inodes(struct ctl_table *table, int write, void *buffer,
+			  size_t *lenp, loff_t *ppos)
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
 	inodes_stat.nr_unused = get_nr_inodes_unused();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
+
+static struct ctl_table inodes_sysctls[] = {
+	{
+		.procname	= "inode-nr",
+		.data		= &inodes_stat,
+		.maxlen		= 2*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_inodes,
+	},
+	{
+		.procname	= "inode-state",
+		.data		= &inodes_stat,
+		.maxlen		= 7*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_inodes,
+	},
+	{ }
+};
+
+static int __init init_fs_inode_sysctls(void)
+{
+	register_sysctl_init("fs", inodes_sysctls);
+	return 0;
+}
+early_initcall(init_fs_inode_sysctls);
 #endif
 
 static int no_open(struct inode *inode, struct file *file)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ef0e48c89ec4..2af01758a1abf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -81,7 +81,6 @@ extern void __init files_maxfiles_init(void);
 extern struct files_stat_struct files_stat;
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
-extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
@@ -3674,8 +3673,6 @@ int proc_nr_files(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_dentry(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
-int proc_nr_inodes(struct ctl_table *table, int write,
-		   void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 05853e7681512..a491d145acc31 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -3116,20 +3116,6 @@ static struct ctl_table vm_table[] = {
 };
 
 static struct ctl_table fs_table[] = {
-	{
-		.procname	= "inode-nr",
-		.data		= &inodes_stat,
-		.maxlen		= 2*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_inodes,
-	},
-	{
-		.procname	= "inode-state",
-		.data		= &inodes_stat,
-		.maxlen		= 7*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_inodes,
-	},
 	{
 		.procname	= "file-nr",
 		.data		= &files_stat,
-- 
2.39.5



