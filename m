Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968E022FAF8;
	Thu, 12 Dec 2024 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022267; cv=none; b=uYeptfcRYGS/q0fqaSdZeIdO2ZV2GTSIklYJ0zPdxdfcXyztSomBdP9nG68bJEdgZpUQab5KF8HLhzeSpx2neTAz9/C6KdeX8UMzaCDwi7HT1xvj0cSFjF004QA+gmnUhsN8vYsf1XMkJjN2HTlOlomC+SlcqvpnOiW5zm8ZTFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022267; c=relaxed/simple;
	bh=RoHyV3hdijBdf/0MhEITdPiWYMo8ahFaeHQPm0F5kCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnP0LcJrb9sq6L+s7OTDu0P2H8Fbd7noN+sCq0dFdnAGBsSbrxxI4+nJfN2/lTaF2CuSEkBy7aUFiCq3QxjmhYQvbLE5xPynj43CZ+LXSWIwEHJFhlLb21DNuEEgQzmbjftIYWGdthyvrwwIcCIQK1LV3a7/nRzJqZOgkL+wTmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTy0+//5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTy0+//5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F7BC4CECE;
	Thu, 12 Dec 2024 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022267;
	bh=RoHyV3hdijBdf/0MhEITdPiWYMo8ahFaeHQPm0F5kCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTy0+//5ZBooec6gsJValLsiQmSCTJgtxyIiAs84NJcVUNRAxzHLCn5ASlW7TlR2E
	 p8K/ZQjQTHOkBq/YnYf2s27JszZEB1VeRPE2TZdp1jCt1pRkv1K3QFPWauCYEOyvAt
	 c8ibwdNDuQRRit+qbY/UtB0lK7Be2XVy+RIvPoXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/565] netfilter: nf_tables: skip transaction if update object is not implemented
Date: Thu, 12 Dec 2024 15:56:21 +0100
Message-ID: <20241212144318.834409724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 84b1a0c0140a9a92ea108576c0002210f224ce59 ]

Turn update into noop as a follow up for:

  9fedd894b4e1 ("netfilter: nf_tables: fix unexpected EOPNOTSUPP error")

instead of adding a transaction object which is simply discarded at a
later stage of the commit protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: cddc04275f95 ("netfilter: nf_tables: must hold rcu read lock while iterating object type list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 71a486d9fd76a..20e2f2deb336d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7189,6 +7189,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (WARN_ON_ONCE(!type))
 			return -ENOENT;
 
+		if (!obj->ops->update)
+			return 0;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
@@ -8787,9 +8790,10 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	obj = nft_trans_obj(trans);
 	newobj = nft_trans_obj_newobj(trans);
 
-	if (obj->ops->update)
-		obj->ops->update(obj, newobj);
+	if (WARN_ON_ONCE(!obj->ops->update))
+		return;
 
+	obj->ops->update(obj, newobj);
 	nft_obj_destroy(&trans->ctx, newobj);
 }
 
-- 
2.43.0



