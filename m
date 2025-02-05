Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0457E792;
	Wed,  5 Feb 2025 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766443; cv=none; b=IWc1Oqb+nTcWbhdRPyzT7IIMuq8HgRmuqTqGQLQM2OiF549l3PbxfsF66bNx5odB+ph2audW/egvBP1GoADuAyyMdT0UZT2jLEOM+A3HkaSeKfKX7rdypNTmOwKAt2Xo2LDrJkWyEGT8AA20aFrasU9k44zrfg2GmJbmiQCjuW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766443; c=relaxed/simple;
	bh=bWrfccaUsFhbSrV9eI1Qp+o3NEB40hReBjp5dRUlba8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlypiuT4jmcL4LjJJL1r0mznr3dZDe/PpUwaDCdbId30agfS4DTi3QGTmxJFHC+AnTDZhCGGI/ihYpfrZip8QCRpeGEyys20NANazai1bv9jRPCrCChpQAXx6G9COzmGWspo7Yh6AzVIBWc461//Oycwm8CT4qxzzlsLMIFAzag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQx498PZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQx498PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6C3C4CED6;
	Wed,  5 Feb 2025 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766443;
	bh=bWrfccaUsFhbSrV9eI1Qp+o3NEB40hReBjp5dRUlba8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQx498PZ49FvyMoQpVctWDQ75EPMV4YaisHe0G0JzlJypyEVguJ8g8J/4tfiVY8Iw
	 +FDFQ+iS2V1zr97EKU/Sm0TGPb0fyKqERCTUVt4NNOZR8v7SzgWs1Jhn9+J5ucm2Yk
	 wiatzk4Wg5/0sEC5+y77yyMaK+vkSAmk0gLINpvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <menglong8.dong@gmail.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/393] tcp: correct handling of extreme memory squeeze
Date: Wed,  5 Feb 2025 14:44:23 +0100
Message-ID: <20250205134433.472810817@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Maloy <jmaloy@redhat.com>

[ Upstream commit 8c670bdfa58e48abad1d5b6ca1ee843ca91f7303 ]

Testing with iperf3 using the "pasta" protocol splicer has revealed
a problem in the way tcp handles window advertising in extreme memory
squeeze situations.

Under memory pressure, a socket endpoint may temporarily advertise
a zero-sized window, but this is not stored as part of the socket data.
The reasoning behind this is that it is considered a temporary setting
which shouldn't influence any further calculations.

However, if we happen to stall at an unfortunate value of the current
window size, the algorithm selecting a new value will consistently fail
to advertise a non-zero window once we have freed up enough memory.
This means that this side's notion of the current window size is
different from the one last advertised to the peer, causing the latter
to not send any data to resolve the sitution.

The problem occurs on the iperf3 server side, and the socket in question
is a completely regular socket with the default settings for the
fedora40 kernel. We do not use SO_PEEK or SO_RCVBUF on the socket.

The following excerpt of a logging session, with own comments added,
shows more in detail what is happening:

//              tcp_v4_rcv(->)
//                tcp_rcv_established(->)
[5201<->39222]:     ==== Activating log @ net/ipv4/tcp_input.c/tcp_data_queue()/5257 ====
[5201<->39222]:     tcp_data_queue(->)
[5201<->39222]:        DROPPING skb [265600160..265665640], reason: SKB_DROP_REASON_PROTO_MEM
                       [rcv_nxt 265600160, rcv_wnd 262144, snt_ack 265469200, win_now 131184]
                       [copied_seq 259909392->260034360 (124968), unread 5565800, qlen 85, ofoq 0]
                       [OFO queue: gap: 65480, len: 0]
[5201<->39222]:     tcp_data_queue(<-)
[5201<->39222]:     __tcp_transmit_skb(->)
                        [tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160]
[5201<->39222]:       tcp_select_window(->)
[5201<->39222]:         (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_NOMEM) ? --> TRUE
                        [tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160]
                        returning 0
