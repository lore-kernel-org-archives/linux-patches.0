Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5D11EDA0F;
	Mon, 23 Jun 2025 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713422; cv=none; b=h3RqXxSV0cVpArjKvZgpouEbiDTXEtRSJxuCT0rUFy+JqjJKSYieBwmywtxyPxX9UJvh05GENbdET2GKNlm6y/dGUgsaCh3tKT06H44itYgbQIw7bOI6UsKe5uGc9ezEHRufB0HMXbSSKLrzKjLT+UwFSjNNgm+ZR6CzQyS82HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713422; c=relaxed/simple;
	bh=9DZqctmU38LiQhuK/hIMAto1jeADd91NUSyL/nuzcEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK99HjxQ1GiS70FxpaZVY3d2VHwpz76u2At3OsuINCad18DkEsS/JplBpqZrQQ6cX2K0ZahZiOQj8i83Z1dF0Q+eNqDtyAbzdgY1TxsNcLndPZvbvlhkCnRKwo0MyzJDnOchMHWwHih1//28cMnwLBdOlBN5OpLAgZl4cKWixM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MImKx3wA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MImKx3wA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E60C4CEEA;
	Mon, 23 Jun 2025 21:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713421;
	bh=9DZqctmU38LiQhuK/hIMAto1jeADd91NUSyL/nuzcEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MImKx3wAj9TrbqfQWDR73HtGgZG+wiMA+arhpSpz1ui4sU4Eic3fhGhrU8klVklJV
	 5pmaPhIjXF9Z7n9qQiquNxcSjK+IHuJ14ZRcDjTT2U2s1k2Uqd3sM4xmlr0ZsDyt5U
	 KoH3ck7z7hWm4ffJe+bE5ZWlyrdRJQQKNdCmKxoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Wheeler <netdev@lists.ewheeler.net>,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/222] tcp: fix tcp_packet_delayed() for tcp_is_non_sack_preventing_reopen() behavior
Date: Mon, 23 Jun 2025 15:09:00 +0200
Message-ID: <20250623130618.470910055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit d0fa59897e049e84432600e86df82aab3dce7aa5 ]

After the following commit from 2024:

commit e37ab7373696 ("tcp: fix to allow timestamp undo if no retransmits were sent")

...there was buggy behavior where TCP connections without SACK support
could easily see erroneous undo events at the end of fast recovery or
RTO recovery episodes. The erroneous undo events could cause those
connections to suffer repeated loss recovery episodes and high
retransmit rates.

The problem was an interaction between the non-SACK behavior on these
connections and the undo logic. The problem is that, for non-SACK
connections at the end of a loss recovery episode, if snd_una ==
high_seq, then tcp_is_non_sack_preventing_reopen() holds steady in
CA_Recovery or CA_Loss, but clears tp->retrans_stamp to 0. Then upon
the next ACK the "tcp: fix to allow timestamp undo if no retransmits
were sent" logic saw the tp->retrans_stamp at 0 and erroneously
concluded that no data was retransmitted, and erroneously performed an
undo of the cwnd reduction, restoring cwnd immediately to the value it
had before loss recovery.  This caused an immediate burst of traffic
and build-up of queues and likely another immediate loss recovery
episode.

This commit fixes tcp_packet_delayed() to ignore zero retrans_stamp
values for non-SACK connections when snd_una is at or above high_seq,
because tcp_is_non_sack_preventing_reopen() clears retrans_stamp in
this case, so it's not a valid signal that we can undo.

Note that the commit named in the Fixes footer restored long-present
behavior from roughly 2005-2019, so apparently this bug was present
for a while during that era, and this was simply not caught.

Fixes: e37ab7373696 ("tcp: fix to allow timestamp undo if no retransmits were sent")
Reported-by: Eric Wheeler <netdev@lists.ewheeler.net>
Closes: https://lore.kernel.org/netdev/64ea9333-e7f9-0df-b0f2-8d566143acab@ewheeler.net/
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Co-developed-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2378d561d171d..6b3bb8a590353 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2290,20 +2290,33 @@ static inline bool tcp_packet_delayed(const struct tcp_sock *tp)
 {
 	const struct sock *sk = (const struct sock *)tp;
 
-	if (tp->retrans_stamp &&
-	    tcp_tsopt_ecr_before(tp, tp->retrans_stamp))
-		return true;  /* got echoed TS before first retransmission */
-
-	/* Check if nothing was retransmitted (retrans_stamp==0), which may
-	 * happen in fast recovery due to TSQ. But we ignore zero retrans_stamp
-	 * in TCP_SYN_SENT, since when we set FLAG_SYN_ACKED we also clear
-	 * retrans_stamp even if we had retransmitted the SYN.
+	/* Received an echoed timestamp before the first retransmission? */
+	if (tp->retrans_stamp)
+		return tcp_tsopt_ecr_before(tp, tp->retrans_stamp);
+
+	/* We set tp->retrans_stamp upon the first retransmission of a loss
+	 * recovery episode, so normally if tp->retrans_stamp is 0 then no
+	 * retransmission has happened yet (likely due to TSQ, which can cause
+	 * fast retransmits to be delayed). So if snd_una advanced while
+	 * (tp->retrans_stamp is 0 then apparently a packet was merely delayed,
+	 * not lost. But there are exceptions where we retransmit but then
+	 * clear tp->retrans_stamp, so we check for those exceptions.
 	 */
-	if (!tp->retrans_stamp &&	   /* no record of a retransmit/SYN? */
-	    sk->sk_state != TCP_SYN_SENT)  /* not the FLAG_SYN_ACKED case? */
-		return true;  /* nothing was retransmitted */
 
-	return false;
+	/* (1) For non-SACK connections, tcp_is_non_sack_preventing_reopen()
+	 * clears tp->retrans_stamp when snd_una == high_seq.
+	 */
+	if (!tcp_is_sack(tp) && !before(tp->snd_una, tp->high_seq))
+		return false;
+
+	/* (2) In TCP_SYN_SENT tcp_clean_rtx_queue() clears tp->retrans_stamp
+	 * when setting FLAG_SYN_ACKED is set, even if the SYN was
+	 * retransmitted.
+	 */
+	if (sk->sk_state == TCP_SYN_SENT)
+		return false;
+
+	return true;	/* tp->retrans_stamp is zero; no retransmit yet */
 }
 
 /* Undo procedures. */
-- 
2.39.5



