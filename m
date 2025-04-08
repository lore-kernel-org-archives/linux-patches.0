Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2178A94A;
	Tue,  8 Apr 2025 11:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112908; cv=none; b=pQ3wh2uFUtdz/0f5cctx51HDOzngunXYNUbDmdsmYzo1olm8r2MmpZOpCdTd16WR0+Pm6ND2jStcySDfrzcu0UepDxsKJdf/LfC2Ve4lNChUqEWDQUOQvyk9cfdXDqY/eG0j1yVhHrd1J5lV8AM56ILp9iwFSzV2izIGrL7PAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112908; c=relaxed/simple;
	bh=k0G6dnZtxYs9UuWlfpfJckJGdXNVXzhsYxQKqrX9TI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXb0cprOZLcpRGyxRK4wFbxp15AfSHRLISUwHYqWaDj3ke9xu+Yt+eKiP++W0RMD5lBxa+TK6o83SZXaYM/dmrOGrQkgB2TPtxnpEbPPny1Z+bp6laSLBbUj1ig7VBNnKc8y6E5gmraoaYImGOgIiZfo9FQupjMEaZiiQ8+A65U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itBqDsXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itBqDsXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F75CC4CEE5;
	Tue,  8 Apr 2025 11:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112907;
	bh=k0G6dnZtxYs9UuWlfpfJckJGdXNVXzhsYxQKqrX9TI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itBqDsXoEc/lbYqxjdQwIWmLpnIMofwp65CqHB28ax6zwXQpuH6nuk56nSqw03UQD
	 OboKphekzyqThFupPwD8QyyKbcemUwaMAdwb/55Ma3moDbKMJd9fyLGODkS1ZerD5K
	 p6sexteTSZixZODxoD7+PzmlkajDOnBMo/OZS/SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/279] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  8 Apr 2025 12:50:24 +0200
Message-ID: <20250408104832.890295082@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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
index 5c4209b49bda7..a592cca7a61f9 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -310,7 +310,8 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 	nft_setelem_expr_foreach(expr, elem_expr, size) {
 		if (expr->ops->gc &&
-		    expr->ops->gc(read_pnet(&set->net), expr))
+		    expr->ops->gc(read_pnet(&set->net), expr) &&
+		    set->flags & NFT_SET_EVAL)
 			return true;
 	}
 
-- 
2.39.5



