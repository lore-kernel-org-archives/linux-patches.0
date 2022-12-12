Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B575728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7472C433EF;
	Mon, 12 Dec 2022 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853126;
	bh=dvfeBtwxbK3P92ofpdcC0XE1p8Nvf2CYCqEjb90y0+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkSZ5tzAOr3k8Y/KnUVtc4sBFMydMG/uQKi6dkzyXZeGrSABwUzPgYuw1lap+zyxj
	 xJVFcZx8rqfO/FaQQ89QfnAYAcprIu88JJafzSVjl9+NgzuxFKh5VxRlQWP6mFzeck
	 b1i7ViZZegpt13lAQyrYafiKULUsm0b7Elcu5HlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jann Horn <jannh@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Shakeel Butt <shakeelb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 15/38] memcg: fix possible use-after-free in memcg_write_event_control()
Date: Mon, 12 Dec 2022 14:19:16 +0100
Message-Id: <20221212130912.879969541@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejun Heo <tj@kernel.org>

commit 4a7ba45b1a435e7097ca0f79a847d0949d0eb088 upstream.

memcg_write_event_control() accesses the dentry->d_name of the specified
control fd to route the write call.  As a cgroup interface file can't be
renamed, it's safe to access d_name as long as the specified file is a
regular cgroup file.  Also, as these cgroup interface files can't be
removed before the directory, it's safe to access the parent too.

Prior to 347c4a874710 ("memcg: remove cgroup_event->cft"), there was a
call to __file_cft() which verified that the specified file is a regular
cgroupfs file before further accesses.  The cftype pointer returned from
__file_cft() was no longer necessary and the commit inadvertently dropped
the file type check with it allowing any file to slip through.  With the
invarients broken, the d_name and parent accesses can now race against
renames and removals of arbitrary files and cause use-after-free's.

Fix the bug by resurrecting the file type check in __file_cft().  Now that
cgroupfs is implemented through kernfs, checking the file operations needs
to go through a layer of indirection.  Instead, let's check the superblock
and dentry type.

Link: https://lkml.kernel.org/r/Y5FRm/cfcKPGzWwl@slm.duckdns.org
Fixes: 347c4a874710 ("memcg: remove cgroup_event->cft")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>	[3.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup.h          |    1 +
 kernel/cgroup/cgroup-internal.h |    1 -
 mm/memcontrol.c                 |   15 +++++++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -122,7 +122,6 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3878,6 +3878,7 @@ static ssize_t memcg_write_event_control
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -3929,6 +3930,16 @@ static ssize_t memcg_write_event_control
 		goto out_put_cfile;
 
 	/*
+	 * The control file must be a regular cgroup1 file. As a regular cgroup
+	 * file can't be renamed, it's safe to access its name afterwards.
+	 */
+	cdentry = cfile.file->f_path.dentry;
+	if (cdentry->d_sb->s_type != &cgroup_fs_type || !d_is_reg(cdentry)) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
+	/*
 	 * Determine the event callbacks and set them in @event.  This used
 	 * to be done via struct cftype but cgroup core no longer knows
 	 * about these events.  The following is crude but the whole thing
@@ -3936,7 +3947,7 @@ static ssize_t memcg_write_event_control
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -3960,7 +3971,7 @@ static ssize_t memcg_write_event_control
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))


