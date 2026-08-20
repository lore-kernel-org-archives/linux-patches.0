Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816E947F774;
	Thu, 20 Aug 2026 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247740; cv=none; b=OZ8pxBFHidf1P2B2kjjAkpHqKi4TvCprMAou2UAmSKvf9OFPj8eyKhR/7MA9g0T8d0C0hbuDSioXWVeddJ/iak4KT99aVFNFcvuQtuxtnk7HmYDhGHeCkweTXGLvM0EvdMQas+Ppn0nVe0qjwsu6Wz5KedGjGOzPDgv0XJOW/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247740; c=relaxed/simple;
	bh=gcBlH5V1XkAWIQ/OKUUAotGUroOJKdYJCCts7ytWOtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABgD5lVK9Py08VNrjXuM/S+vtUKfPzQEhNEOyON/eGv4JeD/2PuZ+TOi0Hdyofva659R1lB5pqpLwLV4fcp73EQ2ZgymJgmCIzZE0Ezcb3WmMyRaRlLLi42XUqPSWimLQjg4jnAaY2TmxS5CgmMtXZLIDiLSQSYlg4Fwwk2z9Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuAP7TOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuAP7TOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A1E1F000E9;
	Thu, 20 Aug 2026 17:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247739;
	bh=UshVTJXUHXZV6JOWLR05kxHCEI6Hjqu4Avr196p3ink=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuAP7TOA94PsniBVlLUNYUNa9A9MfkUfygZoyeYMt7IF5Mm+jFCM6mNPncEJBhAf6
	 P9GUHlTiighNRTAyt65r8L37gSOXBSb/NCJHH20pVY1Qfrp/lugoCJS1HxWxvr6mHN
	 n0LXl5B3Lgw0oj8EQC5OUo4UPGo/7o+RInmm3+yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/166] net, sched: Add tcf_set_drop_reason for {__,}tcf_classify
Date: Thu, 20 Aug 2026 16:56:50 +0200
Message-ID: <20260820145215.712098429@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 39d08b91646d83e87f7cbcd846b3ef33b1a53b79 ]

Add an initial user for the newly added tcf_set_drop_reason() helper to set the
drop reason for internal errors leading to TC_ACT_SHOT inside {__,}tcf_classify().

Right now this only adds a very basic SKB_DROP_REASON_TC_ERROR as a generic
fallback indicator to mark drop locations. Where needed, such locations can be
converted to more specific codes, for example, when hitting the reclassification
limit, etc.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Victor Nogueira <victor@mojatatu.com>
Link: https://lore.kernel.org/r/20231009092655.22025-2-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h |  3 +++
 net/sched/cls_api.c           | 26 ++++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index a587e83fc1694..845dce805de7f 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -80,6 +80,7 @@
 	FN(IPV6_NDISC_BAD_OPTIONS)	\
 	FN(IPV6_NDISC_NS_OTHERHOST)	\
 	FN(QUEUE_PURGE)			\
+	FN(TC_ERROR)			\
 	FNe(MAX)
 
 /**
@@ -345,6 +346,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
 	/** @SKB_DROP_REASON_QUEUE_PURGE: bulk free. */
 	SKB_DROP_REASON_QUEUE_PURGE,
+	/** @SKB_DROP_REASON_TC_ERROR: generic internal tc error. */
+	SKB_DROP_REASON_TC_ERROR,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
 	 * shouldn't be used as a real 'reason' - only for tracing code gen
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ff6af03cb855d..c575b1fa30a71 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1731,12 +1731,16 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			 * time we got here with a cookie from hardware.
 			 */
 			if (unlikely(n->tp != tp || n->tp->chain != n->chain ||
-				     !tp->ops->get_exts))
+				     !tp->ops->get_exts)) {
+				tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 				return TC_ACT_SHOT;
+			}
 
 			exts = tp->ops->get_exts(tp, n->handle);
-			if (unlikely(!exts || n->exts != exts))
+			if (unlikely(!exts || n->exts != exts)) {
+				tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 				return TC_ACT_SHOT;
+			}
 
 			n = NULL;
 			err = tcf_exts_exec_ex(skb, exts, act_index, res);
@@ -1762,8 +1766,10 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			return err;
 	}
 
-	if (unlikely(n))
+	if (unlikely(n)) {
+		tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 		return TC_ACT_SHOT;
+	}
 
 	return TC_ACT_UNSPEC; /* signal: continue lookup */
 #ifdef CONFIG_NET_CLS_ACT
@@ -1773,6 +1779,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				       tp->chain->block->index,
 				       tp->prio & 0xffff,
 				       ntohs(tp->protocol));
+		tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 		return TC_ACT_SHOT;
 	}
 
@@ -1809,8 +1816,10 @@ int tcf_classify(struct sk_buff *skb,
 			if (ext->act_miss) {
 				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
 								&act_index);
-				if (!n)
+				if (!n) {
+					tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 					return TC_ACT_SHOT;
+				}
 
 				chain = n->chain_index;
 			} else {
@@ -1818,8 +1827,10 @@ int tcf_classify(struct sk_buff *skb,
 			}
 
 			fchain = tcf_chain_lookup_rcu(block, chain);
-			if (!fchain)
+			if (!fchain) {
+				tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 				return TC_ACT_SHOT;
+			}
 
 			/* Consume, so cloned/redirect skbs won't inherit ext */
 			skb_ext_del(skb, TC_SKB_EXT);
@@ -1838,8 +1849,11 @@ int tcf_classify(struct sk_buff *skb,
 			struct tc_skb_cb *cb = tc_skb_cb(skb);
 
 			ext = tc_skb_ext_alloc(skb);
-			if (WARN_ON_ONCE(!ext))
+			if (WARN_ON_ONCE(!ext)) {
+				tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
 				return TC_ACT_SHOT;
+			}
+
 			ext->chain = last_executed_chain;
 			ext->mru = cb->mru;
 			ext->post_ct = cb->post_ct;
-- 
2.53.0



