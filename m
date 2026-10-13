Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBB74F472F;
	Tue, 13 Oct 2026 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894714; cv=none; b=qYHZM+pdlP1hw50XawzhLaRElWdeA5/hawl7dmYm3IPkAvntq8w3f1gPkzLAYbBWzL/PpydmywG2OgC0HluhcGr/QSNsDpFnC/AVnifZuSGn2NaKaml9IvYXFsnGcVMlKsl/nZTON3P3ee43IIBlE8oooFj0WwrYQonPBRQSQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894714; c=relaxed/simple;
	bh=c/85I/bEtJCYX5YxhOS7+GFs8g0AC6CdiBIPCTf9K2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFvPSwWYYamhPnG/w/X9j7sRok2C3zM2M9idklvsH6e+xcs3n5rcC1IZx5u0v3hGXiEmOs0sSLIq+d3aEAp3v21nPWA5AFkGeo2C9zcA0UxAsct4/OdQXUBOnXz9RSaU0OLIM9Rv66G3kG40Qks8pPlcg2zwVWsjOONZA1ZNkn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTmOm93T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTmOm93T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAAB1F000FF;
	Tue, 13 Oct 2026 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894712;
	bh=vYnZcuJLwOpbQ+Q/rgFndYKsF2evLaiPhuPMIuO6gw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTmOm93TYUjfIi/DHRk5+UEdboSVBS+mlmb6E7dwiETSGHUVrt7/aGe4CFjhUPsja
	 e/lytWSWWqEDiqJw2xrOa24tRcgKUJU+Somt5js2Mg2tVxmPNGGJ8ziQEPS5A6MYDG
	 ueOCUJItgQ5nUPfjdghES2GUT5MMppVazGieyoks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 030/497] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Tue, 13 Oct 2026 13:33:17 +0200
Message-ID: <20261013112908.601743373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit 747928b5d4ff8c8de55138a54c13980e4bb88578 upstream.

nft_flow_offload_init() bumps the flowtable use count with
nft_use_inc() before calling nf_ct_netns_get().  When the latter
fails, the error is returned as-is and the reference is leaked.

The upper layers do not balance it either: nf_tables_newexpr()
clears expr->ops when the expression init callback fails, so the
nft_expr_more() iteration in nft_rule_expr_deactivate() and
nf_tables_rule_destroy() stops right before the failed expression
and its ->destroy callback, which would drop the reference, never
runs.

Each failed rule addition therefore leaks one flowtable reference
and the flowtable can no longer be removed: NFT_MSG_DELFLOWTABLE
keeps reporting -EBUSY even though no rule references it.

Save the nf_ct_netns_get() return value and undo the nft_use_inc()
when it fails, restoring the inc/dec pairing within
nft_flow_offload_init() itself.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_flow_offload.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -418,6 +418,7 @@ static int nft_flow_offload_init(const s
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -432,7 +433,11 @@ static int nft_flow_offload_init(const s
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,


