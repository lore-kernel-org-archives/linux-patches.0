Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590115;
	b=IsYP0M1C0xMIEFYcEqwKixZ0ldh4I7FFFXD4ED+XPap7VCpFFkWFMvmG7QD5m4cKYx6w
	 oHfb7/gZglVN2lAnRJWRbNi8faWFIqKJxLEMZOEDmycsPB+2ZaG+fuUSANS++SJpAZ2AB
	 gFqz2JZ/64vv2GXSnj8qgMD3UY1tV8PTBIyajFSbo4qZfeFu+h4LJp5F9Bp2QXC7PobIE
	 zoFNrUp2tsROvNQ0AHy5fb13Xu+Hh5/7/EjhTDPPFeFeSbbxX2t5/Re2Ou+rbAtFDEmFD
	 5WfhKoAmNswEwWvvpJJFU9Zyl/Nb+uyNQT55PSmV0m/lLhfoHOj/2MzhKQ0Hp4LTQXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSZMcGBee57YdYDBzh4xYrn9kpuZUW5aMiPUdd+TkRg=;
	b=Dm9WvG/CvqE9SD0kOwT2vQEroH3gzBvYMtuWJZz3Zh6rjcCE4Kyuub9EpdHwTyUhLY++
	 Q6ts1rNc6rMeLy1jy+Kb/m68EhDt9d6iadD5W0/okRcBwb2heJoN4vj1vTNVotuCXa7KU
	 rdmOkk6RjuNOGLIX694fCHg3DpVYSeBtxkZY3Dkv/XHCw908XuIWVotCUdY69DLeYbN8I
	 R6e2NTbu3GwWaahZwB8fLxgdJY9x5q5d6OUpOenr+O7x78OZg4RGH7NDmtFcrVTf1n32D
	 B8J5ZVU4tALtXiSiZR9Znry9eYJVUJIk09VMGvn+jSL0DpqGqSlr2T5fflXdpTkRzuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CJVa+av/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0222606B226;
	Fri, 13 Nov 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJVa+av/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1551F000C4;
	Fri, 13 Nov 2026 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590115;
	bh=hSZMcGBee57YdYDBzh4xYrn9kpuZUW5aMiPUdd+TkRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJVa+av/toVKmSRaQsqgCYdYynzwvvSPwHSsMSlNTBuCrq7RY0FqAEJzSkB59b7qC
	 O07XwpY55RuBbPpRjaoAo6neXYDWLOTcQOAu/HpIxQsgNHM4I91tkbfue1SAd8RC+J
	 Gqdz+XKzPqcUnmqunFpbySsKaHgmtbNtexZmaMOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/686] netrom: check the window size given by the peer
Date: Fri, 13 Nov 2026 10:44:28 -0500
Message-ID: <20261113153825.383038053@linuxfoundation.org>
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

The window size of a circuit is negotiated in its CONNREQ and CONNACK.
On a CONNREQ received, nr_rx_frame() keeps the smaller of ours and the
peer's; on a CONNACK, nr_state1_machine() takes the peer's as is.

So a window of 0 from the peer, in either frame, becomes the window of
the circuit, and nr_kick() then never sends anything: the circuit is
established but stuck. And a CONNACK can raise the window above the
one we asked for, even above NR_MAX_WINDOW_SIZE.

Negotiate both in one helper: take a window of 0 as 1 and keep the
smaller of ours and the peer's.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS. A
speaks NET/ROM itself over a raw AX.25 link and answers B's calls; after
each circuit is up, B sends two messages and A counts the INFO frames
(A does not acknowledge them):

                            before                after
  CONNREQ with window 0     wnd 0, 0 frame sent   wnd 1, 1 frame sent
  CONNACK with window 0     wnd 0, 0 frame sent   wnd 1, 1 frame sent
  CONNACK with window 200   wnd 200, 2 frames     wnd 4 (ours), 2 frames

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit ce7485c6c0e52acdef785adfc46541c20beb55ed)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netrom.h   | 13 +++++++++++++
 net/netrom/af_netrom.c |  3 +--
 net/netrom/nr_in.c     |  2 +-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/net/netrom.h b/include/net/netrom.h
index 2b4685d52bd81..b8f2e324962ba 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -87,6 +87,19 @@ struct nr_sock {
 
 #define nr_sk(sk) ((struct nr_sock *)(sk))
 
+/*
+ * Window negotiation, for a CONNREQ received or a CONNACK: use the smaller
+ * of our window and the peer's. A window of 0 would never let a frame
+ * out: take it as 1.
+ */
+static inline void nr_negotiate_window(struct nr_sock *nr, unsigned char window)
+{
+	if (window == 0)
+		window = 1;
+	if (window < nr->window)
+		nr->window = window;
+}
+
 struct nr_neigh {
 	struct hlist_node	neigh_node;
 	ax25_address		callsign;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index d2b374dbc92fd..ff7f6ba9754cc 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1034,8 +1034,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	bh_lock_sock(sk);
 
 	/* Window negotiation */
-	if (window < nr_make->window)
-		nr_make->window = window;
+	nr_negotiate_window(nr_make, window);
 
 	/*
 	 * L4 timeout negotiation.  Ignore a proposal shorter than the
diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index cf8844cd64b75..805881e5d6c01 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -129,7 +129,7 @@ static int nr_state1_machine(struct sock *sk, struct sk_buff *skb,
 		nr->vl	       = 0;
 		nr->state      = NR_STATE_3;
 		nr->n2count    = 0;
-		nr->window     = skb->data[20];
+		nr_negotiate_window(nr, skb->data[20]);
 		sk->sk_state   = TCP_ESTABLISHED;
 		if (!sock_flag(sk, SOCK_DEAD))
 			sk->sk_state_change(sk);
-- 
2.53.0



