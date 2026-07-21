Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD3B446063;
	Tue, 21 Jul 2026 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661102; cv=none; b=HEEYOFvu5JvgX2kWghc45UH5gLdtwHsdCg/Xo5qcSOTJxJLJ/HUPqKcMsYkDc7C135Hk/A/AiCKSJ2fSSPJVND379XBe7FdNBG5ZNiYZTfU0D96sZ64Xb3+EdAjIJsQZNMMyvyDm/ps9RY5XWX8bRiwznqsTurA0v9Oqu5KBm68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661102; c=relaxed/simple;
	bh=1NlDq721peuL3cpIyvnzVV3ZCOcacmM5bPOQoP+fTC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwnVv/NZMZYabRQ6IZmXq2VvrR4NnvFn46qxcEjaO+zQub3r5czNGKPMTxluicrdicaHODaVsDe1H9HKohTWvtNV80chOGZe0gQbZgoNMwA7Y2PtVQmrQmszXelDea4PByQrULh2BTEXH93hAxVFt5d9/yojvSLc1WO9vRJM9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khhmPPk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khhmPPk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D84C1F000E9;
	Tue, 21 Jul 2026 19:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661100;
	bh=RtExWMMT1dCjTNd6T9CQp8XlbRXjT97qcKMyKWtVrNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khhmPPk9ZuOgEA88ngw5wzcvKSMxvyQScmeyAA/Kb8fwltETkwMfenUp21WTyxuDU
	 NYi3i+l+1dtq7sGHIH3MxxJWY6FL0SO6g1/rFWlQHvOsNr7IwhZuZbNIzaiVTt5XfQ
	 0dj68l161pmqUj84vZvGKlhfXuB41BN+P43mdFVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Wei <n05ec@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1230/2077] netfilter: nft_compat: ebtables emulation must reject non-bridge targets
Date: Tue, 21 Jul 2026 17:15:03 +0200
Message-ID: <20260721152621.824578589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9dbba7e694ec045f21ede2f892fb42b81b4e1692 ]

xtables targets return netfilter verdicts: NF_ACCEPT, NF_DROP, and so
on.  ebtables targets return incompatible verdicts: EBT_ACCEPT,
EBT_DROP, ...   We cannot allow fallback to NFPROTO_UNSPEC.

ebtables doesn't permit this since
11ff7288beb2 ("netfilter: ebtables: reject non-bridge targets")
but that commit missed the nft_compat layer.

Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 0caa9304d2d030..63864b92825909 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -397,6 +397,22 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_target_bridge_validate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct xt_target *target = expr->ops->data;
+
+	/* Do not allow UNSPEC to stand-in for NFPROTO_BRIDGE
+	 * targets: they are incompatible.  ebtables targets return
+	 * EBT_ACCEPT, DROP and so on which are not compatible with
+	 * NF_ACCEPT, NF_DROP and so on.
+	 */
+	if (target->family != NFPROTO_BRIDGE)
+		return -ENOENT;
+
+	return nft_target_validate(ctx, expr);
+}
+
 static void __nft_match_eval(const struct nft_expr *expr,
 			     struct nft_regs *regs,
 			     const struct nft_pktinfo *pkt,
@@ -932,13 +948,15 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->init = nft_target_init;
 	ops->destroy = nft_target_destroy;
 	ops->dump = nft_target_dump;
-	ops->validate = nft_target_validate;
 	ops->data = target;
 
-	if (family == NFPROTO_BRIDGE)
+	if (family == NFPROTO_BRIDGE) {
 		ops->eval = nft_target_eval_bridge;
-	else
+		ops->validate = nft_target_bridge_validate;
+	} else {
 		ops->eval = nft_target_eval_xt;
+		ops->validate = nft_target_validate;
+	}
 
 	return ops;
 err:
-- 
2.53.0



