Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A53B29A2;
	Tue, 30 Jul 2024 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354982; cv=none; b=e3OO1EdsZATdCwGSrziPu2ePhxflkasz3G56RYfkojpSgz4MT0wwnfkT4nmuLk6PSi0cLWDFYTAdbzh44+Y6wjP+3WJHEccKBLxBBHQz1rXww4mtsUAsvrabUl5aTqbFtly2WbUrSPgqM3CFQ7fd0TG9AMBesbLTwNqXB7zM4j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354982; c=relaxed/simple;
	bh=bYwErlcJuz8+fq8HFCooqWCjNzrD/cVPDrCtVJtwpWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnVLYcLugeO6fd9BMsO/8DNCZLNfyw3ybGVwFHaJSEk5eT/6x1VxhtqRsBXiEwBFfry+t39nSjH0QfR2OhrErC3XDE55OS/X68LOld+lK8T2mCnO9oPv8qttkr3CWRfqo/ALhO7TqScl8CLDm7bfpgv49tJqfrqY7+XmVcrN7JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEOrVKH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEOrVKH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3E1C32782;
	Tue, 30 Jul 2024 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354982;
	bh=bYwErlcJuz8+fq8HFCooqWCjNzrD/cVPDrCtVJtwpWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEOrVKH82BRGLNevuFzq/dkDRXt3L/+k3oZgaXEbS56XMIlOWEjTY0LyaZW98HC/4
	 jkqqyMw+3kyBHrO75skV7XBsCsL9CzunpifBNcCJNla8b7Jf7RIPQd0fuSSoObIKqQ
	 TWqSEC5LjbqmGUwjPK/W6MZsBlLJ07lU+/QzzFWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/568] cgroup/cpuset: Prevent UAF in proc_cpuset_show()
Date: Tue, 30 Jul 2024 17:42:04 +0200
Message-ID: <20240730151640.503086745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 1be59c97c83ccd67a519d8a49486b3a8a73ca28a ]

An UAF can happen when /proc/cpuset is read as reported in [1].

This can be reproduced by the following methods:
1.add an mdelay(1000) before acquiring the cgroup_lock In the
 cgroup_path_ns function.
2.$cat /proc/<pid>/cpuset   repeatly.
3.$mount -t cgroup -o cpuset cpuset /sys/fs/cgroup/cpuset/
$umount /sys/fs/cgroup/cpuset/   repeatly.

The race that cause this bug can be shown as below:

(umount)		|	(cat /proc/<pid>/cpuset)
css_release		|	proc_cpuset_show
css_release_work_fn	|	css = task_get_css(tsk, cpuset_cgrp_id);
css_free_rwork_fn	|	cgroup_path_ns(css->cgroup, ...);
cgroup_destroy_root	|	mutex_lock(&cgroup_mutex);
rebind_subsystems	|
cgroup_free_root 	|
			|	// cgrp was freed, UAF
			|	cgroup_path_ns_locked(cgrp,..);

When the cpuset is initialized, the root node top_cpuset.css.cgrp
will point to &cgrp_dfl_root.cgrp. In cgroup v1, the mount operation will
allocate cgroup_root, and top_cpuset.css.cgrp will point to the allocated
&cgroup_root.cgrp. When the umount operation is executed,
top_cpuset.css.cgrp will be rebound to &cgrp_dfl_root.cgrp.

The problem is that when rebinding to cgrp_dfl_root, there are cases
where the cgroup_root allocated by setting up the root for cgroup v1
is cached. This could lead to a Use-After-Free (UAF) if it is
subsequently freed. The descendant cgroups of cgroup v1 can only be
freed after the css is released. However, the css of the root will never
be released, yet the cgroup_root should be freed when it is unmounted.
This means that obtaining a reference to the css of the root does
not guarantee that css.cgrp->root will not be freed.

Fix this problem by using rcu_read_lock in proc_cpuset_show().
As cgroup_root is kfree_rcu after commit d23b5c577715
("cgroup: Make operations on the cgroup root_list RCU safe"),
css->cgroup won't be freed during the critical section.
To call cgroup_path_ns_locked, css_set_lock is needed, so it is safe to
replace task_get_css with task_css.

[1] https://syzkaller.appspot.com/bug?extid=9b1ff7be974a403aa4cd

Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f2025fa5a168d..3646426c69e25 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -21,6 +21,7 @@
  *  License.  See the file COPYING in the main directory of the Linux
  *  distribution for more details.
  */
+#include "cgroup-internal.h"
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
@@ -4293,10 +4294,14 @@ int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
 	if (!buf)
 		goto out;
 
-	css = task_get_css(tsk, cpuset_cgrp_id);
-	retval = cgroup_path_ns(css->cgroup, buf, PATH_MAX,
-				current->nsproxy->cgroup_ns);
-	css_put(css);
+	rcu_read_lock();
+	spin_lock_irq(&css_set_lock);
+	css = task_css(tsk, cpuset_cgrp_id);
+	retval = cgroup_path_ns_locked(css->cgroup, buf, PATH_MAX,
+				       current->nsproxy->cgroup_ns);
+	spin_unlock_irq(&css_set_lock);
+	rcu_read_unlock();
+
 	if (retval == -E2BIG)
 		retval = -ENAMETOOLONG;
 	if (retval < 0)
-- 
2.43.0



