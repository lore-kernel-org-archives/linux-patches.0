Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4981F8F16;
	Tue, 17 Dec 2024 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456740; cv=none; b=HWCWJ3ais3wzrUj3wgPhHlhuejVmvwP0lzVmh329OBFVo2Dx8uEEhtOjP+oCz9p22py+vaeYJuqbP6CpQ56FUWBM+JfRcTqrzIeKJKl0OZDfF1EkH+Ctmg9hmp/UUtTFzTKUVD5ACny72bxlgvsrdEUw7dMM5P4YIb7Bhaq+KOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456740; c=relaxed/simple;
	bh=ugHlXcEckKn7PmZ4urfYRK/1swh3BkCA5CN3kJ0v8fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geXQOtoyIdl7LPZxIg/0Q7YB88Xb+TvxZ5ER9svrCUcIzsh67wPpJQBKIqb22MyLhBVwxjfETgcE39A6CGM+zbP0riD1X7fKPHNPQfYa8ChwSpuedFcxY9yapcGuWgzvYWLYXMNAhbSCToFtCgB0tNf4Fn1xFwoS9l5p99rKcFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmfWQbz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmfWQbz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893FAC4CED3;
	Tue, 17 Dec 2024 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456740;
	bh=ugHlXcEckKn7PmZ4urfYRK/1swh3BkCA5CN3kJ0v8fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmfWQbz0JsUdYjxqO7SwVDDI0UvB0aSNQrTgJq5O7pyoAIlNHFqrLBKalRsjGt6tK
	 lA8e3PWWk91ATOzCwXmes3W+ObZNgpqiOkrW8UyXnYixF72CETVSteKk3tVDBs5ROR
	 jrrVXqXlcInsHlJSi24rGwhkA7RH9KliI4Oo/C34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/172] Bluetooth: iso: Fix circular lock in iso_conn_big_sync
Date: Tue, 17 Dec 2024 18:08:28 +0100
Message-ID: <20241217170552.631719590@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 7a17308c17880d259105f6e591eb1bc77b9612f0 ]

This fixes the circular locking dependency warning below, by reworking
iso_sock_recvmsg, to ensure that the socket lock is always released
before calling a function that locks hdev.

[  561.670344] ======================================================
[  561.670346] WARNING: possible circular locking dependency detected
[  561.670349] 6.12.0-rc6+ #26 Not tainted
[  561.670351] ------------------------------------------------------
[  561.670353] iso-tester/3289 is trying to acquire lock:
[  561.670355] ffff88811f600078 (&hdev->lock){+.+.}-{3:3},
               at: iso_conn_big_sync+0x73/0x260 [bluetooth]
[  561.670405]
               but task is already holding lock:
[  561.670407] ffff88815af58258 (sk_lock-AF_BLUETOOTH){+.+.}-{0:0},
               at: iso_sock_recvmsg+0xbf/0x500 [bluetooth]
[  561.670450]
               which lock already depends on the new lock.

[  561.670452]
               the existing dependency chain (in reverse order) is:
[  561.670453]
               -> #2 (sk_lock-AF_BLUETOOTH){+.+.}-{0:0}:
[  561.670458]        lock_acquire+0x7c/0xc0
[  561.670463]        lock_sock_nested+0x3b/0xf0
[  561.670467]        bt_accept_dequeue+0x1a5/0x4d0 [bluetooth]
[  561.670510]        iso_sock_accept+0x271/0x830 [bluetooth]
[  561.670547]        do_accept+0x3dd/0x610
[  561.670550]        __sys_accept4+0xd8/0x170
[  561.670553]        __x64_sys_accept+0x74/0xc0
[  561.670556]        x64_sys_call+0x17d6/0x25f0
[  561.670559]        do_syscall_64+0x87/0x150
[  561.670563]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  561.670567]
               -> #1 (sk_lock-AF_BLUETOOTH-BTPROTO_ISO){+.+.}-{0:0}:
[  561.670571]        lock_acquire+0x7c/0xc0
[  561.670574]        lock_sock_nested+0x3b/0xf0
[  561.670577]        iso_sock_listen+0x2de/0xf30 [bluetooth]
[  561.670617]        __sys_listen_socket+0xef/0x130
[  561.670620]        __x64_sys_listen+0xe1/0x190
[  561.670623]        x64_sys_call+0x2517/0x25f0
[  561.670626]        do_syscall_64+0x87/0x150
[  561.670629]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  561.670632]
               -> #0 (&hdev->lock){+.+.}-{3:3}:
