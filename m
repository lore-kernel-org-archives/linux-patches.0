Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE0D2AF1D;
	Fri,  9 Oct 2026 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556244; cv=none; b=uQ0/Ohxrb6R/ZIVhH0JtXpmF4IdKSebb/n0aCIa26v4uHiI3np8s902f1Ut1fug9iX8si0jEAVmWPBKj7jE9j+W3qrsVlELn3N/Wcge0ccGTAVH2J0l9EBlVCD6+s1z2DqaTazAxtmgler9gaECEqUd+wizpfP7pFs0cN7KQIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556244; c=relaxed/simple;
	bh=mtJ1Cb13tWHrr5yzJzgvnVYK2dT06VTcABRHZaueMWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMu8M/CSMqAr2MHMGEgwAQfwIHonYeg38zmvL6gK7zjOg0dORenep5xeZi9a3wrnEuUVfybAPoQZmsGe8pGv5F1aDWm8kHRDYxmr4+d3IvSgU0aKSO88WU1Zw/UHbO34l2djw35rVSWKbWaiMiVLsY6eh7ck7pq2uY9cI6sNrbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4vWz24k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4vWz24k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC3C1F000FF;
	Fri,  9 Oct 2026 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556243;
	bh=0/8ikiN4zaPWRvbV12yoESw+YnGaa/As7eryBuFZ+Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4vWz24kr7fDuzV+r70J2v4Q0ejw9vMyrVI7ZbFugfFTXzClL9spskNibs9/TYD+6
	 Kwici4fLjYeJKoi9wh5rGFPG2JV0d+tSAJ1rAOGElJ2Qb1V5X1ZgW2S1ZIAkpUM8Ph
	 estezKibLu8Vsg4kUBCT5FcuSf+0bAFzyxZNCLOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Jo <jeffjo@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 145/428] tcp: refresh TS.Recent for accepted old ACKs
Date: Fri,  9 Oct 2026 16:08:02 +0200
Message-ID: <20261009140949.358026653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Jo <jeffjo@openai.com>

[ Upstream commit 1b92780ae4fc3be64f05d97ed8833c445e73b0cf ]

A TCP packet can carry new data while acknowledging traffic in the
opposite direction. With overlapping traffic in both directions, a
delayed packet's acknowledgment can be older than one Linux has already
accepted, even when that packet fills a gap in the received data.

Linux accepts the data, but tcp_ack() takes the old_ack path and skips
updating TS.Recent, the timestamp saved for outgoing acknowledgments.
The reply therefore echoes an older timestamp. If the sender uses this
echo to measure round-trip time after a long idle period, its estimate
includes the idle time and can reduce its sending rate.

Update TS.Recent in old_ack using tcp_replace_ts_recent(), before SACK
processing can trigger a transmission. This reuses the existing timestamp
and sequence checks, including PAWS protection against old duplicate
packets. ACK validation already rejects old ACKs in SYN_RECV before this
path, so no additional state check is needed.

Echoing the timestamp of the packet that fills the receive gap follows
RFC 7323 section 4.3. In a socket reproduction with 300 seconds idle,
controlled reordering and retransmission to exercise timestamp-based RTT
sampling, the sender's smoothed round-trip time was 37.5 seconds without
the fix and 15.5 ms with it.

Fixes: 12fb3dd9dc3c ("tcp: call tcp_replace_ts_recent() from tcp_ack()")
Assisted-by: LLM sparse
Signed-off-by: Jeff Jo <jeffjo@openai.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 92bc60716f33d..99baf14afdfd8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4465,6 +4465,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	return 1;
 
 old_ack:
+	/* An old ACK can carry new data. Update TS.Recent before SACK
+	 * processing can trigger a retransmission.
+	 */
+	if (flag & FLAG_UPDATE_TS_RECENT)
+		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	/* If data was SACKed, tag it and see if we should send more data.
 	 * If data was DSACKed, see if we can undo a cwnd reduction.
 	 */
-- 
2.53.0



