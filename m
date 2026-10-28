Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214785;
	b=mCQT230ZeOneScvUyyl25gtQsXPuHdOMywlBKVosVuu7/ntaK+lt54Cld1CVRe0xTmsG
	 6S+uzX7N54fcmAeNr6xtr/qvwznfxzEAjcOt0zhSkamh7TXEjUrZytqyneCf2kNSnTb0X
	 AoQQ6qWzkgFiAx9vE/sFY4pOR2OoYE8jEc3DmftOsxuZuvPvLScDPjL0+3QifAN8ImaI3
	 giMJ0B31Htu+61lRTiWevAJrMH/fHit+XarMv/MI8XEi/CF5reS5/gJhfYkmNZDd/Gi48
	 R0rww6PRV/O+uBkQM3s4E+M/jIX257KKGNyhx7k78bzNFRZFvv3CvTdi4XXYvFxtY+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bzj0KSfUKPr0M6yyjZpVwSbYTkiAcRIt/q8h+Ke9ARU=;
	b=YPC0iLaqz/fRjsdK0MkiZwYXLzBLZYpiECDGh3slp487lodt+z+erJc8EFewbOg2gp4s
	 J34PPNMUHbH6d4QcvgN279Z6v6spyFhyqhE8RbDo5WK/zM8gmip1bihE+Nu+VWGZgjwuV
	 /XgzCSPbJzzljWnJU4yxkOGcHnAo3oVcj8mWpOagATHAd8QtZ0DzEeGuGZLv7huVpDjdd
	 rdJH0QTtUQUe+Dmm9LK4Yohan2uPFdmY0+FnV2hrRfB008Bt2fVAvm59YpglBsDXgcksJ
	 NZSF0Flp71q+Xc+keoeJg38vDhVWLu3fVO+aGgH0tU1cHufHafALzMj4vjXpYjjdC8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqC8W9kw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5032A606B7CF;
	Wed, 28 Oct 2026 19:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqC8W9kw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A38F1F01825;
	Wed, 28 Oct 2026 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214785;
	bh=Bzj0KSfUKPr0M6yyjZpVwSbYTkiAcRIt/q8h+Ke9ARU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqC8W9kw8pF9bSZ9eAeinaY0oLVkguDF7qInq387ADZvZNjDcyp4SDfEydoFzrNju
	 znVnGxZpxlhl7b7FtPBt8TsuusBbAxznqWeGftlPTFE5x8IYIwclGyNrtYR8G0WaOH
	 nFdLd4piWddq1twVX9YxxwZO/G85wv7Y5TBju4gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Justin Iurman <justin.iurman@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0980/1887] net: ioam6: fix OOB and missing lock
Date: Wed, 28 Oct 2026 17:51:16 +0100
Message-ID: <20261028170521.712244338@linuxfoundation.org>
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
index a1953cf6131be..8db53f4da6604 100644
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



