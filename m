Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7621C9DF7;
	Tue, 27 Aug 2024 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769875; cv=none; b=Fq1MO91XbhGNiKDV38Au0C4I2XVFnqx7Y3aYxPCKm7lLS08JmIGwAN/Z4sp9xyv3rNKZOL9Oubad3pw5s2IYlTrmEMPnuZGHOSonjjRP2CmdoQBQFKRlwaO0bHRQDyWSkH+xpyzPP3Tr13ZtYiWL8vJMy1Lb37+8LJhD+2IUTdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769875; c=relaxed/simple;
	bh=H+bk6XHPEkce0RoAWkj6VNI1hbO0srE9u2pHG4MZrtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohslnd2QLwQ+Y5fkc+A9jQk2pMSgUYtv2WKMPLTjsv8l4B9EfwtIgE8qGsbwV3Xh+MuDW0p14K2VrBHHCcslhahlmta+Z5/GOr6YHNwnweikFtXXVKeYhCxObL73T/+fVm7ylPIrB0gser1fwt7IRbhr+A4VoIqPidGCgoyUFUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ija4TArB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ija4TArB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52711C61065;
	Tue, 27 Aug 2024 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769874;
	bh=H+bk6XHPEkce0RoAWkj6VNI1hbO0srE9u2pHG4MZrtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ija4TArB0ZCmwW7qRx4XsMqiHZOVBx021V9lIZbQrO/bH6APO+JLjCQsLnou3F6LC
	 +wS6JcYDUIFz/fVV1+79RQThZuT/Pv47sm05E61BOCJmUuQ3nplwFtsVqFpd9FBDUb
	 xB5Mkn5gpeV2sjYq8oHunDKJzp3aT98cR7ges4f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Tranchetti <quic_stranche@quicinc.com>,
	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/341] tcp: Update window clamping condition
Date: Tue, 27 Aug 2024 16:34:53 +0200
Message-ID: <20240827143845.774317576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index d0364cff65c9f..24c7c955dc955 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -243,9 +243,14 @@ static void tcp_measure_rcv_mss(struct sock *sk, const struct sk_buff *skb)
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
@@ -748,7 +753,8 @@ void tcp_rcv_space_adjust(struct sock *sk)
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
+	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		u64 rcvwin, grow;
 		int rcvbuf;
 
@@ -764,22 +770,12 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
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



