Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CB03A255F;
	Sat, 12 Sep 2026 19:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240490; cv=none; b=YmwE8/Ey/kNpQ+clY/A1RVWNBtWlH3WSWo8TPAZidJ2M+NQ5GUmqEMkeZRxST+h3O7VlGYYZG5erCV2Vkb266AJsbniX1Y33bqk0H44fXpo/ael6Wvb7t8qfOrrFWmQBgjSdvjr0DKw21Ac+pHHyQ17yQL0ceEzFydBTh+rkSOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240490; c=relaxed/simple;
	bh=p89KEyVp39mJayRv9295SALrOE1yzZLKKH3j+AL82/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAs96UxhrmBIp6pPqQRKRLVfg8BhLRcvoPJgpNZW96kYys4RVqBeTWdyGeVaE3pGHtYAYTWos+y23f4wLwH8i/Za5uRu/FgWBecCvUIFsqxEUP6Sx4CacZy3GZJZrHbBEgIqcJ1nRNiNgj/43Azpy/atL+aP24kV21FdSVT6dtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN3YEsBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN3YEsBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821761F000FF;
	Sat, 12 Sep 2026 19:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240488;
	bh=cvxARYNM6oc7jj8eSUrGTZa3heyaakqHmIWN/KVa/lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hN3YEsBN47vCSmki/0zzXJ6X93ceOH3rAvjMn22GUYjY4nYVnZ0ZpBq7+NW2oNJ6L
	 Im5ZW99Qc005aPPAJRoywAcc6gzAGKgn2A41fsW6GUybjh0INGyOYQ7S6MnwX/aGXT
	 1DwljRvpv/3c39D7UIk4sYmdFpPRfE6gmMhcGg0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and release
Date: Sat, 12 Sep 2026 09:05:09 +0200
Message-ID: <20260912065546.976652519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 89e856e124f9ae548572c56b1b70c2255705f8fe ]

The problem occurs between the system call to close the sock and hci_rx_work,
where the former releases the sock and the latter accesses it without lock protection.

           CPU0                       CPU1
           ----                       ----
           sock_close                 hci_rx_work
	   l2cap_sock_release         hci_acldata_packet
	   l2cap_sock_kill            l2cap_recv_frame
	   sk_free                    l2cap_conless_channel
	                              l2cap_sock_recv_cb

If hci_rx_work processes the data that needs to be received before the sock is
closed, then everything is normal; Otherwise, the work thread may access the
released sock when receiving data.

Add a chan mutex in the rx callback of the sock to achieve synchronization between
the sock release and recv cb.

Sock is dead, so set chan data to NULL, avoid others use invalid sock pointer.

Reported-and-tested-by: syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: d4bfa78fd679 ("Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 137a8225e2aea..7adebb038d05f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1270,6 +1270,10 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
+	/* Sock is dead, so set chan data to NULL, avoid other task use invalid
+	 * sock pointer.
+	 */
+	l2cap_pi(sk)->chan->data = NULL;
 	/* Kill poor orphan */
 
 	l2cap_chan_put(l2cap_pi(sk)->chan);
@@ -1552,12 +1556,25 @@ static struct l2cap_chan *l2cap_sock_new_connection_cb(struct l2cap_chan *chan)
 
 static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 {
-	struct sock *sk = chan->data;
-	struct l2cap_pinfo *pi = l2cap_pi(sk);
+	struct sock *sk;
+	struct l2cap_pinfo *pi;
 	int err;
 
-	lock_sock(sk);
+	/* To avoid race with sock_release, a chan lock needs to be added here
+	 * to synchronize the sock.
+	 */
+	l2cap_chan_hold(chan);
+	l2cap_chan_lock(chan);
+	sk = chan->data;
 
+	if (!sk) {
+		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
+		return -ENXIO;
+	}
+
+	pi = l2cap_pi(sk);
+	lock_sock(sk);
 	if (chan->mode == L2CAP_MODE_ERTM && !list_empty(&pi->rx_busy)) {
 		err = -ENOMEM;
 		goto done;
@@ -1606,6 +1623,8 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 
 done:
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



