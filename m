Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978824F85C4;
	Wed, 30 Sep 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783113; cv=none; b=IQ7s1lbOlEBWEgtzobD+eOb1Zaebc7s2HfP8ZiOIcm91hr7KoG3iP1SQ788MaWeWWWv2GIXvu8p3Il0XyEEH9vbYkkBOaaXjAYjRKLEFmtuaziqF46pwHcAvwpjSc6Jbf/ChiGUSs6kEtapjfunNFe+pHGyAbNnRhQmRWqW0Tzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783113; c=relaxed/simple;
	bh=wn3b5ZyZZsQ9M+FRAlWNa4y61HdluXMque29sHAKOOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5TASdpmQ5tWnjgeYdcfiKZJ11tKzozSMj56qcJVsD596+h5BIMYOc2HqSE46HipayWevko0nnN1ROIXbAHI6uSMWRkOkYP8/8N/kyJl98kH7BNcPp/g7H8Pn1vSFY/XZBG2yeZJecCV8/0D8bJL2KF/OwVHN5x4l4i3FVOH8Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oamUf+QH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oamUf+QH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738AC1F00893;
	Wed, 30 Sep 2026 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783109;
	bh=Lj+htQgnEmEP5go283VG6fGNk4OiVk0kr+/IHmkYkbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oamUf+QHBJKRE/Ka5vP83njtYkxyV+96dhhbH3xFrY9bH5KBtRIQ5yhGC955ky4gd
	 PsipDDI5XdPOQSxMz447uZSPSF1FfkBTX7pGvczyFvpD3b8xV+HrC6aJ9rReLZ5Y5C
	 HxmHehosfrFsWgN7uc0LLvpfX0NefYeEZq9NjItI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/595] Revert "bluetooth/l2cap: sync sock recv cb and release"
Date: Wed, 30 Sep 2026 17:22:56 +0200
Message-ID: <20260930152353.787588277@linuxfoundation.org>
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

This reverts commit 2243127db6ba20cbef90c6349a2b1000af401d2e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 9d834f2254626..ec95962077e2d 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1258,10 +1258,6 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
-	/* Sock is dead, so set chan data to NULL, avoid other task use invalid
-	 * sock pointer.
-	 */
-	l2cap_pi(sk)->chan->data = NULL;
 	/* Kill poor orphan */
 
 	l2cap_chan_put(l2cap_pi(sk)->chan);
@@ -1544,25 +1540,12 @@ static struct l2cap_chan *l2cap_sock_new_connection_cb(struct l2cap_chan *chan)
 
 static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 {
-	struct sock *sk;
-	struct l2cap_pinfo *pi;
+	struct sock *sk = chan->data;
+	struct l2cap_pinfo *pi = l2cap_pi(sk);
 	int err;
 
-	/* To avoid race with sock_release, a chan lock needs to be added here
-	 * to synchronize the sock.
-	 */
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-	sk = chan->data;
-
-	if (!sk) {
-		l2cap_chan_unlock(chan);
-		l2cap_chan_put(chan);
-		return -ENXIO;
-	}
-
-	pi = l2cap_pi(sk);
 	lock_sock(sk);
+
 	if (chan->mode == L2CAP_MODE_ERTM && !list_empty(&pi->rx_busy)) {
 		err = -ENOMEM;
 		goto done;
@@ -1611,8 +1594,6 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 
 done:
 	release_sock(sk);
-	l2cap_chan_unlock(chan);
-	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



