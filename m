Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D51329396;
	Thu, 28 May 2026 20:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001494; cv=none; b=EbqpjcPkzEhKonTmWp/DyGab+wMQ6QviOCK/3pPuuhetaoihHeQFzs+gvowU38YyrWyIc6drFlwl0lkvj+yKHM81u3IJE0nhvsZYOmDF037TzUrb3juL62/p87eX3AQxLgkiumdy6TUppwAR+22L8l9MCdDGEscZCSiYHM6bcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001494; c=relaxed/simple;
	bh=Naim1k9hLJE0USKyKECQ+iNRa4v1L8IyHgegarxpIpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbtFWh2sgtZaFkneGALsY1qP3YCnqldJ4Qz2YfV6L/xisphSTnqV6TniJxtytVMu4+WlcmAUUb4zMjq3jVW9L3gWUxKvHsPbdlL6Is7ANahVsAK+P6xRsJneQm8BV32h8xn6e/yinVkpH3doZUcCmTnODsuR48G90Yb71/QtKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgePVwrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgePVwrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646D51F000E9;
	Thu, 28 May 2026 20:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001492;
	bh=HgtsTwqsa969jp/BD4jhKhIKTBPe0OfGy99AWTSo0+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgePVwrvYCBGmw9wwh4d3Wehu6jvRqwtlbMzGNLm2UEgKaeGDZzz0mK71iBTPsMwE
	 df3V2HFdhwr/plP7kysyQsorx+6CE8AjESyEXOre9q4AjyiVzVYGhkrBbaF5Y0ArA/
	 vXVYJ/w+/jFy0koWqf5YeBi2B0ofyi0l3/zMFZ1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/186] netfilter: arptables: Select NETFILTER_FAMILY_ARP when building arp_tables.c
Date: Thu, 28 May 2026 21:49:51 +0200
Message-ID: <20260528194931.937700929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 15fba562f7a9f04322b8bfc8f392e04bb93d81be ]

syzkaller started to report a warning below [0] after consuming the
commit 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only
builds").

The change accidentally removed the dependency on NETFILTER_FAMILY_ARP
from IP_NF_ARPTABLES.

If NF_TABLES_ARP is not enabled on Kconfig, NETFILTER_FAMILY_ARP will
be removed and some code necessary for arptables will not be compiled.

  $ grep -E "(NETFILTER_FAMILY_ARP|IP_NF_ARPTABLES|NF_TABLES_ARP)" .config
  CONFIG_NETFILTER_FAMILY_ARP=y
  # CONFIG_NF_TABLES_ARP is not set
  CONFIG_IP_NF_ARPTABLES=y

  $ make olddefconfig

  $ grep -E "(NETFILTER_FAMILY_ARP|IP_NF_ARPTABLES|NF_TABLES_ARP)" .config
  # CONFIG_NF_TABLES_ARP is not set
  CONFIG_IP_NF_ARPTABLES=y

So, when nf_register_net_hooks() is called for arptables, it will
trigger the splat below.

Now IP_NF_ARPTABLES is only enabled by IP_NF_ARPFILTER, so let's
restore the dependency on NETFILTER_FAMILY_ARP in IP_NF_ARPFILTER.

[0]:
WARNING: CPU: 0 PID: 242 at net/netfilter/core.c:316 nf_hook_entry_head+0x1e1/0x2c0 net/netfilter/core.c:316
Modules linked in:
CPU: 0 PID: 242 Comm: syz-executor.0 Not tainted 6.8.0-12821-g537c2e91d354 #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:nf_hook_entry_head+0x1e1/0x2c0 net/netfilter/core.c:316
Code: 83 fd 04 0f 87 bc 00 00 00 e8 5b 84 83 fd 4d 8d ac ec a8 0b 00 00 e8 4e 84 83 fd 4c 89 e8 5b 5d 41 5c 41 5d c3 e8 3f 84 83 fd <0f> 0b e8 38 84 83 fd 45 31 ed 5b 5d 4c 89 e8 41 5c 41 5d c3 e8 26
RSP: 0018:ffffc90000b8f6e8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff83c42164
RDX: ffff888106851180 RSI: ffffffff83c42321 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 000000000000000a
R10: 0000000000000003 R11: ffff8881055c2f00 R12: ffff888112b78000
R13: 0000000000000000 R14: ffff8881055c2f00 R15: ffff8881055c2f00
FS:  00007f377bd78800(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000496068 CR3: 000000011298b003 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __nf_register_net_hook+0xcd/0x7a0 net/netfilter/core.c:428
 nf_register_net_hook+0x116/0x170 net/netfilter/core.c:578
 nf_register_net_hooks+0x5d/0xc0 net/netfilter/core.c:594
 arpt_register_table+0x250/0x420 net/ipv4/netfilter/arp_tables.c:1553
 arptable_filter_table_init+0x41/0x60 net/ipv4/netfilter/arptable_filter.c:39
 xt_find_table_lock+0x2e9/0x4b0 net/netfilter/x_tables.c:1260
 xt_request_find_table_lock+0x2b/0xe0 net/netfilter/x_tables.c:1285
 get_info+0x169/0x5c0 net/ipv4/netfilter/arp_tables.c:808
 do_arpt_get_ctl+0x3f9/0x830 net/ipv4/netfilter/arp_tables.c:1444
 nf_getsockopt+0x76/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt+0x17d/0x1c0 net/ipv4/ip_sockglue.c:1777
 tcp_getsockopt+0x99/0x100 net/ipv4/tcp.c:4373
 do_sock_getsockopt+0x279/0x360 net/socket.c:2373
 __sys_getsockopt+0x115/0x1e0 net/socket.c:2402
 __do_sys_getsockopt net/socket.c:2412 [inline]
 __se_sys_getsockopt net/socket.c:2409 [inline]
 __x64_sys_getsockopt+0xbd/0x150 net/socket.c:2409
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x4f/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
RIP: 0033:0x7f377beca6fe
Code: 1f 44 00 00 48 8b 15 01 97 0a 00 f7 d8 64 89 02 b8 ff ff ff ff eb b8 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 8b 15 c9
RSP: 002b:00000000005df728 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000004966e0 RCX: 00007f377beca6fe
RDX: 0000000000000060 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000042938a R08: 00000000005df73c R09: 00000000005df800
R10: 00000000004966e8 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000496068 R14: 0000000000000003 R15: 00000000004bc9d8
 </TASK>

Fixes: 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only builds")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 8f6e950163a79..1b991b889506a 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -329,6 +329,7 @@ config NFT_COMPAT_ARP
 config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
+	select NETFILTER_FAMILY_ARP
 	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
-- 
2.53.0



