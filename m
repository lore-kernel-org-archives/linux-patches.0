Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891A536D4E1;
	Wed, 30 Sep 2026 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791784; cv=none; b=FrX0THXnwnwxTGkjjFzmKRkv5rZU7QEBYBXhBb6J6zxyDVWfK5ePcie+xaOj9ehRQu7pILDHAGXkf3k8vxgl7K6NfITQ2/jt2YDZSQ8QPFRnOtMqQI0+Q4hBVd9AkwAu6TOaCC39MIjKHIKwc6E5sknP2HpoYD59WC73i2akGW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791784; c=relaxed/simple;
	bh=DDmlztucevtDl6RxYJtXkym63iE8QYZmmuQUJAi1Nxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR8qgQwKbA1QA27d9vYDw83k98x7rq5FNZNFbPAYuYWWuh2AoEZ/uzyjnYeeit08Y73HXFOzmJdJkymejJocGLPycP0i2+xlHuBkrnkaoLH3RzrV7aePwkMvh7nJVQrNbpRkKoLd+Vh9mpZj981ANo/C6SCU9+GCfsxAn3DNrdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbDw5ifs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbDw5ifs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32441F000FF;
	Wed, 30 Sep 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791783;
	bh=XwOLfuAOa7uyB0jmIdrFEM9KP3GMf/33cwh7dAsmH8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbDw5ifszsP2ivHLajGrp+Vt7eCNGhVuaJDw9EM7FzCsG5d1VHKWFNiANXZx5V1tC
	 JSNavh8LkKN1jEKDJVZKoJWWOhpXnzsHVlSm+lHOQwoD/SHFG2j59GySGvfcEHDxhs
	 TPTP0nHXNyvNHfRt0OHHcJHsHCUUyFeUn78FXj8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: [PATCH 5.15 425/752] bluetooth/l2cap: sync sock recv cb and release
Date: Wed, 30 Sep 2026 17:24:55 +0200
Message-ID: <20260930152407.482200989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
[ Karl Mehltretter: applied in the form this commit has after
  f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock"), that is the
  chan->data clearing in l2cap_sock_kill() and the guard in
  l2cap_sock_recv_cb(), without the channel locking in the callback.
  That locking is what caused the recursive chan->lock deadlock.
  f1a8f402f13f removes it and moves the lock to l2cap_conless_channel(),
  which the previous patch does here. l2cap_data_channel() already
  obtains the channel locked from l2cap_get_chan_by_scid(). ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 0b51c3e0f4692..bef6a948d7d51 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1237,6 +1237,10 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
+	/* Sock is dead, so set chan data to NULL, avoid other task use invalid
+	 * sock pointer.
+	 */
+	l2cap_pi(sk)->chan->data = NULL;
 	/* Kill poor orphan */
 
 	l2cap_chan_put(l2cap_pi(sk)->chan);
@@ -1519,9 +1523,13 @@ static struct l2cap_chan *l2cap_sock_new_connection_cb(struct l2cap_chan *chan)
 
 static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 {
-	struct sock *sk = chan->data;
+	struct sock *sk;
 	int err;
 
+	sk = chan->data;
+	if (!sk)
+		return -ENXIO;
+
 	lock_sock(sk);
 
 	if (l2cap_pi(sk)->rx_busy_skb) {
-- 
2.53.0



