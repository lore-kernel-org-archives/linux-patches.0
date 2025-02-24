Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1D21474A9;
	Mon, 24 Feb 2025 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408212; cv=none; b=D4IW9uj7DkB5gDLtA9z3k5e1+6Ff3RpoKgAOnXA81vZjWwYHPkwwFN8Xt9SGVZFadoYKXIJ6XmheYwZJ0RpVUtoTyi0VCZfDab3F2FhE0hsdDQ0+ZOSeM1ovOjR22vOaXbEBHEm0+UQNk04stG4fc1ml5Teia/1eeK58KArB4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408212; c=relaxed/simple;
	bh=HLkXzvmfHy9tExlimtWv2JEzkqXiawnv4/30NOh/3E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noYAOwcxV0ts02crMfPludHupLfEpX0XUHcn08VUwHQOKie+5DrFj3R6hC1MOR4smFKY/w9JCjYk+wt6KvYYw4mIgOICbPkQjob02Ih3wTAcPRNR5tNpYYQ8OIBtwZ3FxyFZD+RNxkRoP1M7st1bJ17zMr4ms4ky/blL38F9iSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A45xAA3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A45xAA3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAA6C4CED6;
	Mon, 24 Feb 2025 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408212;
	bh=HLkXzvmfHy9tExlimtWv2JEzkqXiawnv4/30NOh/3E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A45xAA3g9b/Pebg2j+XoeEYIqSc3xFxJhaficqyftwFZ6zjy4RFOaIbBRghUV9DwG
	 x50D0+5Xut7ZD2LCFrWUMh01q1lNSvSwL/9SaghdpVCtDXTBlWsEmrXD3Ujyaz0BoP
	 KTSgv6b9HsOdq/vGD2J2MxRJJ1qTKbqKFYGHaXu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/140] bpf: Fix deadlock when freeing cgroup storage
Date: Mon, 24 Feb 2025 15:34:59 +0100
Message-ID: <20250224142606.946194461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Wu <wuyun.abel@bytedance.com>

[ Upstream commit c78f4afbd962f43a3989f45f3ca04300252b19b5 ]

The following commit
bc235cdb423a ("bpf: Prevent deadlock from recursive bpf_task_storage_[get|delete]")
first introduced deadlock prevention for fentry/fexit programs attaching
on bpf_task_storage helpers. That commit also employed the logic in map
free path in its v6 version.

Later bpf_cgrp_storage was first introduced in
c4bcfb38a95e ("bpf: Implement cgroup storage available to non-cgroup-attached bpf progs")
which faces the same issue as bpf_task_storage, instead of its busy
counter, NULL was passed to bpf_local_storage_map_free() which opened
a window to cause deadlock:

	<TASK>
		(acquiring local_storage->lock)
	_raw_spin_lock_irqsave+0x3d/0x50
	bpf_local_storage_update+0xd1/0x460
	bpf_cgrp_storage_get+0x109/0x130
	bpf_prog_a4d4a370ba857314_cgrp_ptr+0x139/0x170
	? __bpf_prog_enter_recur+0x16/0x80
	bpf_trampoline_6442485186+0x43/0xa4
	cgroup_storage_ptr+0x9/0x20
		(holding local_storage->lock)
	bpf_selem_unlink_storage_nolock.constprop.0+0x135/0x160
	bpf_selem_unlink_storage+0x6f/0x110
	bpf_local_storage_map_free+0xa2/0x110
	bpf_map_free_deferred+0x5b/0x90
	process_one_work+0x17c/0x390
	worker_thread+0x251/0x360
	kthread+0xd2/0x100
	ret_from_fork+0x34/0x50
	ret_from_fork_asm+0x1a/0x30
	</TASK>

Progs:
 - A: SEC("fentry/cgroup_storage_ptr")
   - cgid (BPF_MAP_TYPE_HASH)
	Record the id of the cgroup the current task belonging
	to in this hash map, using the address of the cgroup
	as the map key.
   - cgrpa (BPF_MAP_TYPE_CGRP_STORAGE)
	If current task is a kworker, lookup the above hash
	map using function parameter @owner as the key to get
	its corresponding cgroup id which is then used to get
	a trusted pointer to the cgroup through
	bpf_cgroup_from_id(). This trusted pointer can then
	be passed to bpf_cgrp_storage_get() to finally trigger
	the deadlock issue.
 - B: SEC("tp_btf/sys_enter")
   - cgrpb (BPF_MAP_TYPE_CGRP_STORAGE)
	The only purpose of this prog is to fill Prog A's
	hash map by calling bpf_cgrp_storage_get() for as
	many userspace tasks as possible.

Steps to reproduce:
 - Run A;
 - while (true) { Run B; Destroy B; }

Fix this issue by passing its busy counter to the free procedure so
it can be properly incremented before storage/smap locking.

Fixes: c4bcfb38a95e ("bpf: Implement cgroup storage available to non-cgroup-attached bpf progs")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20241221061018.37717-1-wuyun.abel@bytedance.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_cgrp_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storage.c
index d44fe8dd97329..ee1c7b77096e7 100644
--- a/kernel/bpf/bpf_cgrp_storage.c
+++ b/kernel/bpf/bpf_cgrp_storage.c
@@ -154,7 +154,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 
 static void cgroup_storage_map_free(struct bpf_map *map)
 {
-	bpf_local_storage_map_free(map, &cgroup_cache, NULL);
+	bpf_local_storage_map_free(map, &cgroup_cache, &bpf_cgrp_storage_busy);
 }
 
 /* *gfp_flags* is a hidden argument provided by the verifier */
-- 
2.39.5



