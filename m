Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BE528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55433C433D2;
	Mon, 30 Jan 2023 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087205;
	bh=1+EqSCh+MI8+1yG5YgYl1rTfrhhhLtc6vZ/QlWufpJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWunWSH+Jony/7y+AZGY1o++TffHaLcbQsXxQscHV1wi/TOgnUyNFsOexAOCoxwNO
	 e1GCJjNVMHKcJGDNXXrW5jgNdzjPMpPYMlI1nKp4g2UpZztXYzimMpcJHcxeHC6SHc
	 g/ECpje6KHT9wo9dxAxt9FaIIP0++7PvCfKFt4bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7ce59...@syzkaller.appspotmail.com,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/313] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
Date: Mon, 30 Jan 2023 14:48:59 +0100
Message-Id: <20230130134341.488068842@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit 1d80d57ffcb55488f0ec0b77928d4f82d16b6a90 ]

syzbot reports a possible deadlock in rfcomm_sk_state_change [1].
While rfcomm_sock_connect acquires the sk lock and waits for
the rfcomm lock, rfcomm_sock_release could have the rfcomm
lock and hit a deadlock for acquiring the sk lock.
Here's a simplified flow:

rfcomm_sock_connect:
  lock_sock(sk)
  rfcomm_dlc_open:
    rfcomm_lock()

rfcomm_sock_release:
  rfcomm_sock_shutdown:
    rfcomm_lock()
    __rfcomm_dlc_close:
        rfcomm_k_state_change:
	  lock_sock(sk)

This patch drops the sk lock before calling rfcomm_dlc_open to
avoid the possible deadlock and holds sk's reference count to
prevent use-after-free after rfcomm_dlc_open completes.

Reported-by: syzbot+d7ce59...@syzkaller.appspotmail.com
Fixes: 1804fdf6e494 ("Bluetooth: btintel: Combine setting up MSFT extension")
Link: https://syzkaller.appspot.com/bug?extid=d7ce59b06b3eb14fd218 [1]

Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 21e24da4847f..4397e14ff560 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
+	sock_hold(sk);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
@@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	d->sec_level = rfcomm_pi(sk)->sec_level;
 	d->role_switch = rfcomm_pi(sk)->role_switch;
 
+	/* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
+	release_sock(sk);
 	err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
 			      sa->rc_channel);
-	if (!err)
+	lock_sock(sk);
+	if (!err && !sock_flag(sk, SOCK_ZAPPED))
 		err = bt_sock_wait_state(sk, BT_CONNECTED,
 				sock_sndtimeo(sk, flags & O_NONBLOCK));
 
 done:
 	release_sock(sk);
+	sock_put(sk);
 	return err;
 }
 
-- 
2.39.0



