Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB41494DB;
	Thu,  5 Sep 2024 10:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530696; cv=none; b=bACqrRWUtZXOQGYfuKHK6MVFYT0HjHYtXajUcotGGscHK2DLqw1oUbOConLEpwSBIKQfZCtTVr1YeMY2yDKbost5fa1i9t1ykXQEfMPJqUkx6IOFeDw+K2xfoXfrcvy7k0yPHneQ3ccKNNK9f4RkVZsxR/pA7iN2jwzkyAPoieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530696; c=relaxed/simple;
	bh=iT1gwhw5hv92AUB0jLT3gff/lgF865d5r73hCneGCOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTApYfGWL78t5NjkyAZuqpoPEfzWbffkI1brO0nIa6/dYiBaPtfHPZyL1oke5FvuIOSE5qDoTK2/QGF9UWFbq1gO8vaVtS0SbKG8GodM3OZLuX/mU+CapJqw5pH3zAzEEIWa0v1oRgSfejc8lYpzB62oAmVbYnVne9+yOBFkJwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6pKHIhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6pKHIhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4669C4CEC3;
	Thu,  5 Sep 2024 10:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530696;
	bh=iT1gwhw5hv92AUB0jLT3gff/lgF865d5r73hCneGCOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6pKHIhZ25Wnx4xnllU+jOAhiJ4RBcUu80NFPyDCGBTCvq5ip74oEeBCdE9uABBHT
	 SWjmJhrMVxKT0kHSJuSt49nDJWjM21MyICozOR+zzpeLJHZ7I+SMPwjSLbtcGjkMbf
	 ATPPjirSJcy22esYt6x6te/53FnX85/Shymmhcl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 095/101] Bluetooth: SCO: Fix possible circular locking dependency on sco_connect_cfm
Date: Thu,  5 Sep 2024 11:42:07 +0200
Message-ID: <20240905093719.839986185@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 9a8ec9e8ebb5a7c0cfbce2d6b4a6b67b2b78e8f3 upstream.

This attempts to fix the following trace:

======================================================
WARNING: possible circular locking dependency detected
6.3.0-rc2-g0b93eeba4454 #4703 Not tainted
------------------------------------------------------
kworker/u3:0/46 is trying to acquire lock:
ffff888001fd9130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at:
sco_connect_cfm+0x118/0x4a0

but task is already holding lock:
ffffffff831e3340 (hci_cb_list_lock){+.+.}-{3:3}, at:
hci_sync_conn_complete_evt+0x1ad/0x3d0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (hci_cb_list_lock){+.+.}-{3:3}:
       __mutex_lock+0x13b/0xcc0
       hci_sync_conn_complete_evt+0x1ad/0x3d0
       hci_event_packet+0x55c/0x7c0
       hci_rx_work+0x34c/0xa00
       process_one_work+0x575/0x910
       worker_thread+0x89/0x6f0
       kthread+0x14e/0x180
       ret_from_fork+0x2b/0x50

-> #1 (&hdev->lock){+.+.}-{3:3}:
       __mutex_lock+0x13b/0xcc0
       sco_sock_connect+0xfc/0x630
       __sys_connect+0x197/0x1b0
       __x64_sys_connect+0x37/0x50
       do_syscall_64+0x42/0x90
       entry_SYSCALL_64_after_hwframe+0x70/0xda

-> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}:
       __lock_acquire+0x18cc/0x3740
       lock_acquire+0x151/0x3a0
       lock_sock_nested+0x32/0x80
       sco_connect_cfm+0x118/0x4a0
       hci_sync_conn_complete_evt+0x1e6/0x3d0
       hci_event_packet+0x55c/0x7c0
       hci_rx_work+0x34c/0xa00
       process_one_work+0x575/0x910
       worker_thread+0x89/0x6f0
       kthread+0x14e/0x180
       ret_from_fork+0x2b/0x50

other info that might help us debug this:

Chain exists of:
  sk_lock-AF_BLUETOOTH-BTPROTO_SCO --> &hdev->lock --> hci_cb_list_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(hci_cb_list_lock);
                               lock(&hdev->lock);
                               lock(hci_cb_list_lock);
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

