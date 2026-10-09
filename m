Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12C32BE7CD;
	Fri,  9 Oct 2026 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556030; cv=none; b=WH2FWrnDUvC43UNQck7S/dOIH81lLl2Otvj+R1HQxJvnJLOWlo9PDENUygrsV3ehV3x0P3RwEOkwRpAjAMz9k5hi7jnEeyq3Ao3FI+9kd1WGxkHEqLrKwQSkSZaYbrMFVUImT9kEZ3kLiBneFCPpT8Xd7yM++RXk3S+O34n4BK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556030; c=relaxed/simple;
	bh=t5VCYAa9H+nbzQqky8oomkezMol9CdqVxx/3a5U+KOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh+7kQh2HGqkuL0DsWNVQpw8PEbHYvHuO/KEGtEzYwlGzyEg5qpGQ6De3S7SWhIieZIx3PyOTKL8BTDxdYhUQysHd/VSCfadqwUwh1OtyYfp59iN4bCqJIFl2thGhLaV7vHUkML8gv0SJ20k/OfyjLQ/D4zjF9Peqbdd255wwHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJauUyib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJauUyib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB21F000FF;
	Fri,  9 Oct 2026 14:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556028;
	bh=tmFQVGZhEiCMzjVh3jxDCe3L4CjI/7/qItvvhQumPr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJauUyib3cTgxD50GzJmTcUyYNBPVLygiA8QzkHVAR9OeeOtk1N2vNbkXQQsjkajb
	 pgHA4Ev872DakfykBBBUQT4JWRhqJ63qm2BR3JCibDM8OVc+wfSfW8gcS+K0zyqCF2
	 /U0uTh/8ONJVCvnuYWDyE4kbBwanXvKSJLz5ULK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 110/428] net/sched: cls_api: reclaim an empty proto on the error path
Date: Fri,  9 Oct 2026 16:07:27 +0200
Message-ID: <20261009140948.621358741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 0bb8eab29b55045281a4963d4557f2776cdf8cfa ]

Two racing tc filter add requests on the same chain/prio of an
unlocked classifier both run change() on the shared proto and both
can fail: the winner's tcf_chain_tp_delete_empty() attempt gives up
because the loser's handle is still in the idr, and the loser's
error path drops only its own reference without a second reclamation
attempt. The empty proto stays linked in the chain, holding the
chain reference, a block reference and the classifier module
reference until the chain or block is torn down.

Reclaim the proto on the error path of any failed request that holds
a proto reference. The reclamation is emptiness-gated:
tcf_chain_tp_delete_empty() unlinks the proto only when
delete_empty() admits it is empty, so a live shared proto is never
unlinked. A proto the request created is reclaimed unconditionally -
it is the only owner, so marking it for deletion is safe even without
a delete_empty callback. Classifiers without one (the check marks the
proto unconditionally) are rtnl-serialized, so the raced window this
guard closes cannot arise for them.

This is a follow-up to commit d4e359b3608a ("net/sched: cls_api: fix
teardown of an adopted proto on insert-race loss"), which stopped the
loser of the insert race from unlinking the winner's live proto but
left the empty-proto residual in place.

Conditions to recreate:
- CONFIG_NET_CLS_FLOWER=y; veth pair
- tc qdisc add dev veth0 ingress
- two concurrent `tc filter add dev veth0 ingress protocol ip pref 1
  flower skip_sw ... action drop` (both fail in fl_hw_replace_filter
  after publishing their handle in the idr); repeat in a loop
- an empty flower tp stays linked after both requests fail; visible
  as a bare `filter protocol ip pref 1 flower chain 0` header in
  `tc filter show` with no filter entries
- CAP_NET_ADMIN (namespace-local via unshare -Urn suffices)

Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260805134049.927864-1-victor@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-JCOT.v1.20260910090924@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c47d2ee13641d..a9f54988561f2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2463,7 +2463,20 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 errout:
-	if (err && tp_state == TP_CREATED)
+	if (err && !IS_ERR_OR_NULL(tp) &&
+	    (tp_state == TP_CREATED || tp->ops->delete_empty))
+		/*
+		 * The request is dropping its reference to tp. If it was
+		 * the last user (the idr is empty now), reclaim the proto.
+		 * A tp this request created is reclaimed unconditionally:
+		 * it is the only owner, so marking it for deletion is
+		 * safe. Otherwise only classifiers with a delete_empty
+		 * callback are reclaimed -- the callback admits an empty
+		 * proto only, so a live shared proto is never unlinked.
+		 * Classifiers without one (deleting is set
+		 * unconditionally) are rtnl-serialized, so the raced
+		 * window this guard closes cannot arise for them.
+		 */
 		tcf_chain_tp_delete_empty(chain, tp, rtnl_held, NULL);
 errout_tp:
 	if (chain) {
-- 
2.53.0



