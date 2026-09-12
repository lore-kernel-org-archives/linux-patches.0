Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67C3AC17;
	Sat, 12 Sep 2026 15:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225386; cv=none; b=SJf+tXQBlnZsDEgg/D/6hs9ojbEoHQErypXAPHXuUWlHrSRUtfoXRiNozKBDaW1N2hoLjXQXkUqJMuPynk6dricjJfKee7ZRozw0p5GQfmZAHrPsmr3NgFDtVrgF0BPMWzXUWvV5cVX1GyRRhhAI2d5A0ceuGk6bCAiwUjZ88co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225386; c=relaxed/simple;
	bh=LpCFR7PIzwa7W55bRxBLnY9Kiq9dSsPqCHZIPTZ/9YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH5Y+e2KPtrgqxW7ai89b2uPSOIONayIE9RapYCeCG/UZSD8yCiU4apNWXE7N/ejoHXGGDIVM7vZbq8DW/yZ4oySwWZhl/n72Qn44oJqO5iUAnNyyzVaJOHvERBlcyT8cjOQPhwitmPAp0rgFVoz/LktQunLf8z6lwZdzPe45dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTWZFBKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTWZFBKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF1E1F000FF;
	Sat, 12 Sep 2026 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225384;
	bh=6vS7XshU8rFb3rnv1RKIZ4Tdn/wkOvxKDp+4ZePYkKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTWZFBKQbAqfea58ubWY03pbyeXt4ZUbf++oCxoZHF4FFOQ3c9wRr8+DwqLOv5Ciw
	 gBRCMl6VkYLT42C9P1yPz5AiHRMDcqLynxs1F3HDr/tYHS1ZQb9ILhhltgUvNURQNw
	 1L+Mit5+huX6bWLXjM1c1KyUujRzw3C89M3AzjWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1134/1424] net/sched: cls_api: fix teardown of an adopted proto on insert-race loss
Date: Sat, 12 Sep 2026 08:59:26 +0200
Message-ID: <20260912065632.696980067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit d4e359b3608a0e184bbe8d61a5c3b50d0831c44a ]

In tc_new_tfilter() the create branch sets tp_created = 1 before calling
tcf_chain_tp_insert_unique(). When the caller loses the race (another
request inserted a proto at the same chain/prio first), insert_unique()
destroys the caller's own tp_new and returns the winner's proto with an
extra reference. tp_created was never cleared, so the loser's errout
path treated the winner's live proto as its own and called
tcf_chain_tp_delete_empty() on it, silently unlinking an active
classifier that the winning request already advertised via
RTM_NEWTFILTER.

Track the outcome of the insert step in a single tri-state variable so
each errout path reacts correctly:

- TP_NOT_CREATED: no proto created; pursue the old path.
- TP_CREATED: proto inserted successfully; same code path as before.
- TP_NOT_OWNED: New - lost the insert race; tp is another request's proto
  (chain ref already released by tp_new's destroy)

Both errout reactions are single expressions derived from the state.

This fix is motivated by the Sashiko's automated review of Patch
(net/sched: cls_api: Always acquire rtnl_lock when destroying locked
classifiers) [1][2]. The review identified the silent-unlink behaviour of
an adopted proto's teardown when a request loses the
tcf_chain_tp_insert_unique() race.

[1] https://sashiko.dev/#/patchset/20260801125632.360365-1-jhs%40mojatatu.com
[2] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260801125632.360365-1-jhs%40mojatatu.com

Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260801125632.360365-1-jhs%40mojatatu.com
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260801125632.360365-1-jhs%40mojatatu.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Tested-by: Aohan Mei <henrymei@tencent.com>
Link: https://patch.msgid.link/20260805134049.927864-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 7f47e937e1b85..ac6d27172c84b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2220,6 +2220,12 @@ static bool is_ingress_or_clsact(struct tcf_block *block, struct Qdisc *q)
 	return tcf_block_shared(block) || (q && !!(q->flags & TCQ_F_INGRESS));
 }
 
+enum tcf_tp_insert_state {
+	TP_NOT_CREATED = 0, /* did not create and insert a new tp */
+	TP_CREATED, /* created and inserted a new tp */
+	TP_NOT_OWNED, /* created a proto but failed to insert */
+};
+
 static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			  struct netlink_ext_ack *extack)
 {
@@ -2240,12 +2246,12 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	unsigned long cl;
 	void *fh;
 	int err;
-	int tp_created;
+	enum tcf_tp_insert_state tp_state;
 	bool rtnl_held = false;
 	u32 flags;
 
 replay:
-	tp_created = 0;
+	tp_state = TP_NOT_CREATED;
 
 	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
 				     rtm_tca_policy, extack);
@@ -2368,13 +2374,15 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			goto errout_tp;
 		}
 
-		tp_created = 1;
+		tp_state = TP_CREATED;
 		tp = tcf_chain_tp_insert_unique(chain, tp_new, protocol, prio,
 						rtnl_held);
 		if (IS_ERR(tp)) {
 			err = PTR_ERR(tp);
 			goto errout_tp;
 		}
+		if (tp != tp_new)
+			tp_state = TP_NOT_OWNED;
 	} else {
 		mutex_unlock(&chain->filter_chain_lock);
 	}
@@ -2428,13 +2436,13 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 errout:
-	if (err && tp_created)
+	if (err && tp_state == TP_CREATED)
 		tcf_chain_tp_delete_empty(chain, tp, rtnl_held, NULL);
 errout_tp:
 	if (chain) {
 		if (tp && !IS_ERR(tp))
 			tcf_proto_put(tp, rtnl_held, NULL);
-		if (!tp_created)
+		if (tp_state == TP_NOT_CREATED)
 			tcf_chain_put(chain);
 	}
 	tcf_block_release(q, block, rtnl_held);
-- 
2.53.0



