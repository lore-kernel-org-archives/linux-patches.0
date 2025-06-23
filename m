Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848D70838;
	Mon, 23 Jun 2025 21:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715963; cv=none; b=d2S02Ef16hxFGaJj8OlrvMrfY2F3K3+/+F2399RWdUzLmwtpKjFVyJMls8f/deOOqCDVwhM+tXfdhYq9NHhpY5EwHrTmVmsNux4BJvRkr3g0FM0usMyQHjFgtSEKm/fFGBM7N9q2x3bay0mzluSCX5gInM2LRH9nC05XH4CryiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715963; c=relaxed/simple;
	bh=lxcMLL3qAnqcAwZalpBmeSiALzR+Y0RoR38eV7KNbEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2EpONHLlMeiv9Tf7IJYt70sUVBvYV1aFgO8T1V+F4x9MTNbdS1ylD5ul6PuHuvtoKiOULV1S1uf+Gg/L53cv/r2u7pJDrZ2eeZPUGcbYTcwOWSoI+BE1CI5n7HYO0Y8wTNo1HMz0Q3knRc0jzyflmLtcwGADtRd7VAksf3ZNPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO/0J2QN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO/0J2QN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217DBC4CEEA;
	Mon, 23 Jun 2025 21:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715963;
	bh=lxcMLL3qAnqcAwZalpBmeSiALzR+Y0RoR38eV7KNbEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO/0J2QNyqMD+Ry5lsHq3CmKkOnvq74r0fu4qPv8MvLJXwZNeZFITcOg5zAaSTsxx
	 n40zvmGHGnTMGKL6pnsWIYCMK0MR7/oALNoU4xI5OugKfhrvrww/xfv1P+tl48z038
	 mltvoD/hXX6/73MlZyk0iWFRGfVWrQYgumOE93l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d3c235276f62963e93a@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/355] atm: atmtcp: Free invalid length skb in atmtcp_c_send().
Date: Mon, 23 Jun 2025 15:08:33 +0200
Message-ID: <20250623130636.163507973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 2f370ae1fb6317985f3497b1bb80d457508ca2f7 ]

syzbot reported the splat below. [0]

vcc_sendmsg() copies data passed from userspace to skb and passes
it to vcc->dev->ops->send().

atmtcp_c_send() accesses skb->data as struct atmtcp_hdr after
checking if skb->len is 0, but it's not enough.

Also, when skb->len == 0, skb and sk (vcc) were leaked because
dev_kfree_skb() is not called and sk_wmem_alloc adjustment is missing
to revert atm_account_tx() in vcc_sendmsg(), which is expected
to be done in atm_pop_raw().

Let's properly free skb with an invalid length in atmtcp_c_send().

[0]:
BUG: KMSAN: uninit-value in atmtcp_c_send+0x255/0xed0 drivers/atm/atmtcp.c:294
 atmtcp_c_send+0x255/0xed0 drivers/atm/atmtcp.c:294
 vcc_sendmsg+0xd7c/0xff0 net/atm/common.c:644
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x330/0x3d0 net/socket.c:727
 ____sys_sendmsg+0x7e0/0xd80 net/socket.c:2566
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2620
 __sys_sendmsg net/socket.c:2652 [inline]
 __do_sys_sendmsg net/socket.c:2657 [inline]
 __se_sys_sendmsg net/socket.c:2655 [inline]
 __x64_sys_sendmsg+0x211/0x3e0 net/socket.c:2655
 x64_sys_call+0x32fb/0x3db0 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4154 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 kmem_cache_alloc_node_noprof+0x818/0xf00 mm/slub.c:4249
 kmalloc_reserve+0x13c/0x4b0 net/core/skbuff.c:579
 __alloc_skb+0x347/0x7d0 net/core/skbuff.c:670
 alloc_skb include/linux/skbuff.h:1336 [inline]
 vcc_sendmsg+0xb40/0xff0 net/atm/common.c:628
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x330/0x3d0 net/socket.c:727
 ____sys_sendmsg+0x7e0/0xd80 net/socket.c:2566
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2620
 __sys_sendmsg net/socket.c:2652 [inline]
 __do_sys_sendmsg net/socket.c:2657 [inline]
 __se_sys_sendmsg net/socket.c:2655 [inline]
 __x64_sys_sendmsg+0x211/0x3e0 net/socket.c:2655
 x64_sys_call+0x32fb/0x3db0 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 5798 Comm: syz-executor192 Not tainted 6.16.0-rc1-syzkaller-00010-g2c4a1f3fe03e #0 PREEMPT(undef)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+1d3c235276f62963e93a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1d3c235276f62963e93a
Tested-by: syzbot+1d3c235276f62963e93a@syzkaller.appspotmail.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250616182147.963333-2-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/atmtcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index 96bea1ab1eccf..ff558908897f3 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -288,7 +288,9 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	struct sk_buff *new_skb;
 	int result = 0;
 
-	if (!skb->len) return 0;
+	if (skb->len < sizeof(struct atmtcp_hdr))
+		goto done;
+
 	dev = vcc->dev_data;
 	hdr = (struct atmtcp_hdr *) skb->data;
 	if (hdr->length == ATMTCP_HDR_MAGIC) {
-- 
2.39.5



