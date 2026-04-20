Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C642E2665;
	Mon, 20 Apr 2026 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700955; cv=none; b=D4Q5iD/NS3hlv9kg1nNWpZY5f4ngi7URFxkaKY2oCIeXgEvUqZeypfd+sCIO/uYtAu/hrW8hNyKMYukT7bIzjU2uOTl1AwuOGZBgUXZPAD+TCC8c9BRX5cFK29u6ZlrytmMJ1IPBqcphyszZw2EyPanIQypbYECptPzdm9q1i5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700955; c=relaxed/simple;
	bh=IKnzkkZunZyKAloUoT6fwQGHKiKVxnN4W+KeTmFh27s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GozfihwpoS/8wk5R9M5GosoACqtumSS55Tf4b6EmpEq30hf+q1B4YnQGUc8KiGMX/ecuLkY8LyOPVG98B9GBk5U9NUF7PjuAyYSsdPBe8cc5JoNRFjAzzendQyTKVNPCOgE7Fyi+kPR2X8/fK8fiqens/yi0MLUxoG2PwY/2rvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKraBXcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKraBXcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177F1C19425;
	Mon, 20 Apr 2026 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700954;
	bh=IKnzkkZunZyKAloUoT6fwQGHKiKVxnN4W+KeTmFh27s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKraBXcDVj3EbJcAwXfAQ8odyyXiEErIR6DbDV5DAiL+Tskar0YO4fViiH/bj9d+J
	 LwQbtUVLtvOKt+StsfSaigNVM9SojqAXvnxlPi/VStig9X7CuiMoIpSqRCELk0c7sg
	 e9lCQNI5kUgwZ/9kfdmLdrljXe7NMbJlHQ9eb/0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Justin Iurman <justin.iurman@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/198] net: ioam6: fix OOB and missing lock
Date: Mon, 20 Apr 2026 17:41:26 +0200
Message-ID: <20260420153939.455680868@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



