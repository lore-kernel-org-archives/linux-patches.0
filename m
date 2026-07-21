Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C29B39A7FE;
	Tue, 21 Jul 2026 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658207; cv=none; b=d3l60bp3xQAD0dzeHYiDfR1+nKzwPZqcwOLricZ0U4qWoaoywJ2tgyzo6k9/R/W2SJYLvjKb/BknF/TlR3BE4EeN9NvAf3cuYi4xUf0tKlV6Noz/ycuG3++FwdDtGNWEfr8LhSwsCIOGWYAp11h8/6rRN/MEh/woHjjg4MpBBis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658207; c=relaxed/simple;
	bh=czxrl+Mc4RwvLJBnWd6W4BO0aPELq9J05jdxLBglwS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh+e0I6GvyBGm7NkxQDHKwT27F2ZfldX4fs/KhdCoXlicQgBWhltjC9EgTbMmSWLPSX3Wnzu2G6vClerfnf2BU5jG3kmVCYRxFb7uO/sMPvdIpwUe86lhuPPQgr2hsngT8pBXymX6PYv4wgz2nNjTcGlh1AvPMM4QuRfIWZ8Hc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMv6su0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMv6su0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18171F00A3A;
	Tue, 21 Jul 2026 18:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658206;
	bh=AO46m3gHEOn8/RxAmL2peJ3RgqKYggoi55e4/JxwplI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMv6su0xhrvclLIVeCBFxVQeu+Fzke40d0jPk66ZM+z8YIg7o6ADkZf/AkSl53XUo
	 nVb1QEJStxLqnl12PrTDHPt65gSastNdqybWYg+ZAUpgmhqBpTYrKZJto4b63yegzx
	 y2gaygslJafJA876DSLM9SS8OlrgTM8SdMepplXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Tian <daveti@purdue.edu>,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1055/1611] Bluetooth: sco: Fix a race condition in sco_sock_timeout()
Date: Tue, 21 Jul 2026 17:19:31 +0200
Message-ID: <20260721152539.136864247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit 0f8a5dcc66648b6e1458a9f3ba4c5a0463a228fc ]

sco_sock_timeout() runs asynchronously and lock_sock(sk). If the socket
is closing while the timer is running, it holds the same lock
(lock_sock(sk)) twice, leading to a deadlock.

CPU 0                      CPU 1
====================       ======================
sco_sock_close()
                           sco_sock_timeout()
lock_sock(sk) // <-- LOCK
  __sco_sock_close()
    sco_chan_del()
      sco_conn_put()
	      sco_conn_free()
	        disable_delayed_work_sync()
	                           lock(sk) // <-- SAME LOCK

Fix this by moving disable_delayed_work_sync() outside of lock_sock(sk),
ensuring that no lock_sock(sk) is held before sco_sock_timeout().

Lockdep splat:

WARNING: possible circular locking dependency detected
6.13.0-rc4 #7 Not tainted

syz-executor292/9514 is trying to acquire lock:
ffff8881115d5070 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: rcu_lock_acquire sect/v6.13-rc4/./include/linux/rcupdate.h:337 [inline]
ffff8881115d5070 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: rcu_read_lock sect/v6.13-rc4/./include/linux/rcupdate.h:849 [inline]
ffff8881115d5070 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: start_flush_work sect/v6.13-rc4/kernel/workqueue.c:4137 [inline]
ffff8881115d5070 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}, at: __flush_work+0xd1/0xc40 sect/v6.13-rc4/kernel/workqueue.c:4195

