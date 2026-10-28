Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212686;
	b=isrEFoPTmd/0nsFlD5sAU5Yl8ZQAZRHDhv0iIGPbVmMAgJMYz2uVKful0SZQe+uWxlnZ
	 LG88LWhtmFBk9wYGubInjxkrL4sA4P6dsmPEK2lyBY6PMVojG693rkDs+bFmM6g+Qi4W9
	 hg1ZWqSnPyPh/Fkyd1DIubnjILIoG/PcdkQyYdCq9VLDckkBIS0SJROVT5rhAslgd2Ktp
	 GZ30Y5E3J6T3YLZUHR7jTlkVg1ebZL69kzk82jD56hiWlNI/zRXvgrYFebGFIzShNkmoj
	 Nvs0lacXeHUCOibVv7CSyvO+uDnSpXasbm0TAaN5iqwa5BBHp/DHCNlkuXvQ2nx/CUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UigLXcoSUb1G8Rtto1VKrm7jfdDRGGv4QEE5y+AC96g=;
	b=46fBOZA1ztk3V/FPrIjheSEpKE/xgsAQF0rQF0Zdy2iS+ieuFmYwhycDj9WkYEwq/py3
	 ZDrTUFCAwIR4FSDKIoroj70murTikxDoM4f/cVKRWVYGIn5Vi8e4Lh3awamHPLIOT5hhh
	 XuVsPVLPoZUE0g20lJ85cpSXq2BSug15ACM3REWTUHF6qtMq4BTTbqg8kmv3R0hN32e9t
	 0b3VfCn+GTqU7Hhh458FimYVSo1DMhrrpt9elx1pQQAKS3GA0Tw7QPCJTEeminRBruED3
	 D1KibgnspCUzngUcZ5L7Y7Li1NS23kNBTBBLnQFYWhU5nVGsXnfZvjl/XKZsUTT4OpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MaQI33l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDAF606A31C;
	Wed, 28 Oct 2026 18:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MaQI33l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4AE1F01825;
	Wed, 28 Oct 2026 18:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212686;
	bh=UigLXcoSUb1G8Rtto1VKrm7jfdDRGGv4QEE5y+AC96g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MaQI33llTqiy6l39OYI2CIIBrYey8vz4j+Rh/4BDLBE4Ewx/IV00SVlE+3nyZi7p
	 boxNEB15UJGui+BmWUM5Wo7WswPtjJVfR7KqGDvxJ4xA4sUZWPN+4G0ZS42mTbVpl+
	 QC+rUUlSjltxKMWwUGwm1puvRErj6wT961Lur6g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Jo <jeffjo@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0240/1887] tcp: refresh TS.Recent for accepted old ACKs
Date: Wed, 28 Oct 2026 17:38:56 +0100
Message-ID: <20261028170504.693399408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4ab6222ff180c..488b1926a2eb2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4024,6 +4024,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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



