Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590951;
	b=r9jhYwBnGeRdAj216lmi5St1WeHA41gMZBcErq9AZUAI5t0h2fvN27BQ4HsW2HaNY6mQ
	 2bWvRoaI0wcs2TA//8vvLa+fO8YPq6w734yx2ROn8sMTIHoSsL6kTe3h9p537mW1KYla/
	 STM8Dg9Fa4hFd2AkR/JgPSf92w9Mbtzkyoh+4MD4CoxyXYGobjHDHb1rZgy92TA7Tc4aF
	 avEvVs6/81bTnnFZT1mg2tN9YIcukA4iUQoWQtiVXSrwdSHadw0kbw6e9KzHKYbeEIWKX
	 VDzfwK9Y5jbCrrLW2B5jslXW06hw4ZK5BZoLZ+Fdl0P5WxvqxFi6byG43F5dRB9mQmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vXRLjGnMA96WNa9KLAY8f8cNA9qQ99E/Re8sZpesWgM=;
	b=GuCz4azdlgL2c/vAQYy15QIiUYF5r0niroSrbOjNTwZWgf4EspQo5H1erPnQ355LIxVG
	 ZZdWvsTVjJVV9QOHq1kzW4vILVpCT9j/bzUDsJt7ND2uTo7UMAzPp/H1tHKkxYZgvDs5a
	 YQQEhfUU/f+ycMsEilAliLpyi7QPAXU0xAQ18DPL0igFf7AJNg+romFmGW3/Lu/vnzCEq
	 MYGbPM4NhGV2SEwrmW+f+hI7x7O5eMEq7kabg1etIE9E+NUFiHCdwfykxZPpRDPCKB8iy
	 xY5jJQHzpO2xn8rPs7hJuchSCrBJN9+Ouno6HQJflp4JYa4Dkp9lcN5rtf4mri2iWtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhetdHQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D376D606F707;
	Fri, 13 Nov 2026 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhetdHQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6C81F000C4;
	Fri, 13 Nov 2026 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590951;
	bh=vXRLjGnMA96WNa9KLAY8f8cNA9qQ99E/Re8sZpesWgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhetdHQGfxcQxkGAJKqXbUR7bYyEa1XHMI6RWKOK8+9/diMMNGVxN5yAut4yEtx5K
	 NM2J2SBzfxO/T+VuGsMQZqYuSpsrBU+EIpVDG5Jzqn+uI2zOHl/ge7rShKZsCuTeF4
	 77I53Ps9/nxb3Raq3J+w2NSPZH5L3wIwsH+XusoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/670] netrom: check the window size given by the peer
Date: Fri, 13 Nov 2026 10:44:56 -0500
Message-ID: <20261113153816.296978260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 27ff6dd7878fe..cb996b2e3ffa4 100644
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



