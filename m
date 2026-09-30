Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1073D3B3894;
	Wed, 30 Sep 2026 19:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795507; cv=none; b=tdVozqvNU4r2Q72iM6duRc5Q5kIfqT+q2T/onpoOHDnDgvAnvRk6FuVyVm/G46ssUJgcMr1/5DecAEZJy3UYjT8Zo6NZ9kd5HyJY41BQYE6JSbyDf/jFbXP6YXX3+RJw8BAuUrGtilAhaWSRhhGUPu4AJ3hiF+IZ3swVWu2YyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795507; c=relaxed/simple;
	bh=eNTSWc4Uu0UBW4H8VwLiR3gpge2o6VKx/QN2jMLdmEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhdcKquDidqhFrKeTxpTIP0WjeXYxi4TgRTrQMkBpucVJFGcnb+lQSRpP8wYv3lF+tuhpqdnXOEfckeSXEg63mLNVwslNCO3QzRaI6a3I4sVIO1DS0YQxNrNzkSJBkMzDMR1Vya4YsMculGH6rWMt8xrnmQ2gOERDtB9ASROghI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07os2PaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07os2PaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BBD1F000FF;
	Wed, 30 Sep 2026 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795505;
	bh=f+vUYWSIN1AlSjMN6Ciwvyj47Nfa1kG2MSNJ7Tk7grQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07os2PaO1GnkpNF7zpvQuoL4Y2Ki8C8tWDNMnRfEnapMfkuiSQIAAnUhgYrHDFhdQ
	 Y9xmh4nd5gK5dJ0PSurc8jI3S+2RC8FNccffjYLXpyURA1q9mHTqUEEAh2dY7xH7F5
	 e1cG/UmWXwdmxyST+eyLl/xYgb6ZajAB3FCedcuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0585/1193] net/sched: cls_route: make netlink errors meaningful
Date: Wed, 30 Sep 2026 17:21:09 +0200
Message-ID: <20260930152447.242870842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit ef765c25875941564edf447302ff339363441e58 ]

Use netlink extended ack and parsing policies to return more meaningful
errors instead of the relying solely on errnos.

Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 41e85e54e564 ("net/sched: cls_route: Fix in-place replace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 9ee9a105f2aa7..7546c3bbee45e 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -385,9 +385,9 @@ static int route4_delete(struct tcf_proto *tp, void *arg, bool *last,
 
 static const struct nla_policy route4_policy[TCA_ROUTE4_MAX + 1] = {
 	[TCA_ROUTE4_CLASSID]	= { .type = NLA_U32 },
-	[TCA_ROUTE4_TO]		= { .type = NLA_U32 },
-	[TCA_ROUTE4_FROM]	= { .type = NLA_U32 },
-	[TCA_ROUTE4_IIF]	= { .type = NLA_U32 },
+	[TCA_ROUTE4_TO]		= NLA_POLICY_MAX(NLA_U32, 0xFF),
+	[TCA_ROUTE4_FROM]	= NLA_POLICY_MAX(NLA_U32, 0xFF),
+	[TCA_ROUTE4_IIF]	= NLA_POLICY_MAX(NLA_U32, 0x7FFF),
 };
 
 static int route4_set_parms(struct net *net, struct tcf_proto *tp,
@@ -407,33 +407,37 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 		return err;
 
 	if (tb[TCA_ROUTE4_TO]) {
-		if (new && handle & 0x8000)
+		if (new && handle & 0x8000) {
+			NL_SET_ERR_MSG(extack, "Invalid handle");
 			return -EINVAL;
+		}
 		to = nla_get_u32(tb[TCA_ROUTE4_TO]);
-		if (to > 0xFF)
-			return -EINVAL;
 		nhandle = to;
 	}
 
+	if (tb[TCA_ROUTE4_FROM] && tb[TCA_ROUTE4_IIF]) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_ROUTE4_FROM],
+				    "'from' and 'fromif' are mutually exclusive");
+		return -EINVAL;
+	}
+
 	if (tb[TCA_ROUTE4_FROM]) {
-		if (tb[TCA_ROUTE4_IIF])
-			return -EINVAL;
 		id = nla_get_u32(tb[TCA_ROUTE4_FROM]);
-		if (id > 0xFF)
-			return -EINVAL;
 		nhandle |= id << 16;
 	} else if (tb[TCA_ROUTE4_IIF]) {
 		id = nla_get_u32(tb[TCA_ROUTE4_IIF]);
-		if (id > 0x7FFF)
-			return -EINVAL;
 		nhandle |= (id | 0x8000) << 16;
 	} else
 		nhandle |= 0xFFFF << 16;
 
 	if (handle && new) {
 		nhandle |= handle & 0x7F00;
-		if (nhandle != handle)
+		if (nhandle != handle) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "Handle mismatch constructed: %x (expected: %x)",
+					   handle, nhandle);
 			return -EINVAL;
+		}
 	}
 
 	if (!nhandle) {
@@ -495,7 +499,6 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	struct route4_filter __rcu **fp;
 	struct route4_filter *fold, *f1, *pfp, *f = NULL;
 	struct route4_bucket *b;
-	struct nlattr *opt = tca[TCA_OPTIONS];
 	struct nlattr *tb[TCA_ROUTE4_MAX + 1];
 	unsigned int h;
 	int err;
@@ -506,10 +509,12 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 		return -EINVAL;
 	}
 
-	if (opt == NULL)
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tca, TCA_OPTIONS)) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing options");
 		return -EINVAL;
+	}
 
-	err = nla_parse_nested_deprecated(tb, TCA_ROUTE4_MAX, opt,
+	err = nla_parse_nested_deprecated(tb, TCA_ROUTE4_MAX, tca[TCA_OPTIONS],
 					  route4_policy, NULL);
 	if (err < 0)
 		return err;
-- 
2.53.0



