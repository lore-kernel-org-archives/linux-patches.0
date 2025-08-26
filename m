Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B7235208F;
	Tue, 26 Aug 2025 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216867; cv=none; b=UaV6yxgqXGVnU/YQCnWPHMr8l3ahIcbO4a6gTd0YeAGPWSUuYePe6OdNF2cupASI2wMtcwPDVa5goqMAu2fCLyM8yr/BtyjIzu70Gj6EU4ySdibr73ySGnCyFZRnqnJrLjinj0x9B4pYWSI3DW2sEVJatvk0GYr890Pkb9Ws5UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216867; c=relaxed/simple;
	bh=yLqbX1N3pqZ7XvEVo2QrEz3SjtT1htAnujGBP7yfqoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRFyarCw5FfRfDLPOHpRflwsot/zRbycL7uSCGx0zlP7shRKVHHgZcKIT5mbup8YH4Fe/vFpxFh0t/ik0V62D87Erqv3X3CxmvNLwi/Q+5me/QQVluaUTcqKy93JoqNZcXnRh7uxqwNJ0KCxNflrIcdLsDdNFfMAzuNyJHHS+NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggoCWI7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggoCWI7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF88C4CEF1;
	Tue, 26 Aug 2025 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216867;
	bh=yLqbX1N3pqZ7XvEVo2QrEz3SjtT1htAnujGBP7yfqoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggoCWI7hdevSgN3+cCPkXA30zo5Yz0R3DXCxVg6Bj+sUu/BBP1najFnfGTCBP0Ucw
	 IMBed9jjjgRTlSoUa98fBtEK33XmpltnmmIGkvZMPNxFnA+TlNj7qB+74lhrytP4eU
	 0Watv/HkRkb9Q8KQIWbBSh6fT5Q4l0x6VgbQInsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Davide Caratti <dcaratti@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 541/644] net/sched: sch_ets: properly init all active DRR list handles
Date: Tue, 26 Aug 2025 13:10:32 +0200
Message-ID: <20250826110959.925020285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 454d3e1ae057a1e09a15905b06b860f60d6c14d0 ]

leaf classes of ETS qdiscs are served in strict priority or deficit round
robin (DRR), depending on the value of 'nstrict'. Since this value can be
changed while traffic is running, we need to be sure that the active list
of DRR classes can be updated at any time, so:

1) call INIT_LIST_HEAD(&alist) on all leaf classes in .init(), before the
   first packet hits any of them.
2) ensure that 'alist' is not overwritten with zeros when a leaf class is
   no more strict priority nor DRR (i.e. array elements beyond 'nbands').

Link: https://lore.kernel.org/netdev/YS%2FoZ+f0Nr8eQkzH@dcaratti.users.ipa.redhat.com
Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 87c6efc5ce9c ("net/sched: ets: use old 'nbands' while purging unused classes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_ets.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -666,7 +666,6 @@ static int ets_qdisc_change(struct Qdisc
 
 	q->nbands = nbands;
 	for (i = nstrict; i < q->nstrict; i++) {
-		INIT_LIST_HEAD(&q->classes[i].alist);
 		if (q->classes[i].qdisc->q.qlen) {
 			list_add_tail(&q->classes[i].alist, &q->active);
 			q->classes[i].deficit = quanta[i];
@@ -694,7 +693,11 @@ static int ets_qdisc_change(struct Qdisc
 	ets_offload_change(sch);
 	for (i = q->nbands; i < oldbands; i++) {
 		qdisc_put(q->classes[i].qdisc);
-		memset(&q->classes[i], 0, sizeof(q->classes[i]));
+		q->classes[i].qdisc = NULL;
+		q->classes[i].quantum = 0;
+		q->classes[i].deficit = 0;
+		memset(&q->classes[i].bstats, 0, sizeof(q->classes[i].bstats));
+		memset(&q->classes[i].qstats, 0, sizeof(q->classes[i].qstats));
 	}
 	return 0;
 }
@@ -703,7 +706,7 @@ static int ets_qdisc_init(struct Qdisc *
 			  struct netlink_ext_ack *extack)
 {
 	struct ets_sched *q = qdisc_priv(sch);
-	int err;
+	int err, i;
 
 	if (!opt)
 		return -EINVAL;
@@ -713,6 +716,9 @@ static int ets_qdisc_init(struct Qdisc *
 		return err;
 
 	INIT_LIST_HEAD(&q->active);
+	for (i = 0; i < TCQ_ETS_MAX_BANDS; i++)
+		INIT_LIST_HEAD(&q->classes[i].alist);
+
 	return ets_qdisc_change(sch, opt, extack);
 }
 


