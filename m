Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8221429D26A;
	Tue, 26 Aug 2025 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208092; cv=none; b=uewB8iIIFblygrxo31s8AxIkSdoBcTqxs4JKln6CA31yid2NDdKymLX0a3xflGAPZJwqpYRBWGwtHitd2g0ebZu6LWyunFuqTxzVCDqn0QTsLDqVpzlNcGo9fCChA+ttTPr1z26vEaLzvB43SGIcWY/+7+IFk8aemwi3/YRd+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208092; c=relaxed/simple;
	bh=7eQ4m+9vWmRh/0b7UQRsZmowl0T1RIplTkNQVUQ2p4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kGmnDpXb9mp0qtVoeinCu+xSVqK4M+Q+Nr3z5hG7TP63DO974Zg6LYeTB1P088vE47vlk++5QAwUr4/cLxg4MMpMBs5t1FWg8wPncapxUqn01O998N7tGBagKa3xCUfC2SJz51z58IfQVJtDt5gqnXK1gJasTsQmbhGUOwKwgxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAFnKSOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAFnKSOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B663C4CEF1;
	Tue, 26 Aug 2025 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208092;
	bh=7eQ4m+9vWmRh/0b7UQRsZmowl0T1RIplTkNQVUQ2p4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAFnKSOIFGl+waBSs9+6cqn1+7RGOiQlZENU5NnqF1cE7k4ezAgooSpVuOQDhlwuS
	 tAVm4PTltOjgCb1Zdk34uZXq3Xh8QX2ISmabuyVgg3ht8bJYo2vurJNjbe0yuCMlJZ
	 Rh2XMDVQfC8HYo2ADe2lIA7TifjM3lnPKiKCd1Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 434/457] net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit
Date: Tue, 26 Aug 2025 13:11:58 +0200
Message-ID: <20250826110948.014910798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Liu <will@willsroot.io>

[ Upstream commit 15de71d06a400f7fdc15bf377a2552b0ec437cf5 ]

The following setup can trigger a WARNING in htb_activate due to
the condition: !cl->leaf.q->q.qlen

tc qdisc del dev lo root
tc qdisc add dev lo root handle 1: htb default 1
tc class add dev lo parent 1: classid 1:1 \
       htb rate 64bit
tc qdisc add dev lo parent 1:1 handle f: \
       cake memlimit 1b
ping -I lo -f -c1 -s64 -W0.001 127.0.0.1

This is because the low memlimit leads to a low buffer_limit, which
causes packet dropping. However, cake_enqueue still returns
NET_XMIT_SUCCESS, causing htb_enqueue to call htb_activate with an
empty child qdisc. We should return NET_XMIT_CN when packets are
dropped from the same tin and flow.

I do not believe return value of NET_XMIT_CN is necessary for packet
drops in the case of ack filtering, as that is meant to optimize
performance, not to signal congestion.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: William Liu <will@willsroot.io>
Reviewed-by: Savino Dicanosa <savy@syst3mfailure.io>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20250819033601.579821-1-will@willsroot.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 48dd8c88903f..aa9f31e4415a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1747,7 +1747,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	ktime_t now = ktime_get();
 	struct cake_tin_data *b;
 	struct cake_flow *flow;
-	u32 idx;
+	u32 idx, tin;
 
 	/* choose flow to insert into */
 	idx = cake_classify(sch, &b, skb, q->flow_mode, &ret);
@@ -1757,6 +1757,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		__qdisc_drop(skb, to_free);
 		return ret;
 	}
+	tin = (u32)(b - q->tins);
 	idx--;
 	flow = &b->flows[idx];
 
@@ -1924,13 +1925,22 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		q->buffer_max_used = q->buffer_used;
 
 	if (q->buffer_used > q->buffer_limit) {
+		bool same_flow = false;
 		u32 dropped = 0;
+		u32 drop_id;
 
 		while (q->buffer_used > q->buffer_limit) {
 			dropped++;
-			cake_drop(sch, to_free);
+			drop_id = cake_drop(sch, to_free);
+
+			if ((drop_id >> 16) == tin &&
+			    (drop_id & 0xFFFF) == idx)
+				same_flow = true;
 		}
 		b->drop_overlimit += dropped;
+
+		if (same_flow)
+			return NET_XMIT_CN;
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.50.1



