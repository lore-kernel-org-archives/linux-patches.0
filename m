Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35E8635D;
	Tue, 26 Aug 2025 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218452; cv=none; b=GFkE4R4g317OI8LH5L7AM1nYHxSRU0SwlAeWu387nPyCDrGpteFgV8ko2TjXvyCsMAxyx2qAZeb6iAJKzMguvWw3YT9/vcGxrqsn7MBLL+EbO9wsyliwS8MF3pWOe2zcVUeP/wF6bwmDgxwvUPrlBTKbZJE8KP+g0uqObsmPRWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218452; c=relaxed/simple;
	bh=x9210eMReYuf5fvIIuZa5imYnjVMliVNQJdFdDaJe2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhBA7MfLU19RlZDJONhZRw3pbXrOkzEdzj1/486Xe0+GuPFLxd5h7EVdN6jkDvZ/WjK6Zie4x4TNjJp1lM8WL/yoFu8os+TZoEgZZpdRHG9Ej2jI7sEofGmb1sSyWzgG9p8YiJgoVF8OpaR0zciZwFXMgj1vQkVrRzkdrbkSn0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxgmJ4/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxgmJ4/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B454C4CEF1;
	Tue, 26 Aug 2025 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218452;
	bh=x9210eMReYuf5fvIIuZa5imYnjVMliVNQJdFdDaJe2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxgmJ4/OhhnDLjVJOyVtQioVyKTPGCRuZknMw1m2AQ/PAe6oXzWoDQUgUlhEMZ1E5
	 bNFZCnJ9cOCnSJypBS6KufXJRup2kc38X1U7qazJDLaYlxF2p8QYmHNPQxdQO5MHgS
	 9CB0ZfPQjIs8jA1Ud1pxO5SEQYcIcmHnLNoQi+zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 508/523] cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key
Date: Tue, 26 Aug 2025 13:11:58 +0200
Message-ID: <20250826110936.972198686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 65f97cc81b0adc5f49cf6cff5d874be0058e3f41 ]

The following lockdep splat was observed.

[  812.359086] ============================================
[  812.359089] WARNING: possible recursive locking detected
[  812.359097] --------------------------------------------
[  812.359100] runtest.sh/30042 is trying to acquire lock:
[  812.359105] ffffffffa7f27420 (cpu_hotplug_lock){++++}-{0:0}, at: static_key_enable+0xe/0x20
[  812.359131]
[  812.359131] but task is already holding lock:
[  812.359134] ffffffffa7f27420 (cpu_hotplug_lock){++++}-{0:0}, at: cpuset_write_resmask+0x98/0xa70
     :
[  812.359267] Call Trace:
[  812.359272]  <TASK>
[  812.359367]  cpus_read_lock+0x3c/0xe0
[  812.359382]  static_key_enable+0xe/0x20
[  812.359389]  check_insane_mems_config.part.0+0x11/0x30
[  812.359398]  cpuset_write_resmask+0x9f2/0xa70
[  812.359411]  cgroup_file_write+0x1c7/0x660
[  812.359467]  kernfs_fop_write_iter+0x358/0x530
[  812.359479]  vfs_write+0xabe/0x1250
[  812.359529]  ksys_write+0xf9/0x1d0
[  812.359558]  do_syscall_64+0x5f/0xe0

Since commit d74b27d63a8b ("cgroup/cpuset: Change cpuset_rwsem
and hotplug lock order"), the ordering of cpu hotplug lock
and cpuset_mutex had been reversed. That patch correctly
used the cpuslocked version of the static branch API to enable
cpusets_pre_enable_key and cpusets_enabled_key, but it didn't do the
same for cpusets_insane_config_key.

The cpusets_insane_config_key can be enabled in the
check_insane_mems_config() which is called from update_nodemask()
or cpuset_hotplug_update_tasks() with both cpu hotplug lock and
cpuset_mutex held. Deadlock can happen with a pending hotplug event that
tries to acquire the cpu hotplug write lock which will block further
cpus_read_lock() attempt from check_insane_mems_config(). Fix that by
switching to use static_branch_enable_cpuslocked().

Fixes: d74b27d63a8b ("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 52274eda8423..efe9785c6c13 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -392,7 +392,7 @@ static inline void check_insane_mems_config(nodemask_t *nodes)
 {
 	if (!cpusets_insane_config() &&
 		movable_only_nodes(nodes)) {
-		static_branch_enable(&cpusets_insane_config_key);
+		static_branch_enable_cpuslocked(&cpusets_insane_config_key);
 		pr_info("Unsupported (movable nodes only) cpuset configuration detected (nmask=%*pbl)!\n"
 			"Cpuset allocations might fail even with a lot of memory available.\n",
 			nodemask_pr_args(nodes));
-- 
2.50.1



