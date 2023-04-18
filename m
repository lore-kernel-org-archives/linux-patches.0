Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273EE2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ECAC433D2;
	Tue, 18 Apr 2023 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822195;
	bh=gDlxUZ1mPVhgwJcnDzU2x4Mp65YZFnSvOCftdKJLIog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eB8l/RcYjCaeaNvQ0mw2qlZRQWgyzeG+7jzf7sr1adSNERoCjQSrCivZdWi32rkx+
	 21tsolndrxHPknp5OnOBeFiFq9Ee6iRcb5UlFL2wCgQ5I9ocJZHCwv9mBWvcwh/MnE
	 HBk6V3aPsHJ4DWRmW3/0IJzhLwmR48nCmxs5BAaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 058/139] Bluetooth: SCO: Fix possible circular locking dependency sco_sock_getsockopt
Date: Tue, 18 Apr 2023 14:22:03 +0200
Message-Id: <20230418120315.943440248@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 975abc0c90fc485ff9b4a6afa475c3b1398d5d47 ]

This attempts to fix the following trace:

======================================================
WARNING: possible circular locking dependency detected
6.3.0-rc2-g68fcb3a7bf97 #4706 Not tainted
------------------------------------------------------
sco-tester/31 is trying to acquire lock:
ffff8880025b8070 (&hdev->lock){+.+.}-{3:3}, at:
sco_sock_getsockopt+0x1fc/0xa90

but task is already holding lock:
ffff888001eeb130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}, at:
sco_sock_getsockopt+0x104/0xa90

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0}:
       lock_sock_nested+0x32/0x80
       sco_connect_cfm+0x118/0x4a0
       hci_sync_conn_complete_evt+0x1e6/0x3d0
       hci_event_packet+0x55c/0x7c0
       hci_rx_work+0x34c/0xa00
       process_one_work+0x575/0x910
       worker_thread+0x89/0x6f0
       kthread+0x14e/0x180
       ret_from_fork+0x2b/0x50

-> #1 (hci_cb_list_lock){+.+.}-{3:3}:
       __mutex_lock+0x13b/0xcc0
       hci_sync_conn_complete_evt+0x1ad/0x3d0
       hci_event_packet+0x55c/0x7c0
       hci_rx_work+0x34c/0xa00
       process_one_work+0x575/0x910
       worker_thread+0x89/0x6f0
       kthread+0x14e/0x180
       ret_from_fork+0x2b/0x50

-> #0 (&hdev->lock){+.+.}-{3:3}:
       __lock_acquire+0x18cc/0x3740
       lock_acquire+0x151/0x3a0
       __mutex_lock+0x13b/0xcc0
       sco_sock_getsockopt+0x1fc/0xa90
       __sys_getsockopt+0xe9/0x190
       __x64_sys_getsockopt+0x5b/0x70
       do_syscall_64+0x42/0x90
       entry_SYSCALL_64_after_hwframe+0x70/0xda

other info that might help us debug this:

Chain exists of:
  &hdev->lock --> hci_cb_list_lock --> sk_lock-AF_BLUETOOTH-BTPROTO_SCO

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sk_lock-AF_BLUETOOTH-BTPROTO_SCO);
                               lock(hci_cb_list_lock);
                               lock(sk_lock-AF_BLUETOOTH-BTPROTO_SCO);
  lock(&hdev->lock);

 *** DEADLOCK ***

1 lock held by sco-tester/31:
 #0: ffff888001eeb130 (sk_lock-AF_BLUETOOTH-BTPROTO_SCO){+.+.}-{0:0},
 at: sco_sock_getsockopt+0x104/0xa90

Fixes: 248733e87d50 ("Bluetooth: Allow querying of supported offload codecs over SCO socket")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1111da4e2f2bd..1755f91a66f6a 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1129,6 +1129,8 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
+		release_sock(sk);
+
 		/* find total buffer size required to copy codec + caps */
 		hci_dev_lock(hdev);
 		list_for_each_entry(c, &hdev->local_codecs, list) {
@@ -1146,15 +1148,13 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 		buf_len += sizeof(struct bt_codecs);
 		if (buf_len > len) {
 			hci_dev_put(hdev);
-			err = -ENOBUFS;
-			break;
+			return -ENOBUFS;
 		}
 		ptr = optval;
 
 		if (put_user(num_codecs, ptr)) {
 			hci_dev_put(hdev);
-			err = -EFAULT;
-			break;
+			return -EFAULT;
 		}
 		ptr += sizeof(num_codecs);
 
@@ -1194,12 +1194,14 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 			ptr += len;
 		}
 
-		if (!err && put_user(buf_len, optlen))
-			err = -EFAULT;
-
 		hci_dev_unlock(hdev);
 		hci_dev_put(hdev);
 
+		lock_sock(sk);
+
+		if (!err && put_user(buf_len, optlen))
+			err = -EFAULT;
+
 		break;
 
 	default:
-- 
2.39.2



