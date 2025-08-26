Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097D02798ED;
	Tue, 26 Aug 2025 11:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208809; cv=none; b=XyAhvnsYuwZ7aNn+8Ubiu15mMzCSyQFsv+mNeUy0GSzB/f6xEs8PA2nUiteFuci17E6cq5iCediPRRdF0VCZFcsdtvclw1q72MSglPGNJ2Jv8R4DTtEUezBEDMwJ5mpRGwv6790a0i6b1oX6siZFD5KIXBZ6y23OK9tnQ+l4FII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208809; c=relaxed/simple;
	bh=kJO6/D9A+KNizT0lZugbC0KonxmFSo3+Pm76nvABGrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmUSfWKwuRKVQrUefILLWxxj5eQh3M8vwhsD6GW/fOsrQzgOt1VFG1+ZitqRJxTNh8IPyq6vukL1AIUnBWnTSPzyT9PBc//D9YK6pu2zS+Am0IQy4TgK/HBGewVPa+ORhu7MH3vvn+tMp5/Mi7bqkUEWL1A4SwAfa2MhROEdQnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMNeVJXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMNeVJXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE52C4CEF1;
	Tue, 26 Aug 2025 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208808;
	bh=kJO6/D9A+KNizT0lZugbC0KonxmFSo3+Pm76nvABGrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMNeVJXFHyabg6xBdPv9KWnWn0hPzGa7awBklV4lEnaunrEAGpPXkI9+66YzDp+/M
	 4lJb1xYlig5IkhVlfR5q6qJk0dG/UzjldbbqjhVyqv+SxryCO69avsW4ZjFXGSBb0O
	 AEQrD+0g97uhRmvhssvNHN+0fu36MiEy/eZcHLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/322] cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key
Date: Tue, 26 Aug 2025 13:11:09 +0200
Message-ID: <20250826110922.208172216@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d1fb4bfbbd4c..af5dc30bfe4b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -267,7 +267,7 @@ static inline void check_insane_mems_config(nodemask_t *nodes)
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



