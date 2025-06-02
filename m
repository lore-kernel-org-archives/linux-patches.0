Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409FF2248A4;
	Mon,  2 Jun 2025 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874929; cv=none; b=tP/vYxGalopffloV7hYvzuMZ4vz8mGB/PdQvE/5659wwfiPwit1pMWXYYzvJCzE5ZgeYbFBQs38+cb1pU1BFFlDH+zuyxaKFXTzNCBhQ78HakLgbdKCLcis1jWQNFiDy1g9a4I39gtseBZ1WifM/m1FWlRfKpBUbOGwbX3HJXdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874929; c=relaxed/simple;
	bh=0HhjwXpbLg1cSm6tyT0NLIrSdQB03KeEp5E9c/exEC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhOTIuY3pf5d3n8oi6ZaO+lnnQpE0D0aqwOcdtq/25gZ8Sug7hjWeXKyY+nWamBx4C6+QJCymnBkSKZnYCqZn/FWoDd3nyryHfAUJOuft2ms6f8ydiRsn4e7Kb9kr/3+o4B2iDKmFwfDkdDpHwTQq1JZkUf81+/WtpUUJng3pGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzg+4O8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzg+4O8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1F2C4CEF0;
	Mon,  2 Jun 2025 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874928;
	bh=0HhjwXpbLg1cSm6tyT0NLIrSdQB03KeEp5E9c/exEC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzg+4O8rwz64ve9+BqGymXjPfBa1Js5SbA6XkWRWimcX81oi86RxffSRb5oJMJnUs
	 whRh9AwpNR8Pk9Vk6bToWwN/9Et8xRUTcgRZi9IdQUzMsz4e1zekz+gejABMtOa3zX
	 2DKdDUy+OJ8ajinca0aYzrqdYBzIrcRHvOiuZWB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Louis DeLosSantos <louis.delos.devel@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/204] xfrm: Sanitize marks before insert
Date: Mon,  2 Jun 2025 15:48:24 +0200
Message-ID: <20250602134302.372971968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 0b91fda3a1f044141e1e615456ff62508c32b202 ]

Prior to this patch, the mark is sanitized (applying the state's mask to
the state's value) only on inserts when checking if a conflicting XFRM
state or policy exists.

We discovered in Cilium that this same sanitization does not occur
in the hot-path __xfrm_state_lookup. In the hot-path, the sk_buff's mark
is simply compared to the state's value:

    if ((mark & x->mark.m) != x->mark.v)
        continue;

Therefore, users can define unsanitized marks (ex. 0xf42/0xf00) which will
never match any packet.

This commit updates __xfrm_state_insert and xfrm_policy_insert to store
the sanitized marks, thus removing this footgun.

This has the side effect of changing the ip output, as the
returned mark will have the mask applied to it when printed.

Fixes: 3d6acfa7641f ("xfrm: SA lookups with mark")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
Co-developed-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 3 +++
 net/xfrm/xfrm_state.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index bffac2f4b581d..78f69ee65d0ea 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1571,6 +1571,9 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
 
+	/* Sanitize mark before store */
+	policy->mark.v &= policy->mark.m;
+
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_bysel(net, &policy->selector, policy->family, dir);
 	if (chain)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index e8be18bff0960..7380aa3a5f0fe 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1244,6 +1244,9 @@ static void __xfrm_state_insert(struct xfrm_state *x)
 
 	list_add(&x->km.all, &net->xfrm.state_all);
 
+	/* Sanitize mark before store */
+	x->mark.v &= x->mark.m;
+
 	h = xfrm_dst_hash(net, &x->id.daddr, &x->props.saddr,
 			  x->props.reqid, x->props.family);
 	hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
-- 
2.39.5



