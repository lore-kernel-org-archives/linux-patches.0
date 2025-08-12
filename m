Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81165282E1;
	Tue, 12 Aug 2025 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022318; cv=none; b=PFKOcQ399VnbgziNr1HZr0cWCbPZTvhTxs4HjQ+kNMwAgcUAsN2XQ/tdK7WfJjZMraKJbzXJQ6VURjEnGh2hOab+FBE0Ol2E/sOq58FB2QXmG/g8buaT4FVzrs9WEivrpzSzYvjVGRinmili+JvAtTpgNQvskQRSjAmao0y1vns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022318; c=relaxed/simple;
	bh=VN28Gm3i1hpkoEUXtscDPunf59SKow4+LjvBufrdOw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvNOxXwJ2tfNJ7xjwVfhbbU7fLXElyvFszxXP+UfM4eZXcAnjqo4j9BAlq9oICANHFuOzsApUFJFFm/3W8tqtcYYSBTYJFXmEwjPjfwo8nZD/WHbNuN2MpqwhhwVprPwjYF1WDdzJ8mWcxOywgfjWJMRcoG32ZOmAXP09nO7+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuokAG0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuokAG0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AF5C4CEF0;
	Tue, 12 Aug 2025 18:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022318;
	bh=VN28Gm3i1hpkoEUXtscDPunf59SKow4+LjvBufrdOw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuokAG0z88ksyuKT6Rtk39fPgEB0bUbR0yNIrwslkfC9LtUmodJUiYj6ujZ/0qLrH
	 +/dZDkndTDG9svwqRuV2bWuSooQkEWgodEkWUBY6LN5EraHLMQK9b9wwW0T4Xv8W0z
	 1oAlgTLMP9IT7Pj+8YCoWmwJrnu6s2GJHAMXqcOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/369] net/sched: Restrict conditions for adding duplicating netems to qdisc tree
Date: Tue, 12 Aug 2025 19:26:40 +0200
Message-ID: <20250812173018.648743432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Liu <will@willsroot.io>

[ Upstream commit ec8e0e3d7adef940cdf9475e2352c0680189d14e ]

netem_enqueue's duplication prevention logic breaks when a netem
resides in a qdisc tree with other netems - this can lead to a
soft lockup and OOM loop in netem_dequeue, as seen in [1].
Ensure that a duplicating netem cannot exist in a tree with other
netems.

Previous approaches suggested in discussions in chronological order:

1) Track duplication status or ttl in the sk_buff struct. Considered
too specific a use case to extend such a struct, though this would
be a resilient fix and address other previous and potential future
DOS bugs like the one described in loopy fun [2].

2) Restrict netem_enqueue recursion depth like in act_mirred with a
per cpu variable. However, netem_dequeue can call enqueue on its
child, and the depth restriction could be bypassed if the child is a
netem.

3) Use the same approach as in 2, but add metadata in netem_skb_cb
to handle the netem_dequeue case and track a packet's involvement
in duplication. This is an overly complex approach, and Jamal
notes that the skb cb can be overwritten to circumvent this
safeguard.

4) Prevent the addition of a netem to a qdisc tree if its ancestral
path contains a netem. However, filters and actions can cause a
packet to change paths when re-enqueued to the root from netem
duplication, leading us to the current solution: prevent a
duplicating netem from inhabiting the same tree as other netems.

[1] https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc1ilxsEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=@willsroot.io/
[2] https://lwn.net/Articles/719297/

Fixes: 0afb51e72855 ("[PKT_SCHED]: netem: reinsert for duplication")
Reported-by: William Liu <will@willsroot.io>
Reported-by: Savino Dicanosa <savy@syst3mfailure.io>
Signed-off-by: William Liu <will@willsroot.io>
Signed-off-by: Savino Dicanosa <savy@syst3mfailure.io>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20250708164141.875402-1-will@willsroot.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 68a08f6d1fbc..2270547b51df 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -972,6 +972,41 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	return 0;
 }
 
+static const struct Qdisc_class_ops netem_class_ops;
+
+static int check_netem_in_tree(struct Qdisc *sch, bool duplicates,
+			       struct netlink_ext_ack *extack)
+{
+	struct Qdisc *root, *q;
+	unsigned int i;
+
+	root = qdisc_root_sleeping(sch);
+
+	if (sch != root && root->ops->cl_ops == &netem_class_ops) {
+		if (duplicates ||
+		    ((struct netem_sched_data *)qdisc_priv(root))->duplicate)
+			goto err;
+	}
+
+	if (!qdisc_dev(root))
+		return 0;
+
+	hash_for_each(qdisc_dev(root)->qdisc_hash, i, q, hash) {
+		if (sch != q && q->ops->cl_ops == &netem_class_ops) {
+			if (duplicates ||
+			    ((struct netem_sched_data *)qdisc_priv(q))->duplicate)
+				goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	NL_SET_ERR_MSG(extack,
+		       "netem: cannot mix duplicating netems with other netems in tree");
+	return -EINVAL;
+}
+
 /* Parse netlink message to set options */
 static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 			struct netlink_ext_ack *extack)
@@ -1030,6 +1065,11 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 	q->gap = qopt->gap;
 	q->counter = 0;
 	q->loss = qopt->loss;
+
+	ret = check_netem_in_tree(sch, qopt->duplicate, extack);
+	if (ret)
+		goto unlock;
+
 	q->duplicate = qopt->duplicate;
 
 	/* for compatibility with earlier versions.
-- 
2.39.5



