Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB0737C925;
	Thu, 20 Aug 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239134; cv=none; b=dAYb1aPnme7nJWZYu/qx26gnB1lgGlzQa5Eump2IVI1wwCTImKXizwE86R782n6RDcbnraF2Hick8tSCK4MhR6uuOvUA9uTBRU+Oj7n7s3mT18wNnIDlmme/EUiGSWCyw5lKdrr7ftJDFBF1rq9/gJrvQsDvSIL4wAC3M4Ab20w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239134; c=relaxed/simple;
	bh=Zw1e54TAM/kPRCAbwm8FRbP57RIBoHM00tVSb0jn8Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLR+iA6wCWY/35RLK18SbSmYyifYGg8ad2hpWlJ7p4HXGXCWeDTkn3Qi2uqwkJfNUYttjVLWASqvlmxjSY5a7qcBdW6BeBNmU4TPP108mrMg7R7A6cdtgxnX943lYVWZbmWdLuEklXXa5Zi3vxsjApwAGHIArhKup0cYXSWR3P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBDJa5n/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBDJa5n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165BD1F00A3A;
	Thu, 20 Aug 2026 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239132;
	bh=fAapafRGQGSybXlC5z7kANF4ovDyotNI+18ircqGQz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBDJa5n/wLdrbcAoZqxhpVNitJ/nTTsUiMXZY7aAa7g7WU5ZbNrSQa83fAvgLVmcP
	 I9pDlETzi8eQathy7s3WMk4XgqPUwwhNjsoKyJjdSKBAg7ulBakgSikDrqAtHA0Hjy
	 3doz8viIggWt+FkhnxlXlFs/EPSlhMSvFBX62AzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/217] sched_ext: Take cgroup_lock() first in scx_cgroup_lock()
Date: Thu, 20 Aug 2026 16:55:27 +0200
Message-ID: <20260820145242.539775479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 5f8b69642d18e1f3e11996707842ac530444e959 ]

scx_cgroup_lock() write-locks scx_cgroup_ops_rwsem and then takes
cgroup_lock(), which can deadlock through kernfs:

  scx enable/disable         cgroup rmdir           cpu.weight write
  ------------------         ------------           ----------------
                             cgroup_lock()
  percpu_down_write(rwsem)
  cgroup_lock()
                                                    kernfs_get_active()
                                                    percpu_down_read(rwsem)
                             kernfs_drain()

The enable path waits for the rmdir to release cgroup_mutex. The rmdir,
deactivating the cpu controller's files, waits in kernfs_drain() for the
write's active reference. The write, in scx_group_set_weight(), waits for
the rwsem behind the pending writer.

Take cgroup_lock() first. The set_* paths take no cgroup locks inside the
read side, so a pending write-lock then only waits for read sections that
always run to completion, and no dependency from the rwsem back to
cgroup_mutex remains.

Fixes: a5bd6ba30b33 ("sched_ext: Use cgroup_lock/unlock() to synchronize against cgroup operations")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ dropped the `#ifdef CONFIG_EXT_GROUP_SCHED` guards since the code already sits inside one, and applied to kernel/sched/ext.c instead of kernel/sched/ext/ext.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3313,16 +3313,21 @@ void scx_group_set_bandwidth(struct task
 	percpu_up_read(&scx_cgroup_ops_rwsem);
 }
 
+/*
+ * cgroup_lock() must nest outside the rwsem write side: a writer waiting
+ * for cgroup_mutex deadlocks with cgroup teardown, which holds it while
+ * draining a set_* file write blocked on the rwsem behind the writer.
+ */
 static void scx_cgroup_lock(void)
 {
-	percpu_down_write(&scx_cgroup_ops_rwsem);
 	cgroup_lock();
+	percpu_down_write(&scx_cgroup_ops_rwsem);
 }
 
 static void scx_cgroup_unlock(void)
 {
-	cgroup_unlock();
 	percpu_up_write(&scx_cgroup_ops_rwsem);
+	cgroup_unlock();
 }
 
 #else	/* CONFIG_EXT_GROUP_SCHED */


