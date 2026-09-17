Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0504547040;
	Thu, 17 Sep 2026 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665101; cv=none; b=axpZrgpVIqDLWy9PdujIEWECkfID11YOJay8QRJJ8pWQmmYV3n2aq2foVXdP2XF+EXudcp9TDGvGsCHBdIU9Lp0vVN0up/qKeYJwcHp3ZMzwv+/FSLcG/QqqaCtOlKymJBT8+7ABNvyDlejPEqkiISjE238CB/RyUEF2AKvDJhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665101; c=relaxed/simple;
	bh=9ObK2F3lSVm4/cK+2lPOHcdunyebMu8Q/newV5Ygq2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8TisjDsbgaVdS+Xerk1sXSHpvx1Va/fMl+MoUaCknPznSFb4l9XP7LBavJUdzhoAoCFO2AJ241X6WJdxVZggmWgop5RrC9iZadIJ4tWPB/LCnD9H8FJWQx+LKrZTXfqTVxkBxU1nSKw3IjYOfYa/GXwfipVm/AUNmwL2Pl6RSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF7Xv1NM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF7Xv1NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193C71F000FF;
	Thu, 17 Sep 2026 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665099;
	bh=v7iaI4Gut1gGFgsu4lt3w2vPaz4tbq4wmHDDfOpflhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IF7Xv1NM6WvyKMpDmRsZtpinNp3mZ+NVl3qFDzITU0+s4K+lZ7hLzYrw8ZnvzFXZO
	 pBFozWhLMb0v2CQBmfVTpNeDgNqtwUri3W0/cXm1vhT7mGLTVAK1Eu/ckpQNZ6Y/9G
	 5ekNXXwXNM29INTeiYJzbgAFaAI2JBOn5RPBj69I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cb2aa2390ac024e25f5c@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0591/1250] ipv4: fib: Dont dump dying fib_info in fib_leaf_notify().
Date: Thu, 17 Sep 2026 16:06:26 +0100
Message-ID: <20260917151607.901281739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 06b693d2eb6651a63ad85bad8673de3b7d4edd6d ]

syzbot reported use-after-free in nsim_fib4_prepare_event(). [0]

The problem is that the following functions call fib_info_hold() /
refcount_inc() while dumping fib_info under RCU, which is unsafe.

  * mlxsw_sp_router_fib4_event()
  * rocker_router_fib_event()
  * nsim_fib4_prepare_event()

refcount_inc_not_zero() must be used, but it would be too late
there.

Let's guarantee the lifetime of fib_info in fib_leaf_notify().

Note that IPv6 does not need the corresponding change since
fib6_table_dump() holds fib6_table.tb6_lock.

[0]:
refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25, CPU#0: kworker/u8:15/3420
Modules linked in:
CPU: 0 UID: 0 PID: 3420 Comm: kworker/u8:15 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: netns cleanup_net
RIP: 0010:refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25
Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 1b f1 22 fd 48 8d 3d 84 cb f1 0a 67 48 0f b9 3a eb 4a e8 08 f1 22 fd 48 8d 3d 81 cb f1 0a <67> 48 0f b9 3a eb 37 e8 f5 f0 22 fd 48 8d 3d 7e cb f1 0a 67 48 0f
RSP: 0018:ffffc9000f2c7270 EFLAGS: 00010293
RAX: ffffffff84a18858 RBX: 0000000000000002 RCX: ffff888032ff9ec0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8f9353e0
RBP: 0000000000000000 R08: ffff888032ff9ec0 R09: 0000000000000005
R10: 0000000000000100 R11: 0000000000000004 R12: ffff8880570cc000
R13: dffffc0000000000 R14: ffff88802b40563c R15: ffff8880570cc000
FS:  0000000000000000(0000) GS:ffff888126173000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb1f4d5d000 CR3: 000000006072a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:-1 [inline]
 __refcount_inc include/linux/refcount.h:366 [inline]
 refcount_inc include/linux/refcount.h:383 [inline]
 fib_info_hold include/net/ip_fib.h:629 [inline]
 nsim_fib4_prepare_event drivers/net/netdevsim/fib.c:930 [inline]
 nsim_fib_event_schedule_work drivers/net/netdevsim/fib.c:1000 [inline]
 nsim_fib_event_nb+0x1055/0x1240 drivers/net/netdevsim/fib.c:1043
 call_fib_notifier+0x45/0x80 net/core/fib_notifier.c:25
 call_fib_entry_notifier net/ipv4/fib_trie.c:90 [inline]
 fib_leaf_notify net/ipv4/fib_trie.c:2176 [inline]
 fib_table_notify net/ipv4/fib_trie.c:2194 [inline]
 fib_notify+0x36b/0x5e0 net/ipv4/fib_trie.c:2217
 fib_net_dump net/core/fib_notifier.c:70 [inline]
 register_fib_notifier+0x184/0x360 net/core/fib_notifier.c:108
 nsim_fib_create+0x85d/0x9f0 drivers/net/netdevsim/fib.c:1596
 nsim_dev_reload_create drivers/net/netdevsim/dev.c:1604 [inline]
 nsim_dev_reload_up+0x374/0x7c0 drivers/net/netdevsim/dev.c:1058
 devlink_reload+0x501/0x8d0 net/devlink/dev.c:475
 devlink_pernet_pre_exit+0x1ff/0x420 net/devlink/core.c:558
 ops_pre_exit_list net/core/net_namespace.c:161 [inline]
 ops_undo_list+0x187/0x940 net/core/net_namespace.c:234
 cleanup_net+0x56e/0x800 net/core/net_namespace.c:702
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fixes: 0ae3eb7b4611 ("netdevsim: fib: Perform the route programming in a non-atomic context")
Fixes: c3852ef7f2f8 ("ipv4: fib: Replay events when registering FIB notifier")
Reported-by: syzbot+cb2aa2390ac024e25f5c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a290011.39669fcc.33b062.00b1.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260610061744.2030996-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h | 5 +++++
 net/ipv4/fib_trie.c  | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 24023c19c7b1f..040eed88fc672 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -628,6 +628,11 @@ static inline void fib_info_hold(struct fib_info *fi)
 	refcount_inc(&fi->fib_clntref);
 }
 
+static inline bool fib_info_hold_safe(struct fib_info *fi)
+{
+	return refcount_inc_not_zero(&fi->fib_clntref);
+}
+
 static inline void fib_info_put(struct fib_info *fi)
 {
 	if (refcount_dec_and_test(&fi->fib_clntref))
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2dc87e2156d37..9bf5550e2fb73 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2172,10 +2172,14 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 		if (fa->fa_slen == last_slen)
 			continue;
 
+		if (!fib_info_hold_safe(fa->fa_info))
+			continue;
+
 		last_slen = fa->fa_slen;
 		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE,
 					      l->key, KEYLENGTH - fa->fa_slen,
 					      fa, extack);
+		fib_info_put(fa->fa_info);
 		if (err)
 			return err;
 	}
-- 
2.53.0



