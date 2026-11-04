Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826922;
	b=KzlI6zi7rCCgeKYCiRr+OvAGUcdMFaP2c2ES/9DjXXsIG861iSoAIeqMEWos7+s2YBPZ
	 Lsl6L0AQf+agJU9YNiIRW2f043KppBz+iUhfgezuQ9u65tN3nphIoCrCgt2FF5sUTCeUx
	 RXgF2/r2DIsd/AdORIb11PMoAdWhkdSosQh+vkKI8DEuOCZYNIoNMdhPHB9rz7SmB5W7a
	 CvY8npPyjQfTh21VxHRNjBe5LGxsX+7wnOJrV9+eYqWX8gZuZHkXHng/VXyjL/LycFS2L
	 Klea80QUZtjP/gHcqUhxVlviv+AqTCRLTvVE2rwzxhLxyEJ7H9WMw9P8NHN09L2zgWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ahBoJwZfgU2FzwDIR6M0cwnQFrIi3DXfkJNBltRZVfQ=;
	b=pLCIr0EHOd9Mci3GPb2KnTJ13cI1Nh2aMGbCU8f8DJ8AJs0gPyr1wPl8v/YSVW6zOwcT
	 rXFot5v7oZILrcr83uuV7vH/GNfYh2vIHpJXAGYP3+uRbDmUvSnU4G4vcn3/s+qOA2InO
	 bptxe6X74Zfq6U7y24w02rjV8BVY7mUXhAtBPwfVNUlNeGs618rSZhvXmhHhw5FkjYUCx
	 OdIZVGhkYWdgpX28ITP3GtLQQ7F0CF7kpqAgmVJJK61WJn8xpuIOOnEXjItTx26JPPF6v
	 XjEOXVltsQxVnJTbSDJI6aPQs1zJs51YlmlTXi7bPYRadD3hOOYvq9b35rNY4EppdvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2emOrn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB006070318;
	Wed,  4 Nov 2026 21:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2emOrn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002501F00919;
	Wed,  4 Nov 2026 21:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826922;
	bh=ahBoJwZfgU2FzwDIR6M0cwnQFrIi3DXfkJNBltRZVfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2emOrn48sRGnrNvPt6nmms6iB8PuvE0sZldBvP/mYa3THz376O+MDtT2yUVv7LDk
	 77NVWw1tzl/6VwAM8bNHHI0WSH27Wlc2C0VaTMfWBhRiVeSHcPtKaYxlCrT7L3q86S
	 DHRzVTyZ2tj+QrD/IF8tecrb5xlhPNiqGavKPB7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 7.3 086/547] ocfs2: drain quorum work before removing the cluster
Date: Wed,  4 Nov 2026 16:04:30 -0500
Message-ID: <20261104211040.679970480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit b584c45b6066fd9799c44ffb9badcb5db351c8a6 upstream.

The configured cluster must remain available until an in-flight quorum
decision has finished using its fencing method.  o2quo_make_decision()
drops qs_lock before calling o2quo_fence_self(), which marks heartbeat
regions for unclean stop and then reads
o2nm_single_cluster->cl_fence_method.  Cluster removal clears the
singleton without waiting for this independent system-workqueue item.

When a failed-quorum decision overlaps removal of the heartbeat regions,
nodes and cluster through configfs, the worker can be preempted after
marking the regions and resume after the singleton has been cleared:

  Quorum worker                     Configfs removal
  select fence; drop qs_lock
  o2hb_stop_all_regions()
                                    remove regions; join heartbeat threads
                                    remove nodes; stop o2net
                                    clear singleton; release cluster
  read cl_fence_method

The resumed read dereferences NULL instead of applying the configured
fencing method. The heartbeat thread's dependency protects the local
node only until the thread exits, and draining o2net does not wait for
qs_work.

Add o2quo_flush_work() to drain pending or running quorum decisions
before clearing the singleton in o2nm_cluster_group_drop_item(). By
this point the heartbeat regions and nodes have been removed, so their
work publishers are stopped. The worker can finish while the cluster
and its configured fencing method remain available. It does not acquire
the configfs mutex held by the removal path.

Keep o2quo_exit() as the counterpart of o2quo_init() for module teardown
and initialization failure, and have it call the same drain helper.
Cluster removal uses only the explicitly named drain operation.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc000000011b: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x00000000000008d8-0x00000000000008df]
    CPU: 0 UID: 0 PID: 72 Comm: kworker/0:2 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: events o2quo_make_decision
    RIP: 0010:o2quo_fence_self+0x65/0x200

Register dump omitted.

    Call Trace:
     <TASK>
     o2quo_make_decision+0x345/0x3a0
     ? __pfx_o2quo_make_decision+0x10/0x10
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    Modules linked in:
    ---[ end trace 0000000000000000 ]---

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0064-v5-e3870bf6571b80b07b52@gmail.com
Fixes: f6656d26d17b ("ocfs2/cluster: Make fence method configurable - v2")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/cluster/nodemanager.c |    3 +++
 fs/ocfs2/cluster/quorum.c      |    7 ++++++-
 fs/ocfs2/cluster/quorum.h      |    1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -12,6 +12,7 @@
 #include "tcp.h"
 #include "nodemanager.h"
 #include "heartbeat.h"
+#include "quorum.h"
 #include "masklog.h"
 #include "sys.h"
 
@@ -740,6 +741,8 @@ static void o2nm_cluster_group_drop_item
 	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
 
 	BUG_ON(o2nm_single_cluster != cluster);
+	/* Drain quorum work before it loses access to the cluster. */
+	o2quo_flush_work();
 	o2nm_single_cluster = NULL;
 
 	configfs_remove_default_groups(&cluster->cl_group);
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -318,9 +318,14 @@ void o2quo_init(void)
 	INIT_WORK(&qs->qs_work, o2quo_make_decision);
 }
 
-void o2quo_exit(void)
+void o2quo_flush_work(void)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
 	flush_work(&qs->qs_work);
 }
+
+void o2quo_exit(void)
+{
+	o2quo_flush_work();
+}
--- a/fs/ocfs2/cluster/quorum.h
+++ b/fs/ocfs2/cluster/quorum.h
@@ -8,6 +8,7 @@
 
 void o2quo_init(void);
 void o2quo_exit(void);
+void o2quo_flush_work(void);
 
 void o2quo_hb_up(u8 node);
 void o2quo_hb_down(u8 node);