[5201<->39222]:       tcp_select_window(<-)
[5201<->39222]:       ADVERTISING WIN 0, ACK_SEQ: 265600160
[5201<->39222]:     [__tcp_transmit_skb(<-)
[5201<->39222]:   tcp_rcv_established(<-)
[5201<->39222]: tcp_v4_rcv(<-)

// Receive queue is at 85 buffers and we are out of memory.
// We drop the incoming buffer, although it is in sequence, and decide
// to send an advertisement with a window of zero.
// We don't update tp->rcv_wnd and tp->rcv_wup accordingly, which means
// we unconditionally shrink the window.

[5201<->39222]: tcp_recvmsg_locked(->)
[5201<->39222]:   __tcp_cleanup_rbuf(->) tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160
[5201<->39222]:     [new_win = 0, win_now = 131184, 2 * win_now = 262368]
[5201<->39222]:     [new_win >= (2 * win_now) ? --> time_to_ack = 0]
[5201<->39222]:     NOT calling tcp_send_ack()
                    [tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160]
[5201<->39222]:   __tcp_cleanup_rbuf(<-)
                  [rcv_nxt 265600160, rcv_wnd 262144, snt_ack 265469200, win_now 131184]
                  [copied_seq 260040464->260040464 (0), unread 5559696, qlen 85, ofoq 0]
                  returning 6104 bytes
[5201<->39222]: tcp_recvmsg_locked(<-)

// After each read, the algorithm for calculating the new receive
// window in __tcp_cleanup_rbuf() finds it is too small to advertise
// or to update tp->rcv_wnd.
// Meanwhile, the peer thinks the window is zero, and will not send
// any more data to trigger an update from the interrupt mode side.

[5201<->39222]: tcp_recvmsg_locked(->)
[5201<->39222]:   __tcp_cleanup_rbuf(->) tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160
[5201<->39222]:     [new_win = 262144, win_now = 131184, 2 * win_now = 262368]
[5201<->39222]:     [new_win >= (2 * win_now) ? --> time_to_ack = 0]
[5201<->39222]:     NOT calling tcp_send_ack()
                    [tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160]
[5201<->39222]:   __tcp_cleanup_rbuf(<-)
                  [rcv_nxt 265600160, rcv_wnd 262144, snt_ack 265469200, win_now 131184]
                  [copied_seq 260099840->260171536 (71696), unread 5428624, qlen 83, ofoq 0]
                  returning 131072 bytes
[5201<->39222]: tcp_recvmsg_locked(<-)

// The above pattern repeats again and again, since nothing changes
// between the reads.

[...]

[5201<->39222]: tcp_recvmsg_locked(->)
[5201<->39222]:   __tcp_cleanup_rbuf(->) tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160
[5201<->39222]:     [new_win = 262144, win_now = 131184, 2 * win_now = 262368]
[5201<->39222]:     [new_win >= (2 * win_now) ? --> time_to_ack = 0]
[5201<->39222]:     NOT calling tcp_send_ack()
                    [tp->rcv_wup: 265469200, tp->rcv_wnd: 262144, tp->rcv_nxt 265600160]
[5201<->39222]:   __tcp_cleanup_rbuf(<-)
                  [rcv_nxt 265600160, rcv_wnd 262144, snt_ack 265469200, win_now 131184]
                  [copied_seq 265600160->265600160 (0), unread 0, qlen 0, ofoq 0]
                  returning 54672 bytes
[5201<->39222]: tcp_recvmsg_locked(<-)

// The receive queue is empty, but no new advertisement has been sent.
// The peer still thinks the receive window is zero, and sends nothing.
// We have ended up in a deadlock situation.

Note that well behaved endpoints will send win0 probes, so the problem
will not occur.

Furthermore, we have observed that in these situations this side may
send out an updated 'th->ack_seq´ which is not stored in tp->rcv_wup
as it should be. Backing ack_seq seems to be harmless, but is of
course still wrong from a protocol viewpoint.

We fix this by updating the socket state correctly when a packet has
been dropped because of memory exhaustion and we have to advertize
a zero window.

Further testing shows that the connection recovers neatly from the
squeeze situation, and traffic can continue indefinitely.

Fixes: e2142825c120 ("net: tcp: send zero-window ACK when no memory")
Cc: Menglong Dong <menglong8.dong@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20250127231304.1465565-1-jmaloy@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfddc94508f0b..3771ed22c2f56 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -263,11 +263,14 @@ static u16 tcp_select_window(struct sock *sk)
 	u32 cur_win, new_win;
 
 	/* Make the window 0 if we failed to queue the data because we
-	 * are out of memory. The window is temporary, so we don't store
-	 * it on the socket.
+	 * are out of memory.
 	 */
-	if (unlikely(inet_csk(sk)->icsk_ack.pending & ICSK_ACK_NOMEM))
+	if (unlikely(inet_csk(sk)->icsk_ack.pending & ICSK_ACK_NOMEM)) {
+		tp->pred_flags = 0;
+		tp->rcv_wnd = 0;
+		tp->rcv_wup = tp->rcv_nxt;
 		return 0;
+	}
 
 	cur_win = tcp_receive_window(tp);
 	new_win = __tcp_select_window(sk);
-- 
2.39.5



