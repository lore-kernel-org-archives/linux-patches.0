Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E3C4BC023;
	Mon, 20 Apr 2026 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691975; cv=none; b=HDdOmSfZ1oqSaO2gInL+bnglqdgCbK4/eTgO/tGPKt2xgXOFDk1tvtP0gX6w3y09xmYnLajGbcwA65nIHvNMwq8hvwQ7yr/iwfOsgdO5yQfWfOtlh3xOB3ROAP/nSOsNgksN2Ty2zLPeCCQQVKXmKlh813US2jjbj9e8kAKTHV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691975; c=relaxed/simple;
	bh=QZGRzo0jnTbhPPd+/ZY0zfEDwZtH05XVa3owuElNTLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgJRYYlvCwqnxZ0RFjL4rURouQvIT3dGpdEoUGtvTnsV/5MRig1Ga2s47yjrEvVe/IRc3MnMYg+E1CswnNemgBDXTTXpGd8bsXffHPjkKNGxgbT42CHR5jr6zoyePJY0tH3lmzxOnvVoLB43ys8F72/W8Q6NyO23+frUai2ue2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SH9Qmr9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SH9Qmr9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A9EC19425;
	Mon, 20 Apr 2026 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691974;
	bh=QZGRzo0jnTbhPPd+/ZY0zfEDwZtH05XVa3owuElNTLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SH9Qmr9gX7S3WQF2WHHdOvBPiYiBg+ZJ9dEM+SMKCeGxleKCM2rbMsSPv0/VBnDbh
	 k4YnBNd0ON8wxDjxbZJBWLmpuUQnSpRJV6iAgG/R/AsPXNkMZ5IJ8iGo5i7OWroVkA
	 kj1aATZumJtZnbX4ncAFa2blyAy5+686O8pRl7Qe2Q3822DSgEuG1OlPr3hU1I02wp
	 nnsTJxCxw3IFVA8n7jnZqhgLBTrRl/VNZWA+P2xaJtsT8EpC+6JHHOVro+BMQQwWeV
	 WjZJ7EJ0Vu2iLs2jrFDqlhOzQnsnx/UVjQ5zgqwLGwqPhLNvOTPiXeWRwjPpqwA3CT
	 wRwbknLTAJNig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	idosch@nvidia.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ioam6: fix OOB and missing lock
Date: Mon, 20 Apr 2026 09:21:34 -0400
Message-ID: <20260420132314.1023554-300-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/ipv6/ioam6.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 12350e1e18bde..b91de51ffa9ea 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -803,12 +803,16 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		struct Qdisc *qdisc;
 		__u32 qlen, backlog;
 
-		if (dev->flags & IFF_LOOPBACK) {
+		if (dev->flags & IFF_LOOPBACK ||
+		    skb_get_queue_mapping(skb) >= dev->num_tx_queues) {
 			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
 		} else {
 			queue = skb_get_tx_queue(dev, skb);
 			qdisc = rcu_dereference(queue->qdisc);
+
+			spin_lock_bh(qdisc_lock(qdisc));
 			qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
+			spin_unlock_bh(qdisc_lock(qdisc));
 
 			*(__be32 *)data = cpu_to_be32(backlog);
 		}
-- 
2.53.0

