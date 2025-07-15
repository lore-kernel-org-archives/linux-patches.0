Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99692E2657;
	Tue, 15 Jul 2025 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585446; cv=none; b=jC+4nGOI8yrQApjPrtacotfqDkON0HcSMsjRhiIEsKcIL/bMQ269KyQh4bLTLQVmVO4xgLJMM4P1xBGmDbLeyHIOd8lpvzGC74k24yfYExFCJIqdWb/oqQXxmuMbwkL0obCH6e2kYUBFQ/eQZ/5KCE6gyChaNopf09EK4BprunY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585446; c=relaxed/simple;
	bh=fJETfnQWO4kRzP/kWxdqn+fk/v8jtKlf1gczHMKuNgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9EqZAei11lWDJ8mzx1KNDqyRxCZD/Gjkzqx3Zlv7H8W8mgAK4c0P9bOnAQPmoXBG8xUZWFjmifJvd5BcFlPM+/diRrd8RsbuQZtrkoYHvLlD79RiZ4UIGtzPuBat+iDdJvMnWpE7AbXhZSHoz8FRFCAk2i8qzs8dAKfQ4DzMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xT4Uas2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xT4Uas2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE8CC4CEF7;
	Tue, 15 Jul 2025 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585446;
	bh=fJETfnQWO4kRzP/kWxdqn+fk/v8jtKlf1gczHMKuNgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xT4Uas2U/FHmGslt0yXqaiXwLdpHcGepZZ5TXtAgxOBLvI9e6uabZBRu7N0+adGaw
	 3Sv47GyIZqzv16JfJewolifUiLicWuVJH+s7aiHG3r+1ZTBGgVCxQ5TZuHPBRATX4+
	 wK+NvBb4sZpvnoZ/gqxZzEbywY4ZBEq5l5ezv5n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e34e5e6b5eddb0014def@syzkaller.appspotmail.com,
	Yue Haibing <yuehaibing@huawei.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/163] atm: clip: Fix NULL pointer dereference in vcc_sendmsg()
Date: Tue, 15 Jul 2025 15:11:51 +0200
Message-ID: <20250715130810.491091736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 22fc46cea91df3dce140a7dc6847c6fcf0354505 ]

atmarpd_dev_ops does not implement the send method, which may cause crash
as bellow.

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: Oops: 0010 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted 6.15.0-rc6-syzkaller-00346-g5723cc3450bc #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000d3cf778 EFLAGS: 00010246
RAX: 1ffffffff1910dd1 RBX: 00000000000000c0 RCX: dffffc0000000000
RDX: ffffc9000dc82000 RSI: ffff88803e4c4640 RDI: ffff888052cd0000
RBP: ffffc9000d3cf8d0 R08: ffff888052c9143f R09: 1ffff1100a592287
R10: dffffc0000000000 R11: 0000000000000000 R12: 1ffff92001a79f00
R13: ffff888052cd0000 R14: ffff88803e4c4640 R15: ffffffff8c886e88
FS:  00007fbc762566c0(0000) GS:ffff88808d6c2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000041f1b000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vcc_sendmsg+0xa10/0xc50 net/atm/common.c:644
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:727
 ____sys_sendmsg+0x52d/0x830 net/socket.c:2566
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
 __sys_sendmmsg+0x227/0x430 net/socket.c:2709
 __do_sys_sendmmsg net/socket.c:2736 [inline]
 __se_sys_sendmmsg net/socket.c:2733 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2733
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+e34e5e6b5eddb0014def@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/682f82d5.a70a0220.1765ec.0143.GAE@google.com/T
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250705085228.329202-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/clip.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index 0baade6febed8..ebba0d6ae3248 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -632,8 +632,16 @@ static void atmarpd_close(struct atm_vcc *vcc)
 	module_put(THIS_MODULE);
 }
 
+static int atmarpd_send(struct atm_vcc *vcc, struct sk_buff *skb)
+{
+	atm_return_tx(vcc, skb);
+	dev_kfree_skb_any(skb);
+	return 0;
+}
+
 static const struct atmdev_ops atmarpd_dev_ops = {
-	.close = atmarpd_close
+	.close = atmarpd_close,
+	.send = atmarpd_send
 };
 
 
-- 
2.39.5



