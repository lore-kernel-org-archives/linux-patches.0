Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4070F26B2D6;
	Tue,  8 Apr 2025 12:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115303; cv=none; b=CwUmbaa9QpRTFp15wdglK86L6j+5XIZ2ioA39eWwJJvrTlJvvOZuRUeXcq3ND2l/BZXeNv8OjyauljXVNjgbNz7YxBiem4oGOzNrhlXx4IFDYBAcByM3PgQsUrEmyYfz2v26KePePdgEuB8fAgMl4QHvJwKsG94h0JXYjEwnW3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115303; c=relaxed/simple;
	bh=rI4Q1dqJ4zJYQpEMPiPlE6mODvFf8PYf5AmiRu7BTeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDv9+TAGBOeZjED0iRds0bJd39joRQsvaVXbGQhilT/oPZFO9gNlNPTJMyYTGK+0aAw/T563Q1UYkSJKdLijNAhE3iVSIB0OQFj+Wt6u7ID/qotsqK/P3lbKLvFMYmAbY/Dkpc2k8W+jEaTFg0GG9ExhDaY9al2tckTPLBDOGRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0KYCHid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0KYCHid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D35C4CEE5;
	Tue,  8 Apr 2025 12:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115303;
	bh=rI4Q1dqJ4zJYQpEMPiPlE6mODvFf8PYf5AmiRu7BTeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0KYCHidDWIpRp2G9jJg82Jq7mvlw0r3LsN659LJpgnrZVnVwWlf73kodVRF8+FCI
	 kBucEY1r14vBldz/9bxxCxI1scD9VtuOApDfgVimLy9x2HVgmj1WXldSt8M6hWP1KP
	 VgN/5zqYaRqO3JTZ8nShlfHt/PmjfwwcTIri8R+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 385/499] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  8 Apr 2025 12:49:57 +0200
Message-ID: <20250408104900.832359987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



