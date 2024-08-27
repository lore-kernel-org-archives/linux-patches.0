Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8A71C461D;
	Tue, 27 Aug 2024 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771252; cv=none; b=njYSKrnf91dQ1SJ2BRsVPWnczAl7hOfzT9yFY+xOw0FeSFTsViaWCqWrrU5wig2XZfdketZz50fG5a8IlxDQtOxUAADfQ7rPp48k9/ZczQLiBT89GgvyjEqF37Z6RwRr7OSVD5YS0V8psDAimhFz1k7Wl7MKUWoQ1NT20WGeSiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771252; c=relaxed/simple;
	bh=eL0MKFfh/U/Kx3hp8nIecaHVkcCAeLCfSpTPgtWFbYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/kc2s1NYvV3hf3emF0bnWqS9+retcM/jZQLGZxqpt7OKqAud1WYaKhUiIl5iRnhbM4YTfDqTiAW97vcL1d4gLjkkFbN/T57bRC2a3sIDqC9YssInjKiZZrSCOTjTlWvEFnaM6w+8tY7BZkDvZAWt3iNFDVO6KCnonWTtPlbOMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xjd8OXzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xjd8OXzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4080C61040;
	Tue, 27 Aug 2024 15:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771251;
	bh=eL0MKFfh/U/Kx3hp8nIecaHVkcCAeLCfSpTPgtWFbYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xjd8OXzGexE0SeoCu3jPp9rjdwLEw/r9XQzDNZg4F0FXXOCydkVY3Dc2kFZrU+KCO
	 jWy4CGFouYxACljLsbXVSI5RXg+tOYEWAZhUL9t/M9GMNLcbJ2N6Oaj4KyjLtHEAS4
	 p//DTb0ZUOPCI9SmnOab9E+ABp2QV5v1F1w3psvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Tranchetti <quic_stranche@quicinc.com>,
	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 101/273] tcp: Update window clamping condition
Date: Tue, 27 Aug 2024 16:37:05 +0200
Message-ID: <20240827143837.253608489@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

[ Upstream commit a2cbb1603943281a604f5adc48079a148db5cb0d ]

This patch is based on the discussions between Neal Cardwell and
Eric Dumazet in the link
https://lore.kernel.org/netdev/20240726204105.1466841-1-quic_subashab@quicinc.com/

It was correctly pointed out that tp->window_clamp would not be
updated in cases where net.ipv4.tcp_moderate_rcvbuf=0 or if
(copied <= tp->rcvq_space.space). While it is expected for most
setups to leave the sysctl enabled, the latter condition may
not end up hitting depending on the TCP receive queue size and
the pattern of arriving data.

The updated check should be hit only on initial MSS update from
TCP_MIN_MSS to measured MSS value and subsequently if there was
an update to a larger value.

Fixes: 05f76b2d634e ("tcp: Adjust clamping window for applications specifying SO_RCVBUF")
Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ecd521108559f..2c52f6dcbd290 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -238,9 +238,14 @@ static void tcp_measure_rcv_mss(struct sock *sk, const struct sk_buff *skb)
 		 */
 		if (unlikely(len != icsk->icsk_ack.rcv_mss)) {
 			u64 val = (u64)skb->len << TCP_RMEM_TO_WIN_SCALE;
+			u8 old_ratio = tcp_sk(sk)->scaling_ratio;
 
 			do_div(val, skb->truesize);
 			tcp_sk(sk)->scaling_ratio = val ? val : 1;
+
+			if (old_ratio != tcp_sk(sk)->scaling_ratio)
+				WRITE_ONCE(tcp_sk(sk)->window_clamp,
+					   tcp_win_from_space(sk, sk->sk_rcvbuf));
 		}
 		icsk->icsk_ack.rcv_mss = min_t(unsigned int, len,
 					       tcp_sk(sk)->advmss);
@@ -754,7 +759,8 @@ void tcp_rcv_space_adjust(struct sock *sk)
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
+	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		u64 rcvwin, grow;
 		int rcvbuf;
 
@@ -770,22 +776,12 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		rcvbuf = min_t(u64, tcp_space_from_win(sk, rcvwin),
 			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
-		if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
-			if (rcvbuf > sk->sk_rcvbuf) {
-				WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
-
-				/* Make the window clamp follow along.  */
-				WRITE_ONCE(tp->window_clamp,
-					   tcp_win_from_space(sk, rcvbuf));
-			}
-		} else {
-			/* Make the window clamp follow along while being bounded
-			 * by SO_RCVBUF.
-			 */
-			int clamp = tcp_win_from_space(sk, min(rcvbuf, sk->sk_rcvbuf));
+		if (rcvbuf > sk->sk_rcvbuf) {
+			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
-			if (clamp > tp->window_clamp)
-				WRITE_ONCE(tp->window_clamp, clamp);
+			/* Make the window clamp follow along.  */
+			WRITE_ONCE(tp->window_clamp,
+				   tcp_win_from_space(sk, rcvbuf));
 		}
 	}
 	tp->rcvq_space.space = copied;
-- 
2.43.0



