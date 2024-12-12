Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132B621578F;
	Thu, 12 Dec 2024 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020668; cv=none; b=Y8icb6m43Y/ZmQJ+lcrdhWlB3hRvVmW2prS1k3t/g3yFDNmz5loyTB0mjeQdawlaZJ+rraPXYng8BX693AiLOW6IBUbdhS6qMgmuvspmUmERZAG0O7wy1TypKThATH1ycW2Q57PZIkUclIGRo6UjZD+TKhFgUJ2V8rfkirUFDV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020668; c=relaxed/simple;
	bh=ok1dTBx5Pg/QCMSFVrVFLEhvE0qCE6nNCMEcKvENhT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPWlK+n3g4dOHxudSExYIE0gF5txe6IuvaDdWIE4w2nkV+BZeXiaI8NiAr0GanV+qfEYUion/k+rm6TGdQCBeKYd2ekoPH7uQH0z4jE9Rj6BULz2+mWzcg8bD+Bf8pkubKYbRFQnM+2vRb+O1IoXCqt4cskPBp0KFlhpOs+XoDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXaPbCQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXaPbCQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6693BC4CECE;
	Thu, 12 Dec 2024 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020667;
	bh=ok1dTBx5Pg/QCMSFVrVFLEhvE0qCE6nNCMEcKvENhT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXaPbCQKe3M47q/tBl/qJ32tyHeo+DW681AM1VROpLqvKUUeTjXZmHUoD3QavwEgX
	 yeEZLZXK/xvFlxOyjUo8q03PBsXxKSGw1Nkr5SY2bMt20BpIMy6WHglamRQwJg11Z3
	 6jQv1vjhfJ+VsX7zUGJJHUcxoqQ4EKxfHfVrnVrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Ottens <martin.ottens@fau.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 529/772] net/sched: tbf: correct backlog statistic for GSO packets
Date: Thu, 12 Dec 2024 15:57:54 +0100
Message-ID: <20241212144411.821479115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Ottens <martin.ottens@fau.de>

[ Upstream commit 1596a135e3180c92e42dd1fbcad321f4fb3e3b17 ]

When the length of a GSO packet in the tbf qdisc is larger than the burst
size configured the packet will be segmented by the tbf_segment function.
Whenever this function is used to enqueue SKBs, the backlog statistic of
the tbf is not increased correctly. This can lead to underflows of the
'backlog' byte-statistic value when these packets are dequeued from tbf.

Reproduce the bug:
Ensure that the sender machine has GSO enabled. Configured the tbf on
the outgoing interface of the machine as follows (burstsize = 1 MTU):
$ tc qdisc add dev <oif> root handle 1: tbf rate 50Mbit burst 1514 latency 50ms

Send bulk TCP traffic out via this interface, e.g., by running an iPerf3
client on this machine. Check the qdisc statistics:
$ tc -s qdisc show dev <oif>

The 'backlog' byte-statistic has incorrect values while traffic is
transferred, e.g., high values due to u32 underflows. When the transfer
is stopped, the value is != 0, which should never happen.

This patch fixes this bug by updating the statistics correctly, even if
single SKBs of a GSO SKB cannot be enqueued.

Fixes: e43ac79a4bc6 ("sch_tbf: segment too big GSO packets")
Signed-off-by: Martin Ottens <martin.ottens@fau.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241125174608.1484356-1-martin.ottens@fau.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_tbf.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 277ad11f4d613..c4c91b55e98b0 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -207,7 +207,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	struct tbf_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *segs, *nskb;
 	netdev_features_t features = netif_skb_features(skb);
-	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
+	unsigned int len = 0, prev_len = qdisc_pkt_len(skb), seg_len;
 	int ret, nb;
 
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
@@ -218,21 +218,27 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	nb = 0;
 	skb_list_walk_safe(segs, segs, nskb) {
 		skb_mark_not_on_list(segs);
-		qdisc_skb_cb(segs)->pkt_len = segs->len;
-		len += segs->len;
+		seg_len = segs->len;
+		qdisc_skb_cb(segs)->pkt_len = seg_len;
 		ret = qdisc_enqueue(segs, q->qdisc, to_free);
 		if (ret != NET_XMIT_SUCCESS) {
 			if (net_xmit_drop_count(ret))
 				qdisc_qstats_drop(sch);
 		} else {
 			nb++;
+			len += seg_len;
 		}
 	}
 	sch->q.qlen += nb;
-	if (nb > 1)
+	sch->qstats.backlog += len;
+	if (nb > 0) {
 		qdisc_tree_reduce_backlog(sch, 1 - nb, prev_len - len);
-	consume_skb(skb);
-	return nb > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
+		consume_skb(skb);
+		return NET_XMIT_SUCCESS;
+	}
+
+	kfree_skb(skb);
+	return NET_XMIT_DROP;
 }
 
 static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-- 
2.43.0



