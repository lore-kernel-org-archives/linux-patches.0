Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726DA18F2DF;
	Tue, 10 Sep 2024 10:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964408; cv=none; b=KW2HMbLdmwCtlRgEWaZMkAzpNqSI8trU731GsU5zIFBbMQtcGBao9Kz/PkOjbY2ph1uqlm5ldITa//sDO7pRFzZa4Sg3w8Zhy4HYsJ3LQ2UJd5CgEes9XvUY9dSk7TpGVQGEiH7dGGxwNo9Exn0d0uFgzHwhGBB6zfa93gxCfFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964408; c=relaxed/simple;
	bh=a0w8fPhnIoDFWX49bcoClVpTLEphNBx9BoTcVvEPNP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKc2+inNhrD2SU4L3Ee/Yf8Fv9sGNYKEiYuW21cRjdNV/P2Hv4UjXmU6zHTRHvJZ3SJvuu2r7lbslBjP6LZgz7a1Bit2TR7iEnuhaaRmgNXpWIEX/uuLLlRYlf5AkwATyirMqkH88WAD+koPnk9RPpm+5v9Al43GCWieHwwspU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFSCBUbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFSCBUbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBCBC4CEC3;
	Tue, 10 Sep 2024 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964408;
	bh=a0w8fPhnIoDFWX49bcoClVpTLEphNBx9BoTcVvEPNP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFSCBUbSRBdIzcdgI1HBL263mTHyBLoa82yhEBG0hl1q7NVWn+WDCVEd6RKdhWnqj
	 DZSlMdrnijfo6rFanCa5+3+m/Ob8dgNb6f5yHEn6qHPEmICyC+WPXLy9q7DhMHOcfD
	 FCWZOChf0vOlodgH8CIwvb2Q7zeaRh3QHueCcw1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/269] tcp: Dont drop SYN+ACK for simultaneous connect().
Date: Tue, 10 Sep 2024 11:32:39 +0200
Message-ID: <20240910092614.306177193@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 23e89e8ee7be73e21200947885a6d3a109a2c58d ]

RFC 9293 states that in the case of simultaneous connect(), the connection
gets established when SYN+ACK is received. [0]

      TCP Peer A                                       TCP Peer B

  1.  CLOSED                                           CLOSED
  2.  SYN-SENT     --> <SEQ=100><CTL=SYN>              ...
  3.  SYN-RECEIVED <-- <SEQ=300><CTL=SYN>              <-- SYN-SENT
  4.               ... <SEQ=100><CTL=SYN>              --> SYN-RECEIVED
  5.  SYN-RECEIVED --> <SEQ=100><ACK=301><CTL=SYN,ACK> ...
  6.  ESTABLISHED  <-- <SEQ=300><ACK=101><CTL=SYN,ACK> <-- SYN-RECEIVED
  7.               ... <SEQ=100><ACK=301><CTL=SYN,ACK> --> ESTABLISHED

However, since commit 0c24604b68fc ("tcp: implement RFC 5961 4.2"), such a
SYN+ACK is dropped in tcp_validate_incoming() and responded with Challenge
ACK.

For example, the write() syscall in the following packetdrill script fails
with -EAGAIN, and wrong SNMP stats get incremented.

   0 socket(..., SOCK_STREAM|SOCK_NONBLOCK, IPPROTO_TCP) = 3
  +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)

  +0 > S  0:0(0) <mss 1460,sackOK,TS val 1000 ecr 0,nop,wscale 8>
  +0 < S  0:0(0) win 1000 <mss 1000>
  +0 > S. 0:0(0) ack 1 <mss 1460,sackOK,TS val 3308134035 ecr 0,nop,wscale 8>
  +0 < S. 0:0(0) ack 1 win 1000

  +0 write(3, ..., 100) = 100
  +0 > P. 1:101(100) ack 1

  --

  # packetdrill cross-synack.pkt
  cross-synack.pkt:13: runtime error in write call: Expected result 100 but got -1 with errno 11 (Resource temporarily unavailable)
  # nstat
  ...
  TcpExtTCPChallengeACK           1                  0.0
  TcpExtTCPSYNChallenge           1                  0.0

The problem is that bpf_skops_established() is triggered by the Challenge
ACK instead of SYN+ACK.  This causes the bpf prog to miss the chance to
check if the peer supports a TCP option that is expected to be exchanged
in SYN and SYN+ACK.

Let's accept a bare SYN+ACK for active-open TCP_SYN_RECV sockets to avoid
such a situation.

Note that tcp_ack_snd_check() in tcp_rcv_state_process() is skipped not to
send an unnecessary ACK, but this could be a bit risky for net.git, so this
targets for net-next.

Link: https://www.rfc-editor.org/rfc/rfc9293.html#section-3.5-7 [0]
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240710171246.87533-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 24c7c955dc95..336bc97e86d5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5880,6 +5880,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	 * RFC 5961 4.2 : Send a challenge ack
 	 */
 	if (th->syn) {
+		if (sk->sk_state == TCP_SYN_RECV && sk->sk_socket && th->ack &&
+		    TCP_SKB_CB(skb)->seq + 1 == TCP_SKB_CB(skb)->end_seq &&
+		    TCP_SKB_CB(skb)->seq + 1 == tp->rcv_nxt &&
+		    TCP_SKB_CB(skb)->ack_seq == tp->snd_nxt)
+			goto pass;
 syn_challenge:
 		if (syn_inerr)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
@@ -5889,6 +5894,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		goto discard;
 	}
 
+pass:
 	bpf_skops_parse_hdr(sk, skb);
 
 	return true;
@@ -6673,6 +6679,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tcp_fast_path_on(tp);
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			tcp_shutdown(sk, SEND_SHUTDOWN);
+
+		if (sk->sk_socket)
+			goto consume;
 		break;
 
 	case TCP_FIN_WAIT1: {
-- 
2.43.0



