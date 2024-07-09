Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA6A155389;
	Tue,  9 Jul 2024 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523646; cv=none; b=rR5F8HHEytUph8XTA1fycOyFg/Ank8YypJzI/P1Pv7xMN9o+qGAXSfRwEKwqWoqieDpbR+dIut+/NsZPJo0kTXNWcJWoMd+At+F5181n5KHENiWO+fKG8AV1CpsIXP/hDVCytliiDk973rPsBE5ayUNqZSjxu/OdPowwLcALzsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523646; c=relaxed/simple;
	bh=q7WcrVNrR/r0Q4s7ZJUDpyjObahELfgmTWsqWL9bqz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r00i7rjsZFm6wEgMupvHtst5xz/TMrslcJ1vWv4hstxcghDRkipV864cK1B7+E3BNxUZZBaA/wGHU9890VQLEGIFAhJ6JMpPdd2vdjD4u/5yBQ1FrwOEO5kEMzo0YXZloCZENL+qRHGGL4ZoYRxvrULqRhyDtawGnYzmUZdZo/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObXNzqVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObXNzqVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8184C3277B;
	Tue,  9 Jul 2024 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523646;
	bh=q7WcrVNrR/r0Q4s7ZJUDpyjObahELfgmTWsqWL9bqz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObXNzqVeVlAeijzh8ANm8U//xOUcXRtby0+gyCQ5kZ3l6uynRe213ZEdDzOgcsEDZ
	 nSs7HNb+HFRrHFj9IPx7i1q6Ahkt/J9UWNPxIXTp7dCWPNGZ1lr81bQHf1TPrf9mX0
	 7GbYHoLYS/2vL9nExUzJFvOq0qJuz30axzHKSeCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/139] UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()
Date: Tue,  9 Jul 2024 13:09:23 +0200
Message-ID: <20240709110700.611123705@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit a6458ab7fd4f427d4f6f54380453ad255b7fde83 ]

In some production workloads we noticed that connections could
sometimes close extremely prematurely with ETIMEDOUT after
transmitting only 1 TLP and RTO retransmission (when we would normally
expect roughly tcp_retries2 = TCP_RETR2 = 15 RTOs before a connection
closes with ETIMEDOUT).

>From tracing we determined that these workloads can suffer from a
scenario where in fast recovery, after some retransmits, a DSACK undo
can happen at a point where the scoreboard is totally clear (we have
retrans_out == sacked_out == lost_out == 0). In such cases, calling
tcp_try_keep_open() means that we do not execute any code path that
clears tp->retrans_stamp to 0. That means that tp->retrans_stamp can
remain erroneously set to the start time of the undone fast recovery,
even after the fast recovery is undone. If minutes or hours elapse,
and then a TLP/RTO/RTO sequence occurs, then the start_ts value in
retransmits_timed_out() (which is from tp->retrans_stamp) will be
erroneously ancient (left over from the fast recovery undone via
DSACKs). Thus this ancient tp->retrans_stamp value can cause the
connection to die very prematurely with ETIMEDOUT via
tcp_write_err().

The fix: we change DSACK undo in fast recovery (TCP_CA_Recovery) to
call tcp_try_to_open() instead of tcp_try_keep_open(). This ensures
that if no retransmits are in flight at the time of DSACK undo in fast
recovery then we properly zero retrans_stamp. Note that calling
tcp_try_to_open() is more consistent with other loss recovery
behavior, since normal fast recovery (CA_Recovery) and RTO recovery
(CA_Loss) both normally end when tp->snd_una meets or exceeds
tp->high_seq and then in tcp_fastretrans_alert() the "default" switch
case executes tcp_try_to_open(). Also note that by inspection this
change to call tcp_try_to_open() implies at least one other nice bug
fix, where now an ECE-marked DSACK that causes an undo will properly
invoke tcp_enter_cwr() rather than ignoring the ECE mark.

Fixes: c7d9d6a185a7 ("tcp: undo on DSACK during recovery")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6743b6bfbc9c5..2621c262f182a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3046,7 +3046,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 			return;
 
 		if (tcp_try_undo_dsack(sk))
-			tcp_try_keep_open(sk);
+			tcp_try_to_open(sk, flag);
 
 		tcp_identify_packet_loss(sk, ack_flag);
 		if (icsk->icsk_ca_state != TCP_CA_Recovery) {
-- 
2.43.0



