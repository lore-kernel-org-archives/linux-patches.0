Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211008;
	b=w3m9Xp3jDLuFnOll3EbxT8xIadWSowdpneWL3ND3TRp5CTKgDkp3/2DcpwK0s9Itpm/u
	 bF43AtcV9x09Nlxa2Id1wFQ1+6lsNznUr0Lp4wDhdRmBDDT2rSq/Ha8nUtsk2MBgYjgBN
	 r8sg7R6aV6Ejvv/MomGrOZw6MZD7sRj0d01akUUAJSXPGId5cCLdEQwSs7kws7dLa/M+O
	 5GVpcKHbeHL3mvhb7rXJmYURmDLURjNIUm63qKG40tUPN/HqmadsETA0uopYAiy16lcW4
	 SBF6bAR2gpPXSfzrY9okss2+Hd1P4Y6CsoNR14Zaumwc5kl1ylGGQTZX2hmkv9FdE2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5GqYCN6IbGaXfNpvNg/pCnQJl8VH3zcJlIC9zEgtZbs=;
	b=I0+OKq1BguXi8FV21n2F08UoIRoH1wAEnHX3LlhWaXwG72+Vni5gVmL+8B1osBJpW9Hs
	 QHlwZh1gBm+XCqDBg0Vm1Zk61x9IPGUPTBYJFfPXAMPjZFNAwF5LJ3HD6RUzLffCmrXbi
	 HCpiBT3zXQiwKsowm+jZmxWPM9IXry+TU4yVWP3Ripzm0i2ncB72ASmcl4+hmACDJN9px
	 QRmD1fn6IYyZ6j34qMldCSqnZqXVH4LUHADbxPX6qmnf3WV7CUJgMPxu/dwV8BKjfLktB
	 +UiK9rBz0oBFT++RUPeqlsygiiuemNlQm8i0pXUp00Li0X8qosKA07nr2XfmnIOZm/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jY4mRw2G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E2606A322;
	Wed, 28 Oct 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jY4mRw2G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2C01F01825;
	Wed, 28 Oct 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211007;
	bh=5GqYCN6IbGaXfNpvNg/pCnQJl8VH3zcJlIC9zEgtZbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jY4mRw2G++Fj+ry8dNYhcZQTepUc1CZrLtO8x39j4/+v/PtZww4BSx6jsDvZk9jh5
	 YzvjDgPzDuFFxdHKTMDW6AZsvxcTiXZJnj0HCSgvxHIsaVp+Zzf7/kXsVL+JfG6m97
	 ejHdyUnXGK10uQg2B4fz8RQT4+cv6kEhxba1CO+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Jo <jeffjo@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/571] tcp: refresh TS.Recent for accepted old ACKs
Date: Wed, 28 Oct 2026 17:55:28 +0100
Message-ID: <20261028170012.307423608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b746b62b854ab..4a481dd4579b1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4017,6 +4017,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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



