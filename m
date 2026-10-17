Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0402C1F16B;
	Sat, 17 Oct 2026 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258516; cv=none; b=Ln90QnSiPHOtIyPhu3BGxRxmwRTOcl2RQfpBD6PdRGZud2IN72Pw5hMPGIjjxnZnVi3HgNQ3Ga/AOP4j3RTRoqPyeg0+1QDmR/Nl/fbM2UAFSX4f6ESnur+GOVkCtqAK+1A53HDQoW1D6cIclXT8CEhrK7MKNl/YKN4gYSO64yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258516; c=relaxed/simple;
	bh=nZoI3tgowUf+JTgSvHSI/fsk2i8ib1JjfJsAk2sllHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWxktiVnLxb0Fgs22S85mRRyLCrunSbbwfKmH0r1xfiGJkm1fDGcJslJN791RhBJYOFsL1oRe0JYs6ptcEiTkIeFuA5hiPyzoVFBtXfq8ocQuGIkklXKTnVw59dLTbJ+ATS81FguAottExPHo9c9nA5Qr+4iqebuL39AoJLXGgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsdtKAkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsdtKAkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBF11F000C4;
	Sat, 17 Oct 2026 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258514;
	bh=QZ1U2v2y13yXbDH4xzDpfvEHzDfs2bZnkpK7qWFxvx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsdtKAkDZeg6//pLEf0zNxv/fa+SC7uoysu3ntUANh/pgR8Gkhm//jRwMrgyffWYZ
	 MpqYcCIlOVF1h7Bw+bz+pvFuJPY/Z8M082i1Lgcei9uDX3yppdd70tAvwVtc0G1rgr
	 cmjq1zKOEPlssiw6KeODPIOxMcTtsX5U5piZpO/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Justin Iurman <justin.iurman@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0910/1674] net: ioam6: fix OOB and missing lock
Date: Sat, 17 Oct 2026 17:53:02 +0200
Message-ID: <20261017160454.490622617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@gmail.com>

[ Upstream commit b30b1675aa2bcf0491fd3830b051df4e08a7c8ca ]

When trace->type.bit6 is set:

    if (trace->type.bit6) {
        ...
        queue = skb_get_tx_queue(dev, skb);
        qdisc = rcu_dereference(queue->qdisc);

This code can lead to an out-of-bounds access of the dev->_tx[] array
when is_input is true. In such a case, the packet is on the RX path and
skb->queue_mapping contains the RX queue index of the ingress device. If
the ingress device has more RX queues than the egress device (dev) has
TX queues, skb_get_queue_mapping(skb) will exceed dev->num_tx_queues.
Add a check to avoid this situation since skb_get_tx_queue() does not
clamp the index. This issue has also revealed that per queue visibility
cannot be accurate and will be replaced later as a new feature.

While at it, add missing lock around qdisc_qstats_qlen_backlog(). The
function __ioam6_fill_trace_data() is called from both softirq and
process contexts, hence the use of spin_lock_bh() here.

Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260403214418.2233266-2-kuba@kernel.org/
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260404134137.24553-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index fee1e23c3ae19..9bf3be3a26c5b 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -737,12 +737,16 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		struct Qdisc *qdisc;
 		__u32 qlen, backlog;
 
-		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
+		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK ||
+		    skb_get_queue_mapping(skb) >= skb_dst(skb)->dev->num_tx_queues) {
 			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
 		} else {
 			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
 			qdisc = rcu_dereference(queue->qdisc);
+
+			spin_lock_bh(qdisc_lock(qdisc));
 			qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
+			spin_unlock_bh(qdisc_lock(qdisc));
 
 			*(__be32 *)data = cpu_to_be32(backlog);
 		}
-- 
2.53.0



