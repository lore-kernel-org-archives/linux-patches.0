Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208588;
	b=nTROJIm9vJks84Om8M2DgtT7s/E7A/G7e7T3mEr1pd+To0wZ6L6LFtR4FbS90zzCa4kr
	 Ph8mKO0juxvdldw0v7/2Gc/YPHkN1QbGj+IY2e3qslWXTPzKv0rgdv/k9ZaeDQArgBQow
	 7iw5Nbtd6j/vMJmKh5FuD/0/0BcXghQUTR4JX+3d/9kU4VnSx3cp9bGeqLibZ7QDdck3T
	 6Y0RVDmFqWqzWOI9Ut4RZCTYAgjbCPndMo5TH9kZt7XAdmo3v7wD3/i3Fs4qUcf2dZ3Qe
	 2hJlvDGwmmdr7ducz+1lXwxmEcBL7VRlPYnwmmUHQXvyVnzNa4s7z73T+iz0JH8c55Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uhqrB99moITuYV8nE3jZL0dAMo3x+5fyY/hRT670+zg=;
	b=lRmkvcGmKn87PtispXdqntz2hpRyGLF9HflNVRoZgElc98OwIcdRT/bHpfFdiUnzEfNo
	 1wig0Ov7KBvpIZ4fmYNVqib6uhMxSoaZ7BwDKvccqs2HECYw+FPJ4eU7ARGHZj7u/52yq
	 uK682rmDdIhnHnksyZGPD+Nz+zirYhRxSFWmVM5Qdb4w9hVwYPsTfJwxA1i3mUuHthS4O
	 UngQaDXPEoFJI+BRhs5sjHvJ2Oy+zdJwH8/qcd3mefOKN6NrDGd5QikQLwFhUcq695BYA
	 TkOo5uKmsSxDOvW9bUFNYdc9mGsecCAvzL/eqe3l2Ye5/pi3axzIOvTZ5quc+gZyLmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDkx7Mh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF064606A31A;
	Wed, 28 Oct 2026 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDkx7Mh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7111F01825;
	Wed, 28 Oct 2026 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208587;
	bh=uhqrB99moITuYV8nE3jZL0dAMo3x+5fyY/hRT670+zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDkx7Mh6kk46UdXuqnCfZkzqXacdGHjDfhvyR+H8AStvBDtTK8cnl4tzImEdtzp3H
	 vRkkjfBFlesKEYa7WhniYjNr/yANfUvqtN/xG4ZFCcUTJ9yOK6fJQcJae1w9NuBR+B
	 4Cu6aeXTFRaNCKfFmid9N9mOi7qNvbKsdbPmKyDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Jo <jeffjo@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/516] tcp: refresh TS.Recent for accepted old ACKs
Date: Wed, 28 Oct 2026 17:55:23 +0100
Message-ID: <20261028170007.557038929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 43b718dd9583b..111d582dbba3b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3976,6 +3976,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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



