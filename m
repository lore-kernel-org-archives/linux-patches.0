Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C86375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302564; cv=none; b=fNHakw+x1Irnh/tYst/aSdMWsDceR8r/dtjWUWmqv6Y7YFH+7mJ7F+ouX6TefYxjOxk+Tziv3UFNwj1H8NwFLDLYYNDGzD3bVkGzNz2UYUooQfu0mdzF970aqQ3nBvnlf3UpZcfsjVY8z7SVTpYD50yxbA1xxfjq+4tzWR8ns4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302564; c=relaxed/simple;
	bh=SPggF8X7DJK6SBY7qTDtg4stTnZQ9LBnQMF0uM7dknM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1/s2Y7EGR5J5nGTV1x4ocnv2dB7vZ74J+v+V31u09OTuEFIkZSxtzld3+808IbmJjxSB03GkSbLo3C4R7a+qlvVF1rphfalbWulbxFkTlR94Xm3IvmQ4LstZ3ASAG75QyOaVlAn58xzkbdv9xuwHENPQDAPx4JU7SEt8sC8yts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhvWyC5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhvWyC5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1682C19423;
	Sat, 28 Feb 2026 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302564;
	bh=SPggF8X7DJK6SBY7qTDtg4stTnZQ9LBnQMF0uM7dknM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhvWyC5Tpp+W7XPTQw8aPFTwRu0kJnmrB2zzTN3b2xRIayPoaedaELbv165cRmmEZ
	 FKZxSUPs7PkUVUX18ZcCnN9k4bLNs1TVUrMA9LlB6sGz5pMg3LzM0j5f9jPld84+sv
	 pHBqKirH9z2/VMGwCj9YoMTTDFN7vlSctxjxl0m574ANKfkUOk3QXj8JRVmIEqHB2k
	 fpof2u4LGZzp7mFsb7RuYR9vLOU+iP/KVc5k+qPuEKJ94ZmoiuYmIYd+jljFVdfbrF
	 DFNbgEdMttXZGYAfC+zrojwI92nRREb6OXNwMQY6UtwfaLXhfLG+UE48vHFZvC2SJj
	 K0eNyNiFsudkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/164] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Sat, 28 Feb 2026 13:13:29 -0500
Message-ID: <20260228181505.1600663-70-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 838eb9687691d29915797a885b861fd09353386e ]

tcp_tx_timestamp() is only called at the end of tcp_sendmsg_locked()
before the final tcp_push().

By the time it is called, it is possible all the copied data
has been sent already (transmit queue is empty).

If this is the case, use the last skb in the rtx queue.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260127123828.4098577-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b3d373372e841..36981a3e9013f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -471,6 +471,9 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 {
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 
+	if (unlikely(!skb))
+		skb = skb_rb_last(&sk->tcp_rtx_queue);
+
 	if (tsflags && skb) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 		struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
-- 
2.51.0

