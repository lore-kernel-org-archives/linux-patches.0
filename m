Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A121B192;
	Mon, 17 Aug 2026 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975080; cv=none; b=p7yTVJYnsF5s9EDhjU/k1HXt/ASe2ZOrJ7HYeyA8rWht4CDfd+GWOocsJO2HZC0wHTkUBWcdJMLfy++b6OjyQs+Ijx5qbErjNH/7rASLfOYQAp+i6y709fGEEGNDpje3ZQZ9fRURTgADaFU3oQitiGAN2SxjPmYIjq6ozyeKdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975080; c=relaxed/simple;
	bh=Lw7hvgprw4fOeF1HEiMLPUp3rDrvTn3Tp5mXAcm9FTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUUtJx5O1Q01We7pzax96EawWasfCZYI8ra7gCA7c2WSml4krbDI+UfeWQwh0SN7iSXERS9JhUopuniiX6RiVhYdDjfczac2qQWXshynZB+c0AoUoZUeprL82oJbatPNP6wBUCxRYkpm+8aEGAD26eqMnKIK4kcFq4yw5xcpyPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5EVS0nK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5EVS0nK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B981F00A3F;
	Mon, 17 Aug 2026 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975079;
	bh=FWIOUch/FJk7WQEkghMfp8wiNBwuVV8Mp5ICgYDagXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5EVS0nKl0bQYpc146/20uPPcTCW5bBIhTwHntCoVaX1y2h1Fnj2DM9SS/rcuBLi+
	 aNU4FD+4jqHO5H7IKNFzj8S/qni1e+QV7GTnV1JYUaviu9uFpV/pVQUyP7jb0TtuGG
	 we0uAOawKd2bfsN1i75QJJx/KufP7LtPNfoh4WfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/250] netfilter: nf_tables: avoid softlockup warnings in nft_chain_validate
Date: Mon, 17 Aug 2026 15:31:54 +0200
Message-ID: <20260817132542.809476779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7e7a817f2dfd79098a706ee5581ea9518b2de878 ]

This reverts commit
314c82841602 ("netfilter: nf_tables: can't schedule in nft_chain_validate"):
Since commit a60a5abe19d6 ("netfilter: nf_tables: allow iter callbacks to sleep")
the iterator callback is invoked without rcu read lock held, so this
cond_resched() is now valid.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca6d2041eee66..db939e1988009 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4080,6 +4080,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 			if (err < 0)
 				return err;
 		}
+
+		cond_resched();
 	}
 
 	nft_chain_vstate_update(ctx, chain);
@@ -4104,8 +4106,6 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
 			goto err;
-
-		cond_resched();
 	}
 
 err:
-- 
2.53.0



