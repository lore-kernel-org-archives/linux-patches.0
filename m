Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF371BA878;
	Tue, 30 Jul 2024 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355143; cv=none; b=iaewDy6fBEegaILC254b0KwaMkNE3GzKDmSltl9Fk04u+w9ekGvGf/hgZICyoSh8gBUY+EdtU7Y+969YX4SFkayjE5WEkyAuONFPDGXDm+80nxswQgmOFbgLEs+8J2farf/UNhtN5cyotTbGxItJwsUwO57vMGVnjWrB155R6L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355143; c=relaxed/simple;
	bh=j0R3EfOA01NbwqBm3+UIKl2nQhULziUUpRNNuX3oQjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unj6/UeMMd56f1QDS/wy3WOKOoPUfq1QcuBCQ1G9vVVUI6E3yFS14mDG1BkY5MmfUfbW+iUgYbKDIYywZ994dNymDZiG8OeBemZQewPEgENJ705f/+wlB7vdS9U3RG4oTIX5V6e/kDy5WMhoxiSXpIzlFSWmdQB46vacmLM12DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tJkT5dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tJkT5dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57F6C32782;
	Tue, 30 Jul 2024 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355143;
	bh=j0R3EfOA01NbwqBm3+UIKl2nQhULziUUpRNNuX3oQjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tJkT5dck2jfOwcQnCMCHU10dgCTWZymIIs/5QxzSAWC/DuSpBZvwRO/Q1aWTJ96m
	 oE+VT8kZkxy3AHaKNm8eJpDzWxtfOp5NrwPEqzOJG6pxcygn3bm7TYWKmkYCVCQEuT
	 WkAQD2QwwP6aIl0YxpT8kUKxFNoRFPrlAaG9LRG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 023/809] cgroup/cpuset: Prevent UAF in proc_cpuset_show()
Date: Tue, 30 Jul 2024 17:38:19 +0200
Message-ID: <20240730151725.574096502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a29de57540d71..5e468db958104 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -21,6 +21,7 @@
  *  License.  See the file COPYING in the main directory of the Linux
  *  distribution for more details.
  */
+#include "cgroup-internal.h"
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
@@ -5088,10 +5089,14 @@ int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
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



