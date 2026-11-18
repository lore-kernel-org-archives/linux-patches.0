Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021855;
	b=nO0sURt9G0Lihij096WzxI4sMZOzokGafDflz7MHrZtwBktEDsLFyBYlbmsSw+3jsbXQ
	 Ho1nS1Jky1lcHyD9WO/XSyEuUBMvy3Sttb0dOWfrwA4KVbkG7pwnDN0zPj5FYm6Qmtzr1
	 qz0QxYAL8umtvqDgh2IR8iP6W9sWjS6C2bGkeRLUrtTjAH8+d77jg8S72N13fbecYox5/
	 FA1cMZ9vT2PCHlDrkBD9b8Lnf2bBbz7eP15805BFKnVcUxLnC+Z9v5udz8qXAoTteEtSa
	 IQSTcTNEmYVZ8RMhOZdaTlNwFrcNOctHzcntDA+g/z5UGGGuR3Gcqd989cRl/UQwDHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R21XpJOpeZtEADLGngZEZHz12vIQQZI4HGYzyWbL1ME=;
	b=pHNZqS8DyhmZeK1zRT8bDlb17TRsWujOQE6tWD05+G+f2KYp9vOUqyYuIKi/g2uQ7TXB
	 By365kNGg6DPQX6C8AFvyCVdzZgfEL0nZv7T8ZNdsT8vAo5MoCjXTfrnmL2HPD1IzPiUS
	 or5ENOl9ACNE53YRF1mmfHU9LMjbbeeeW8K4wmQKTmk+MZgbJjlBbl2W+2QpzD9EvAJRb
	 v593e+AoSlT554kAnYTlT4/vXgUaypd+ZS2zgpXHzT1iiayAjxPpFJiQjbL8WkwpliypL
	 ypr0LBp1zYf49fudzMM+HO4PPtZ7+tDAqApJDHu0yu+4b2EfLB3maXLKFp2jkO5rVfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FksZ0tTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932BD606A31C;
	Wed, 18 Nov 2026 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FksZ0tTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B461F000C4;
	Wed, 18 Nov 2026 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021855;
	bh=R21XpJOpeZtEADLGngZEZHz12vIQQZI4HGYzyWbL1ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FksZ0tTo8z26vJIBwPJtMP4z5hw61+eoJ7nWJfPo8kvjoTghbsVkyFelxooYKZ6x0
	 WAy0DfWA+1a1ZVzf+FAzAZMYX37OUbawWuZhqPQbmw7Cp6KGCQnn1j1YeX11nDFjwi
	 zhFkyMxe1GMtODDvWwHxXiCi3pJxbSAfoX/co6Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2448/2651] net: harden qdisc_pkt_len_segs_init() against malicious GSO packets
Date: Wed, 18 Nov 2026 16:01:28 +0100
Message-ID: <20261118150413.257603513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit c6648c9f3b51c5a8a3df470c1542b2aa378d88f9 ]

An SKB_GSO_DODGY packet can carry untrusted gso_size and headers.

For instance, gso_size=1 and hdr_len=65532 for a 524275-byte frame
makes qdisc_pkt_len_segs_init() compute an accounted length of
about 4,294,574,091 bytes (after gso_segs silently wrapped in a u16).

With DRR quantum 256, the dequeue path then needs ~16.8 million
deficit refills before it can dequeue the skb, keeping the CPU in
the qdisc path long enough to trigger the soft-lockup watchdog.

Commit 8f735d64382d ("net/sched: bound qdisc_pkt_len to prevent
qdisc soft lockup") added QDISC_PKT_LEN_MAX to bound size table
amplification. Use the same bound for DODGY packets:

- Make gso_segs a u32 and drop packets whose segment count does
  not fit GSO_MAX_SEGS, instead of silently truncating it.

- Drop packets whose estimated qdisc_pkt_len() would exceed
  QDISC_PKT_LEN_MAX.

Fixes: 15e5a0307164 ("net_sched: better precise estimation on packet length for untrusted packets")
Reported-by: shaos <shawnq1@163.com>
Closes: https://lore.kernel.org/netdev/20261022144755.65025-1-shawnq1@163.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261022155436.117507-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 455ee43c248b1..2d033b45a3f00 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4178,7 +4178,7 @@ static enum skb_drop_reason qdisc_pkt_len_segs_init(struct sk_buff *skb)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	unsigned int hdr_len, tlen;
-	u16 gso_segs;
+	u32 gso_segs;
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
 	if (!shinfo->gso_size) {
@@ -4231,6 +4231,15 @@ static enum skb_drop_reason qdisc_pkt_len_segs_init(struct sk_buff *skb)
 		if (payload <= 0)
 			return SKB_DROP_REASON_SKB_BAD_GSO;
 		gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
+		/* shinfo->gso_segs is a 16bit field.
+		 * Also make sure untrusted gso_size/hdr_len can not inflate
+		 * qdisc_pkt_len() beyond QDISC_PKT_LEN_MAX, or deficit
+		 * schedulers could spin in their refill loops.
+		 */
+		if (unlikely(gso_segs > GSO_MAX_SEGS ||
+			     skb->len + (u64)(gso_segs - 1) * hdr_len >
+			     QDISC_PKT_LEN_MAX))
+			return SKB_DROP_REASON_SKB_BAD_GSO;
 		shinfo->gso_segs = gso_segs;
 		qdisc_skb_cb(skb)->pkt_segs = gso_segs;
 	}
-- 
2.53.0



