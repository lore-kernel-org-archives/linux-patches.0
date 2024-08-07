Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905A6FE16;
	Wed,  7 Aug 2024 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043035; cv=none; b=cs8nhzak9V7iCtVFyGeg0SirQDLMMlci7bVcEJhIFMJRymDdzhGn0vUhxBOXWrh5LZuEH/B9Ak513HF5wYKv2Ebwoeb1mWJyiZxMEreAi0muxRKvknsqs/RLGiebQ9Nbfs8JkpU1jgfKGrN9/jeIx2/gpYgP4DqMNrcM2VUZ2PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043035; c=relaxed/simple;
	bh=e73y6voutiKMcQHgLi+JoHw8GP09yKouQb6C1hhZ7t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3fE80gf32q/Y8FWCBn9SYC8j5KKb9ALs7xWk148U9x5LFxmNFQ22p9HfURDDNKMfNNiOcMp16ltIrEcOtP2ovjiUen14KNfumZS77hIKqOA1heS5FDEnWCOcSwmuxjGbGvPtCy3HLQHXiKRKyYusd1eTVxoR96+0uFcMlo0rCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frxYaC9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frxYaC9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E1BC32781;
	Wed,  7 Aug 2024 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043035;
	bh=e73y6voutiKMcQHgLi+JoHw8GP09yKouQb6C1hhZ7t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frxYaC9JEQ+3NxN6dM5jbGr/fKLKi3PVVTljFwv/UPT2DQsDJNcRQ9BoOGARRD6Ue
	 T7eOxhftXCKdTQhJsMHHhIDQ56UVxc+OIQ0idVFqNh5DuDpJ0jMNNB7JfymxrMSuyz
	 XhEhOcc4anYURuKzc626QJ1vUslot0qJMDK02uzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Tranchetti <quic_stranche@quicinc.com>,
	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 037/123] tcp: Adjust clamping window for applications specifying SO_RCVBUF
Date: Wed,  7 Aug 2024 16:59:16 +0200
Message-ID: <20240807150022.032951310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>

[ Upstream commit 05f76b2d634e65ab34472802d9b142ea9e03f74e ]

tp->scaling_ratio is not updated based on skb->len/skb->truesize once
SO_RCVBUF is set leading to the maximum window scaling to be 25% of
rcvbuf after
commit dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale")
and 50% of rcvbuf after
commit 697a6c8cec03 ("tcp: increase the default TCP scaling ratio").
50% tries to emulate the behavior of older kernels using
sysctl_tcp_adv_win_scale with default value.

Systems which were using a different values of sysctl_tcp_adv_win_scale
in older kernels ended up seeing reduced download speeds in certain
cases as covered in https://lists.openwall.net/netdev/2024/05/15/13
While the sysctl scheme is no longer acceptable, the value of 50% is
a bit conservative when the skb->len/skb->truesize ratio is later
determined to be ~0.66.

Applications not specifying SO_RCVBUF update the window scaling and
the receiver buffer every time data is copied to userspace. This
computation is now used for applications setting SO_RCVBUF to update
the maximum window scaling while ensuring that the receive buffer
is within the application specified limit.

Fixes: dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale")
Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 570e87ad9a56e..ecd521108559f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -754,8 +754,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
-	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)) {
 		u64 rcvwin, grow;
 		int rcvbuf;
 
@@ -771,12 +770,22 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		rcvbuf = min_t(u64, tcp_space_from_win(sk, rcvwin),
 			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
-		if (rcvbuf > sk->sk_rcvbuf) {
-			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
+		if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
+			if (rcvbuf > sk->sk_rcvbuf) {
+				WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
-			/* Make the window clamp follow along.  */
-			WRITE_ONCE(tp->window_clamp,
-				   tcp_win_from_space(sk, rcvbuf));
+				/* Make the window clamp follow along.  */
+				WRITE_ONCE(tp->window_clamp,
+					   tcp_win_from_space(sk, rcvbuf));
+			}
+		} else {
+			/* Make the window clamp follow along while being bounded
+			 * by SO_RCVBUF.
+			 */
+			int clamp = tcp_win_from_space(sk, min(rcvbuf, sk->sk_rcvbuf));
+
+			if (clamp > tp->window_clamp)
+				WRITE_ONCE(tp->window_clamp, clamp);
 		}
 	}
 	tp->rcvq_space.space = copied;
-- 
2.43.0



