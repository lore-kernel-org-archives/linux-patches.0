Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B4A186615;
	Tue, 10 Sep 2024 10:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964499; cv=none; b=Ox2Eucuz2iewEkiTYe7gV3hGZATZY7gPD+c5w/7TzBCc4KZ8RhB55iFIaq5TSj233E1Ysp1AAQ23WYykdMOBsRiGtjpJ/XoauMR7jTda3kC/gyRbY0v229MkHuGcMiS0NccI1dcxw76l+BSeZNJ1CbJpGqFXmH7N18u7E1snGaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964499; c=relaxed/simple;
	bh=YGjRCu9bLMNZqmxyV1tSgIHUwVI5o0GFEowgVAj4K1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsvNp/Bay9rHqy/b8TA+KjZ0PdZFh/41mJ7gIGeuUUip8XgAk483CrD26QmJcCJ9YFyDkwYy8PV3OBQLO/soDN/2pGXnAn8PxQmr0P4BVLHUUea/LPKZEAXogLYN/Eo9kZRxUw/W5gU+eQODZ4Guw0JJQImNS9t+5DSPr1roFYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE9Vhqnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE9Vhqnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD908C4CEC3;
	Tue, 10 Sep 2024 10:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964499;
	bh=YGjRCu9bLMNZqmxyV1tSgIHUwVI5o0GFEowgVAj4K1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FE9VhqnpU6OD/sSdKgiE5IYLD9nCcP3NC38gCC+H0t8OlfV7jDx0c4cPPHl4B9bgd
	 eVbtwZLcPmqsC48Xen2Y857AprrNgpVZCioqwfqFnkOETx7BK52vwr25wC6wioMZuO
	 xufOKrs4CqQkWcjssNAHk2lraSZUQwsGXavESww8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.6 203/269] tcp: process the 3rd ACK with sk_socket for TFO/MPTCP
Date: Tue, 10 Sep 2024 11:33:10 +0200
Message-ID: <20240910092615.307230832@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit c1668292689ad2ee16c9c1750a8044b0b0aad663 upstream.

The 'Fixes' commit recently changed the behaviour of TCP by skipping the
processing of the 3rd ACK when a sk->sk_socket is set. The goal was to
skip tcp_ack_snd_check() in tcp_rcv_state_process() not to send an
unnecessary ACK in case of simultaneous connect(). Unfortunately, that
had an impact on TFO and MPTCP.

I started to look at the impact on MPTCP, because the MPTCP CI found
some issues with the MPTCP Packetdrill tests [1]. Then Paolo Abeni
suggested me to look at the impact on TFO with "plain" TCP.

For MPTCP, when receiving the 3rd ACK of a request adding a new path
(MP_JOIN), sk->sk_socket will be set, and point to the MPTCP sock that
has been created when the MPTCP connection got established before with
the first path. The newly added 'goto' will then skip the processing of
the segment text (step 7) and not go through tcp_data_queue() where the
MPTCP options are validated, and some actions are triggered, e.g.
sending the MPJ 4th ACK [2] as demonstrated by the new errors when
running a packetdrill test [3] establishing a second subflow.

This doesn't fully break MPTCP, mainly the 4th MPJ ACK that will be
delayed. Still, we don't want to have this behaviour as it delays the
switch to the fully established mode, and invalid MPTCP options in this
3rd ACK will not be caught any more. This modification also affects the
MPTCP + TFO feature as well, and being the reason why the selftests
started to be unstable the last few days [4].

For TFO, the existing 'basic-cookie-not-reqd' test [5] was no longer
passing: if the 3rd ACK contains data, and the connection is accept()ed
before receiving them, these data would no longer be processed, and thus
not ACKed.

One last thing about MPTCP, in case of simultaneous connect(), a
fallback to TCP will be done, which seems fine:

  `../common/defaults.sh`

   0 socket(..., SOCK_STREAM|SOCK_NONBLOCK, IPPROTO_MPTCP) = 3
  +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)

  +0 > S  0:0(0)                 <mss 1460, sackOK, TS val 100 ecr 0,   nop, wscale 8, mpcapable v1 flags[flag_h] nokey>
  +0 < S  0:0(0) win 1000        <mss 1460, sackOK, TS val 407 ecr 0,   nop, wscale 8, mpcapable v1 flags[flag_h] nokey>
  +0 > S. 0:0(0) ack 1           <mss 1460, sackOK, TS val 330 ecr 0,   nop, wscale 8, mpcapable v1 flags[flag_h] nokey>
  +0 < S. 0:0(0) ack 1 win 65535 <mss 1460, sackOK, TS val 700 ecr 100, nop, wscale 8, mpcapable v1 flags[flag_h] key[skey=2]>
  +0 >  . 1:1(0) ack 1           <nop, nop, TS val 845707014 ecr 700, nop, nop, sack 0:1>

Simultaneous SYN-data crossing is also not supported by TFO, see [6].

Kuniyuki Iwashima suggested to restrict the processing to SYN+ACK only:
that's a more generic solution than the one initially proposed, and
also enough to fix the issues described above.

Later on, Eric Dumazet mentioned that an ACK should still be sent in
reaction to the second SYN+ACK that is received: not sending a DUPACK
here seems wrong and could hurt:

   0 socket(..., SOCK_STREAM|SOCK_NONBLOCK, IPPROTO_TCP) = 3
  +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)

  +0 > S  0:0(0)                <mss 1460, sackOK, TS val 1000 ecr 0,nop,wscale 8>
  +0 < S  0:0(0)       win 1000 <mss 1000, sackOK, nop, nop>
  +0 > S. 0:0(0) ack 1          <mss 1460, sackOK, TS val 3308134035 ecr 0,nop,wscale 8>
  +0 < S. 0:0(0) ack 1 win 1000 <mss 1000, sackOK, nop, nop>
  +0 >  . 1:1(0) ack 1          <nop, nop, sack 0:1>  // <== Here

So in this version, the 'goto consume' is dropped, to always send an ACK
when switching from TCP_SYN_RECV to TCP_ESTABLISHED. This ACK will be
seen as a DUPACK -- with DSACK if SACK has been negotiated -- in case of
simultaneous SYN crossing: that's what is expected here.

Link: https://github.com/multipath-tcp/mptcp_net-next/actions/runs/9936227696 [1]
Link: https://datatracker.ietf.org/doc/html/rfc8684#fig_tokens [2]
Link: https://github.com/multipath-tcp/packetdrill/blob/mptcp-net-next/gtests/net/mptcp/syscalls/accept.pkt#L28 [3]
Link: https://netdev.bots.linux.dev/contest.html?executor=vmksft-mptcp-dbg&test=mptcp-connect-sh [4]
Link: https://github.com/google/packetdrill/blob/master/gtests/net/tcp/fastopen/server/basic-cookie-not-reqd.pkt#L21 [5]
Link: https://github.com/google/packetdrill/blob/master/gtests/net/tcp/fastopen/client/simultaneous-fast-open.pkt [6]
Fixes: 23e89e8ee7be ("tcp: Don't drop SYN+ACK for simultaneous connect().")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240724-upstream-net-next-20240716-tcp-3rd-ack-consume-sk_socket-v3-1-d48339764ce9@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6679,9 +6679,6 @@ int tcp_rcv_state_process(struct sock *s
 		tcp_fast_path_on(tp);
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			tcp_shutdown(sk, SEND_SHUTDOWN);
-
-		if (sk->sk_socket)
-			goto consume;
 		break;
 
 	case TCP_FIN_WAIT1: {


