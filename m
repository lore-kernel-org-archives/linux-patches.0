Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8233064AB3;
	Tue, 23 Jan 2024 01:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975066; cv=none; b=iA8wPh2DSn20NqR94Z0CdU9POzIOKnj/plumEkhOd8cdLA7T/Zia4MdIAdir87mSR5H7OD3qSivDbFlm+6huGOOhzB1cvrWmvatZ+cf/DmDIlMRzovuX0oSCVQ9Obx5a5OzMUvI0QKm4uNG2FcEDLsRwhYQvi0i98Vq+vCf6w90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975066; c=relaxed/simple;
	bh=PvK4Xhd1zChs1Z/3KIsqK6jiam7kcmRKivMjtH2CRrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8LU3VfwQsar6YCUSHKG16IBH2BLCOof8CU0Kzv4Vbe2QTcenO9fKBnDmwJuidFBeoVrVfEMf32WhgeDC4O2yCwFh2MsOf4jkS+a1kEMyzgOtaJyIGYMnbXFEVNkAvPiDtxIS0HXa/h5orYMFc2cwFar5LYtnaanDZqiptSGmb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5q7TZop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5q7TZop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6E6C433C7;
	Tue, 23 Jan 2024 01:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975066;
	bh=PvK4Xhd1zChs1Z/3KIsqK6jiam7kcmRKivMjtH2CRrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5q7TZopsAimCOW570a/W1Tu9O0SlIxBOSJ9y9KIrobbQNF5o93SpzAi7KpbuupVw
	 Hjoncyh2gI1T/yfkKRCox+YvLN9JKnufupQFPJckr8/o4dKkVJWN1mRpzeSaxF6g6/
	 prSBldeLb7RPk2NOBC1tIn/Ps/raYW65dxhp9VBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@openvz.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/374] netfilter: nf_tables: memcg accounting for dynamically allocated objects
Date: Mon, 22 Jan 2024 16:00:06 -0800
Message-ID: <20240122235757.109254575@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vasily Averin <vasily.averin@linux.dev>

[ Upstream commit 42193ffd79bd3acd91bd947e53f3548a3661d0a1 ]

nft_*.c files whose NFT_EXPR_STATEFUL flag is set on need to
use __GFP_ACCOUNT flag for objects that are dynamically
allocated from the packet path.

Such objects are allocated inside nft_expr_ops->init() callbacks
executed in task context while processing netlink messages.

In addition, this patch adds accounting to nft_set_elem_expr_clone()
used for the same purposes.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a139cee120 ("netfilter: nft_limit: do not ignore unsupported flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nft_connlimit.c | 2 +-
 net/netfilter/nft_counter.c   | 2 +-
 net/netfilter/nft_last.c      | 2 +-
 net/netfilter/nft_limit.c     | 2 +-
 net/netfilter/nft_quota.c     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8a5fca1e61be..e1a06d5a386f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5896,7 +5896,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 	int err, i, k;
 
 	for (i = 0; i < set->num_exprs; i++) {
-		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL);
+		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL_ACCOUNT);
 		if (!expr)
 			goto err_expr;
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 58dcafe8bf79..2a2042adf3b1 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -76,7 +76,7 @@ static int nft_connlimit_do_init(const struct nft_ctx *ctx,
 			invert = true;
 	}
 
-	priv->list = kmalloc(sizeof(*priv->list), GFP_KERNEL);
+	priv->list = kmalloc(sizeof(*priv->list), GFP_KERNEL_ACCOUNT);
 	if (!priv->list)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 8edd3b3c173d..9f78f8ad4ee1 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -61,7 +61,7 @@ static int nft_counter_do_init(const struct nlattr * const tb[],
 	struct nft_counter __percpu *cpu_stats;
 	struct nft_counter *this_cpu;
 
-	cpu_stats = alloc_percpu(struct nft_counter);
+	cpu_stats = alloc_percpu_gfp(struct nft_counter, GFP_KERNEL_ACCOUNT);
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 5ee33d0ccd4e..df48a11e224e 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -30,7 +30,7 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	u64 last_jiffies;
 	int err;
 
-	last = kzalloc(sizeof(*last), GFP_KERNEL);
+	last = kzalloc(sizeof(*last), GFP_KERNEL_ACCOUNT);
 	if (!last)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index f04be5be73a0..ac0979febdac 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -90,7 +90,7 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 				 priv->rate);
 	}
 
-	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL);
+	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL_ACCOUNT);
 	if (!priv->limit)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 0484aef74273..18ff38682de4 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -90,7 +90,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 			return -EOPNOTSUPP;
 	}
 
-	priv->consumed = kmalloc(sizeof(*priv->consumed), GFP_KERNEL);
+	priv->consumed = kmalloc(sizeof(*priv->consumed), GFP_KERNEL_ACCOUNT);
 	if (!priv->consumed)
 		return -ENOMEM;
 
-- 
2.43.0



