Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21CF38D3F8;
	Thu, 20 Aug 2026 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248231; cv=none; b=lVEsoQxRF89XExMSUiSgx2eR0b+pf88WgxdJyBDnl1FqtsXZkqLSTJwO2VosjHskSDtedYLsJKFglYG1JhoxTtAQBYWPe5iBrpq8xdTsLnecAo2jaRuQ1ByD2UBxrVHJswXf6ETR0TuyBGcgkD7dkw96ZHQ392eAseVOs0oiI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248231; c=relaxed/simple;
	bh=Ye5Pj4EuW/N9WMav0crGYeGfCeF+k59klBJKLO8AR7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4AhlFYX420scRdvvOXsnQXNj8z4KKmgVzlPktsFJG2Ucc7v6t6vN3bG+LP3v51kBbyRhFTLN+/+3FG8ylFGe+r8ka262lsp6wNJB5ZBWIbBRygH+flxfiwnkm7fZuGHLob1Sz1p20SuOVNqe9pRW3p2Wm3y2jIyuhvbqCEtcJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAx17XYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAx17XYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1301F00A3A;
	Thu, 20 Aug 2026 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248229;
	bh=9QFP0QRPrm5JW/6qQZUhQQVlT/JtUWJoClHRxC2CiEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAx17XYRlWoxYlqsarPUl2RIAgAqg4yYOO4Rql+i9gF7I+NOIHsiYCL3wnprU8Ptb
	 Zozq3PBWdWq6mov470MGKN/ixtcjNSjuF3dP+qR8qCk0zvRP2cZEPFnn/kBc8+wVC0
	 cyqlTAk8HYeJRQm6rSlIehwdj3rqa5kuLzu4a9t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/303] net/sched: taprio: avoid calling child->ops->dequeue(child) twice
Date: Thu, 20 Aug 2026 16:54:52 +0200
Message-ID: <20260820145257.983434215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4c22942734f0814d3c928c25a80f48df0a6ce45e ]

Simplify taprio_dequeue_from_txq() by noticing that we can goto one call
earlier than the previous skb_found label. This is possible because
we've unified the treatment of the child->ops->dequeue(child) return
call, we always try other TXQs now, instead of abandoning the root
dequeue completely if we failed in the peek() case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e056e1dfcddc ("net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -567,12 +567,8 @@ static struct sk_buff *taprio_dequeue_fr
 	if (unlikely(!child))
 		return NULL;
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		skb = child->ops->dequeue(child);
-		if (!skb)
-			return NULL;
-		goto skb_found;
-	}
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags))
+		goto skip_peek_checks;
 
 	skb = child->ops->peek(child);
 	if (!skb)
@@ -599,11 +595,11 @@ static struct sk_buff *taprio_dequeue_fr
 	    atomic_sub_return(len, &entry->budget) < 0)
 		return NULL;
 
+skip_peek_checks:
 	skb = child->ops->dequeue(child);
 	if (unlikely(!skb))
 		return NULL;
 
-skb_found:
 	qdisc_bstats_update(sch, skb);
 	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;