but task is already holding lock:
ffff88807db3a258 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at: lock_sock sect/v6.13-rc4/./include/net/sock.h:1623 [inline]
ffff88807db3a258 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at: sco_sock_close+0x25/0x100 sect/v6.13-rc4/net/bluetooth/sco.c:524

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}:
       lock_acquire+0x1c4/0x520 sect/v6.13-rc4/kernel/locking/lockdep.c:5849
       lock_sock_nested+0x48/0x130 sect/v6.13-rc4/net/core/sock.c:3622
       lock_sock sect/v6.13-rc4/./include/net/sock.h:1623 [inline]
       sco_sock_timeout+0xbe/0x270 sect/v6.13-rc4/net/bluetooth/sco.c:158
       process_one_work sect/v6.13-rc4/kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa99/0x18f0 sect/v6.13-rc4/kernel/workqueue.c:3310
       worker_thread+0x8a9/0xd80 sect/v6.13-rc4/kernel/workqueue.c:3391
       kthread+0x2c6/0x360 sect/v6.13-rc4/kernel/kthread.c:389
       ret_from_fork+0x4e/0x80 sect/v6.13-rc4/arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 sect/v6.13-rc4/arch/x86/entry/entry_64.S:244

-> #0 ((work_completion)(&(&conn->timeout_work)->work)){+.+.}-{0:0}:
       check_prev_add sect/v6.13-rc4/kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add sect/v6.13-rc4/kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x1888/0x5760 sect/v6.13-rc4/kernel/locking/lockdep.c:3904
       __lock_acquire+0x13b4/0x2120 sect/v6.13-rc4/kernel/locking/lockdep.c:5226
       lock_acquire+0x1c4/0x520 sect/v6.13-rc4/kernel/locking/lockdep.c:5849
       touch_work_lockdep_map sect/v6.13-rc4/kernel/workqueue.c:3909 [inline]
       start_flush_work sect/v6.13-rc4/kernel/workqueue.c:4163 [inline]
       __flush_work+0x70f/0xc40 sect/v6.13-rc4/kernel/workqueue.c:4195
       __cancel_work_sync sect/v6.13-rc4/kernel/workqueue.c:4351 [inline]
       disable_delayed_work_sync+0xbb/0xf0 sect/v6.13-rc4/kernel/workqueue.c:4514
       sco_conn_free sect/v6.13-rc4/net/bluetooth/sco.c:95 [inline]
       kref_put sect/v6.13-rc4/./include/linux/kref.h:65 [inline]
       sco_conn_put+0x18f/0x270 sect/v6.13-rc4/net/bluetooth/sco.c:107
       sco_chan_del+0xe2/0x210 sect/v6.13-rc4/net/bluetooth/sco.c:236
       sco_sock_close+0x8f/0x100 sect/v6.13-rc4/net/bluetooth/sco.c:526
       sco_sock_release+0x62/0x2d0 sect/v6.13-rc4/net/bluetooth/sco.c:1300
       __sock_release+0xe1/0x2d0 sect/v6.13-rc4/net/socket.c:640
       sock_close+0x1c/0x30 sect/v6.13-rc4/net/socket.c:1408
       __fput+0x2bd/0xa80 sect/v6.13-rc4/fs/file_table.c:450
       __fput_sync+0x15e/0x1c0 sect/v6.13-rc4/fs/file_table.c:535
       __do_sys_close sect/v6.13-rc4/fs/open.c:1554 [inline]
       __se_sys_close sect/v6.13-rc4/fs/open.c:1539 [inline]
       __x64_sys_close+0x93/0x120 sect/v6.13-rc4/fs/open.c:1539
       do_syscall_x64 sect/v6.13-rc4/arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xee/0x210 sect/v6.13-rc4/arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: e6720779ae61 ("Bluetooth: SCO: Use kref to track lifetime of sco_conn")
Acked-by: Dave Tian <daveti@purdue.edu>
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index a19ae1b39bc02f..15b9c234bce106 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -566,10 +566,23 @@ static void __sco_sock_close(struct sock *sk)
 /* Must be called on unlocked socket. */
 static void sco_sock_close(struct sock *sk)
 {
+	struct sco_conn *conn;
+
+	lock_sock(sk);
+	conn = sco_pi(sk)->conn;
+	if (conn)
+		sco_conn_hold(conn);
+	release_sock(sk);
+
+	if (conn)
+		disable_delayed_work_sync(&conn->timeout_work);
+
 	lock_sock(sk);
-	sco_sock_clear_timer(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
+
+	if (conn)
+		sco_conn_put(conn);
 }
 
 static void sco_sock_init(struct sock *sk, struct sock *parent)
-- 
2.53.0



