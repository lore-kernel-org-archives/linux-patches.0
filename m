Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A354E433E;
	Fri,  9 Oct 2026 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555637; cv=none; b=ndyhhKaOwO21UEXp5ZzR7VLL8lrENhqNwE2lBj5ktHbPFvjlc0gF154n7dg/+giUqakfnRuzQ3XlBdvlovdmtz03DzlCi2kwwxwXWHO4igBTdbgLnIapuhDUFks/bxlD9Of1mVcDk8RaZ+9ugaVMVxExdRIRCAjHbdyjDYprhbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555637; c=relaxed/simple;
	bh=N3/oWY7Mby1OfizDu83Ib5TQ64GJuBkqd3u0xYEyTGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIlgg9sntfIEvL/th5EulvBNKuBq7mKw7sa4W3cJe8+ycIicJxZhsd4XjCJXQqzqmmgvxCBp0+4l72AgTEaU1zOPKGo+Lw6K/Q3kD9DvSFg56hlOy0wY3gRoKQ5fyqDVrFatwtVtfcYLE53bnewh1RifA8iZALdT3GTZsxT54+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06/oMMSS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06/oMMSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9C81F00893;
	Fri,  9 Oct 2026 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555628;
	bh=aOyx6z/WA6EQZvrgCFYIxoRLo3vzXibfePE8Ln2ePS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06/oMMSSIAsZzPhqGgSk/6UAJCYrqwmtrAvyds6FSh1GxZP9MhpF/cQZLjy5PA9MJ
	 HXeXzHm9DUtntTEn91K2ITt2s6EzBFl7xmOlA5f+IMLWE1FAM9ZonI9kfxh2vDNWX1
	 VG1EhKhf08WZ8FERBmvU2E6wBWxTD7EduvKF/9sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/403] net/sched: cls_api: reclaim an empty proto on the error path
Date: Fri,  9 Oct 2026 16:07:31 +0200
Message-ID: <20261009140954.195288947@linuxfoundation.org>
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
index 8a881048e71ec..0bc0c010434cb 100644
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



