Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B084F1FBCB5;
	Tue, 26 Aug 2025 13:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214047; cv=none; b=UbeCIamDn7k3KjjmMIE/v0QCu4eOQSVXCkyVskIuN4d29KALeUPoq7yIclPX5fKTmUJGSPJ6rOzatHhx8mRieB8wcc9B8zDIlVhp8F1h4UOObGBYP86QfeiHkxMPsmp2IlwJDzQCh3Ul5OE8VC7hD0fzjr9b2JX2d90VLPhVU2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214047; c=relaxed/simple;
	bh=gtzP9J7tViN4/Tdwx0UQ8H1vtnDVlP5Ro2pfqfFzvj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrMwiJ/G19Bob/sQDEILuCim8VD7nA13YCCdqMrF9bpxH+KHkJyQOPdPzLW55hIB6HjIMMM+whb5uWGCIjKoHEUT9F6ktkq+Jh/e4RmaujEJxWgYzsgPSjeOF1XS1VwAs7D+267qhS87u1vBLOlQUROAQoPMmjGZnhc0GDwn1a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUj46kwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUj46kwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E1CC4CEF1;
	Tue, 26 Aug 2025 13:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214047;
	bh=gtzP9J7tViN4/Tdwx0UQ8H1vtnDVlP5Ro2pfqfFzvj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUj46kwngED25DGbScQqQGRBf8s4hcPcrMVVzRxQm3WRwyZ9PkBEK0wZsIDYKDAcy
	 MCsLX9iG4Ipx3YRfV6vhgq9sDMO+6Xtoh8lQmr29TEuWQs5KO5sYNtAGIwFlRenR1A
	 5RYmej+mELP4gJg6Shrixmmw+A/VXyWvi/qmns/o=
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
Subject: [PATCH 6.6 576/587] net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit
Date: Tue, 26 Aug 2025 13:12:05 +0200
Message-ID: <20250826111007.688456378@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 09242578dac5..85984c91cf51 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1762,7 +1762,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	ktime_t now = ktime_get();
 	struct cake_tin_data *b;
 	struct cake_flow *flow;
-	u32 idx;
+	u32 idx, tin;
 
 	/* choose flow to insert into */
 	idx = cake_classify(sch, &b, skb, q->flow_mode, &ret);
@@ -1772,6 +1772,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		__qdisc_drop(skb, to_free);
 		return ret;
 	}
+	tin = (u32)(b - q->tins);
 	idx--;
 	flow = &b->flows[idx];
 
@@ -1939,13 +1940,22 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



