Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4559A5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DBBC433C0;
	Mon, 19 Jun 2023 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171423;
	bh=i+OmtVDysKCCcOCHXpE+vwMi+kJJQtG8x9OWsvL05/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Suz6sgBNJD/x41xs9bpBy+OCnr2MG7EEZJ0XUjpsmtu9+/A4bRrJ8hVHhXfqIhJW
	 3GkY8X+iE5i5cbEJSNtYNSu7baO6nMqQ6jSvXkEiVCNDtAWeFw8snDI1Mh+VGLsChe
	 i7axr5xxfPH7Mn3F2kDW1LMdZAjKo0CtsJh9iAN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/166] cgroup: fix missing cpus_read_{lock,unlock}() in cgroup_transfer_tasks()
Date: Mon, 19 Jun 2023 12:28:03 +0200
Message-ID: <20230619102154.951726719@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit ab1de7ead871ebe6d12a774c3c25de0388cde082 ]

The commit 4f7e7236435c ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock()
deadlock") fixed the deadlock between cgroup_threadgroup_rwsem and
cpus_read_lock() by introducing cgroup_attach_{lock,unlock}() and removing
cpus_read_{lock,unlock}() from cpuset_attach(). But cgroup_transfer_tasks()
was missed and not handled, which will cause th following warning:

 WARNING: CPU: 0 PID: 589 at kernel/cpu.c:526 lockdep_assert_cpus_held+0x32/0x40
 CPU: 0 PID: 589 Comm: kworker/1:4 Not tainted 6.4.0-rc2-next-20230517 #50
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Workqueue: events cpuset_hotplug_workfn
 RIP: 0010:lockdep_assert_cpus_held+0x32/0x40
 <...>
 Call Trace:
  <TASK>
  cpuset_attach+0x40/0x240
  cgroup_migrate_execute+0x452/0x5e0
  ? _raw_spin_unlock_irq+0x28/0x40
  cgroup_transfer_tasks+0x1f3/0x360
  ? find_held_lock+0x32/0x90
  ? cpuset_hotplug_workfn+0xc81/0xed0
  cpuset_hotplug_workfn+0xcb1/0xed0
  ? process_one_work+0x248/0x5b0
  process_one_work+0x2b9/0x5b0
  worker_thread+0x56/0x3b0
  ? process_one_work+0x5b0/0x5b0
  kthread+0xf1/0x120
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

So just use the cgroup_attach_{lock,unlock}() helper to fix it.

Reported-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Fixes: 05c7b7a92cc8 ("cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index aeef06c465ef1..5407241dbb45f 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -108,7 +108,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 
 	cgroup_lock();
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock(true);
 
 	/* all tasks in @from are being moved, all csets are source */
 	spin_lock_irq(&css_set_lock);
@@ -144,7 +144,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	} while (task && !ret);
 out_err:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(true);
 	cgroup_unlock();
 	return ret;
 }
-- 
2.39.2



