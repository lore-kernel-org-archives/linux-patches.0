Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7007124167F;
	Thu, 13 Feb 2025 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457625; cv=none; b=A/e18LEUkMe0t890t5GOhta3xyjKOeNiZc9ISzmtLLgZebvGT3N7sl5VYvA/NCwjmGNipCrbTAkwk6Xq6H+eO0SjbeSOkT6gmWv05HZXX9sELDFLxAjAmM8WJ34FkElDDgc1Q8nNPJX34LaV8hjHIsZbO9d9Qz05yY+RVwWNwGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457625; c=relaxed/simple;
	bh=aleAURu2BmRsW9krMxaH9GeYw5FMKaJIK7yRqEh+FRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcmXjgIaR/KtvvPmkQRspyODC/tZvP3XlGflonXs7mFwZrF2Mg3ypgXXUn8LEtYKuyiC5wC2OFWhMKzRJJ4pmAivLs6vk38oDF1wHZPdPUZczbqxABzwiWlF3paByE8Q6Q9iULSHqd1BLKkuun1v4kCES40G3Ps9ismFnDMi0Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLpifsKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLpifsKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6236FC4CEEB;
	Thu, 13 Feb 2025 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457625;
	bh=aleAURu2BmRsW9krMxaH9GeYw5FMKaJIK7yRqEh+FRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLpifsKvstuvBsMKKbDXBDmgYhsoUfNVY7/33YY5Ma0f55f6CLydKzEHMWz76/yGS
	 JKaKXvH1xGj3nMgS2pM4e+jKI3xNx4y8WdJQOwMU00S6N7MHkjKNAsHu48lo4kZj9D
	 4B0rhKggvQmrdtp7eeXoCGq36fZdHhCAwxvMzy3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Le <quanglex97@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/422] pfifo_tail_enqueue: Drop new packet when sch->limit == 0
Date: Thu, 13 Feb 2025 15:24:32 +0100
Message-ID: <20250213142441.295819504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Le <quanglex97@gmail.com>

[ Upstream commit 647cef20e649c576dff271e018d5d15d998b629d ]

Expected behaviour:
In case we reach scheduler's limit, pfifo_tail_enqueue() will drop a
packet in scheduler's queue and decrease scheduler's qlen by one.
Then, pfifo_tail_enqueue() enqueue new packet and increase
scheduler's qlen by one. Finally, pfifo_tail_enqueue() return
`NET_XMIT_CN` status code.

Weird behaviour:
In case we set `sch->limit == 0` and trigger pfifo_tail_enqueue() on a
scheduler that has no packet, the 'drop a packet' step will do nothing.
This means the scheduler's qlen still has value equal 0.
Then, we continue to enqueue new packet and increase scheduler's qlen by
one. In summary, we can leverage pfifo_tail_enqueue() to increase qlen by
one and return `NET_XMIT_CN` status code.

The problem is:
Let's say we have two qdiscs: Qdisc_A and Qdisc_B.
 - Qdisc_A's type must have '->graft()' function to create parent/child relationship.
   Let's say Qdisc_A's type is `hfsc`. Enqueue packet to this qdisc will trigger `hfsc_enqueue`.
 - Qdisc_B's type is pfifo_head_drop. Enqueue packet to this qdisc will trigger `pfifo_tail_enqueue`.
 - Qdisc_B is configured to have `sch->limit == 0`.
 - Qdisc_A is configured to route the enqueued's packet to Qdisc_B.

Enqueue packet through Qdisc_A will lead to:
 - hfsc_enqueue(Qdisc_A) -> pfifo_tail_enqueue(Qdisc_B)
 - Qdisc_B->q.qlen += 1
 - pfifo_tail_enqueue() return `NET_XMIT_CN`
 - hfsc_enqueue() check for `NET_XMIT_SUCCESS` and see `NET_XMIT_CN` => hfsc_enqueue() don't increase qlen of Qdisc_A.

The whole process lead to a situation where Qdisc_A->q.qlen == 0 and Qdisc_B->q.qlen == 1.
Replace 'hfsc' with other type (for example: 'drr') still lead to the same problem.
This violate the design where parent's qlen should equal to the sum of its childrens'qlen.

Bug impact: This issue can be used for user->kernel privilege escalation when it is reachable.

Fixes: 57dbb2d83d10 ("sched: add head drop fifo queue")
Reported-by: Quang Le <quanglex97@gmail.com>
Signed-off-by: Quang Le <quanglex97@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://patch.msgid.link/20250204005841.223511-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fifo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index b50b2c2cc09bc..e6bfd39ff3396 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -40,6 +40,9 @@ static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	unsigned int prev_backlog;
 
+	if (unlikely(READ_ONCE(sch->limit) == 0))
+		return qdisc_drop(skb, sch, to_free);
+
 	if (likely(sch->q.qlen < READ_ONCE(sch->limit)))
 		return qdisc_enqueue_tail(skb, sch);
 
-- 
2.39.5



