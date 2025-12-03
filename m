Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A4234F49C;
	Wed,  3 Dec 2025 16:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778114; cv=none; b=HpU13JaXu+BIuEFpK9jQyn6yMmLIsTd9jwhXWqs1JGXhvYCdkH8zoCHz2MAojZg+64v7myWKowrEODkRhLcKEGuoVshHzHM5YZr0bay4pfzf8b3BoxRsqDP5nDRwUsNMSmw/oTGMXRQXtzNxttGTkdVN+mYDcq8MeAhRNBfLeog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778114; c=relaxed/simple;
	bh=ChAVyggNqyit5ssg8LGDoFwfQc0ZFiVCtUu+yp/sxKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vei+UYH8nAW3r3HLhTwbBY3FCG/BupweuL3X1Ye3nDqP4j8QADgOoBOkhl0Zm/pOgLo916QkM7L+pTEax5zHdn/onwV5ef0UdVuVf3FpmmwaCxfT19V2yacwx1b+oXbY3cIFfBc3K+te7re6zwVlgKG9Z0/3uICtj3KiW43An2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXOjkjQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXOjkjQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6443C4CEF5;
	Wed,  3 Dec 2025 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778114;
	bh=ChAVyggNqyit5ssg8LGDoFwfQc0ZFiVCtUu+yp/sxKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXOjkjQRFJozkO/hdaWHgnMoStZJn9Kkp62SMSiGPSoLFLH/SrYagYKRWPLtGdV43
	 vgz/d0uUfuAUoQgQxq+AAH3/WtJbg4u5S+T/4IGj5ejt69sJ1nj0wWgwL2l9o67Q8X
	 GZLoPurzZyLUUIff0zd+M1LvqRqSdzLvpxnDfero=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/392] net: sched: act_connmark: get rid of tcf_connmark_walker and tcf_connmark_search
Date: Wed,  3 Dec 2025 16:26:38 +0100
Message-ID: <20251203152423.298165139@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c4d2497032ae31d234425648bf2720dfb1688796 ]

tcf_connmark_walker() and tcf_connmark_search() do the same thing as
generic walk/search function, so remove them.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 62b656e43eae ("net: sched: act_connmark: initialize struct tc_ife to fix kernel leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_connmark.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 16b3d56ef2f43..d41002e4613ff 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -199,23 +199,6 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 	return -1;
 }
 
-static int tcf_connmark_walker(struct net *net, struct sk_buff *skb,
-			       struct netlink_callback *cb, int type,
-			       const struct tc_action_ops *ops,
-			       struct netlink_ext_ack *extack)
-{
-	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
-
-	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
-}
-
-static int tcf_connmark_search(struct net *net, struct tc_action **a, u32 index)
-{
-	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
-
-	return tcf_idr_search(tn, a, index);
-}
-
 static struct tc_action_ops act_connmark_ops = {
 	.kind		=	"connmark",
 	.id		=	TCA_ID_CONNMARK,
@@ -223,8 +206,6 @@ static struct tc_action_ops act_connmark_ops = {
 	.act		=	tcf_connmark_act,
 	.dump		=	tcf_connmark_dump,
 	.init		=	tcf_connmark_init,
-	.walk		=	tcf_connmark_walker,
-	.lookup		=	tcf_connmark_search,
 	.size		=	sizeof(struct tcf_connmark_info),
 };
 
-- 
2.51.0



