Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590083;
	b=VDgzwFqnIDXXmRUdY+hYa2VGdCbKlphDlMogrcSzjw4MampI7bFTaXtBr6ImatQZNKhs
	 7OSh1CF5zcPkWaGqFtBneYld9ymezCnzpboecSfgDi6tgxG1+Y0HbuimR9nWqBywWR7bs
	 XvGJi6gPS/oSMwtEERnQaGmd4VpN0HlhXYrqvyRO7zCIZTA8SVK0kN19oR2mYkon/DgiH
	 fuapatPNk0houbm5VQf3oL/qwTTpxpuJsrfeFpPUQ1FqwEL6EkEsKgyhLviseqN33haaO
	 6ZXLoWJHdrIEJp9QUmAda4miO8cwx06WMFtkbE3rXW3aez3Ez+Y6X0t2PywEb3J+KYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zOo/lGsEY0INL66rPMU7B0/Fo4W4hvGXOCUOE2eqdKc=;
	b=0r0/WMi87b1NXoRMhkP9QZ2RBckkRnQDyAK1OZoHVMRCEfefmvBXmCr8fXhTsbA4Xbdw
	 cCjdcxuO3sFGnw6fiJRUbLLuYxNXTnJOpS4n6CwiRch13fJ1x9jOyASQax2bxjLCx4vwJ
	 Yyx/iF6oNgLLlyMe+mn8pwNZG5wKatbzaIdVOb+gnk5+jLCMoWJ8oY98Yj8O2SHaZc01f
	 Jvx1iMtb22OlQZvkOpl8k+taYGTrBxTndmvk6wodc/Bo3Tgugaw/Ir7ghzpK884bIOVdN
	 7s4Iuao+WWqmDjbvUhs/HQnxCoh1edp/T8sWPj95NJxBejPHjM5A1PJJhd5kz9XTQOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hw7wgFSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A71606A32E;
	Fri, 13 Nov 2026 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hw7wgFSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0141F000C4;
	Fri, 13 Nov 2026 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590083;
	bh=zOo/lGsEY0INL66rPMU7B0/Fo4W4hvGXOCUOE2eqdKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hw7wgFSBYmSBMuVq29s/zLUL1nyhJzOqaCt3PEg8MxqvXLiNJEyzQJ9HhZlUt0LAQ
	 7KdnCktXzoVI38LAkkwSUQ7EJ3KpUXCuAywWQlNvCWmJzts4q2ELnVBXm42rUuTxuU
	 2yu9rTIEtq+bgAVRejg5Gy7HFTjvjDh9xyeAz4JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/686] ax25: dont create a second connection for a link on an incoming SABM
Date: Fri, 13 Nov 2026 10:44:04 -0500
Message-ID: <20261113153824.607621775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When a SABM arrives for one of our interfaces and no socket listens,
ax25_rcv() looks the link up with ax25_find_cb(), creates a control
block if there is none, and adds it with ax25_cb_add() at the end.
The lookup and the add are not done under one lock.  If
ax25_send_frame() opens the same link on another CPU in between, for
instance a ROSE restart request or a NetRom frame for that neighbour,
both control blocks end up on ax25_list.  The one created by
ax25_send_frame() stays in state 1 with the frames queued on it and
never reaches state 3, as the peer's UA and its later frames go to
the other one.

ax25_send_frame() already adds its control block with
ax25_cb_add_unique() for the same reason.  Do the same here before
the UA is sent: if a connection for the link exists by then, drop the
new control block and give the SABM to the existing one, which
answers it from state 1 like a SABM received after the lookup.
ax25_send_frame() may find the new control block before it reaches
state 3 and only queue its frames, so kick the queue once the
connection is up.

The listener path is left alone: the new socket is on the listener's
accept queue by then and the race needs a socket connecting from the
listening address.

On a QEMU bench with a delay widening the window between the lookup
and the add, an incoming SABM crossing a ROSE call to the same
neighbour left two connections for the link in 5 rounds out of 6
before, and one connection in state 3 in every round after.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit b87e40ffda58b9077925fd8170d912b868992733)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 1bcb5e321467d..cb48a479ba3cc 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -201,7 +201,7 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	int type = 0, mine = 0, dama;
 	struct sock *make, *sk;
 	ax25_digi dp, reverse_dp;
-	ax25_cb *ax25;
+	ax25_cb *ax25, *existing;
 	ax25_dev *ax25_dev;
 
 	/*
@@ -450,6 +450,24 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 		ax25->window  = ax25_dev->values[AX25_VALUES_WINDOW];
 	}
 
+	if (!sk) {
+		/*
+		 * ax25_send_frame() may have created a connection for this
+		 * link since the lookup above: add ours only if there is
+		 * none, otherwise give the SABM to the existing one. Frames
+		 * queued on ours before it reaches state 3 are sent by the
+		 * ax25_kick() below.
+		 */
+		existing = ax25_cb_add_unique(ax25);
+		if (existing) {
+			ax25_cb_put(ax25);
+			if (ax25_process_rx_frame(existing, skb, type, dama) == 0)
+				kfree_skb(skb);
+			ax25_cb_put(existing);
+			return 0;
+		}
+	}
+
 	ax25_send_control(ax25, AX25_UA, AX25_POLLON, AX25_RESPONSE);
 
 #ifdef CONFIG_AX25_DAMA_SLAVE
@@ -459,12 +477,16 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	ax25->state = AX25_STATE_3;
 
-	ax25_cb_add(ax25);
+	if (sk)
+		ax25_cb_add(ax25);
 
 	ax25_start_heartbeat(ax25);
 	ax25_start_t3timer(ax25);
 	ax25_start_idletimer(ax25);
 
+	if (!sk)
+		ax25_kick(ax25);
+
 	if (sk) {
 		if (!sock_flag(sk, SOCK_DEAD))
 			sk->sk_data_ready(sk);
-- 
2.53.0



