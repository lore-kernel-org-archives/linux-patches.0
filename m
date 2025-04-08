Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10143AC1C;
	Tue,  8 Apr 2025 11:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113559; cv=none; b=bAJARp3lPVDY04cm/M1IcUgP2F2RVgJWqW2YCX2jnzu2TF8ctL4RrCtCuU9atztCeJVNAFVlCiBMNeH3nfGDAvHDZ/bRZjg3OjDw3zrFXwy0iHLClw+0xv7XfUVQECzROBYkn1JjukCCZpYOVnUXzB4nNVHjxyZmz/aTRIWoeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113559; c=relaxed/simple;
	bh=CZ4WLpQoPJsp2RC4uVzGwH4ZSUiP2VWF6KCcRTnONA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc+YEMgBIL1sgL8mlx3t7GvUhXSu/KO6s3tm1jduH32uM6NKeu1PQpPDf/bfaJvRs8YUUpk4Ql/4cRc/iPzwDYoyLOsjczvguzixRghCTPaJq1vljQ2fJ4RidJyxiMRUECG3AJjCakL7gHi88RlCPJ7VN++2CH2arhyFQa1YSu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXodYlDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXodYlDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E34C4CEE5;
	Tue,  8 Apr 2025 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113558;
	bh=CZ4WLpQoPJsp2RC4uVzGwH4ZSUiP2VWF6KCcRTnONA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXodYlDt1VgjJxth5/z7eJBQm1nou/FsG8ZB2eho3n6C8P6heP5vBDe8CtKkHWE9Y
	 FhwtPi7ShXbxnZTn5E7uCS/AO32un9lfu2lE4a4Nd3eDcDW88lilmeHxhhB40Rh9Ee
	 N7yPqNMF56CnEhOCHizfsrnmSlGijflyHxoxwHX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/268] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  8 Apr 2025 12:50:16 +0200
Message-ID: <20250408104834.097449696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0370f69dce86d..2f1012bde1f34 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -308,7 +308,8 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 	nft_setelem_expr_foreach(expr, elem_expr, size) {
 		if (expr->ops->gc &&
-		    expr->ops->gc(read_pnet(&set->net), expr))
+		    expr->ops->gc(read_pnet(&set->net), expr) &&
+		    set->flags & NFT_SET_EVAL)
 			return true;
 	}
 
-- 
2.39.5



