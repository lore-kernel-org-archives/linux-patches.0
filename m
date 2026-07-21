Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462AA471250;
	Tue, 21 Jul 2026 18:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658049; cv=none; b=F6AtzdBMnIQ+SwBmCpM5BAYPz1rfluaTcgoH1vh+0Z7ujla9XX5ty1LPiSeJb2w3Iuzh3918fdBwuaT1fB9wi860nMC+wYproR78U7BbCj9L2zTCciX4dELCzHQERBjRZkB9sJK9oeWJOTQiwvmsyJDV3+9WhAGbfMHYTypefLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658049; c=relaxed/simple;
	bh=kt0n6NvD2qgfSiZqSoeVu+xJkpyijFgjXeg9hBP3rzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pyk/YWhBTNdlT6fHf7j1MY3/kdV87O0CE7bnPr2zt7gY3oNw0yqArUzWmORfnW78jcYpKHxfF/flTos/hzLCS222Cja9jcjySGX25jL2KOp3t3dxJwKVHkpIOjxEC0TdTExiQD0gh+i3qT6NO/xaOhnboMwjgmnRexXGmhVa0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuQvR3hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuQvR3hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A638A1F000E9;
	Tue, 21 Jul 2026 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658048;
	bh=i+SF5DvbfHNVvGqanmSdWRQhg1Qhs/gwIANrUOieFCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuQvR3hjxnJABERnPZWKeOp6x6M6uQTDo5nU/ADES2PpLMi1ozkS4+0CPBZfoXQy9
	 X9QiT2cwBfcyRTR85W2d5+hJ9YRPOgJQ77FQ3cxeqbezk80p6SwZVhCJeVUafbh4Qh
	 XjTMibnTeIx1qJtQbQtz172kownrO6ip4XxcahpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0996/1611] net/sched: dualpi2: clear stale classification on filter miss
Date: Tue, 21 Jul 2026 17:18:32 +0200
Message-ID: <20260721152537.794019254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit bf83ee45874e9f071478bed39f9cf40cc741629f ]

DualPI2 leaves previous classification state attached to an skb when
filter classification returns no match.  The enqueue path can then act
on stale state from an earlier classification attempt.

A filter miss should fall back to the default class without reusing old
per-packet classification data.

Initialize the classification result to CLASSIC before running the
classifier.  Explicit L4S, priority, and successful filter
classification can still override that default.

Fixes: 8f9516daedd6 ("sched: Add enqueue/dequeue of dualpi2 qdisc")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index 02d3c6c45aa3f7..f20a798e8f36ab 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -346,6 +346,8 @@ static int dualpi2_skb_classify(struct dualpi2_sched_data *q,
 	struct tcf_proto *fl;
 	int result;
 
+	cb->classified = DUALPI2_C_CLASSIC;
+
 	dualpi2_read_ect(skb);
 	if (cb->ect & q->ecn_mask) {
 		cb->classified = DUALPI2_C_L4S;
@@ -359,10 +361,8 @@ static int dualpi2_skb_classify(struct dualpi2_sched_data *q,
 	}
 
 	fl = rcu_dereference_bh(q->tcf_filters);
-	if (!fl) {
-		cb->classified = DUALPI2_C_CLASSIC;
+	if (!fl)
 		return NET_XMIT_SUCCESS;
-	}
 
 	result = tcf_classify(skb, NULL, fl, &res, false);
 	if (result >= 0) {
-- 
2.53.0



