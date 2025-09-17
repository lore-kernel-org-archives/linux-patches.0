Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB1D2BE622;
	Wed, 17 Sep 2025 12:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112688; cv=none; b=OX5D0Xmj8zfnPYBs5rF0dydM+dQA3gleW5JpUeTpBNHqZ82Jnf5f5JiZt7uIkijvCvhYOopVOQXJpGSukIPtKzpWZvLl4Ii0CpMEiYLjWCitQ6bZisIjAXsfPnhVPTkSReQzn8juCD1xWli0Nm66xCYBy/Mr+FWUZufeqrKQ57w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112688; c=relaxed/simple;
	bh=+1HZBgzkAumFMG95NMXrXlNEQnOUNkehvLGNLN473Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+lpVY4cb4ScssGs0iH1/3nqKIHi/UL0p+SzUgEg8SzqzznHRGy1JHcSjkMwmM1gAvutiqgXML9yd+LSA4NGpnxhNH+UolRleTW08W8yct5st5WxtYJktqO5eiN1JV3G0fuWidYcwCNAZ86eu1x95Mi5YXlXzWJ/p538NCaUUOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4CbuZhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4CbuZhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBD3C4CEF0;
	Wed, 17 Sep 2025 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112687;
	bh=+1HZBgzkAumFMG95NMXrXlNEQnOUNkehvLGNLN473Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4CbuZhh6T+OY2XmN8NrDMrEzjAtr5PJz7j2qfDHfN9NSfBlW14GPyaC/BTR5hor2
	 o3laEwwL47iMv+MLCsyroctBAfHb6E2NTPfceN+Kibbt3HNEdNAF7EfOWahcxuFCte
	 mhzsz9ufiJU1m2CLPMxAPy9xQdQ+atsB5RHwxrq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Peilin Ye <yepeilin@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 045/189] bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()
Date: Wed, 17 Sep 2025 14:32:35 +0200
Message-ID: <20250917123352.964142984@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peilin Ye <yepeilin@google.com>

[ Upstream commit 6d78b4473cdb08b74662355a9e8510bde09c511e ]

Currently, calling bpf_map_kmalloc_node() from __bpf_async_init() can
cause various locking issues; see the following stack trace (edited for
style) as one example:

...
 [10.011566]  do_raw_spin_lock.cold
 [10.011570]  try_to_wake_up             (5) double-acquiring the same
 [10.011575]  kick_pool                      rq_lock, causing a hardlockup
 [10.011579]  __queue_work
 [10.011582]  queue_work_on
 [10.011585]  kernfs_notify
 [10.011589]  cgroup_file_notify
 [10.011593]  try_charge_memcg           (4) memcg accounting raises an
 [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
 [10.011599]  obj_cgroup_charge_account
 [10.011600]  __memcg_slab_post_alloc_hook
 [10.011603]  __kmalloc_node_noprof
...
 [10.011611]  bpf_map_kmalloc_node
 [10.011612]  __bpf_async_init
 [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
 [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
 [10.011619]  bpf__sched_ext_ops_runnable
 [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
 [10.011622]  enqueue_task
 [10.011626]  ttwu_do_activate
 [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
...

The above was reproduced on bpf-next (b338cf849ec8) by modifying
./tools/sched_ext/scx_flatcg.bpf.c to call bpf_timer_init() during
ops.runnable(), and hacking the memcg accounting code a bit to make
a bpf_timer_init() call more likely to raise an MEMCG_MAX event.

We have also run into other similar variants (both internally and on
bpf-next), including double-acquiring cgroup_file_kn_lock, the same
worker_pool::lock, etc.

As suggested by Shakeel, fix this by using __GFP_HIGH instead of
GFP_ATOMIC in __bpf_async_init(), so that e.g. if try_charge_memcg()
raises an MEMCG_MAX event, we call __memcg_memory_event() with
@allow_spinning=false and avoid calling cgroup_file_notify() there.

Depends on mm patch
"memcg: skip cgroup_file_notify if spinning is not allowed":
https://lore.kernel.org/bpf/20250905201606.66198-1-shakeel.butt@linux.dev/

v0 approach s/bpf_map_kmalloc_node/bpf_mem_alloc/
https://lore.kernel.org/bpf/20250905061919.439648-1-yepeilin@google.com/
v1 approach:
https://lore.kernel.org/bpf/20250905234547.862249-1-yepeilin@google.com/

Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Peilin Ye <yepeilin@google.com>
Link: https://lore.kernel.org/r/20250909095222.2121438-1-yepeilin@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index fdf8737542ac4..3abbdebb2d9ef 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1277,8 +1277,11 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
 		goto out;
 	}
 
-	/* allocate hrtimer via map_kmalloc to use memcg accounting */
-	cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
+	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Until
+	 * kmalloc_nolock() is available, avoid locking issues by using
+	 * __GFP_HIGH (GFP_ATOMIC & ~__GFP_RECLAIM).
+	 */
+	cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
 	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.51.0



