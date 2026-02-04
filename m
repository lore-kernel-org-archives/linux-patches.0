Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE822332E;
	Wed,  4 Feb 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218815; cv=none; b=qE6O7xG21M6ed8p2cjZm4h3W4U3YDDQitviMPfHBb029ZXbdiB8MU7ZhnSWoO+TG+/6GZyAnTS2QdtPmu7WXNSET1tJk0w3s65b3KP7a9EDpI/Q9NAp+I67LqU/PKZL8dFnjq8WIGarLMaRY8DKpxndQDx+CoL1mBXBtcC7Xusg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218815; c=relaxed/simple;
	bh=uYeGUvVRJjvOxemBwsUrpBmeS/lqQKNwn5Q7wm0Z64U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5KyNdkiJTCvUaLgi2uxMbhyTsr4mlNHf1OzqvZ3z2jj+IH/Iw/TAt7pBK+SuwB+wKJrxSzZcLWNkpQghFiObI0TunaZ0iDhphaIiXYocoD3z+9dmmCsMxaOoSRrIXXsMuJPV7HsWFc2VNbHeMW8gR4Xlzn9DFGIjY7eJu5FM5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0441wm2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0441wm2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98952C4CEF7;
	Wed,  4 Feb 2026 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218815;
	bh=uYeGUvVRJjvOxemBwsUrpBmeS/lqQKNwn5Q7wm0Z64U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0441wm2NymGPkK1l4MSitbKeAWl3hJcRgwWVVtrdcJbwzH9Ou2/xdyRQG7EojEhxe
	 UhCw40y7Bgrdc6WFMHj4ZNp40+bcwNl5mAkiXuZxPsdqvMtGaL8wtdpgTMYc6wR1bl
	 7Qn0ZyNrUJhxQo57OSVGixW/bQJ+jfH4qidv2/W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 6.12 69/87] cgroup: Fix kernfs_node UAF in css_free_rwork_fn
Date: Wed,  4 Feb 2026 15:41:07 +0100
Message-ID: <20260204143849.400071829@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "T.J. Mercier" <tjmercier@google.com>

