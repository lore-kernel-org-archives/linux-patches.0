Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9814012;
	Mon, 24 Feb 2025 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408967; cv=none; b=G6GF4lCpKN/lZ0QMcZ5HmYw0764+zyn2T5gyboLCTn+msMRoczF+V3udQeW1BwE1sKMdKCeGm38j7gc6dfgKr1T1imgEyVGla4mcW6CcEWlzeOkSnbq8erqEzvv1In3MSJvow0YBlHFJGVhQgPRaLmzjWQYADXFSa2eMbM+9rIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408967; c=relaxed/simple;
	bh=fzWh4+IKAqWn3gcfX3y4HEgPjdAA5MQpBMilceGMilw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLFhd2FqDlgKZrOb1JELuxtyktkJs2xpACdm6qqh4oSC7/f6XmYzEfjD8oQBFIWcTLKfrRoM7QsoBeBvp5Wrxlnt0+8yW5jtWdy9jg5mZ4woC64nw+vPOTn0y7sQl02gryGHbHPtWwI5E05qhYWeY9LArngZbNZWWKpUm3aCRhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDNcHCQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDNcHCQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EB0C4CED6;
	Mon, 24 Feb 2025 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408966;
	bh=fzWh4+IKAqWn3gcfX3y4HEgPjdAA5MQpBMilceGMilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDNcHCQ6R8Pi0sys7mDB+E5KqFEhdHrAO99YQ77UpOtGbIvEDmw6W3IyWe/MQkNFQ
	 QehNlk+US/5uy4PqKx3fUN/Otgxqdf6jcB7FOfYFP8p+miVJEKrdV74Vpd3SANMLKk
	 tDhPfoJRhJCcPedR9G8VQ+jmY4rjuRIi7DVX3oCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 056/138] bpf: Fix deadlock when freeing cgroup storage
Date: Mon, 24 Feb 2025 15:34:46 +0100
Message-ID: <20250224142606.682385340@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 20f05de92e9c3..7996fcea3755e 100644
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