4 locks held by kworker/u3:0/46:
 #0: ffff8880028d1130 ((wq_completion)hci0#2){+.+.}-{0:0}, at:
 process_one_work+0x4c0/0x910
 #1: ffff8880013dfde0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0},
 at: process_one_work+0x4c0/0x910
 #2: ffff8880025d8070 (&hdev->lock){+.+.}-{3:3}, at:
 hci_sync_conn_complete_evt+0xa6/0x3d0
 #3: ffffffffb79e3340 (hci_cb_list_lock){+.+.}-{3:3}, at:
 hci_sync_conn_complete_evt+0x1ad/0x3d0

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   69 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 29 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -239,27 +239,41 @@ static int sco_chan_add(struct sco_conn
 	return err;
 }
 
-static int sco_connect(struct hci_dev *hdev, struct sock *sk)
+static int sco_connect(struct sock *sk)
 {
 	struct sco_conn *conn;
 	struct hci_conn *hcon;
+	struct hci_dev  *hdev;
 	int err, type;
 
 	BT_DBG("%pMR -> %pMR", &sco_pi(sk)->src, &sco_pi(sk)->dst);
 
+	hdev = hci_get_route(&sco_pi(sk)->dst, &sco_pi(sk)->src, BDADDR_BREDR);
+	if (!hdev)
+		return -EHOSTUNREACH;
+
+	hci_dev_lock(hdev);
+
 	if (lmp_esco_capable(hdev) && !disable_esco)
 		type = ESCO_LINK;
 	else
 		type = SCO_LINK;
 
 	if (sco_pi(sk)->setting == BT_VOICE_TRANSPARENT &&
-	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev)))
-		return -EOPNOTSUPP;
+	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev))) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
 
 	hcon = hci_connect_sco(hdev, type, &sco_pi(sk)->dst,
 			       sco_pi(sk)->setting, &sco_pi(sk)->codec);
-	if (IS_ERR(hcon))
-		return PTR_ERR(hcon);
+	if (IS_ERR(hcon)) {
+		err = PTR_ERR(hcon);
+		goto unlock;
+	}
+
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	conn = sco_conn_add(hcon);
 	if (!conn) {
@@ -267,13 +281,15 @@ static int sco_connect(struct hci_dev *h
 		return -ENOMEM;
 	}
 
-	/* Update source addr of the socket */
-	bacpy(&sco_pi(sk)->src, &hcon->src);
-
 	err = sco_chan_add(conn, sk, NULL);
 	if (err)
 		return err;
 
+	lock_sock(sk);
+
+	/* Update source addr of the socket */
+	bacpy(&sco_pi(sk)->src, &hcon->src);
+
 	if (hcon->state == BT_CONNECTED) {
 		sco_sock_clear_timer(sk);
 		sk->sk_state = BT_CONNECTED;
@@ -282,6 +298,13 @@ static int sco_connect(struct hci_dev *h
 		sco_sock_set_timer(sk, sk->sk_sndtimeo);
 	}
 
+	release_sock(sk);
+
+	return err;
+
+unlock:
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 	return err;
 }
 
@@ -561,7 +584,6 @@ static int sco_sock_connect(struct socke
 {
 	struct sockaddr_sco *sa = (struct sockaddr_sco *) addr;
 	struct sock *sk = sock->sk;
-	struct hci_dev  *hdev;
 	int err;
 
 	BT_DBG("sk %p", sk);
@@ -570,37 +592,26 @@ static int sco_sock_connect(struct socke
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
-	lock_sock(sk);
-	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
-		err = -EBADFD;
-		goto done;
-	}
+	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND)
+		return -EBADFD;
 
-	if (sk->sk_type != SOCK_SEQPACKET) {
+	if (sk->sk_type != SOCK_SEQPACKET)
 		err = -EINVAL;
-		goto done;
-	}
-
-	hdev = hci_get_route(&sa->sco_bdaddr, &sco_pi(sk)->src, BDADDR_BREDR);
-	if (!hdev) {
-		err = -EHOSTUNREACH;
-		goto done;
-	}
-	hci_dev_lock(hdev);
 
+	lock_sock(sk);
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
+	release_sock(sk);
 
-	err = sco_connect(hdev, sk);
-	hci_dev_unlock(hdev);
-	hci_dev_put(hdev);
+	err = sco_connect(sk);
 	if (err)
-		goto done;
+		return err;
+
+	lock_sock(sk);
 
 	err = bt_sock_wait_state(sk, BT_CONNECTED,
 				 sock_sndtimeo(sk, flags & O_NONBLOCK));
 
-done:
 	release_sock(sk);
 	return err;
 }