[  561.670636]        __lock_acquire+0x32ad/0x6ab0
[  561.670639]        lock_acquire.part.0+0x118/0x360
[  561.670642]        lock_acquire+0x7c/0xc0
[  561.670644]        __mutex_lock+0x18d/0x12f0
[  561.670647]        mutex_lock_nested+0x1b/0x30
[  561.670651]        iso_conn_big_sync+0x73/0x260 [bluetooth]
[  561.670687]        iso_sock_recvmsg+0x3e9/0x500 [bluetooth]
[  561.670722]        sock_recvmsg+0x1d5/0x240
[  561.670725]        sock_read_iter+0x27d/0x470
[  561.670727]        vfs_read+0x9a0/0xd30
[  561.670731]        ksys_read+0x1a8/0x250
[  561.670733]        __x64_sys_read+0x72/0xc0
[  561.670736]        x64_sys_call+0x1b12/0x25f0
[  561.670738]        do_syscall_64+0x87/0x150
[  561.670741]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  561.670744]
               other info that might help us debug this:

[  561.670745] Chain exists of:
&hdev->lock --> sk_lock-AF_BLUETOOTH-BTPROTO_ISO --> sk_lock-AF_BLUETOOTH

[  561.670751]  Possible unsafe locking scenario:

[  561.670753]        CPU0                    CPU1
[  561.670754]        ----                    ----
[  561.670756]   lock(sk_lock-AF_BLUETOOTH);
[  561.670758]                                lock(sk_lock
                                              AF_BLUETOOTH-BTPROTO_ISO);
[  561.670761]                                lock(sk_lock-AF_BLUETOOTH);
[  561.670764]   lock(&hdev->lock);
[  561.670767]
                *** DEADLOCK ***

Fixes: 07a9342b94a9 ("Bluetooth: ISO: Send BIG Create Sync via hci_sync")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 809e88fd3fcb..644b606743e2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1411,6 +1411,7 @@ static void iso_conn_big_sync(struct sock *sk)
 	 * change.
 	 */
 	hci_dev_lock(hdev);
+	lock_sock(sk);
 
 	if (!test_and_set_bit(BT_SK_BIG_SYNC, &iso_pi(sk)->flags)) {
 		err = hci_le_big_create_sync(hdev, iso_pi(sk)->conn->hcon,
@@ -1423,6 +1424,7 @@ static void iso_conn_big_sync(struct sock *sk)
 				   err);
 	}
 
+	release_sock(sk);
 	hci_dev_unlock(hdev);
 }
 
@@ -1431,39 +1433,57 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct iso_pinfo *pi = iso_pi(sk);
+	bool early_ret = false;
+	int err = 0;
 
 	BT_DBG("sk %p", sk);
 
 	if (test_and_clear_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
+		sock_hold(sk);
 		lock_sock(sk);
+
 		switch (sk->sk_state) {
 		case BT_CONNECT2:
 			if (test_bit(BT_SK_PA_SYNC, &pi->flags)) {
+				release_sock(sk);
 				iso_conn_big_sync(sk);
+				lock_sock(sk);
+
 				sk->sk_state = BT_LISTEN;
 			} else {
 				iso_conn_defer_accept(pi->conn->hcon);
 				sk->sk_state = BT_CONFIG;
 			}
-			release_sock(sk);
-			return 0;
+
+			early_ret = true;
+			break;
 		case BT_CONNECTED:
 			if (test_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags)) {
+				release_sock(sk);
 				iso_conn_big_sync(sk);
+				lock_sock(sk);
+
 				sk->sk_state = BT_LISTEN;
-				release_sock(sk);
-				return 0;
+				early_ret = true;
 			}
 
-			release_sock(sk);
 			break;
 		case BT_CONNECT:
 			release_sock(sk);
-			return iso_connect_cis(sk);
+			err = iso_connect_cis(sk);
+			lock_sock(sk);
+
+			early_ret = true;
+			break;
 		default:
-			release_sock(sk);
 			break;
 		}
+
+		release_sock(sk);
+		sock_put(sk);
+
+		if (early_ret)
+			return err;
 	}
 
 	return bt_sock_recvmsg(sock, msg, len, flags);
-- 
2.39.5



