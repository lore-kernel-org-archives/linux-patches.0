Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125A221DA2;
	Mon,  2 Jun 2025 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875079; cv=none; b=RmXccPo99lHW5FN0owxM7uhGQ3JRnNo869E9KznnTUSIHTb/JRSKyEEr+PH9uHWjuvMuSitUNFbDMnwQDQwzU1JyV9Ln6tfTt2OTL76GvWIF1zYUMl9BJmvFGKMOwbRPn44odCRla2l5h4Ayxg0CShTZcSXe8tTlpE/n41NhNdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875079; c=relaxed/simple;
	bh=H+OghfKBU5Cb+y6BV09ybp6KLsIicsuDN+E/ie/hd6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+fa6StuaE11y0p1XAy3KH27iWreu+t16nKdKImEOCXvo689nQfsdl/JsNje0UKuizBlVtyaoqxsojMjI+VBcoeU1mHRJkKcX1yJE4/p+RGv4NnTlngTdye/wtAMT14h5fVmnk3DsGxisNPjeS0WjX1DPlNXOInbIZ3qrNIYvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hk3axRQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hk3axRQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BE4C4CEEB;
	Mon,  2 Jun 2025 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875079;
	bh=H+OghfKBU5Cb+y6BV09ybp6KLsIicsuDN+E/ie/hd6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk3axRQFL5z6Byxj3XGZjqPuwFtBPY+l0VcKcCtZ8unhy2csC03HxiyaUJd0U69MV
	 hyVv63nIYM4oySE7dPNhCqFMdFokR/+ZqYSKb9MuuUAjCNMBJ14DkOoFxmRpgXymsI
	 HujBvzFuOsOiPIEkq3ZDPYgGi7xL5X8n4P5ofzyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/270] net_sched: ets: Fix double list add in class with netem as child qdisc
Date: Mon,  2 Jun 2025 15:45:06 +0200
Message-ID: <20250602134308.067787729@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 1a6d0c00fa07972384b0c308c72db091d49988b6 ]

As described in Gerrard's report [1], there are use cases where a netem
child qdisc will make the parent qdisc's enqueue callback reentrant.
In the case of ets, there won't be a UAF, but the code will add the same
classifier to the list twice, which will cause memory corruption.

In addition to checking for qlen being zero, this patch checks whether
the class was already added to the active_list (cl_is_active) before
doing the addition to cater for the reentrant case.

[1] https://lore.kernel.org/netdev/CAHcdcOm+03OD2j6R0=YHKqmy=VgJ8xEOKuP6c7mSgnp-TEJJbw@mail.gmail.com/

Fixes: 37d9cf1a3ce3 ("sched: Fix detection of empty queues in child qdiscs")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20250425220710.3964791-4-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 0afd9187f836a..35b8577aef7dc 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -74,6 +74,11 @@ static const struct nla_policy ets_class_policy[TCA_ETS_MAX + 1] = {
 	[TCA_ETS_QUANTA_BAND] = { .type = NLA_U32 },
 };
 
+static bool cl_is_active(struct ets_class *cl)
+{
+	return !list_empty(&cl->alist);
+}
+
 static int ets_quantum_parse(struct Qdisc *sch, const struct nlattr *attr,
 			     unsigned int *quantum,
 			     struct netlink_ext_ack *extack)
@@ -424,7 +429,6 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct ets_sched *q = qdisc_priv(sch);
 	struct ets_class *cl;
 	int err = 0;
-	bool first;
 
 	cl = ets_classify(skb, sch, &err);
 	if (!cl) {
@@ -434,7 +438,6 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return err;
 	}
 
-	first = !cl->qdisc->q.qlen;
 	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
@@ -444,7 +447,7 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return err;
 	}
 
-	if (first && !ets_class_is_strict(q, cl)) {
+	if (!cl_is_active(cl) && !ets_class_is_strict(q, cl)) {
 		list_add_tail(&cl->alist, &q->active);
 		cl->deficit = cl->quantum;
 	}
-- 
2.39.5



