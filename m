Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D14F25D8FF;
	Tue, 11 Mar 2025 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707430; cv=none; b=ZmlTP2NiLlDimZ3pUvhVlq1qZj+wUwzSDf7nZqGi0TBV2+zXdwiJyYB9rGGQsRBu3nC58QmB0qlf0CW7kKjXFoEF8cGNyYRSPm/E2D8xYwHHVIJzhK4MUN/mPLDKErwu6g5lfacS2Uazy0OzD9605rYecy4giZkL6F8fN/zO72Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707430; c=relaxed/simple;
	bh=vLsuRuBx0o6iv+i6PCnyQCi8VW8hyNlXMezewm8t3Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfqZR4G5gZDMH5yRATIpBVqUh3kQQhsTLzIi2pao7D7njIzIGbeq4XMUSBUSTjEv2SU7/vyKXVDABo5wZNXKVZAW12NXac54UPbnU5AL4d2pqcW9EWGyOBVVPWvbbuOHMpJXijqhqzXP1AsFrFHPi8sMxWVH/QOUk8VKkU4x4DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtXzK/da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtXzK/da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCEFC4CEE9;
	Tue, 11 Mar 2025 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707429;
	bh=vLsuRuBx0o6iv+i6PCnyQCi8VW8hyNlXMezewm8t3Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtXzK/da2/dFZC2D/j9ufGcam1NgozJAZAIioPpzQDq4mCcxOfKQr17H4PYxhX6p9
	 a55xzl8Yzid/MZaTbrGbs/GxQGG1aRHxjg/ZmU7CUSkRedeKm4K43EqB2JoBvs4qp2
	 ALRD9e1WnxPdXTnOvdoM6ur+pwKsR92T3ka1uluk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Le <quanglex97@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 379/462] pfifo_tail_enqueue: Drop new packet when sch->limit == 0
Date: Tue, 11 Mar 2025 16:00:45 +0100
Message-ID: <20250311145813.321892103@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Le <quanglex97@gmail.com>

commit 647cef20e649c576dff271e018d5d15d998b629d upstream.

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
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fifo.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -39,6 +39,9 @@ static int pfifo_tail_enqueue(struct sk_
 {
 	unsigned int prev_backlog;
 
+	if (unlikely(READ_ONCE(sch->limit) == 0))
+		return qdisc_drop(skb, sch, to_free);
+
 	if (likely(sch->q.qlen < sch->limit))
 		return qdisc_enqueue_tail(skb, sch);
 


