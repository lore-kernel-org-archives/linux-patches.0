Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BDA263C78;
	Tue,  8 Apr 2025 11:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111946; cv=none; b=bdEBtaEG0wYStmL8UcokuhYsrnOpezoOIOuXHWwUoMSRjp9qley+sY7IzEbBqf8BLrEc+CZh6Ckd5VXKTYAV1VizapvdjObnzxNRMcWWFyXDxrve9OVe06re1m7rS67y7XDLvNJD7+rcWREXIrFboSnQUikWr4Dm4APXjsmRwUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111946; c=relaxed/simple;
	bh=70djLRNGTnsmbHAXdgg6ubPWftYbl2N+rfomqVAOtQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRudM70P5dyjeGO2B0Dn9wrrfhnE+CkLZLOeejfpLF3E/acxGGY9Af55j0FI8+d0qwtWXDCprUzQtQQPdfweuI7kkRsDeYGMvyo4IotVoPasA0gMErrxhuvEOH3R2sxrIaU6Gd48VoC1b4dLvXVzwGfxi84Q+yfrScPxWV3GRgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXgZxYGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXgZxYGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DBDC4CEE5;
	Tue,  8 Apr 2025 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111945;
	bh=70djLRNGTnsmbHAXdgg6ubPWftYbl2N+rfomqVAOtQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXgZxYGLruWFvDk2gunpQGCv3yk8NIs4cQ9mEdwBo4ZD2ragtKxvpWKfQUzeWcSdF
	 b45126OX60u+FD20q+e3MBcV+p0iibOGpUZ4ATkNGJtMTPO8v2JCe09o6RHeVLeQmD
	 3PjmP/Yirhv9R/BcUz+9hvLtk6Yf4d/JC8RgwEqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 618/731] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  8 Apr 2025 12:48:35 +0200
Message-ID: <20250408104928.644899196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 9d74da1177c800eb3d51c13f9821b7b0683845a5 ]

conncount has its own GC handler which determines when to reap stale
elements, this is convenient for dynamic sets. However, this also reaps
non-dynamic sets with static configurations coming from control plane.
Always run connlimit gc handler but honor feedback to reap element if
this set is dynamic.

Fixes: 290180e2448c ("netfilter: nf_tables: add connlimit support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8bfac4185ac79..abb0c8ec63719 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -309,7 +309,8 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 	nft_setelem_expr_foreach(expr, elem_expr, size) {
 		if (expr->ops->gc &&
-		    expr->ops->gc(read_pnet(&set->net), expr))
+		    expr->ops->gc(read_pnet(&set->net), expr) &&
+		    set->flags & NFT_SET_EVAL)
 			return true;
 	}
 
-- 
2.39.5