This fix patch is not upstream, and is applicable only to kernels 6.10
(where the cgroup_rstat_lock tracepoint was added) through 6.15 after
which commit 5da3bfa029d6 ("cgroup: use separate rstat trees for each
subsystem") reordered cgroup_rstat_flush as part of a new feature
addition and inadvertently fixed this UAF.

css_free_rwork_fn first releases the last reference on the cgroup's
kernfs_node, and then calls cgroup_rstat_exit which attempts to use it
in the cgroup_rstat_lock tracepoint:

kernfs_put(cgrp->kn);
cgroup_rstat_exit
  cgroup_rstat_flush
    __cgroup_rstat_lock
      trace_cgroup_rstat_locked:
        TP_fast_assign(
          __entry->root = cgrp->root->hierarchy_id;
          __entry->id = cgroup_id(cgrp);

Where cgroup_id is:
static inline u64 cgroup_id(const struct cgroup *cgrp)
{
	return cgrp->kn->id;
}

Fix this by reordering the kernfs_put after cgroup_rstat_exit.

[78782.605161][ T9861] BUG: KASAN: slab-use-after-free in trace_event_raw_event_cgroup_rstat+0x110/0x1dc
[78782.605182][ T9861] Read of size 8 at addr ffffff890270e610 by task kworker/6:1/9861
[78782.605199][ T9861] CPU: 6 UID: 0 PID: 9861 Comm: kworker/6:1 Tainted: G        W  OE      6.12.23-android16-5-gabaf21382e8f-4k #1 0308449da8ad70d2d3649ae989c1d02f0fbf562c
[78782.605220][ T9861] Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[78782.605226][ T9861] Hardware name: Qualcomm Technologies, Inc. Alor QRD + WCN7750 WLAN + Kundu PD2536F_EX (DT)
[78782.605235][ T9861] Workqueue: cgroup_destroy css_free_rwork_fn
[78782.605251][ T9861] Call trace:
[78782.605254][ T9861]  dump_backtrace+0x120/0x170
[78782.605267][ T9861]  show_stack+0x2c/0x40
[78782.605276][ T9861]  dump_stack_lvl+0x84/0xb4
[78782.605286][ T9861]  print_report+0x144/0x7a4
[78782.605301][ T9861]  kasan_report+0xe0/0x140
[78782.605315][ T9861]  __asan_load8+0x98/0xa0
[78782.605329][ T9861]  trace_event_raw_event_cgroup_rstat+0x110/0x1dc
[78782.605339][ T9861]  __traceiter_cgroup_rstat_locked+0x78/0xc4
[78782.605355][ T9861]  __cgroup_rstat_lock+0xe8/0x1dc
[78782.605368][ T9861]  cgroup_rstat_flush_locked+0x7dc/0xaec
[78782.605383][ T9861]  cgroup_rstat_flush+0x34/0x108
[78782.605396][ T9861]  cgroup_rstat_exit+0x2c/0x120
[78782.605409][ T9861]  css_free_rwork_fn+0x504/0xa18
[78782.605421][ T9861]  process_scheduled_works+0x378/0x8e0
[78782.605435][ T9861]  worker_thread+0x5a8/0x77c
[78782.605446][ T9861]  kthread+0x1c4/0x270
[78782.605455][ T9861]  ret_from_fork+0x10/0x20
[78782.605470][ T9861] Allocated by task 2864 on cpu 7 at 78781.564561s:
[78782.605467][    C5] ENHANCE: rpm_suspend+0x93c/0xafc: 0:0:0:0 ret=0
[78782.605481][ T9861]  kasan_save_track+0x44/0x9c
[78782.605497][ T9861]  kasan_save_alloc_info+0x40/0x54
[78782.605507][ T9861]  __kasan_slab_alloc+0x70/0x8c
[78782.605521][ T9861]  kmem_cache_alloc_noprof+0x1a0/0x428
[78782.605534][ T9861]  __kernfs_new_node+0xd4/0x3e4
[78782.605545][ T9861]  kernfs_new_node+0xbc/0x168
[78782.605554][ T9861]  kernfs_create_dir_ns+0x58/0xe8
[78782.605565][ T9861]  cgroup_mkdir+0x25c/0xc9c
[78782.605576][ T9861]  kernfs_iop_mkdir+0x130/0x214
[78782.605586][ T9861]  vfs_mkdir+0x290/0x388
[78782.605599][ T9861]  do_mkdirat+0xfc/0x27c
[78782.605612][ T9861]  __arm64_sys_mkdirat+0x5c/0x78
[78782.605625][ T9861]  invoke_syscall+0x90/0x1e8
[78782.605634][ T9861]  el0_svc_common+0x134/0x168
[78782.605643][ T9861]  do_el0_svc+0x34/0x44
[78782.605652][ T9861]  el0_svc+0x38/0x84
[78782.605667][ T9861]  el0t_64_sync_handler+0x70/0xbc
[78782.605681][ T9861]  el0t_64_sync+0x19c/0x1a0
[78782.605695][ T9861] Freed by task 69 on cpu 1 at 78782.573275s:
[78782.605705][ T9861]  kasan_save_track+0x44/0x9c
[78782.605719][ T9861]  kasan_save_free_info+0x54/0x70
[78782.605729][ T9861]  __kasan_slab_free+0x68/0x8c
[78782.605743][ T9861]  kmem_cache_free+0x118/0x488
[78782.605755][ T9861]  kernfs_free_rcu+0xa0/0xb8
[78782.605765][ T9861]  rcu_do_batch+0x324/0xaa0
[78782.605775][ T9861]  rcu_nocb_cb_kthread+0x388/0x690
[78782.605785][ T9861]  kthread+0x1c4/0x270
[78782.605794][ T9861]  ret_from_fork+0x10/0x20
[78782.605809][ T9861] Last potentially related work creation:
[78782.605814][ T9861]  kasan_save_stack+0x40/0x70
[78782.605829][ T9861]  __kasan_record_aux_stack+0xb0/0xcc
[78782.605839][ T9861]  kasan_record_aux_stack_noalloc+0x14/0x24
[78782.605849][ T9861]  __call_rcu_common+0x54/0x390
[78782.605863][ T9861]  call_rcu+0x18/0x28
[78782.605875][ T9861]  kernfs_put+0x17c/0x28c
[78782.605884][ T9861]  css_free_rwork_fn+0x4f4/0xa18
[78782.605897][ T9861]  process_scheduled_works+0x378/0x8e0
[78782.605910][ T9861]  worker_thread+0x5a8/0x77c
[78782.605923][ T9861]  kthread+0x1c4/0x270
[78782.605932][ T9861]  ret_from_fork+0x10/0x20
[78782.605947][ T9861] The buggy address belongs to the object at ffffff890270e5b0
[78782.605947][ T9861]  which belongs to the cache kernfs_node_cache of size 144
[78782.605957][ T9861] The buggy address is located 96 bytes inside of
[78782.605957][ T9861]  freed 144-byte region [ffffff890270e5b0, ffffff890270e640)

Fixes: fc29e04ae1ad ("cgroup/rstat: add cgroup_rstat_lock helpers and tracepoints")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5481,9 +5481,9 @@ static void css_free_rwork_fn(struct wor
 			 * children.
 			 */
 			cgroup_put(cgroup_parent(cgrp));
-			kernfs_put(cgrp->kn);
 			psi_cgroup_free(cgrp);
 			cgroup_rstat_exit(cgrp);
+			kernfs_put(cgrp->kn);
 			kfree(cgrp);
 		} else {
 			/*


