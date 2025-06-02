Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479BE22A7E4;
	Mon,  2 Jun 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876392; cv=none; b=MYpLzMgAWa2qFD0S/f0A+kDLh9RX9I3kBMzSa4/quiP7SdFzalwkq3I8gyrBuTpzm3sBCcw9EFYG2N9qqirX/fLg+i7k6S0yo7g/LlHy51ZYiSZiHe2Z7Xh1ig0hdDQFNUxsizB5kHYv+CZucIqKFl7Sfoc6YyU1bd3LhyurQrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876392; c=relaxed/simple;
	bh=YP6rEBZQapLMvTuCJEOQytMoEzXCWlfVZOLkXOJZ3So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNV/3YVjU25oNxYA1Xd5cyNlAZ7psW5bJxpeTm14g/uyrniGoq3pgBe+QIida3a0y5Utoi1TqZSPsfQ48/m3cjSsMBI3YSbxT2Se7QXfnhQS0Jmp4FZr+lBJoNSWuqN5VPeZ+EDyVEWBZLZOxqqmGrun6NkpIjEVv3VjtSt4inI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM3ZvVNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM3ZvVNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE415C4CEEB;
	Mon,  2 Jun 2025 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876392;
	bh=YP6rEBZQapLMvTuCJEOQytMoEzXCWlfVZOLkXOJZ3So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM3ZvVNT37ES86/DSFMueaOcVD98SPADHR4x6Ggd3ykyNJglmkA6s2PfnDz5Gw6+c
	 aFCLhfAHMD+Rvaxy2dGFmxv028Ue1d3E00KLI8lwYcN9AuOSckCcQKZ3rhmlDkeZyZ
	 axOQcjv5VdPg/uQ9h1eQAudJir7n8j4ze9EC7D3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Louis DeLosSantos <louis.delos.devel@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/207] xfrm: Sanitize marks before insert
Date: Mon,  2 Jun 2025 15:48:55 +0200
Message-ID: <20250602134305.121858902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 55ef8e8329243..16958656b6d43 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1594,6 +1594,9 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
 
+	/* Sanitize mark before store */
+	policy->mark.v &= policy->mark.m;
+
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_bysel(net, &policy->selector, policy->family, dir);
 	if (chain)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ff8159bae7bbf..c1bc5d780f640 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1277,6 +1277,9 @@ static void __xfrm_state_insert(struct xfrm_state *x)
 
 	list_add(&x->km.all, &net->xfrm.state_all);
 
+	/* Sanitize mark before store */
+	x->mark.v &= x->mark.m;
+
 	h = xfrm_dst_hash(net, &x->id.daddr, &x->props.saddr,
 			  x->props.reqid, x->props.family);
 	hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
-- 
2.39.5



