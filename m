Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CC239B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302580; cv=none; b=QBWvUvZA2BTkPNz05/4y/TsI2dzDRxw2eOst1Hp+bNqUZhGwev6P6GlmIn7ahdzQG7RQmk3RYMjijtrxRjOTkP7+Tp8gn6Dm5ZTgAJ/lwzb9aLH1aqy88ORMNNfm4/CqoBhGK8CdCDvi66C7++7SvSWO/eB43M2prZUMTPS+NoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302580; c=relaxed/simple;
	bh=/Xtw64qXi+JDk2X2tdB9KVpochUlK5bbxv1rnFqeaxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN1aiMGFd5BVYm3WSpNslIPevehQgnM6n5kJe/zJ29tDddmQUyVmkYMemFi4l6Hd+dZ9pfwIymoxu7aD8g/ZbSTlgYQC2tBAZ5WYrRMNPNRUNYDHpqYSVSyFcKDXpaRYJXfyPfL0v5PwIXnylkTGzOADz39AtwFG8CVHnZOGjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vt7yK07O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vt7yK07O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA62FC19423;
	Sat, 28 Feb 2026 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302580;
	bh=/Xtw64qXi+JDk2X2tdB9KVpochUlK5bbxv1rnFqeaxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt7yK07O8pPyGq0ZuMI64et0BpSmAUcyTtC8+q3Jl7lMn16+15CmYCTvSgEBGKs/C
	 fd/yZRFeNuj7rY1ZDOF2spgjLErAzEGIvinyE/gzx/aV1fIlG1bypqe83NpdjFI9mY
	 OiwuCHepyy/Ukv24xTugtqL55ykP8S9zsqLeresBrLfchUNs/vXCmjPSmaihhRDHCr
	 LLPm1edJ+2Z5+DMbkZLK+N2qaOYg7dFyI3Xt90vazQz6FILUboN9ZJTeLT8Sssx7yA
	 vip+k7dY/USFzNKjbLpowkrqoeqtY7acZ7D4jb+AEK6LSaNVv5bMXhVdY2k8oFuZOQ
	 YZhpEmmAp0cJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+827272712bd6d12c79a4@syzkaller.appspotmail.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/164] serial: caif: fix use-after-free in caif_serial ldisc_close()
Date: Sat, 28 Feb 2026 13:13:47 -0500
Message-ID: <20260228181505.1600663-88-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 308e7e4d0a846359685f40aade023aee7b27284c ]

There is a use-after-free bug in caif_serial where handle_tx() may
access ser->tty after the tty has been freed.

The race condition occurs between ldisc_close() and packet transmission:

    CPU 0 (close)                     CPU 1 (xmit)
    -------------                     ------------
    ldisc_close()
      tty_kref_put(ser->tty)
      [tty may be freed here]
                     <-- race window -->
                                      caif_xmit()
                                        handle_tx()
                                          tty = ser->tty  // dangling ptr
                                          tty->ops->write() // UAF!
      schedule_work()
        ser_release()
          unregister_netdevice()

The root cause is that tty_kref_put() is called in ldisc_close() while
the network device is still active and can receive packets.

Since ser and tty have a 1:1 binding relationship with consistent
lifecycles (ser is allocated in ldisc_open and freed in ser_release
via unregister_netdevice, and each ser binds exactly one tty), we can
safely defer the tty reference release to ser_release() where the
network device is unregistered.

Fix this by moving tty_kref_put() from ldisc_close() to ser_release(),
after unregister_netdevice(). This ensures the tty reference is held
as long as the network device exists, preventing the UAF.

Note: We save ser->tty before unregister_netdevice() because ser is
embedded in netdev's private data and will be freed along with netdev
(needs_free_netdev = true).

How to reproduce: Add mdelay(500) at the beginning of ldisc_close()
to widen the race window, then run the reproducer program [1].

Note: There is a separate deadloop issue in handle_tx() when using
PORT_UNKNOWN serial ports (e.g., /dev/ttyS3 in QEMU without proper
serial backend). This deadloop exists even without this patch,
and is likely caused by inconsistency between uart_write_room() and
uart_write() in serial core. It has been addressed in a separate
patch [2].

KASAN report:

==================================================================
BUG: KASAN: slab-use-after-free in handle_tx+0x5d1/0x620
Read of size 1 at addr ffff8881131e1490 by task caif_uaf_trigge/9929

Call Trace:
 <TASK>
 dump_stack_lvl+0x10e/0x1f0
 print_report+0xd0/0x630
 kasan_report+0xe4/0x120
 handle_tx+0x5d1/0x620
 dev_hard_start_xmit+0x9d/0x6c0
 __dev_queue_xmit+0x6e2/0x4410
 packet_xmit+0x243/0x360
 packet_sendmsg+0x26cf/0x5500
 __sys_sendto+0x4a3/0x520
 __x64_sys_sendto+0xe0/0x1c0
 do_syscall_64+0xc9/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f615df2c0d7

Allocated by task 9930:

Freed by task 64:

Last potentially related work creation:

The buggy address belongs to the object at ffff8881131e1000
 which belongs to the cache kmalloc-cg-2k of size 2048
The buggy address is located 1168 bytes inside of
 freed 2048-byte region [ffff8881131e1000, ffff8881131e1800)

The buggy address belongs to the physical page:
page_owner tracks the page as allocated
page last free pid 9778 tgid 9778 stack trace:

Memory state around the buggy address:
 ffff8881131e1380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881131e1400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881131e1480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8881131e1500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881131e1580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
[1]: https://gist.github.com/mrpre/f683f244544f7b11e7fa87df9e6c2eeb
[2]: https://lore.kernel.org/linux-serial/20260204074327.226165-1-jiayuan.chen@linux.dev/T/#u

Reported-by: syzbot+827272712bd6d12c79a4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000a4a7550611e234f5@google.com/T/
Fixes: 56e0ef527b18 ("drivers/net: caif: fix wrong rtnl_is_locked() usage")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260206074450.154267-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 2a7af611d43a5..90b4820486990 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -298,6 +298,7 @@ static void ser_release(struct work_struct *work)
 {
 	struct list_head list;
 	struct ser_device *ser, *tmp;
+	struct tty_struct *tty;
 
 	spin_lock(&ser_lock);
 	list_replace_init(&ser_release_list, &list);
@@ -306,9 +307,11 @@ static void ser_release(struct work_struct *work)
 	if (!list_empty(&list)) {
 		rtnl_lock();
 		list_for_each_entry_safe(ser, tmp, &list, node) {
+			tty = ser->tty;
 			dev_close(ser->dev);
 			unregister_netdevice(ser->dev);
 			debugfs_deinit(ser);
+			tty_kref_put(tty);
 		}
 		rtnl_unlock();
 	}
@@ -369,8 +372,6 @@ static void ldisc_close(struct tty_struct *tty)
 {
 	struct ser_device *ser = tty->disc_data;
 
-	tty_kref_put(ser->tty);
-
 	spin_lock(&ser_lock);
 	list_move(&ser->node, &ser_release_list);
 	spin_unlock(&ser_lock);
-- 
2.51.0

