Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210882;
	b=5n8kCnKND3LTAF8a70Klau4P44PJ6CpLqMsDV1b0oHcO61KQDuIkGSNnhc//Y+2M6ROX
	 5lLCG385Tn88OCAxO04mtNBHr0Ma0/nFjZogij6Km9lzujnckWk7uvNiv43H53aFk9Fqy
	 UwYqpTLSWg1uxd6UO/fWFxDDhyS7NpRvj9wvXYjHuBSkq/gw+r5PPM2hvZMuV269xDZyx
	 XbQIZYHSU2AAvZR9L3Q+iy8nunqEXRjt3HEn5mB5ySmKdaAgV99ZQ6r7mIRvDsUSSMJSM
	 D7Z6M+OCZE4bU4WgGOeUg+ZwQCE7yr9g0V76Gro3gLwm64hwMR1R6AhOWpHf6BZ+gKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XTxzrd+TWutAXITW532B3rC6bBGC19TCobOph0dWeUM=;
	b=mqf7e9JMQwMrpzkOXFZdVTW4HGdaQqlbzSMnnU9MCbg3HyaL9ljiw3RDbbR70Fx14R+k
	 mmJvc8sVBwWivR3eqMOf3VUf6hOWHbHXeGTkytxw0o65r7Lg1esjSB0AI2cKfT4ZKAN3N
	 LrRNSHnchM4cTbOYZLZChFZM5ZkdJ+uHWlvZ/Z++tjsKWlK+2d1UAcbauEmPFTimyEHYy
	 i/YKY871MPeNoIlNuLg+tjnpc+aCkcaVE9alQqXDSKSHMxGCqQn2357rp21EzrEGfRpsa
	 FAJdTyV/nd76ZIJWX5X3caRNNc6Eb6AKq19JHFUFeI5yfM8Q7RjAPB22F8/vjBBCtAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfm7dOfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D246606A31E;
	Wed, 28 Oct 2026 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfm7dOfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE95C1F01825;
	Wed, 28 Oct 2026 18:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210882;
	bh=XTxzrd+TWutAXITW532B3rC6bBGC19TCobOph0dWeUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfm7dOfVxfelLl6mwMnNme42oGG/X6mqlY/ujKAL0LZTa1nrrKgpt4MsRscDfNGuD
	 3Mg7fUjTFBhLmvzsfNwe9GruMVfy8+BgSGRco4s4zP0JbIfE0YYMgQVnTvoscWDtaC
	 wyWZs+9wJpSt7voPudF4KxVES+wEfPV49ni8hkHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/571] net/sched: cls_api: reclaim an empty proto on the error path
Date: Wed, 28 Oct 2026 17:55:22 +0100
Message-ID: <20261028170012.166429824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 0bb8eab29b55045281a4963d4557f2776cdf8cfa ]

Two racing tc filter add requests on the same chain/prio of an
unlocked classifier both run change() on the shared proto and both
can fail: the winner's tcf_chain_tp_delete_empty() attempt gives up
because the loser's handle is still in the idr, and the loser's
error path drops only its own reference without a second reclamation
attempt. The empty proto stays linked in the chain, holding the
chain reference, a block reference and the classifier module
reference until the chain or block is torn down.

Reclaim the proto on the error path of any failed request that holds
a proto reference. The reclamation is emptiness-gated:
tcf_chain_tp_delete_empty() unlinks the proto only when
delete_empty() admits it is empty, so a live shared proto is never
unlinked. A proto the request created is reclaimed unconditionally -
it is the only owner, so marking it for deletion is safe even without
a delete_empty callback. Classifiers without one (the check marks the
proto unconditionally) are rtnl-serialized, so the raced window this
guard closes cannot arise for them.

This is a follow-up to commit d4e359b3608a ("net/sched: cls_api: fix
teardown of an adopted proto on insert-race loss"), which stopped the
loser of the insert race from unlinking the winner's live proto but
left the empty-proto residual in place.

Conditions to recreate:
- CONFIG_NET_CLS_FLOWER=y; veth pair
- tc qdisc add dev veth0 ingress
- two concurrent `tc filter add dev veth0 ingress protocol ip pref 1
  flower skip_sw ... action drop` (both fail in fl_hw_replace_filter
  after publishing their handle in the idr); repeat in a loop
- an empty flower tp stays linked after both requests fail; visible
  as a bare `filter protocol ip pref 1 flower chain 0` header in
  `tc filter show` with no filter entries
- CAP_NET_ADMIN (namespace-local via unshare -Urn suffices)

Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260805134049.927864-1-victor@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-JCOT.v1.20260910090924@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ace3e9e4626c5..abe45d7a6c13f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2155,7 +2155,20 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 errout:
-	if (err && tp_state == TP_CREATED)
+	if (err && !IS_ERR_OR_NULL(tp) &&
+	    (tp_state == TP_CREATED || tp->ops->delete_empty))
+		/*
+		 * The request is dropping its reference to tp. If it was
+		 * the last user (the idr is empty now), reclaim the proto.
+		 * A tp this request created is reclaimed unconditionally:
+		 * it is the only owner, so marking it for deletion is
+		 * safe. Otherwise only classifiers with a delete_empty
+		 * callback are reclaimed -- the callback admits an empty
+		 * proto only, so a live shared proto is never unlinked.
+		 * Classifiers without one (deleting is set
+		 * unconditionally) are rtnl-serialized, so the raced
+		 * window this guard closes cannot arise for them.
+		 */
 		tcf_chain_tp_delete_empty(chain, tp, rtnl_held, NULL);
 errout_tp:
 	if (chain) {
-- 
2.53.0



