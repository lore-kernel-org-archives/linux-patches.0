Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC5C2192F2;
	Tue, 26 Aug 2025 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218273; cv=none; b=jAw8aTUYOkCIcP+sWNVqMBKsMvzg7MIcvTN233xQSFsbm580wOueKzwnGsFmuOQJd5av8DSHGncN0h7B+ugNu3M6lIPm1d3FfLTfqliMCCrV/ZcmqbfRXuLPLcWzjwyN3RkzHP1WxY3GqTC2SWT8QpFFumwPtmTz+GZFAJQB5Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218273; c=relaxed/simple;
	bh=dGkBXw/LaFK/+BNBL4Pfguxzf74DzEnqbnOaGLuL8RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGnszJ3L4+rBeB/Ms/fF5DUUGGbY2vJTe5k0bMMeI0qryQh56truGv0Kl3Smxhy1x8PyL+iCm4INRQkh3a51B304c4raud7ZOu4NOnK7a1pCECVK91uulV0QXu+fi4c6wEN2tamMA/p+0wHfO8Ow0c9wF/wgLwIWK1CuJU38oiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cx4VxlSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cx4VxlSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34920C4CEF1;
	Tue, 26 Aug 2025 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218273;
	bh=dGkBXw/LaFK/+BNBL4Pfguxzf74DzEnqbnOaGLuL8RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cx4VxlSzq1/CgNben3WrEXa4BqYLgeZAptYNa3PzupE49ba06T17vZhExnCA9aAY8
	 WATF05YaUEG1I4vVDAausfwxHPafnAYziEeJ9FowrSqeeOWoKqr2J/q/XBKzQYvM0G
	 9gw/keQw9cIi/Y6HNJD22g5qG62bTdOWriw+BkOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Davide Caratti <dcaratti@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 459/523] net/sched: sch_ets: properly init all active DRR list handles
Date: Tue, 26 Aug 2025 13:11:09 +0200
Message-ID: <20250826110935.767840404@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


