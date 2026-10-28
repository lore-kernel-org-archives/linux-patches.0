Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215726;
	b=c+eJELC3H2ZWZJY95RES9dqChr+Fkm5NnLuFRSbKCxxeVptnCayptolvQjhOZE2SeI0e
	 ZliWTAUClcQr0olj08hOgmp1xtbLxmrJN97fpNIFgkvKQ3vM7jXFzjykmCCQQWQPZECVV
	 a7AYAmUR+pc2RnqJNf6kFmtA5B0yftEgCJbvGQ9r5t+QIuzTGOGahptgRHV5AriOwifNv
	 gudjbQgBcQsCdg+lKXqwQ7YQVaq1iFTFAlzxqWD3MKRr4EWP/dv7evuOjK0HZp4JOHR+V
	 x78/somcA9h3u5LN+GjJ2kW4kYclsYTxs7YbjK5E9CHgaOXVoeKt9z7dL8+oYAZJhsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2rgxgDYSqRLuHc0YBvJpJLMgkruLMJz2q4p6JRRBoXQ=;
	b=j3bKA6LSjAci93EkeuJNwRnD+4AhiqIKpvL7xYqu8SXXFX7Nf2gnHExnCQhL0ELgfu41
	 VzutcnGP3UjnegITFmMFgz4rdb0e6sPfJnOI7cirnx+KFl/BfU6jO1MdBGHgW3/tVtjAd
	 NB4IgqsadJ5xj0HtcY9DqPQ1Z2Jahs62K3mc74QkiChW0AxMGLR/Vn+MPY1FS1S9jrlvJ
	 tP+lMo9LXkMM6HLExkzlnmGU7wu4ORuLO58qo6tvagNgcNmmY2DKIcMb4QJ+GJG9uoQTl
	 aMOnNiQfKTI5qJfIWPyVUA5XS2kP/f8+Aeuxaa4ca220NKbSPxUdddPMmNUbcdEy+SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gT6kW/ST";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE4606A31E;
	Wed, 28 Oct 2026 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gT6kW/ST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2941C1F01825;
	Wed, 28 Oct 2026 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215725;
	bh=2rgxgDYSqRLuHc0YBvJpJLMgkruLMJz2q4p6JRRBoXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gT6kW/STzBmFlQVips6vPx79+1LhgsCOHt9NV8qgFo4bc80cHxtNS/vG9iJs01zE4
	 4RI8540i7DF7ID8gOu8uGsUy0lwiwrNBGo64TaXiArWmveQDy1Hkd9Vr/w8z4BN4Ll
	 IW7BsLd31xEkpvPk9dGNZw+rFmv40eR9SWuGjPUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1310/1887] net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain
Date: Wed, 28 Oct 2026 17:56:46 +0100
Message-ID: <20261028170529.243053005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f60b396ee174206fe08ebf997d16cd3801b77b22 ]

tcf_action_exec() handles TC_ACT_GOTO_CHAIN by first checking
rcu_access_pointer(a->goto_chain) and then calling
tcf_action_goto_chain_exec(), which does a second, independent
rcu_dereference_bh(a->goto_chain) read and immediately dereferences
chain->filter_chain. A concurrent tcf_action_set_ctrlact() (e.g. the gact
replace path) can clear a->goto_chain between the two reads, so the second
read returns NULL and tcf_action_goto_chain_exec() dereferences NULL.

Fix the race by doing a single rcu_dereference_bh() read of a->goto_chain
in tcf_action_exec(), checking it once for NULL, and passing the resulting
chain pointer into tcf_action_goto_chain_exec(). This turns the split
check/use into a single check/use on one value.

Fixes: ee3bbfe806cd ("net/sched: let actions use RCU to access 'goto_chain'")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Link: https://patch.msgid.link/20260809090928.868186-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9f21cc4d1dacc..7cfae02653002 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -40,11 +40,9 @@ int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
 }
 EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);
 
-static void tcf_action_goto_chain_exec(const struct tc_action *a,
+static void tcf_action_goto_chain_exec(const struct tcf_chain *chain,
 				       struct tcf_result *res)
 {
-	const struct tcf_chain *chain = rcu_dereference_bh(a->goto_chain);
-
 	res->goto_tp = rcu_dereference_bh(chain->filter_chain);
 }
 
@@ -1130,12 +1128,14 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 					return TC_ACT_OK;
 			}
 		} else if (TC_ACT_EXT_CMP(ret, TC_ACT_GOTO_CHAIN)) {
-			if (unlikely(!rcu_access_pointer(a->goto_chain))) {
+			struct tcf_chain *chain = rcu_dereference_bh(a->goto_chain);
+
+			if (unlikely(!chain)) {
 				tcf_set_drop_reason(skb,
 						    SKB_DROP_REASON_TC_CHAIN_NOTFOUND);
 				return TC_ACT_SHOT;
 			}
-			tcf_action_goto_chain_exec(a, res);
+			tcf_action_goto_chain_exec(chain, res);
 		}
 
 		if (ret != TC_ACT_PIPE)
-- 
2.53.0



