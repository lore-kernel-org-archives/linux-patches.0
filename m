Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1006B19F424;
	Tue, 29 Apr 2025 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950315; cv=none; b=m00DC6aYzgRTkq4+dcNXQz5No+TxeICpGP/AySJcG1URYju5YKq8zraXLoXxiP2ezNRgQZPYtTCnwISO48iEpddxV19sLOSj+Vfe487xI3YV7IaQMrRPfDYN55AgzhruNbr8ZFLT33A/SEzIZDc6M33KRv1ozBGib2+zTMf68bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950315; c=relaxed/simple;
	bh=nCtoN0jo+JRG5sZ+bUmQPdfU0LXGQG8KkhZNt+sLP8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFTtHdHqIKcq1aOVXv+2MxJjasKQRYKj2zYxBd7f5rwyz5W+TfjAO4SOrTIcM6xQlNLiamnYNcuEVfyOmyEROJtRLi5xUvF9s1gTNuXdzuGn3N5sePa3UkAZth3e+X7+wRuHHyIBGJCWpV7HoriIXsvriyoQfWAFsO7OiNrJqls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hCDrLFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hCDrLFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD72C4CEE3;
	Tue, 29 Apr 2025 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950314;
	bh=nCtoN0jo+JRG5sZ+bUmQPdfU0LXGQG8KkhZNt+sLP8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hCDrLFgfXvL0NBNxm1R3UkzWmR7amope8EjCbondDm2g/1PEK1eaaJDk0t7Ps/kh
	 VB8urPbj8BEcqkhAtUDuBDZ6kHmJ/IlCY8Pm97tqK+p9gnZcluCWkHD9bElOhBPyh2
	 c+Wv4Pjf8OoL4QyQp9P8MUGU6BZCqB8Z72RjX3dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ed60da8d686dc709164c@syzkaller.appspotmail.com,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/204] tipc: fix NULL pointer dereference in tipc_mon_reinit_self()
Date: Tue, 29 Apr 2025 18:42:24 +0200
Message-ID: <20250429161101.703307024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit d63527e109e811ef11abb1c2985048fdb528b4cb ]

syzbot reported:

tipc: Node number set to 1055423674
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 3 UID: 0 PID: 6017 Comm: kworker/3:5 Not tainted 6.15.0-rc1-syzkaller-00246-g900241a5cc15 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: events tipc_net_finalize_work
RIP: 0010:tipc_mon_reinit_self+0x11c/0x210 net/tipc/monitor.c:719
...
RSP: 0018:ffffc9000356fb68 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000003ee87cba
RDX: 0000000000000000 RSI: ffffffff8dbc56a7 RDI: ffff88804c2cc010
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000007
R13: fffffbfff2111097 R14: ffff88804ead8000 R15: ffff88804ead9010
FS:  0000000000000000(0000) GS:ffff888097ab9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f720eb00 CR3: 000000000e182000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tipc_net_finalize+0x10b/0x180 net/tipc/net.c:140
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c2/0x780 kernel/kthread.c:464
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
...
RIP: 0010:tipc_mon_reinit_self+0x11c/0x210 net/tipc/monitor.c:719
...
RSP: 0018:ffffc9000356fb68 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000003ee87cba
RDX: 0000000000000000 RSI: ffffffff8dbc56a7 RDI: ffff88804c2cc010
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000007
R13: fffffbfff2111097 R14: ffff88804ead8000 R15: ffff88804ead9010
FS:  0000000000000000(0000) GS:ffff888097ab9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f720eb00 CR3: 000000000e182000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

There is a racing condition between workqueue created when enabling
bearer and another thread created when disabling bearer right after
that as follow:

enabling_bearer                          | disabling_bearer
---------------                          | ----------------
tipc_disc_timeout()                      |
{                                        | bearer_disable()
 ...                                     | {
 schedule_work(&tn->work);               |  tipc_mon_delete()
 ...                                     |  {
}                                        |   ...
                                         |   write_lock_bh(&mon->lock);
                                         |   mon->self = NULL;
                                         |   write_unlock_bh(&mon->lock);
                                         |   ...
                                         |  }
tipc_net_finalize_work()                 | }
{                                        |
 ...                                     |
 tipc_net_finalize()                     |
 {                                       |
  ...                                    |
  tipc_mon_reinit_self()                 |
  {                                      |
   ...                                   |
   write_lock_bh(&mon->lock);            |
   mon->self->addr = tipc_own_addr(net); |
   write_unlock_bh(&mon->lock);          |
   ...                                   |
  }                                      |
  ...                                    |
 }                                       |
 ...                                     |
}                                        |

'mon->self' is set to NULL in disabling_bearer thread and dereferenced
later in enabling_bearer thread.

This commit fixes this issue by validating 'mon->self' before assigning
node address to it.

Reported-by: syzbot+ed60da8d686dc709164c@syzkaller.appspotmail.com
Fixes: 46cb01eeeb86 ("tipc: update mon's self addr when node addr generated")
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250417074826.578115-1-tung.quang.nguyen@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 77a3d016cadec..ddc3e4e5e18d7 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -716,7 +716,8 @@ void tipc_mon_reinit_self(struct net *net)
 		if (!mon)
 			continue;
 		write_lock_bh(&mon->lock);
-		mon->self->addr = tipc_own_addr(net);
+		if (mon->self)
+			mon->self->addr = tipc_own_addr(net);
 		write_unlock_bh(&mon->lock);
 	}
 }
-- 
2.39.5



