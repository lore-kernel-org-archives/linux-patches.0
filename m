Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2972015CD55;
	Mon,  2 Jun 2025 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877312; cv=none; b=nRW0hllDV5yU8iDB9QDkgV2GCC+lmz2OnXkjZHoJlosetxGfy2p0do+RPiQPj0CAcelFvNTJ/jpZ/067ByNiNvnhv8nto+jo39ThIOyS5dMD/S+p7ThrHX5RrZ9PD0vFYJp7jcufrDlXszzTdzRGq1+jToD+xUy9ZUUrU9Oqstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877312; c=relaxed/simple;
	bh=pT4plt0hFY3BcabwB2BebMQN69NkxSKLTBxTdpcncvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mu5bt31NCHYomFGL9RFw4PdxBVpkF+k30dFhuFSPaB2Y4l3KrPh2azorJSKGlYHx8PuTYdh3GDeVhzECykEUy+h+FV1FLC02EwD2BhJXKThHhv1FREONInRbinvlcv8o3wvc2/xMnZmb2YkNRO6nkPVtEAyhJ/XQz+palEwavdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fxee7e3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fxee7e3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F68C4CEEB;
	Mon,  2 Jun 2025 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877311;
	bh=pT4plt0hFY3BcabwB2BebMQN69NkxSKLTBxTdpcncvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fxee7e3KcXODFX/x0jaWbNsJBtTH6sNWcOAMTpvvs41kLEIy3TGoskQcVh/n6MYno
	 Y0PNfCYw3qyqjiCCOv0OjztMDEYZYS4MmRV4cSW3I6npb0cMJAXrVSHfR5el6gRsDh
	 PvYngRevv3TV4xnhaNF/aCFX1zUcVFfW7DoYaOoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Louis DeLosSantos <louis.delos.devel@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/325] xfrm: Sanitize marks before insert
Date: Mon,  2 Jun 2025 15:48:32 +0200
Message-ID: <20250602134329.374510440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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
index a022f49846879..e015ff225b27a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1597,6 +1597,9 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
 
+	/* Sanitize mark before store */
+	policy->mark.v &= policy->mark.m;
+
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_bysel(net, &policy->selector, policy->family, dir);
 	if (chain)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b5047a94c7d01..58c53bb1c5838 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1275,6 +1275,9 @@ static void __xfrm_state_insert(struct xfrm_state *x)
 
 	list_add(&x->km.all, &net->xfrm.state_all);
 
+	/* Sanitize mark before store */
+	x->mark.v &= x->mark.m;
+
 	h = xfrm_dst_hash(net, &x->id.daddr, &x->props.saddr,
 			  x->props.reqid, x->props.family);
 	hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
-- 
2.39.5



