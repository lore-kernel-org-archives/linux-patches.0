Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F8084A46;
	Wed,  7 Aug 2024 15:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043367; cv=none; b=fAb61Uf+yRIeqNW5rH+H92xL6GEwETnwLlbRvxEA5vdHUUKhemzXZhQks3BCBIAejMCH7unQs7lSI4bNYIhZytPeO+205ZyuymyDMFWDALcKYi6Y0AEyOOoK9qpywHOi7a+8aukb/lmmr0zBSyAMWuU5Aca2FodzLbE1eFSpTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043367; c=relaxed/simple;
	bh=gRjYnkFcSnwR0UkyQ4wDIL2xaXVxd+5Ii3qL3QRVIpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEWtFxdj5xUZr2USXdcRVbLAJpquHRDhZ7s9w3xzh/GWRUilSxd50SXNEHOEnDC9OKcDHm/WV/dVF5a8UjkNzYV6JG57A3lEYBq95dZMOWBhleMSdci+q4BrIO13wzkuZg3wXleifwy+VzcSs0kTTpdpXL5Ksxu8JRbc5nztYvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMbs+EZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMbs+EZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190AEC4AF0B;
	Wed,  7 Aug 2024 15:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043367;
	bh=gRjYnkFcSnwR0UkyQ4wDIL2xaXVxd+5Ii3qL3QRVIpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMbs+EZX2jiNsCHWKFtepwSTp2xaHfLYj9cYhVEL1nIJDX4KpXlo5yND1TG/+cy26
	 nAIe1O1pyyqVxE6OAhv3rZ9DguQM8i0HQoJeEoUD9VQKFlrEct72FGIUrkgtv5HTfz
	 pyir2/JiK+ZvMopqCeXzYkA+aR/9MHb0oDu/6BGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Tranchetti <quic_stranche@quicinc.com>,
	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/121] tcp: Adjust clamping window for applications specifying SO_RCVBUF
Date: Wed,  7 Aug 2024 16:59:57 +0200
Message-ID: <20240807150021.534621717@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13464e35d7565..d0364cff65c9f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -748,8 +748,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
-	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)) {
 		u64 rcvwin, grow;
 		int rcvbuf;
 
@@ -765,12 +764,22 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
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



