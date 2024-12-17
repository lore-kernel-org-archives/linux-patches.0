Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB4D1FC7F1;
	Tue, 17 Dec 2024 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456733; cv=none; b=gMXacCgCFA1mIBeBLIrchvFcfzpva7BrqTbD1Jl/MRQ1cHL/lo+ST5LhsPvzmG6EX7kPL+O/Acst2KQgJcdKtQMGtcchyUBJOWRVuNLcQLIqkLVRV4PgNCpdVLD41k8iVLiJ/2jUyhICXlyd46k1Jn+9nUKhxB1qqBM9rqYRyys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456733; c=relaxed/simple;
	bh=HuPdAK1kKRtRgVFoGQqq5/+R7XjLesBspl2GrnN1K0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8vLV9m+LDDzvKmpOeq21o/A3VHFzuzJpiqfNPe6mwyxC/3OfjpGwhQGEPzrkYSNh9/aBXafykiLqiVpGt/2P5Hd5mwMQDHwFzNB49CLYEzUWTZuNp+t4ByJZMmA/+itLqyDqhTo0JL3HZyqMeB09Uo/DPsQW8G4wZ5EOC83PXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAXfXkrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAXfXkrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BBEC4CEDD;
	Tue, 17 Dec 2024 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456733;
	bh=HuPdAK1kKRtRgVFoGQqq5/+R7XjLesBspl2GrnN1K0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAXfXkrzBxtO+g0+ERH/lmYwYLA4sd4cjx6moDGsIQ8nXPUO6YXabaGRWL9qs2Nep
	 50Fipi4pRpwnykiPAXBxLKK81MtnuJWlE25W5+PP3XTTEbwpVQg1zmYIcG46EiOR+w
	 94tj7gQve3h74JAZPZgkNc8xbPFMQifFTVwcs3UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/172] Bluetooth: iso: Fix circular lock in iso_listen_bis
Date: Tue, 17 Dec 2024 18:08:27 +0100
Message-ID: <20241217170552.592264303@linuxfoundation.org>
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

[ Upstream commit 168e28305b871d8ec604a8f51f35467b8d7ba05b ]

This fixes the circular locking dependency warning below, by
releasing the socket lock before enterning iso_listen_bis, to
avoid any potential deadlock with hdev lock.

[   75.307983] ======================================================
[   75.307984] WARNING: possible circular locking dependency detected
[   75.307985] 6.12.0-rc6+ #22 Not tainted
[   75.307987] ------------------------------------------------------
[   75.307987] kworker/u81:2/2623 is trying to acquire lock:
[   75.307988] ffff8fde1769da58 (sk_lock-AF_BLUETOOTH-BTPROTO_ISO)
               at: iso_connect_cfm+0x253/0x840 [bluetooth]
[   75.308021]
               but task is already holding lock:
[   75.308022] ffff8fdd61a10078 (&hdev->lock)
               at: hci_le_per_adv_report_evt+0x47/0x2f0 [bluetooth]
[   75.308053]
               which lock already depends on the new lock.

[   75.308054]
               the existing dependency chain (in reverse order) is:
[   75.308055]
               -> #1 (&hdev->lock){+.+.}-{3:3}:
[   75.308057]        __mutex_lock+0xad/0xc50
[   75.308061]        mutex_lock_nested+0x1b/0x30
[   75.308063]        iso_sock_listen+0x143/0x5c0 [bluetooth]
[   75.308085]        __sys_listen_socket+0x49/0x60
[   75.308088]        __x64_sys_listen+0x4c/0x90
[   75.308090]        x64_sys_call+0x2517/0x25f0
[   75.308092]        do_syscall_64+0x87/0x150
[   75.308095]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   75.308098]
               -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_ISO){+.+.}-{0:0}:
[   75.308100]        __lock_acquire+0x155e/0x25f0
[   75.308103]        lock_acquire+0xc9/0x300
[   75.308105]        lock_sock_nested+0x32/0x90
[   75.308107]        iso_connect_cfm+0x253/0x840 [bluetooth]
[   75.308128]        hci_connect_cfm+0x6c/0x190 [bluetooth]
[   75.308155]        hci_le_per_adv_report_evt+0x27b/0x2f0 [bluetooth]
[   75.308180]        hci_le_meta_evt+0xe7/0x200 [bluetooth]
[   75.308206]        hci_event_packet+0x21f/0x5c0 [bluetooth]
[   75.308230]        hci_rx_work+0x3ae/0xb10 [bluetooth]
[   75.308254]        process_one_work+0x212/0x740
[   75.308256]        worker_thread+0x1bd/0x3a0
[   75.308258]        kthread+0xe4/0x120
[   75.308259]        ret_from_fork+0x44/0x70
[   75.308261]        ret_from_fork_asm+0x1a/0x30
[   75.308263]
               other info that might help us debug this:

[   75.308264]  Possible unsafe locking scenario:

[   75.308264]        CPU0                CPU1
[   75.308265]        ----                ----
[   75.308265]   lock(&hdev->lock);
[   75.308267]                            lock(sk_lock-
                                                AF_BLUETOOTH-BTPROTO_ISO);
[   75.308268]                            lock(&hdev->lock);
[   75.308269]   lock(sk_lock-AF_BLUETOOTH-BTPROTO_ISO);
[   75.308270]
                *** DEADLOCK ***

[   75.308271] 4 locks held by kworker/u81:2/2623:
[   75.308272]  #0: ffff8fdd66e52148 ((wq_completion)hci0#2){+.+.}-{0:0},
                at: process_one_work+0x443/0x740
[   75.308276]  #1: ffffafb488b7fe48 ((work_completion)(&hdev->rx_work)),
                at: process_one_work+0x1ce/0x740
[   75.308280]  #2: ffff8fdd61a10078 (&hdev->lock){+.+.}-{3:3}
                at: hci_le_per_adv_report_evt+0x47/0x2f0 [bluetooth]
[   75.308304]  #3: ffffffffb6ba4900 (rcu_read_lock){....}-{1:2},
                at: hci_connect_cfm+0x29/0x190 [bluetooth]

Fixes: 02171da6e86a ("Bluetooth: ISO: Add hcon for listening bis sk")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 269ce0bb73a1..809e88fd3fcb 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1129,6 +1129,7 @@ static int iso_listen_bis(struct sock *sk)
 		return -EHOSTUNREACH;
 
 	hci_dev_lock(hdev);
+	lock_sock(sk);
 
 	/* Fail if user set invalid QoS */
 	if (iso_pi(sk)->qos_user_set && !check_bcast_qos(&iso_pi(sk)->qos)) {
@@ -1159,6 +1160,7 @@ static int iso_listen_bis(struct sock *sk)
 	}
 
 unlock:
+	release_sock(sk);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
 	return err;
@@ -1187,6 +1189,7 @@ static int iso_sock_listen(struct socket *sock, int backlog)
 
 	BT_DBG("sk %p backlog %d", sk, backlog);
 
+	sock_hold(sk);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_BOUND) {
@@ -1199,10 +1202,16 @@ static int iso_sock_listen(struct socket *sock, int backlog)
 		goto done;
 	}
 
-	if (!bacmp(&iso_pi(sk)->dst, BDADDR_ANY))
+	if (!bacmp(&iso_pi(sk)->dst, BDADDR_ANY)) {
 		err = iso_listen_cis(sk);
-	else
+	} else {
+		/* Drop sock lock to avoid potential
+		 * deadlock with the hdev lock.
+		 */
+		release_sock(sk);
 		err = iso_listen_bis(sk);
+		lock_sock(sk);
+	}
 
 	if (err)
 		goto done;
@@ -1214,6 +1223,7 @@ static int iso_sock_listen(struct socket *sock, int backlog)
 
 done:
 	release_sock(sk);
+	sock_put(sk);
 	return err;
 }
 
-- 
2.39.5



