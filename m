Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460D244661;
	Mon, 20 Apr 2026 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700317; cv=none; b=h8oqVBLr1nHBhkqKj+l4ZCMOFPsB24KoV5zmlZp91mUWVrGkIo2Fb6n8GId6sxrPnsk0oo7q46/F5QSQlnOa3pguaHDz+tqj3oJazbn0e9HuCReUuJ7PYble+W2nzvW973GsF6B+XVLOPPhNw/cqDuhzHMioF8TkxL/MMROA2bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700317; c=relaxed/simple;
	bh=HtcDEXlrwDkhswwnjVfOBx4gcQzr0FTi1i1YxYCbLSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhu3nFF4HfOgJ4IEZcRFUpxP2Jo13NYOscbRDbRb4vqz4JHgsm82IQ717Mcnpsf/dJUsZb66e5yipI9BMNS8DrjPz3gn+Tsbx8pKCqS+O+UTd/lXxjzIaDIqyusVR6MjwKBzx4Z5glbhqOpMDIGw3NZSJ8SGoo6oXOAoReflwFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qaa6lP4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qaa6lP4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF6CC19425;
	Mon, 20 Apr 2026 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700317;
	bh=HtcDEXlrwDkhswwnjVfOBx4gcQzr0FTi1i1YxYCbLSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qaa6lP4CdaOKtzYuLljTae961iBud0MXDEckMxWQNIV5nTagZVVWBOKGiIzmmVv82
	 OwVEGwgJ0vBHg/D+nrxLTntqBMZwOm8qtbuVaw07lwfywBrDWO54rzHFZxDpKF791S
	 ViLKVYDHJOaKIE9DaDNdk3oJLsZ3QEClSh5a5jCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Justin Iurman <justin.iurman@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 125/220] net: ioam6: fix OOB and missing lock
Date: Mon, 20 Apr 2026 17:41:06 +0200
Message-ID: <20260420153938.528393651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



