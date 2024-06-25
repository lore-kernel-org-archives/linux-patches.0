Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057861465A8;
	Tue, 25 Jun 2024 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308807; cv=none; b=mvsn69vNpWodqWHTZdKjDoGB0liq6yB3bzrZtK7map7HDy7sMGxjN4bm47g25D3Zf4Dcx+FOFrDxxMlTJ7mnWdJUHUVUZm2nsFGln5ypNIWOxIZAfy4WO7zRUCLaVV+UV2OtjjPyLAlyrxRP+Z1Fm58uBXPWqmueW9E41Qx8MYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308807; c=relaxed/simple;
	bh=gVDeQ9zWlzyedLaD6Ms2FItjMAQb3EM/Irb60Mmvrac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNs7ErKJ2yAj4SMXwIzucHwdt3/uZ2Ic32Kj1asDGF7M2WIBJlAm+8OK+x76MBoquBmXl14FHgVYrhKlrb6ex13o1D3SQtKEqSWyBhLLlz152p4tqvJt1J84nistlRLVLerw2lZDUPxmi1vWREgSWHgGcrMHkwMUh0juEopGzjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6YLAlJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6YLAlJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F65EC32781;
	Tue, 25 Jun 2024 09:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308806;
	bh=gVDeQ9zWlzyedLaD6Ms2FItjMAQb3EM/Irb60Mmvrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6YLAlJPjExksZVXm5S6jtx29zj5iUwarI1PT0cSDRu52u1N2bgoyTZoc4ndAM/RK
	 2HxwkbjZO8DK74SilAgCwXahN1Ul8bx2x5z9BMqcu+5Ws0uxwycbOKeXYSOMQ+K1rp
	 PQsBExCcoJOfvTYxobhAssM1s/Skmm4M2wwJWL1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Davide Caratti <dcaratti@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 247/250] net/sched: unregister lockdep keys in qdisc_create/qdisc_alloc error path
Date: Tue, 25 Jun 2024 11:33:25 +0200
Message-ID: <20240625085557.531593401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Caratti <dcaratti@redhat.com>

commit 86735b57c905e775f05de995df35379366b72168 upstream.

Naresh and Eric report several errors (corrupted elements in the dynamic
key hash list), when running tdc.py or syzbot. The error path of
qdisc_alloc() and qdisc_create() frees the qdisc memory, but it forgets
to unregister the lockdep key, thus causing use-after-free like the
following one:

 ==================================================================
 BUG: KASAN: slab-use-after-free in lockdep_register_key+0x5f2/0x700
 Read of size 8 at addr ffff88811236f2a8 by task ip/7925

 CPU: 26 PID: 7925 Comm: ip Kdump: loaded Not tainted 6.9.0-rc2+ #648
 Hardware name: Supermicro SYS-6027R-72RF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0  07/26/2013
 Call Trace:
  <TASK>
  dump_stack_lvl+0x7c/0xc0
  print_report+0xc9/0x610
  kasan_report+0x89/0xc0
  lockdep_register_key+0x5f2/0x700
  qdisc_alloc+0x21d/0xb60
  qdisc_create_dflt+0x63/0x3c0
  attach_one_default_qdisc.constprop.37+0x8e/0x170
  dev_activate+0x4bd/0xc30
  __dev_open+0x275/0x380
  __dev_change_flags+0x3f1/0x570
  dev_change_flags+0x7c/0x160
  do_setlink+0x1ea1/0x34b0
  __rtnl_newlink+0x8c9/0x1510
  rtnl_newlink+0x61/0x90
  rtnetlink_rcv_msg+0x2f0/0xbc0
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x420/0x630
  netlink_sendmsg+0x732/0xbc0
  __sock_sendmsg+0x1ea/0x280
  ____sys_sendmsg+0x5a9/0x990
  ___sys_sendmsg+0xf1/0x180
  __sys_sendmsg+0xd3/0x180
  do_syscall_64+0x96/0x180
  entry_SYSCALL_64_after_hwframe+0x71/0x79
 RIP: 0033:0x7f9503f4fa07
 Code: 0a 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 RSP: 002b:00007fff6c729068 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 000000006630c681 RCX: 00007f9503f4fa07
 RDX: 0000000000000000 RSI: 00007fff6c7290d0 RDI: 0000000000000003
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000078
 R10: 000000000000009b R11: 0000000000000246 R12: 0000000000000001
 R13: 00007fff6c729180 R14: 0000000000000000 R15: 000055bf67dd9040
  </TASK>

 Allocated by task 7745:
  kasan_save_stack+0x1c/0x40
  kasan_save_track+0x10/0x30
  __kasan_kmalloc+0x7b/0x90
  __kmalloc_node+0x1ff/0x460
  qdisc_alloc+0xae/0xb60
  qdisc_create+0xdd/0xfb0
  tc_modify_qdisc+0x37e/0x1960
  rtnetlink_rcv_msg+0x2f0/0xbc0
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x420/0x630
  netlink_sendmsg+0x732/0xbc0
  __sock_sendmsg+0x1ea/0x280
  ____sys_sendmsg+0x5a9/0x990
  ___sys_sendmsg+0xf1/0x180
  __sys_sendmsg+0xd3/0x180
  do_syscall_64+0x96/0x180
  entry_SYSCALL_64_after_hwframe+0x71/0x79

 Freed by task 7745:
  kasan_save_stack+0x1c/0x40
  kasan_save_track+0x10/0x30
  kasan_save_free_info+0x36/0x60
  __kasan_slab_free+0xfe/0x180
  kfree+0x113/0x380
  qdisc_create+0xafb/0xfb0
  tc_modify_qdisc+0x37e/0x1960
  rtnetlink_rcv_msg+0x2f0/0xbc0
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x420/0x630
  netlink_sendmsg+0x732/0xbc0
  __sock_sendmsg+0x1ea/0x280
  ____sys_sendmsg+0x5a9/0x990
  ___sys_sendmsg+0xf1/0x180
  __sys_sendmsg+0xd3/0x180
  do_syscall_64+0x96/0x180
  entry_SYSCALL_64_after_hwframe+0x71/0x79

Fix this ensuring that lockdep_unregister_key() is called before the
qdisc struct is freed, also in the error path of qdisc_create() and
qdisc_alloc().

Fixes: af0cb3fa3f9e ("net/sched: fix false lockdep warning on qdisc root lock")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/netdev/20240429221706.1492418-1-naresh.kamboju@linaro.org/
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/2aa1ca0c0a3aa0acc15925c666c777a4b5de553c.1714496886.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c     |    1 +
 net/sched/sch_generic.c |    1 +
 2 files changed, 2 insertions(+)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1389,6 +1389,7 @@ err_out4:
 		ops->destroy(sch);
 	qdisc_put_stab(rtnl_dereference(sch->stab));
 err_out3:
+	lockdep_unregister_key(&sch->root_lock_key);
 	netdev_put(dev, &sch->dev_tracker);
 	qdisc_free(sch);
 err_out2:
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -983,6 +983,7 @@ struct Qdisc *qdisc_alloc(struct netdev_
 
 	return sch;
 errout1:
+	lockdep_unregister_key(&sch->root_lock_key);
 	kfree(sch);
 errout:
 	return ERR_PTR(err);


