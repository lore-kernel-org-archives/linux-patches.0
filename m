Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB7029A0;
	Wed,  7 May 2025 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643613; cv=none; b=MGmmaQL5tw0riTqFbUpbMqHsJ/lAYGxu884W1tW5N1atB1yJ/9jf8xQmVCiutC7Sju3KbZczwb0R3xOAy8UVhkQln5pynvZ0A36+n9IX5TlgxDs7SfmIFK0xEoNTgxYZA41Agpc2vYkc7w0GBXG3eT5NirIxJbjNziw7t1dsLNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643613; c=relaxed/simple;
	bh=Voea03K6TkDFfskcc6AuViJGUwMqVfQNtQlevKPQD6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dun0mIAjMMPeMYsKTU8SCW/tJStWiCAj0WkYioAp6wtTvtzC1N/cE93074lWO9Ht15O/lQ0XEJu5e4XyM14TRN8xFawqbXUC90Oe9UxuWJVI5OARBKiQjFN84ke0sl4evRoy12Ng8Dd3nOTgaNOuvWFWSa0y/ZXEE9+9uk1UCrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXh3YQ9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXh3YQ9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DEEC4CEE2;
	Wed,  7 May 2025 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643612;
	bh=Voea03K6TkDFfskcc6AuViJGUwMqVfQNtQlevKPQD6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXh3YQ9ye+9q0lCOoIiJM4vMFs3tOkFAzWLdY11rl3GE8D+Fasg95ew8w13mABC2E
	 uDc9Tg+GlHzniPRzVGWh6RAnyj/Udq67WO5T4T8Jvzcu53ZBPo3X1pspCz9htTyREf
	 Xy0HGHgcYu1XbezyzNSoza1aauXoNKwUgCZqHKLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 52/97] net_sched: ets: Fix double list add in class with netem as child qdisc
Date: Wed,  7 May 2025 20:39:27 +0200
Message-ID: <20250507183809.094216863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9fd70462b41d5..18269f86d21ef 100644
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
@@ -416,7 +421,6 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct ets_sched *q = qdisc_priv(sch);
 	struct ets_class *cl;
 	int err = 0;
-	bool first;
 
 	cl = ets_classify(skb, sch, &err);
 	if (!cl) {
@@ -426,7 +430,6 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return err;
 	}
 
-	first = !cl->qdisc->q.qlen;
 	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		if (net_xmit_drop_count(err)) {
@@ -436,7 +439,7 @@ static int ets_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return err;
 	}
 
-	if (first && !ets_class_is_strict(q, cl)) {
+	if (!cl_is_active(cl) && !ets_class_is_strict(q, cl)) {
 		list_add_tail(&cl->alist, &q->active);
 		cl->deficit = cl->quantum;
 	}
-- 
2.39.5



