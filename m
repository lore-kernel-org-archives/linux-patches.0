Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7A4C6E;
	Mon, 23 Jun 2025 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686190; cv=none; b=BwiE4hJqSUwCtZUY8Hy+T+Z7VKO5Y7SqBuKiI+UTcoFrhB5ecS26rhTokyv3Z6/u391hdbSuuSjrF+By4GvlK/5cX+j7H+TeUt2IgM5ZsxDupvJLZ7uCtr3dWIQ6+1ycx86BqITOFR4CbFq2O193yxp0N/GFzj3GXaCGHY3nHxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686190; c=relaxed/simple;
	bh=a/47+7GvjOyAuFJ2of8yaRN1s7Cz84VYFw2QR0WO/ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ko6beSuewlJ5NC/osPzvoVuxax/yLfHltvVIwSrVfV5EUWU7D3XxZ181j6qsqebgXqe8ZJVbWeR5ezMWgemEmzLRt/O6S98XHSWz4ATc0XfCIQZ9LnQpgvNgpMtn6ucwfaM0B3lb6jfcjNLOCyVZYcwU6Vi85dy6PSnZ9mub5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiJ4Dn9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiJ4Dn9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C82C4CEEA;
	Mon, 23 Jun 2025 13:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686190;
	bh=a/47+7GvjOyAuFJ2of8yaRN1s7Cz84VYFw2QR0WO/ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiJ4Dn9XWaGu4obF0RyJyJYSpwU61mruFTh+nLy27ztn8IRNJQdUlU4iEJYNUecIl
	 6dfOC1n+eyI0lpPwRjTqNYCq6Dl40teNLUexVA8llra0bU5mtZsHVG0xS6K+rXYrPr
	 A7V2ghqlIpCXbIS2WW082GTTVRr5NkMKaOuaSkxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Wichelmann <marcus.wichelmann@hetzner-cloud.de>,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/355] net_sched: sch_sfq: fix a potential crash on gso_skb handling
Date: Mon, 23 Jun 2025 15:05:21 +0200
Message-ID: <20250623130630.363787564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 82ffbe7776d0ac084031f114167712269bf3d832 ]

SFQ has an assumption of always being able to queue at least one packet.

However, after the blamed commit, sch->q.len can be inflated by packets
in sch->gso_skb, and an enqueue() on an empty SFQ qdisc can be followed
by an immediate drop.

Fix sfq_drop() to properly clear q->tail in this situation.

Tested:

ip netns add lb
ip link add dev to-lb type veth peer name in-lb netns lb
ethtool -K to-lb tso off                 # force qdisc to requeue gso_skb
ip netns exec lb ethtool -K in-lb gro on # enable NAPI
ip link set dev to-lb up
ip -netns lb link set dev in-lb up
ip addr add dev to-lb 192.168.20.1/24
ip -netns lb addr add dev in-lb 192.168.20.2/24
tc qdisc replace dev to-lb root sfq limit 100

ip netns exec lb netserver

netperf -H 192.168.20.2 -l 100 &
netperf -H 192.168.20.2 -l 100 &
netperf -H 192.168.20.2 -l 100 &
netperf -H 192.168.20.2 -l 100 &

Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
Reported-by: Marcus Wichelmann <marcus.wichelmann@hetzner-cloud.de>
Closes: https://lore.kernel.org/netdev/9da42688-bfaa-4364-8797-e9271f3bdaef@hetzner-cloud.de/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20250606165127.3629486-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 066754a18569b..6b65c5efb378e 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -317,7 +317,10 @@ static unsigned int sfq_drop(struct Qdisc *sch, struct sk_buff **to_free)
 		/* It is difficult to believe, but ALL THE SLOTS HAVE LENGTH 1. */
 		x = q->tail->next;
 		slot = &q->slots[x];
-		q->tail->next = slot->next;
+		if (slot->next == x)
+			q->tail = NULL; /* no more active slots */
+		else
+			q->tail->next = slot->next;
 		q->ht[slot->hash] = SFQ_EMPTY_SLOT;
 		goto drop;
 	}
-- 
2.39.5



