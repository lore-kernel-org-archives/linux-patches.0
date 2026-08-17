Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9223E0C76;
	Mon, 17 Aug 2026 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974603; cv=none; b=ly0vdXnAD3DbM43PmxBO6khXKlu/kY7RgdZSUKTa6UzTV3ISTDX7jeDP8ZQygGVgWbmrrwIoDuvNmqKfbkriQQgBxElzSehCvkSH2A0FXUy/bVBOw2EfwLmcI+MHZId9o3gdz/mShL+8Vb7yh4DxxCfq/BGKSX9Udzv/hr9sZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974603; c=relaxed/simple;
	bh=wygAWLnw80k61MuDXL3W0Sq2xjLmU1OdNv70KaMSgR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjr4jRd0Cd3wo4O0L0MHAJ3M5VXuzhkzDu0DT7x9VjTJCPQrGKryKyayMLa2tVJDjbx3fb4z3NBTYjXeyssVvKv5elBNk1/oVon5YIN5upB+HLTlSVV9PWT4GEmbmFn25+RGl9UyiVuzXsKsq0YseER4Cp10pt++XFsRjrYS32s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWStZfrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWStZfrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B931F00A3F;
	Mon, 17 Aug 2026 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974594;
	bh=XlnKN+t2/Rh9z6cTNOOAPcLn/L1DrkrvedBnYyXmSgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWStZfrjtnUwnkEgpiwCSKlbL9k9ybi+9NLkc59aFhjsLTZAht4hTPM8+pFPPoolB
	 /knvRa8jl+wu40UbPy8/XxuVz8Lk61OEtS+YqrzOVbLkj0lNd0AKeUgdHRa7f+fkGO
	 0yL2MXLUk+S7Hg48dpXZXJWLKJKEqDPihxW4ugJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.1 260/271] sched_ext: Take cgroup_lock() first in scx_cgroup_lock()
Date: Mon, 17 Aug 2026 15:33:05 +0200
Message-ID: <20260817132547.425654772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 5f8b69642d18e1f3e11996707842ac530444e959 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4515,20 +4515,25 @@ static struct cgroup *root_cgroup(void)
 	return &cgrp_dfl_root.cgrp;
 }
 
+/*
+ * cgroup_lock() must nest outside the rwsem write side: a writer waiting
+ * for cgroup_mutex deadlocks with cgroup teardown, which holds it while
+ * draining a set_* file write blocked on the rwsem behind the writer.
+ */
 static void scx_cgroup_lock(void)
 {
+	cgroup_lock();
 #ifdef CONFIG_EXT_GROUP_SCHED
 	percpu_down_write(&scx_cgroup_ops_rwsem);
 #endif
-	cgroup_lock();
 }
 
 static void scx_cgroup_unlock(void)
 {
-	cgroup_unlock();
 #ifdef CONFIG_EXT_GROUP_SCHED
 	percpu_up_write(&scx_cgroup_ops_rwsem);
 #endif
+	cgroup_unlock();
 }
 #else	/* CONFIG_EXT_GROUP_SCHED || CONFIG_EXT_SUB_SCHED */
 static struct cgroup *root_cgroup(void) { return NULL; }


