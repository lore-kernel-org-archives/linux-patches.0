Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208A352FCE;
	Tue, 26 Aug 2025 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218421; cv=none; b=ttKAwlXR2TDSTAQ2M4huj9ECNI94wfjvk2GUGJ8XHqtrud5EO7XGAEfHcAR8TSuvi38nV42cJPa/Gn6HXAkAbwuvGr5T8iMaxw+XbOhDTnQwk8aB1mE5T836QR3u2TAU09nJuquOjBcrn8CR+1z01dL0yxatQq305qAmey3R3OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218421; c=relaxed/simple;
	bh=3X4vPCTI+qfVjzHHzKs5LsSuS40kgG3xTxnIE+Dw2gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+fpQh+2+SVbI18U3AY7/vPy0PinHsAll0AU6wwC3PYZSGoAQ++fg0+eCcSQjOCLJ884FNkbCefgyisH+8XXiIohlvVrpz/tKi3g0/KtFY3NtP8xxHNBtVK1V5XIXjVEdqY/PtryBK0gY+ZiId3QQ+op0HrZJYNbxeEi1FMRaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfeXVXWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfeXVXWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D6C4CEF1;
	Tue, 26 Aug 2025 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218421;
	bh=3X4vPCTI+qfVjzHHzKs5LsSuS40kgG3xTxnIE+Dw2gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfeXVXWvzMJH8pe6BdmFyb1sBN5S+uqwJDy8akLM1Jy7R+91lpytbz4x0goIx3lEX
	 6AvEAo327YhhXMx+MH+uYEk2sIeiKBFT9v7udgO75gOjy4dJ6B8/HuGTBZrTMn/Rma
	 xJ/8xb4oDK05dEPZQ9Px07zsq3miWk4F2087wn3c=
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
Subject: [PATCH 5.10 516/523] net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit
Date: Tue, 26 Aug 2025 13:12:06 +0200
Message-ID: <20250826110937.167468548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
index d9535129f4e9..6dabe5eaa3be 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1761,7 +1761,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	ktime_t now = ktime_get();
 	struct cake_tin_data *b;
 	struct cake_flow *flow;
-	u32 idx;
+	u32 idx, tin;
 
 	/* choose flow to insert into */
 	idx = cake_classify(sch, &b, skb, q->flow_mode, &ret);
@@ -1771,6 +1771,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		__qdisc_drop(skb, to_free);
 		return ret;
 	}
+	tin = (u32)(b - q->tins);
 	idx--;
 	flow = &b->flows[idx];
 
@@ -1938,13 +1939,22 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



