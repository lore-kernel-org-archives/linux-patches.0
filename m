Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0593AFAE3;
	Sat, 17 Oct 2026 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255615; cv=none; b=WKcpG0GmbnR7nSk4htbL2OpE3TpgLx1sHpyaTEbcjM9IarJAJMi8gPAKdw3KPcACdCsx/jPFCWwnE25uHLO/i62rndz2sqxQSMTVTenDwdyvFOfFrfcqV8T61EfLwLrgSax8uugAT3PDpLIcAUfjj8Oo+E7K9eAsm+HJBxWBhJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255615; c=relaxed/simple;
	bh=XJXyJdf/7LP+eiO9d2aHeKgFUtcXapqf1yr51y3E6gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpNf1qwp5bZ0l+JmR/do3OI7A5/zLJvapgsvfIz58BXKDwkfjt36QkUoxlAkAWts3fqQOVYV07StpEiuZt2NXlG28c0SKIwk6rVxARdLsIxQdK+dYc2UPH0t9dwxzNy7+R2wZInUWkUIkzyGGIMNKbJ1wTriuPHyfquCeIvdHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvnPhU1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvnPhU1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9021F000C4;
	Sat, 17 Oct 2026 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255614;
	bh=igm1i+hWNPDQwH2q9ZyiAMi/S8GNzHl7gcXqZ3vwlzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvnPhU1tK4a6FrxnRC0XmutriHiDVZcoIPAZLGGT5i9j8QhvjdTL+7ituKtGU9ntI
	 WyqGH+jb9r5pXRwrDJjhbXaP9mWU7JS6iCNvCOrzyWHJE8rTf1LU33FQJ2BBbBF0Lf
	 Okvvo9dDwYW4dKMp2IahZfyGWFg4q0y4TztYbiUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 832/869] net: Fix wild-memory-access in __register_pernet_operations() when CONFIG_NET_NS=n.
Date: Sat, 17 Oct 2026 18:01:13 +0200
Message-ID: <20261017160058.208489283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit f0cc3777b2db18307d9734edf2d16e046714760f ]

kernel test robot reported the splat below. [0]

Before commit fed176bf3143 ("net: Add ops_undo_single for module
load/unload."), if CONFIG_NET_NS=n, ops was linked to pernet_list
only when init_net had not been initialised, and ops was unlinked
from pernet_list only under the same condition.

Let's say an ops is loaded before the init_net setup but unloaded
after that.  Then, the ops remains in pernet_list, which seems odd.

The cited commit added ops_undo_single(), which calls list_add() for
ops to link it to a temporary list, so a minor change was added to
__register_pernet_operations() and __unregister_pernet_operations()
under CONFIG_NET_NS=n to avoid the pernet_list corruption.

However, the corruption must have been left as is.

When CONFIG_NET_NS=n, pernet_list was used to keep ops registered
before the init_net setup, and after that, pernet_list was not used
at all.

This was because some ops annotated with __net_initdata are cleared
out of memory at some point during boot.

Then, such ops is initialised by POISON_FREE_INITMEM (0xcc), resulting
in that ops->list.{next,prev} suddenly switches from a valid pointer
to a weird value, 0xcccccccccccccccc.

To avoid such wild memory access, let's allow the pernet_list
corruption for CONFIG_NET_NS=n.

[0]:
Oops: general protection fault, probably for non-canonical address 0xf999959999999999: 0000 [#1] SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0xccccccccccccccc8-0xcccccccccccccccf]
CPU: 2 UID: 0 PID: 346 Comm: modprobe Not tainted 6.15.0-rc1-00294-ga4cba7e98e35 #85 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:__list_add_valid_or_report (lib/list_debug.c:32)
Code: 48 c1 ea 03 80 3c 02 00 0f 85 5a 01 00 00 49 39 74 24 08 0f 85 83 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 1f 01 00 00 4c 39 26 0f 85 ab 00 00 00 4c 39 ee
RSP: 0018:ff11000135b87830 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: ffffffffc02223c0 RCX: ffffffff8406fcc2
RDX: 1999999999999999 RSI: cccccccccccccccc RDI: ffffffffc02223c0
RBP: ffffffff86064e40 R08: 0000000000000001 R09: fffffbfff0a9f5b5
R10: ffffffff854fadaf R11: 676552203a54454e R12: ffffffff86064e40
R13: ffffffffc02223c0 R14: ffffffff86064e48 R15: 0000000000000021
FS:  00007f6fb0d9e1c0(0000) GS:ff11000858ea0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6fb0eda580 CR3: 0000000122fec005 CR4: 0000000000771ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 register_pernet_operations (./include/linux/list.h:150 (discriminator 5) ./include/linux/list.h:183 (discriminator 5) net/core/net_namespace.c:1315 (discriminator 5) net/core/net_namespace.c:1359 (discriminator 5))
 register_pernet_subsys (net/core/net_namespace.c:1401)
 inet6_init (net/ipv6/af_inet6.c:535) ipv6
 do_one_initcall (init/main.c:1257)
 do_init_module (kernel/module/main.c:2942)
 load_module (kernel/module/main.c:3409)
 init_module_from_file (kernel/module/main.c:3599)
 idempotent_init_module (kernel/module/main.c:3611)
 __x64_sys_finit_module (./include/linux/file.h:62 ./include/linux/file.h:83 kernel/module/main.c:3634 kernel/module/main.c:3621 kernel/module/main.c:3621)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
 RIP: 0033:0x7f6fb0df7e5d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 9f 1b 00 f7 d8 64 89 01 48
RSP: 002b:00007fffdc6a8968 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000055b535721b70 RCX: 00007f6fb0df7e5d
RDX: 0000000000000000 RSI: 000055b51e44aa2a RDI: 0000000000000004
RBP: 0000000000040000 R08: 0000000000000000 R09: 000055b535721b30
R10: 0000000000000004 R11: 0000000000000246 R12: 000055b51e44aa2a
R13: 000055b535721bf0 R14: 000055b5357220b0 R15: 0000000000000000
 </TASK>
Modules linked in: ipv6(+) crc_ccitt

Fixes: fed176bf3143 ("net: Add ops_undo_single for module load/unload.")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504181511.1c3f23e4-lkp@intel.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250418215025.87871-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9e518df2cfeb5..1b5d151f434e1 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1309,19 +1309,19 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
 {
-	list_add_tail(&ops->list, list);
-
-	if (!init_net_initialized)
+	if (!init_net_initialized) {
+		list_add_tail(&ops->list, list);
 		return 0;
+	}
 
 	return ops_init(ops, &init_net);
 }
 
 static void __unregister_pernet_operations(struct pernet_operations *ops)
 {
-	list_del(&ops->list);
-
-	if (init_net_initialized) {
+	if (!init_net_initialized) {
+		list_del(&ops->list);
+	} else {
 		LIST_HEAD(net_exit_list);
 
 		list_add(&init_net.exit_list, &net_exit_list);
-- 
2.53.0



