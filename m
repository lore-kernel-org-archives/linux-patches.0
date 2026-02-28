Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D76C2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301797; cv=none; b=u9GAemQxVa+FSTC5hjKEFcUMAiO5HY0IlLVIdV6hmgGqodbHdxeP5LT2BcJItVxfnc2qvBV0c6DWA8no+OFrvZV5bHiUIFyL/qnsmKfTpr9wxzk6s/+kkiqXGMg//pZ1zpIoqXP1eHydGMh+Yo6xTrDIhpZEwctkx9X29sChnrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301797; c=relaxed/simple;
	bh=EXkCIrA1QmIU9xfP2mptPDeP5GsmtT2NFeNxjqtbVW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4y7CFHi9vdkQJsPTTptOLS7zHTYalQ2RSneeXMdExExi71EGTg+0x4lvOBzcUaa2F2fRg0BSNWfa4rhHVQa6SmmBgeg9gf1oEuceuq9Zjo2vVjB9JO5rfkeGTeV+Dj7e+CRu+MtVv0OS042/ie9jKnV4SH3OZXT6GwZ7MoxGQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bz1WLJNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bz1WLJNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD2FC19424;
	Sat, 28 Feb 2026 18:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301797;
	bh=EXkCIrA1QmIU9xfP2mptPDeP5GsmtT2NFeNxjqtbVW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz1WLJNhe5N67OUfTkXCXWd1L7LgEDh83QJ5kN2RLxo3QcpMdSltrpEwF+SPSdJzH
	 rPzf4Kp8k5Qk1luAqd88dqEx4/zM8qfYQTomHbEDDpIumYmnFGxvrUk0b9p90wJixH
	 mBGET+of2QXeQ0gPat1jwZknpoLQ322mQ3vaztt7BDnONnTR89gWCD4ZqbSv5pIvPS
	 0DQjm5TTXkbVr2UBRd7LgHLOdhR2T0jsrxwzs+0qSDVLDnvaxo9zAMU85aURsRXJ2m
	 +LGAB6oNlmxVltdTBb75ZtGV5TW+Orv0S5C/AxdLkJPVGjN2weN3EnDCAH91qeorho
	 nRtc9zKGL5QfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/385] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Sat, 28 Feb 2026 12:57:10 -0500
Message-ID: <20260228180011.1568201-208-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index ad5f30cefdf96..4090107b0c4d5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -481,6 +481,9 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
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

