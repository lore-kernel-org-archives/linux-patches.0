Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217CA4E2F36;
	Fri,  9 Oct 2026 14:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555723; cv=none; b=Yq05TncB1AiW1vZ36B5+kDA6HfZCT4XUqZ4cxWmFt+OFG5z8VHBKosSOq9JY9d/zyYYjvvnjwgQfbLmSi685cVnMyq7i5rRkQWSiO3E0oJY/xygVvqUXifF1SHbYmF10HtpgRl+fIrKubPxiwkbYLRjSO8B1fDpBpw6EcbvQ/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555723; c=relaxed/simple;
	bh=nBOi+BcNXpVxNquoL5AOCWr2wFBgxVoy8LEZk4AtbCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgg5f+rhgJhgMzBP7dCxBFoMujXzOpgl9ZepQynma9zqx2YDhP4fx19w8z6f9h6RoQZBpTFtkqmdZnyV0CQ9EZAbQ0wE1gsOHz1I2NNeX89QEoRSrqcU6p8XWZlScIVHHqX3A6OAj+LUB41cn1ZRsWmDmtA5J/WOpmvfR86noPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwtwMSOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwtwMSOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D4C1F000FF;
	Fri,  9 Oct 2026 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555722;
	bh=43buH2Os4rBHrJKKvuO+CkT+Bhd+TxZspW7UiUcMaUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwtwMSODbqH1jIxntmdM1/QRh/fKwJ3Zz+y8cwbr0Csp71cubMUFSasdTxzKvejEa
	 sqf82mqZFZprLEwUIYpLVQ0UwHIhRM6y046WjkRcAdOUSuFRwpLmhX2cR34BFJakxt
	 L0eOzUfsQMfrteHCa3R7AOx3w5LG/g4xJQUtgdu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/403] net/sched: fq_codel: match the no-drop threshold to the packet size
Date: Fri,  9 Oct 2026 16:07:46 +0200
Message-ID: <20261009140954.540194862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit d031465acc362866f27e4f8f79cfecf1037fe2e5 ]

commit d9ebd8f9aa8b ("net/sched: fq_codel: clamp default quantum and mtu")
clamped both q->quantum and q->cparams.mtu to [256, FQ_CODEL_QUANTUM_MAX].
The two fields mean different things: quantum is a DRR credit that wants
the 256 floor, but cparams.mtu is the CoDel no-drop threshold
(codel_impl.h "*backlog <= params->mtu"). On a link whose maximum
transmitted packet size is below 256, the floor extends CoDel's
minimum-backlog exemption beyond one packet and delays drop or mark
eligibility by several small packets.

Split the clamp. quantum keeps [256, FQ_CODEL_QUANTUM_MAX]; cparams.mtu
tracks psched_mtu() (the device MTU plus its hard-header length) with
only the upper bound that guards the original overflow (psched_mtu()
wrapping to ~2 GiB on a huge-MTU device).

Conditions to recreate the bug: attach an fq_codel qdisc on a link
whose MTU plus hard_header_len is below 256 (e.g. a CAN interface). At
that MTU the no-drop threshold must equal the device MTU plus its
hard-header length; before this patch it was forced to 256.
Basic Testing done: with dev->mtu=100 and hard_header_len=14, a
return probe on fq_codel_init() observed cparams.mtu change from 256 to 114

Fixes: d9ebd8f9aa8b ("net/sched: fq_codel: clamp default quantum and mtu")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260819143136.57350-1-jhs@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-34MS.v1.20260925165535@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 3b3401dc5c6f1..c135b1dd5972b 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -515,8 +515,8 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	q->flows_cnt = 1024;
 	q->memory_limit = 32 << 20; /* 32 MBytes */
 	q->drop_batch_size = 64;
-	mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, FQ_CODEL_QUANTUM_MAX);
-	q->quantum = mtu;
+	mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), FQ_CODEL_QUANTUM_MAX);
+	q->quantum = clamp_t(u32, mtu, 256, FQ_CODEL_QUANTUM_MAX);
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
 	codel_params_init(&q->cparams);
-- 
2.53.0



