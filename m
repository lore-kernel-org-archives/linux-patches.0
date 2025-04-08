Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9E326B2BF;
	Tue,  8 Apr 2025 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115930; cv=none; b=MqlQC5gmSPwzGf6z6PfpfZP9EwlvfsnMNp4I2C17CP9aUE/rtnZKa/UlZMzqhT4SwkbXiG2VfmEDvj1pPYTwRniRpmDKdOtzuNXVwkNYsAxqw/vmkfp94GO3q1CiRWQmwz76HD7S6TlehPLXUecO4FeINkS4A7sKvhiTjeJVqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115930; c=relaxed/simple;
	bh=QqS3PaTnVVCDCLpxWOLpmg4WhjPxMRV4VSZgqeoDFVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NX3e9R/Hi5hbKOE+FZaWqFZa9qOTd7R+TfpMQgTNOofgPhn5Sn+mdH42XZMzC9PGkNbvCz+TBsE8a3RHrvpvsPlxY7qps7riE0OVp+zo5qDmMRaX/AaEu91js4+xDIEdaUY9ZU5SMckFrRQbBPs+L7C6+DfFHZIRjBmnI0IL5ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtYqpUzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtYqpUzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE9CC4CEE5;
	Tue,  8 Apr 2025 12:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115930;
	bh=QqS3PaTnVVCDCLpxWOLpmg4WhjPxMRV4VSZgqeoDFVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtYqpUzYgrL8yPVmxbzhFzzytRCSX7FBnlYCSnhHjkne5JpM/F62ZbkDnoKp9lFo6
	 mZ8ppcT1sIJYDOpP2FVvlDCQYVldXmHXhGopFNWqEWFYWhgJ3HQnwGw0Hi/ZEA2wwt
	 EmVFCz1qhS97sXYc+nTLyjij0JIMb9FGigaVDTSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/204] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  8 Apr 2025 12:51:25 +0200
Message-ID: <20250408104824.856257154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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



