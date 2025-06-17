Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B634237162;
	Tue, 17 Jun 2025 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176714; cv=none; b=MGI5oSz4gqiDeAnShUcsNUFADP/qYk2GPzluUi2y9YiO1TRsTqgJZED4EuXRZOuidcQd6jday3p/6afALkAsxLC+sf66hpdZKyL2F/bg+zgQ4a/M95YCTY+U1E0ldXwRm5nMeE0HOX6UiIZYBntqJkwEqimxC/n3ZO6HNa5apjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176714; c=relaxed/simple;
	bh=X8CnlJLkfooNguZV9X9T1njuB1z/WgT8U2TOrDcaTsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nN0NRlHWeZz5IoxsYpv4CCvmnDgyYKtcwmuJbJmhcSjzk3PMFk9BpKkVuie3pHRwD9tfipevZn33Z4gJGQGXQd+b9f1JEgpYLr4uxk+CffLXMgQmEk8aSd9kIp3PukOrY8AgVBZi3gHl/IoJ5aKYZwIWTXQTFHmWlfHkhoGLXkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjRkaKot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjRkaKot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0495C4CEE3;
	Tue, 17 Jun 2025 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176714;
	bh=X8CnlJLkfooNguZV9X9T1njuB1z/WgT8U2TOrDcaTsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjRkaKotABopyKvwt+tV8eW4lVZ6hXaznirK7pPIbar4SBc8LEZafFQcV0jrMKk+A
	 pVDZu1UvIrAiUWn7J9unMrMFkSsLyj6kB1/+4fu5Lz6hFSQWW5qLiel+koYaOn8C71
	 mYb5wG/UCIErx1zlXCnO9X1HH38Fxujwlnr/50P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Wichelmann <marcus.wichelmann@hetzner-cloud.de>,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/356] net_sched: sch_sfq: fix a potential crash on gso_skb handling
Date: Tue, 17 Jun 2025 17:27:01 +0200
Message-ID: <20250617152350.489421654@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 002941d35b643..d564675a8be4d 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -310,7 +310,10 @@ static unsigned int sfq_drop(struct Qdisc *sch, struct sk_buff **to_free)
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



