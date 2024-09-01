Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFC1E498;
	Sun,  1 Sep 2024 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209040; cv=none; b=hn9lB9oNKI7Punfg0haSSH0OlUKjf+KU2JdW1uV+xHDKy7yTLcRDItu5uAu3dfS4vOfJNCyw8vfJCo320yNzFXGPiCB6PJL9QSuJBhg1X5Ocr6ssb7CgetUCHYjeI585qqocXrfvF/A21HuCen3Br58B/CQdzW3zQapgC1n2/28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209040; c=relaxed/simple;
	bh=hWZhw7xim75OQFEWhP5Yw1ZanlSVZ5eQ/GMRCZ4sG8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOShHx1ZS5VLOuD5pYCoK3tlUYYmlOAWkdV4VxEW1i/QSOsPLopfew/O7qSzP+iLk2GtC2SZmUc1Pv4JINfesWekrAeb6qpme3h15q7poPmGDe7jxjezl0Xg6vXCuc1LiQMitS70wMbGHmPX1lf4l9rvGg+LqNszRVIfAplcKiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9EFpwEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9EFpwEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAC3C4CEC3;
	Sun,  1 Sep 2024 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209040;
	bh=hWZhw7xim75OQFEWhP5Yw1ZanlSVZ5eQ/GMRCZ4sG8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9EFpwEsTfRYcLwe0CCScZ5KUqyFKV/CumwbGPxippM2xrK1cL5M+cYvUmKSMMtUW
	 zUoik1NUlNrvPYeaWqqj97pvxgGGpwzkKsv4B1CnnK6wXApbSlhg/MxvMrKBDhVQpf
	 fqjcIZrYGpjuYr7ryCdDn9f1SpXzmBG21VyvLx7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.4 115/134] cgroup/cpuset: Prevent UAF in proc_cpuset_show()
Date: Sun,  1 Sep 2024 18:17:41 +0200
Message-ID: <20240901160814.410983102@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

commit 1be59c97c83ccd67a519d8a49486b3a8a73ca28a upstream.

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
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -22,6 +22,7 @@
  *  distribution for more details.
  */
 
+#include "cgroup-internal.h"
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/cpuset.h>
@@ -3644,10 +3645,14 @@ int proc_cpuset_show(struct seq_file *m,
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
 	if (retval >= PATH_MAX)
 		retval = -ENAMETOOLONG;
 	if (retval < 0)


