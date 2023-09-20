Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1B330FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92377C433C8;
	Wed, 20 Sep 2023 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212630;
	bh=8I8OuPa7O3iNxnD1Df7FXVonTVOkg3NUs+Cj2j3R9+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkUM9rfRtGpsLU8ztpv/E0vDIVpr4w9sntHJtsHCj0HAr8cEwvJ/k4duMLJCH+sQW
	 2yPH35PuygyQOvPggsXRV6wffrezAvBMozfWxgdtOPNZPBiI4rMOn+W1aal0UVm2cd
	 IrpfhjgmoxPl72vqiWfIGyAeeF+gQPG2mZALBrLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Brian Foster <bfoster@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baoquan He <bhe@redhat.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 5.10 72/83] proc: fix a dentry lock race between release_task and lookup
Date: Wed, 20 Sep 2023 13:32:02 +0200
Message-ID: <20230920112829.502498246@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit d919a1e79bac890421537cf02ae773007bf55e6b upstream.

Commit 7bc3e6e55acf06 ("proc: Use a list of inodes to flush from proc")
moved proc_flush_task() behind __exit_signal().  Then, process systemd can
take long period high cpu usage during releasing task in following
concurrent processes:

  systemd                                 ps
kernel_waitid                 stat(/proc/tgid)
  do_wait                       filename_lookup
    wait_consider_task            lookup_fast
      release_task
        __exit_signal
          __unhash_process
            detach_pid
              __change_pid // remove task->pid_links
                                     d_revalidate -> pid_revalidate  // 0
                                     d_invalidate(/proc/tgid)
                                       shrink_dcache_parent(/proc/tgid)
                                         d_walk(/proc/tgid)
                                           spin_lock_nested(/proc/tgid/fd)
                                           // iterating opened fd
        proc_flush_pid                                    |
           d_invalidate (/proc/tgid/fd)                   |
              shrink_dcache_parent(/proc/tgid/fd)         |
                shrink_dentry_list(subdirs)               ↓
                  shrink_lock_dentry(/proc/tgid/fd) --> race on dentry lock

Function d_invalidate() will remove dentry from hash firstly, but why does
proc_flush_pid() process dentry '/proc/tgid/fd' before dentry
'/proc/tgid'?  That's because proc_pid_make_inode() adds proc inode in
reverse order by invoking hlist_add_head_rcu().  But proc should not add
any inodes under '/proc/tgid' except '/proc/tgid/task/pid', fix it by
adding inode into 'pid->inodes' only if the inode is /proc/tgid or
/proc/tgid/task/pid.

Performance regression:
Create 200 tasks, each task open one file for 50,000 times. Kill all
tasks when opened files exceed 10,000,000 (cat /proc/sys/fs/file-nr).

Before fix:
$ time killall -wq aa
  real    4m40.946s   # During this period, we can see 'ps' and 'systemd'
			taking high cpu usage.

After fix:
$ time killall -wq aa
  real    1m20.732s   # During this period, we can see 'systemd' taking
			high cpu usage.

Link: https://lkml.kernel.org/r/20220713130029.4133533-1-chengzhihao1@huawei.com
Fixes: 7bc3e6e55acf06 ("proc: Use a list of inodes to flush from proc")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216054
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Suggested-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Context adjustments ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1881,7 +1881,7 @@ void proc_pid_evict_inode(struct proc_in
 	put_pid(pid);
 }
 
-struct inode *proc_pid_make_inode(struct super_block * sb,
+struct inode *proc_pid_make_inode(struct super_block *sb,
 				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
@@ -1910,11 +1910,6 @@ struct inode *proc_pid_make_inode(struct
 
 	/* Let the pid remember us for quick removal */
 	ei->pid = pid;
-	if (S_ISDIR(mode)) {
-		spin_lock(&pid->lock);
-		hlist_add_head_rcu(&ei->sibling_inodes, &pid->inodes);
-		spin_unlock(&pid->lock);
-	}
 
 	task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
 	security_task_to_inode(task, inode);
@@ -1927,6 +1922,39 @@ out_unlock:
 	return NULL;
 }
 
+/*
+ * Generating an inode and adding it into @pid->inodes, so that task will
+ * invalidate inode's dentry before being released.
+ *
+ * This helper is used for creating dir-type entries under '/proc' and
+ * '/proc/<tgid>/task'. Other entries(eg. fd, stat) under '/proc/<tgid>'
+ * can be released by invalidating '/proc/<tgid>' dentry.
+ * In theory, dentries under '/proc/<tgid>/task' can also be released by
+ * invalidating '/proc/<tgid>' dentry, we reserve it to handle single
+ * thread exiting situation: Any one of threads should invalidate its
+ * '/proc/<tgid>/task/<pid>' dentry before released.
+ */
+static struct inode *proc_pid_make_base_inode(struct super_block *sb,
+				struct task_struct *task, umode_t mode)
+{
+	struct inode *inode;
+	struct proc_inode *ei;
+	struct pid *pid;
+
+	inode = proc_pid_make_inode(sb, task, mode);
+	if (!inode)
+		return NULL;
+
+	/* Let proc_flush_pid find this directory inode */
+	ei = PROC_I(inode);
+	pid = ei->pid;
+	spin_lock(&pid->lock);
+	hlist_add_head_rcu(&ei->sibling_inodes, &pid->inodes);
+	spin_unlock(&pid->lock);
+
+	return inode;
+}
+
 int pid_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int query_flags)
 {
@@ -3341,7 +3369,8 @@ static struct dentry *proc_pid_instantia
 {
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
+	inode = proc_pid_make_base_inode(dentry->d_sb, task,
+					 S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
@@ -3637,7 +3666,8 @@ static struct dentry *proc_task_instanti
 	struct task_struct *task, const void *ptr)
 {
 	struct inode *inode;
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
+	inode = proc_pid_make_base_inode(dentry->d_sb, task,
+					 S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 


