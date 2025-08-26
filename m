Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF0350D5D;
	Tue, 26 Aug 2025 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217000; cv=none; b=BiAVED3IRLLsM+2AdOCL8vqNQ7zJJm9vbirVvqrd8IUVdMtYnTmfIPHbn7ZZIigcnUZcn9I6+A+9ZlLnIXHSHH5WhAxJKieRZgSbNPRcPd7TixIsbYISiSlYZqhTLNMoyPrG7l584S2hwB1M+OBvoNkaWnzH6x5JrRB2KEtiqrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217000; c=relaxed/simple;
	bh=tUh0H3/5w1+JSNUlL4MS3Xuep+vgn2srVcRXBDcygvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFhQxpnwVevCLGKLR4+iL/+QgAGGmAWCQ7KkGAZ2siw6PGenrSMboLevDQ2gvTR47k+95V0mwxt+9rFBxnsUQiSH8RTIbJl2TvK5QIPMsMnnvfUxBksW2L2hGy8OLT/qdZsnOPPxZsRGfXoYY+zeVNDLWpxO/GMat9Dm2mXqWTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng/R4Vep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng/R4Vep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2B1C4CEF1;
	Tue, 26 Aug 2025 14:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217000;
	bh=tUh0H3/5w1+JSNUlL4MS3Xuep+vgn2srVcRXBDcygvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ng/R4VepVZMWS+JtZ0S2tq4AK1INhZRGFoR9ProJDH69spXnFshgGB+QIh3XG8RSM
	 dgWUAqRqHdg3unaosuhByJRMrc/UqzkDZHkJUX1cxt+OT+96rmjRAg6dVFk5k4cumL
	 pH3vIB+n04ILS958tg8f7V9ayWI8g8k41w5U3PXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 621/644] cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key
Date: Tue, 26 Aug 2025 13:11:52 +0200
Message-ID: <20250826111001.945123474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index b40f86a3f605..78c499021768 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -408,7 +408,7 @@ static inline void check_insane_mems_config(nodemask_t *nodes)
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



