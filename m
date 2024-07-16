Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899EE541;
	Tue, 16 Jul 2024 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144174; cv=none; b=IqzomgtVjevd9t3jrfF19039wG63QYc3mOQNomf0Zuo9tzjGRnXza1QkgOHfm0H5/rK+3sQh9nIL379no5B910cJOAyoPMGwJW9JNFy6Qh4m8ezFjJe8N1H+6k/ETrpC9Rbdu94zyf3Hw+KoFOo17Q3/1HxPb1++xpP1EIVKQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144174; c=relaxed/simple;
	bh=yMKYKQ9wHDEuvyRusNKGBaYk1t6P1KXs0aQdLXldrJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j95trapXvpIt+QJL18liJpx6Too2/A6G76UTK/fk6McFI7X8/cISOe6D2FkpiRxgc9nf7TMBPgr8955NmgT0pUm04mXZ8+Qx7l+By/fUhvYsG6VIJ+rNZwrlMxADdST6mmh3/v6ZUs1yFrJ1JC/Shy9MrQTzTiQ4PDJ1r2uhTEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ati+igK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ati+igK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F813C116B1;
	Tue, 16 Jul 2024 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144174;
	bh=yMKYKQ9wHDEuvyRusNKGBaYk1t6P1KXs0aQdLXldrJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ati+igK+Yi75cKDcv8GqKjXdaXUH8xMcmO8hjZWUN610lPlewNMdfcKrLT9nOe3YQ
	 nWnROMsNs6nL94bAGrfaVnXe6NAD2jj9Va1tfhBxP3wR8shOGnFTHr3akYVsEYlpnx
	 rERKj4eIIga3cr6wAFpX9TMCw8vKifP6EqYp09XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mingkun bian <bianmingkun@gmail.com>,
	Yuchung Cheng <ycheng@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/66] net: tcp better handling of reordering then loss cases
Date: Tue, 16 Jul 2024 17:30:57 +0200
Message-ID: <20240716152739.011062849@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit a29cb6914681a55667436a9eb7a42e28da8cf387 ]

This patch aims to improve the situation when reordering and loss are
ocurring in the same flight of packets.

Previously the reordering would first induce a spurious recovery, then
the subsequent ACK may undo the cwnd (based on the timestamps e.g.).
However the current loss recovery does not proceed to invoke
RACK to install a reordering timer. If some packets are also lost, this
may lead to a long RTO-based recovery. An example is
https://groups.google.com/g/bbr-dev/c/OFHADvJbTEI

The solution is to after reverting the recovery, always invoke RACK
to either mount the RACK timer to fast retransmit after the reordering
window, or restarts the recovery if new loss is identified. Hence
it is possible the sender may go from Recovery to Disorder/Open to
Recovery again in one ACK.

Reported-by: mingkun bian <bianmingkun@gmail.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a6458ab7fd4f ("UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 45 +++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88216b87c986f..5503f130cc6dd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2727,8 +2727,17 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 	*rexmit = REXMIT_LOST;
 }
 
+static bool tcp_force_fast_retransmit(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	return after(tcp_highest_sack_seq(tp),
+		     tp->snd_una + tp->reordering * tp->mss_cache);
+}
+
 /* Undo during fast recovery after partial ACK. */
-static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una)
+static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una,
+				 bool *do_lost)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2753,7 +2762,9 @@ static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una)
 		tcp_undo_cwnd_reduction(sk, true);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPARTIALUNDO);
 		tcp_try_keep_open(sk);
-		return true;
+	} else {
+		/* Partial ACK arrived. Force fast retransmit. */
+		*do_lost = tcp_force_fast_retransmit(sk);
 	}
 	return false;
 }
@@ -2777,14 +2788,6 @@ static void tcp_identify_packet_loss(struct sock *sk, int *ack_flag)
 	}
 }
 
-static bool tcp_force_fast_retransmit(struct sock *sk)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	return after(tcp_highest_sack_seq(tp),
-		     tp->snd_una + tp->reordering * tp->mss_cache);
-}
-
 /* Process an event, which can update packets-in-flight not trivially.
  * Main goal of this function is to calculate new estimate for left_out,
  * taking into account both packets sitting in receiver's buffer and
@@ -2854,17 +2857,21 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
 			if (tcp_is_reno(tp))
 				tcp_add_reno_sack(sk, num_dupack, ece_ack);
-		} else {
-			if (tcp_try_undo_partial(sk, prior_snd_una))
-				return;
-			/* Partial ACK arrived. Force fast retransmit. */
-			do_lost = tcp_force_fast_retransmit(sk);
-		}
-		if (tcp_try_undo_dsack(sk)) {
-			tcp_try_keep_open(sk);
+		} else if (tcp_try_undo_partial(sk, prior_snd_una, &do_lost))
 			return;
-		}
+
+		if (tcp_try_undo_dsack(sk))
+			tcp_try_keep_open(sk);
+
 		tcp_identify_packet_loss(sk, ack_flag);
+		if (icsk->icsk_ca_state != TCP_CA_Recovery) {
+			if (!tcp_time_to_recover(sk, flag))
+				return;
+			/* Undo reverts the recovery state. If loss is evident,
+			 * starts a new recovery (e.g. reordering then loss);
+			 */
+			tcp_enter_recovery(sk, ece_ack);
+		}
 		break;
 	case TCP_CA_Loss:
 		tcp_process_loss(sk, flag, num_dupack, rexmit);
-- 
2.43.0



