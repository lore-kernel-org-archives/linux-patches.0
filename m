Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC5D63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E7C433EF;
	Mon, 20 Feb 2023 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901704;
	bh=OrqMO5f59f298dIkvzPlOFncHG/doW3AZg1/fBYg3OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQXEEfBrMT/+QKmp2vroX0+DYt2EUAfw00SB5vAoZHYY48gBsHrkAjZ9UCiCYNuv2
	 g+7tDBT5B3nHSk1jctQn/WFrlshkRcuTlHHrw82TVVRvwmTgMGCMkfGGT1r76TqCDr
	 Eh+SZPB1uXjw2JQjsTeBRlnzroFqSUo84orBpO7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Erin MacNeil <lnx.erin@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 097/118] net: use a bounce buffer for copying skb->mark
Date: Mon, 20 Feb 2023 14:36:53 +0100
Message-Id: <20230220133604.269565695@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

commit 2558b8039d059342197610498c8749ad294adee5 upstream.

syzbot found arm64 builds would crash in sock_recv_mark()
when CONFIG_HARDENED_USERCOPY=y

x86 and powerpc are not detecting the issue because
they define user_access_begin.
This will be handled in a different patch,
because a check_object_size() is missing.

Only data from skb->cb[] can be copied directly to/from user space,
as explained in commit 79a8a642bf05 ("net: Whitelist
the skbuff_head_cache "cb" field")

syzbot report was:
usercopy: Kernel memory exposure attempt detected from SLUB object 'skbuff_head_cache' (offset 168, size 4)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:102 !
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 4410 Comm: syz-executor533 Not tainted 6.2.0-rc7-syzkaller-17907-g2d3827b3f393 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : usercopy_abort+0x90/0x94 mm/usercopy.c:90
lr : usercopy_abort+0x90/0x94 mm/usercopy.c:90
sp : ffff80000fb9b9a0
x29: ffff80000fb9b9b0 x28: ffff0000c6073400 x27: 0000000020001a00
x26: 0000000000000014 x25: ffff80000cf52000 x24: fffffc0000000000
x23: 05ffc00000000200 x22: fffffc000324bf80 x21: ffff0000c92fe1a8
x20: 0000000000000001 x19: 0000000000000004 x18: 0000000000000000
x17: 656a626f2042554c x16: ffff0000c6073dd0 x15: ffff80000dbd2118
x14: ffff0000c6073400 x13: 00000000ffffffff x12: ffff0000c6073400
x11: ff808000081bbb4c x10: 0000000000000000 x9 : 7b0572d7cc0ccf00
x8 : 7b0572d7cc0ccf00 x7 : ffff80000bf650d4 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0001fefbff08 x1 : 0000000100000000 x0 : 000000000000006c
Call trace:
usercopy_abort+0x90/0x94 mm/usercopy.c:90
__check_heap_object+0xa8/0x100 mm/slub.c:4761
check_heap_object mm/usercopy.c:196 [inline]
__check_object_size+0x208/0x6b8 mm/usercopy.c:251
check_object_size include/linux/thread_info.h:199 [inline]
__copy_to_user include/linux/uaccess.h:115 [inline]
put_cmsg+0x408/0x464 net/core/scm.c:238
sock_recv_mark net/socket.c:975 [inline]
__sock_recv_cmsgs+0x1fc/0x248 net/socket.c:984
sock_recv_cmsgs include/net/sock.h:2728 [inline]
packet_recvmsg+0x2d8/0x678 net/packet/af_packet.c:3482
____sys_recvmsg+0x110/0x3a0
___sys_recvmsg net/socket.c:2737 [inline]
__sys_recvmsg+0x194/0x210 net/socket.c:2767
__do_sys_recvmsg net/socket.c:2777 [inline]
__se_sys_recvmsg net/socket.c:2774 [inline]
__arm64_sys_recvmsg+0x2c/0x3c net/socket.c:2774
__invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
invoke_syscall+0x64/0x178 arch/arm64/kernel/syscall.c:52
el0_svc_common+0xbc/0x180 arch/arm64/kernel/syscall.c:142
do_el0_svc+0x48/0x110 arch/arm64/kernel/syscall.c:193
el0_svc+0x58/0x14c arch/arm64/kernel/entry-common.c:637
el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
Code: 91388800 aa0903e1 f90003e8 94e6d752 (d4210000)

Fixes: 6fd1d51cfa25 ("net: SO_RCVMARK socket option for SO_MARK with recvmsg()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Erin MacNeil <lnx.erin@gmail.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/r/20230213160059.3829741-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -971,9 +971,12 @@ static inline void sock_recv_drops(struc
 static void sock_recv_mark(struct msghdr *msg, struct sock *sk,
 			   struct sk_buff *skb)
 {
-	if (sock_flag(sk, SOCK_RCVMARK) && skb)
-		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32),
-			 &skb->mark);
+	if (sock_flag(sk, SOCK_RCVMARK) && skb) {
+		/* We must use a bounce buffer for CONFIG_HARDENED_USERCOPY=y */
+		__u32 mark = skb->mark;
+
+		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32), &mark);
+	}
 }
 
 void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,


