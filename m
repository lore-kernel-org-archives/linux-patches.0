Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE25617A30A;
	Sat, 12 Sep 2026 13:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219800; cv=none; b=CojWi0sPFaqn86CBIvZATwzrxXi0M2isa56ysTAQDmCQjYOubKq1bbtXjyUQDE81LjWECv5gUp66ddb+lDmebTC1wnzxRHLjNhg+mrvJsr03+2PuJrkn6p5j03O3/KAAo9TaB4p7cTgCZx6IOuuKaAqDRzmbiNpILLOGu+HrKdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219800; c=relaxed/simple;
	bh=FMRJziGqX32BFGHcc24XjfyndC3fJ5dEULXp1IhnslQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaGREWL4ekTI5lXeCnImdf7VPI11GmJaewBQDSl8cenO1SWh3v7kL9Ce1lnSXS88vgMoFYG0c5Kgy1cqT53y59BLhU9VARsU45TH3Yq71vHr9mImsidfhY0+mEUixUHd6/xFaHFa+FF74od61ouKWs2QfldfF2cPvySAYFsLiYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkYkOVlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkYkOVlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925C81F000FF;
	Sat, 12 Sep 2026 13:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219799;
	bh=yIRPXyxVleiez3UDD9UVUzEoJImHXABEAqSowqydoJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkYkOVlAL8lApWMyxAF3vqvRcMCJ7lfOuzRNXA2EoJUIx8eiDg6ebKIvyia5KoN19
	 aqbfJvGuYDG3EMTjF9BL1WXILJWu7JmI+04SgUaPqBI8tB68n8VQMdquViOF6Q0jT7
	 1x1d4AgL82+R5h5eXGKnhzi//M5wbftFvnqQVkEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0047/1424] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Sat, 12 Sep 2026 08:41:19 +0200
Message-ID: <20260912065608.356633342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit d0728723c80dcb3432effd67c7e919b596004b1d upstream.

nfsd_prune_bucket_locked() evicts an entry before checking
the freed count against @max. The check uses "++freed > max",
which does not break until freed exceeds max, resulting in
max + 1 evictions. Use ">=" so the limit stated in the
function comment is honored.

Fixes: a9507f6af145 ("NFSD: Replace nfsd_prune_bucket()")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717001232.438792-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -284,7 +284,7 @@ nfsd_prune_bucket_locked(struct nfsd_net
 		nfsd_cacherep_unlink_locked(nn, b, rp);
 		list_add(&rp->c_lru, dispose);
 
-		if (max && ++freed > max)
+		if (max && ++freed >= max)
 			break;
 	}
 }


