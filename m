Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4037BE7A;
	Wed, 30 Sep 2026 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783251; cv=none; b=eIH84uYu8XIF3raNDxRG3ks5Wy5pc3/AEvoJ1SYnMEv0BaXXTnGmu/oOf88Ib3CgrkAFVTXAP2GZcrHoTcqMa0bhqQhgXRFekRe6EhxwEetVb6eJplD8ClvBSH2o4uM3fxZsETU1l2k2/6DBDb3/SAHLDHQbAHeUDTUF3eWbT1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783251; c=relaxed/simple;
	bh=Pe5o3K2p2XEP8u5dW2tYdv2zZ3fvYjiYFZY0m6JaFlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK7dJgAlyBcYLkN/jmL1hEIs6yTizqJHPlc7+TbNwFpx8ENsrBpbZ/uLhpsAZU60dlgINvpHBz/CJf/qT84ZkuQJgN9mlgpTBRVKpU7BrUmNLIV+07BJPrvMMa35179h0Pmh0BQSx3/fhHNnJFjmqYVqzDSe2E/56AwPIa1h9ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJNhkdz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJNhkdz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0491F000FF;
	Wed, 30 Sep 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783248;
	bh=Je4PtH1yHRCkGpHX5YOgja24WnNNubBtrWtqc6rYyI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJNhkdz4Z4SmHRv0ErGufGNIcITBe4zJ1x3AeaGwzflfkzjSKVdO99faznTgXKM2e
	 wpIlHKOAR7c4B+K42qycdI9qq+e7M57XevgLxCh/WckZ0gxDDWpQF2SQsrm2TMzHz6
	 u2uxXGK2nZg00wrybFVDhrfgtocXN9tHlD0ZD5bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/595] Reapply "bluetooth/l2cap: sync sock recv cb and release"
Date: Wed, 30 Sep 2026 17:23:45 +0200
Message-ID: <20260930152354.824355082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 89e856e124f9ae548572c56b1b70c2255705f8fe ]

This reverts commit 6ecdf922fb6bf92b6942edfa3f1aa874f1fd7c4d.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ec95962077e2d..9d834f2254626 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1258,6 +1258,10 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
+	/* Sock is dead, so set chan data to NULL, avoid other task use invalid
+	 * sock pointer.
+	 */
+	l2cap_pi(sk)->chan->data = NULL;
 	/* Kill poor orphan */
 
 	l2cap_chan_put(l2cap_pi(sk)->chan);
@@ -1540,12 +1544,25 @@ static struct l2cap_chan *l2cap_sock_new_connection_cb(struct l2cap_chan *chan)
 
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
@@ -1594,6 +1611,8 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 
 done:
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



