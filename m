Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DEB13DBA0;
	Sun,  7 Jun 2026 10:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828037; cv=none; b=dGNka7SKsSMnxfEmFMt63sGhQI2X2upvC8KULNyi8y4EOm7JHgjyghkjRgjxvhsQv0O+sS7J6dUUuFggSHA7EBAwe0pVjqZm8yPFNLGJg3ESx9EQ0rR0MfyfMbwuXR6erppMmPBLpybdwDLPxvWlIxjKqGrnMOCPe56ij7OuIRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828037; c=relaxed/simple;
	bh=5VQ90IS7+seK/qLkTmXPd2outVTrjL6LkUSZZue3/nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RliwAhhhXlR8PUKbiu/hheu5ToRjmBRrVKt1xh9BBo2G5XksJCw5rgV931ZJOGUShkezbCRwPUYWwqOh0uTRwWNCXdgMhnhYhEUxzTClHTna4bSv/n7VdwT6XKxo0bzy9tHL8a851D5o/BZ0pG1O7UvnpXrRwLEHZXpk+1qhuNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RioDZUM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RioDZUM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EBB1F00893;
	Sun,  7 Jun 2026 10:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828036;
	bh=MMTD3b8S7jQkyTensj+AGnbcsXvUUO3GE+Xsk8iU02U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RioDZUM2IJq6odvLkb3B1Ni/oY618VbclsZZhBT07vG1H2ZcR3RfJtMxisRmDhlqf
	 ykHaN0whdhMxEsdBlqL+lQAe7n+k94bUzW4jOG+szC5xQT2f55Yn3qiNcoVN3D6SSY
	 IMKr+gh1LBrmJ/W/DmfEF3F8zomdlbQVWUZNwtZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 146/332] Bluetooth: L2CAP: use chan timer to close channels in cleanup_listen()
Date: Sun,  7 Jun 2026 11:58:35 +0200
Message-ID: <20260607095733.458616287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 8c8e620467a7b51562dbcefbd1f09f288d7d710d upstream.

l2cap_chan_close() removes the channel from conn->chan_l, which
must be done under conn->lock.  cleanup_listen() runs under the
parent sk_lock, so acquiring conn->lock would invert the
established conn->lock -> chan->lock -> sk_lock order.

Instead of calling l2cap_chan_close() directly, schedule
l2cap_chan_timeout with delay 0 to close the channel
asynchronously.  The timeout handler already acquires conn->lock
and chan->lock in the correct order.

The timer is only armed when chan->conn is still set: if it is
already NULL, l2cap_conn_del() has already processed this channel
(l2cap_chan_del + l2cap_sock_teardown_cb + l2cap_sock_close_cb),
so there is nothing left to do.  If l2cap_conn_del() races in
after the timer is armed, __clear_chan_timer() inside
l2cap_chan_del() cancels it; if the timer has already fired, the
handler returns harmlessly because chan->conn was cleared.

Fixes: 3df91ea20e74 ("Bluetooth: Revert to mutexes from RCU list")
Cc: <stable@vger.kernel.org> # 0b58004: Bluetooth: fix UAF in l2cap_sock_cleanup_listen() vs l2cap_conn_del()
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1499,6 +1499,10 @@ static void l2cap_sock_cleanup_listen(st
 	 * pin it (hold_unless_zero() additionally skips a chan already past
 	 * its last reference).  We then drop the sk lock before taking
 	 * chan->lock, so sk and chan locks are never held together.
+	 *
+	 * Since we cannot call l2cap_chan_close() without conn->lock,
+	 * schedule l2cap_chan_timeout to close the channel; it already
+	 * acquires conn->lock -> chan->lock in the correct order.
 	 */
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		struct l2cap_chan *chan;
@@ -1516,14 +1520,12 @@ static void l2cap_sock_cleanup_listen(st
 		       state_to_string(chan->state));
 
 		l2cap_chan_lock(chan);
-		__clear_chan_timer(chan);
-		l2cap_chan_close(chan, ECONNRESET);
-		/* l2cap_conn_del() may already have killed this socket
-		 * (it sets SOCK_DEAD); skip the duplicate to avoid a
-		 * double sock_put()/l2cap_chan_put().
+		/* Since we cannot call l2cap_chan_close() without
+		 * conn->lock, schedule its timer to trigger the close
+		 * and cleanup of this channel.
 		 */
-		if (!sock_flag(sk, SOCK_DEAD))
-			l2cap_sock_kill(sk);
+		if (chan->conn)
+			__set_chan_timer(chan, 0);
 		l2cap_chan_unlock(chan);
 
 		l2cap_chan_put(chan);


