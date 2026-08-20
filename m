Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED06481AAD;
	Thu, 20 Aug 2026 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247755; cv=none; b=bfAdcFLdH9OanC+6PI1sQvStLh04R3mmDq0/Ec6grZdxPW9rW/ZD0yR50z6h9akOlLBFsk78/muVQ7CuwJNy+1rqSkmpDADlerruW34M246MMsp0mIBI1YZr1NjTGzPn9eaz/27QJKWTOdO9NfpFVuoIg2C0qR7fVXsYBl9Y20o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247755; c=relaxed/simple;
	bh=fReByEverk6FiKRpQTDdgHMUstvtFEu+2KxsGxUgXeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNBL9Hlxg09T7m9W7wZ9jfjRh9EmE35XG+qoZ61WU9WXDq1TE9uaJaLcrlJmviXycsdjc+Q6r9E9nqTRBFQu5x/tZH/98L7m29uBBmaOi+ScvLaSGkk+3LV4LQZdYJOyMlBkRIfd8PHsqRFYHiY/TmTajVhzVb0EeQOC7mlxkZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jetQuI4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jetQuI4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DA71F000E9;
	Thu, 20 Aug 2026 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247753;
	bh=XaKr6I3w+At7FNls9xkgpJooWyUZO8up6V7MmYspOhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jetQuI4Mzh8ex0B0WkRMxxv7sPkbdaKivfHOwELETIFGoCHS6D3zOQdddOamx/yrM
	 qx8uZ4LIJkcDrUu26CNFrKuyJZk18DtHAYz2zRtLilgOnmS1HTCfYKPdEb+NQ1x+Ot
	 oO+MGoIj7EpidmSRhEssMYtVT5ppcQeWCqg1cmic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/166] net: sched: Add initial TC error skb drop reasons
Date: Thu, 20 Aug 2026 16:56:54 +0200
Message-ID: <20260820145215.830337285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

[ Upstream commit 4cf24dc8934074725042c0bd10b91f4d4b5269bb ]

Continue expanding Daniel's patch by adding new skb drop reasons that
are idiosyncratic to TC.

More specifically:

- SKB_DROP_REASON_TC_COOKIE_ERROR: An error occurred whilst
  processing a tc ext cookie.

- SKB_DROP_REASON_TC_CHAIN_NOTFOUND: tc chain lookup failed.

- SKB_DROP_REASON_TC_RECLASSIFY_LOOP: tc exceeded max reclassify loop
  iterations

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 18 +++++++++++++++---
 net/sched/act_api.c           |  3 ++-
 net/sched/cls_api.c           | 22 ++++++++++++++--------
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 6ff543fe8a8b5..e88e785d221bb 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -80,8 +80,10 @@
 	FN(IPV6_NDISC_BAD_OPTIONS)	\
 	FN(IPV6_NDISC_NS_OTHERHOST)	\
 	FN(QUEUE_PURGE)			\
-	FN(TC_ERROR)			\
+	FN(TC_COOKIE_ERROR)		\
 	FN(PACKET_SOCK_ERROR)		\
+	FN(TC_CHAIN_NOTFOUND)		\
+	FN(TC_RECLASSIFY_LOOP)		\
 	FNe(MAX)
 
 /**
@@ -347,13 +349,23 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
 	/** @SKB_DROP_REASON_QUEUE_PURGE: bulk free. */
 	SKB_DROP_REASON_QUEUE_PURGE,
-	/** @SKB_DROP_REASON_TC_ERROR: generic internal tc error. */
-	SKB_DROP_REASON_TC_ERROR,
+	/**
+	 * @SKB_DROP_REASON_TC_COOKIE_ERROR: An error occurred whilst
+	 * processing a tc ext cookie.
+	 */
+	SKB_DROP_REASON_TC_COOKIE_ERROR,
 	/**
 	 * @SKB_DROP_REASON_PACKET_SOCK_ERROR: generic packet socket errors
 	 * after its filter matches an incoming packet.
 	 */
 	SKB_DROP_REASON_PACKET_SOCK_ERROR,
+	/** @SKB_DROP_REASON_TC_CHAIN_NOTFOUND: tc chain lookup failed. */
+	SKB_DROP_REASON_TC_CHAIN_NOTFOUND,
+	/**
+	 * @SKB_DROP_REASON_TC_RECLASSIFY_LOOP: tc exceeded max reclassify loop
+	 * iterations.
+	 */
+	SKB_DROP_REASON_TC_RECLASSIFY_LOOP,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
 	 * shouldn't be used as a real 'reason' - only for tracing code gen
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index c5a3f316d0de4..96412b374e7b4 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1118,7 +1118,8 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			}
 		} else if (TC_ACT_EXT_CMP(ret, TC_ACT_GOTO_CHAIN)) {
 			if (unlikely(!rcu_access_pointer(a->goto_chain))) {
-				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb,
+						    SKB_DROP_REASON_TC_CHAIN_NOTFOUND);
 				return TC_ACT_SHOT;
 			}
 			tcf_action_goto_chain_exec(a, res);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 841360e07d7aa..7f47e937e1b85 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1732,13 +1732,15 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			 */
 			if (unlikely(n->tp != tp || n->tp->chain != n->chain ||
 				     !tp->ops->get_exts)) {
-				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb,
+						    SKB_DROP_REASON_TC_COOKIE_ERROR);
 				return TC_ACT_SHOT;
 			}
 
 			exts = tp->ops->get_exts(tp, n->handle);
 			if (unlikely(!exts || n->exts != exts)) {
-				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb,
+						    SKB_DROP_REASON_TC_COOKIE_ERROR);
 				return TC_ACT_SHOT;
 			}
 
@@ -1767,7 +1769,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
 	}
 
 	if (unlikely(n)) {
-		tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+		tcf_set_drop_reason(skb,
+				    SKB_DROP_REASON_TC_COOKIE_ERROR);
 		return TC_ACT_SHOT;
 	}
 
@@ -1779,7 +1782,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				       tp->chain->block->index,
 				       tp->prio & 0xffff,
 				       ntohs(tp->protocol));
-		tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+		tcf_set_drop_reason(skb,
+				    SKB_DROP_REASON_TC_RECLASSIFY_LOOP);
 		return TC_ACT_SHOT;
 	}
 
@@ -1817,7 +1821,8 @@ int tcf_classify(struct sk_buff *skb,
 				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
 								&act_index);
 				if (!n) {
-					tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+					tcf_set_drop_reason(skb,
+							    SKB_DROP_REASON_TC_COOKIE_ERROR);
 					return TC_ACT_SHOT;
 				}
 
@@ -1828,7 +1833,9 @@ int tcf_classify(struct sk_buff *skb,
 
 			fchain = tcf_chain_lookup_rcu(block, chain);
 			if (!fchain) {
-				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb,
+						    SKB_DROP_REASON_TC_CHAIN_NOTFOUND);
+
 				return TC_ACT_SHOT;
 			}
 
@@ -1850,10 +1857,9 @@ int tcf_classify(struct sk_buff *skb,
 
 			ext = tc_skb_ext_alloc(skb);
 			if (WARN_ON_ONCE(!ext)) {
-				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb, SKB_DROP_REASON_NOMEM);
 				return TC_ACT_SHOT;
 			}
-
 			ext->chain = last_executed_chain;
 			ext->mru = cb->mru;
 			ext->post_ct = cb->post_ct;
-- 
2.53.0



