Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C1B352FC7;
	Tue, 26 Aug 2025 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216870; cv=none; b=IOlBn4KWaxyeDt4F4PIXHmyl6JqANy6N/jMov0Dc9cDAKHrY+XzzukPAQUnUjaKqJq+ulriMTrmMM1TKG3CUVOpW1PfhvuI2I42/HmqlgeNIYjjV18i5kKWp3lERAfvQcundaG5DlO/jjZ05hw8F+/ceyx7d8H355b1Ter1+PBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216870; c=relaxed/simple;
	bh=ibmhUqpCmqgneio3Dq5qwsdl+MPjTdgHSpa7s/DpQxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAPnbDZwYmZ6KI84PFMxbGMHkZMwoqKUak9WK4SXqta2OIsSTSc0XiRLVO90PRwN14tuoZynVXP594usc2OTwvZ9M/GgqNd0d7ZP0iy2ea6/+M1CgiXghP2myMk43OXgbTV1aFILbnPcDW7L1febAchY6SK/cf3IpKsw3qU2WIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+ihDsKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+ihDsKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60384C4CEF1;
	Tue, 26 Aug 2025 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216869;
	bh=ibmhUqpCmqgneio3Dq5qwsdl+MPjTdgHSpa7s/DpQxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+ihDsKjVxP5q2abZDRD3FsEcxmgROjsRnOhLxehgMz7zV0d3rAasmk3jnDZYqChm
	 OFEZSS5BZroEyCqRv7Q3somC9C5AkvHF2o7E475RreQxnmTv1ndiBVClXTUi06OYRo
	 TifrdgAr4S6ZOn+ihp4ocdS0IYY3zi6THALaTGHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 542/644] net_sched: sch_ets: implement lockless ets_dump()
Date: Tue, 26 Aug 2025 13:10:33 +0200
Message-ID: <20250826110959.950302446@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c5f1dde7f731e7bf2e7c169ca42cb4989fc2f8b9 ]

Instead of relying on RTNL, ets_dump() can use READ_ONCE()
annotations, paired with WRITE_ONCE() ones in ets_change().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 87c6efc5ce9c ("net/sched: ets: use old 'nbands' while purging unused classes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_ets.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -664,7 +664,7 @@ static int ets_qdisc_change(struct Qdisc
 
 	sch_tree_lock(sch);
 
-	q->nbands = nbands;
+	WRITE_ONCE(q->nbands, nbands);
 	for (i = nstrict; i < q->nstrict; i++) {
 		if (q->classes[i].qdisc->q.qlen) {
 			list_add_tail(&q->classes[i].alist, &q->active);
@@ -676,11 +676,11 @@ static int ets_qdisc_change(struct Qdisc
 			list_del_init(&q->classes[i].alist);
 		qdisc_purge_queue(q->classes[i].qdisc);
 	}
-	q->nstrict = nstrict;
+	WRITE_ONCE(q->nstrict, nstrict);
 	memcpy(q->prio2band, priomap, sizeof(priomap));
 
 	for (i = 0; i < q->nbands; i++)
-		q->classes[i].quantum = quanta[i];
+		WRITE_ONCE(q->classes[i].quantum, quanta[i]);
 
 	for (i = oldbands; i < q->nbands; i++) {
 		q->classes[i].qdisc = queues[i];
@@ -694,7 +694,7 @@ static int ets_qdisc_change(struct Qdisc
 	for (i = q->nbands; i < oldbands; i++) {
 		qdisc_put(q->classes[i].qdisc);
 		q->classes[i].qdisc = NULL;
-		q->classes[i].quantum = 0;
+		WRITE_ONCE(q->classes[i].quantum, 0);
 		q->classes[i].deficit = 0;
 		memset(&q->classes[i].bstats, 0, sizeof(q->classes[i].bstats));
 		memset(&q->classes[i].qstats, 0, sizeof(q->classes[i].qstats));
@@ -751,6 +751,7 @@ static int ets_qdisc_dump(struct Qdisc *
 	struct ets_sched *q = qdisc_priv(sch);
 	struct nlattr *opts;
 	struct nlattr *nest;
+	u8 nbands, nstrict;
 	int band;
 	int prio;
 	int err;
@@ -763,21 +764,22 @@ static int ets_qdisc_dump(struct Qdisc *
 	if (!opts)
 		goto nla_err;
 
-	if (nla_put_u8(skb, TCA_ETS_NBANDS, q->nbands))
+	nbands = READ_ONCE(q->nbands);
+	if (nla_put_u8(skb, TCA_ETS_NBANDS, nbands))
 		goto nla_err;
 
-	if (q->nstrict &&
-	    nla_put_u8(skb, TCA_ETS_NSTRICT, q->nstrict))
+	nstrict = READ_ONCE(q->nstrict);
+	if (nstrict && nla_put_u8(skb, TCA_ETS_NSTRICT, nstrict))
 		goto nla_err;
 
-	if (q->nbands > q->nstrict) {
+	if (nbands > nstrict) {
 		nest = nla_nest_start(skb, TCA_ETS_QUANTA);
 		if (!nest)
 			goto nla_err;
 
-		for (band = q->nstrict; band < q->nbands; band++) {
+		for (band = nstrict; band < nbands; band++) {
 			if (nla_put_u32(skb, TCA_ETS_QUANTA_BAND,
-					q->classes[band].quantum))
+					READ_ONCE(q->classes[band].quantum)))
 				goto nla_err;
 		}
 
@@ -789,7 +791,8 @@ static int ets_qdisc_dump(struct Qdisc *
 		goto nla_err;
 
 	for (prio = 0; prio <= TC_PRIO_MAX; prio++) {
-		if (nla_put_u8(skb, TCA_ETS_PRIOMAP_BAND, q->prio2band[prio]))
+		if (nla_put_u8(skb, TCA_ETS_PRIOMAP_BAND,
+			       READ_ONCE(q->prio2band[prio])))
 			goto nla_err;
 	}
 


