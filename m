Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5813DB92;
	Tue, 27 Feb 2024 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043622; cv=none; b=X7PZ6DkoXgyHVSDLDK6sfM8ktkIBPiTjIHINjMLl2+J6N8e1OJB8cSSahShjiJaSi1K5pJEGeANVMBh6O1hecqqnpXpsSWoovbevelm4u717fiEPIGCuovv74X/mYfybcSRqW30K3Ur2EkmJMSazi70rPgyqLm/A8twh9Zgc3U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043622; c=relaxed/simple;
	bh=Za6N8x9wSQjxd4LvijtCN++GP3nO120aBPUC0ZtY6Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JETf/1lkBo5ew7PxxgrLIcOWB9vlvGP8gzVpQhZj8pWP9mEi/VPgcCKw4a1N+74knFpVJF5H023uqIOQFt9GC5/GEpMvpTWVV3OLyhDfoK5f09j3sBFh//z/beM9ho8xnstAE1wU0YaHcpyyKj00A8NNCRhbNPHDFcZbRUTl2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kvv/nGIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kvv/nGIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F30C433F1;
	Tue, 27 Feb 2024 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043622;
	bh=Za6N8x9wSQjxd4LvijtCN++GP3nO120aBPUC0ZtY6Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kvv/nGIhgMTNkgI9RprAfTG01pTNGUewhql/pEfOEd23e1LEBewi+Hh9CaD8ObYvn
	 yTFgKh9qNcNFAU0G8pQApWpKEtQ0DCI79ELkDmOxOPzozz9o0otV/jNopY1+D1qjHd
	 GEcm1SzkE9GucAMlzWfqSx/q9NDjDO/DlvHUXhZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/195] netfilter: nf_tables: use kzalloc for hook allocation
Date: Tue, 27 Feb 2024 14:27:16 +0100
Message-ID: <20240227131616.183715203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 195e5f88c2e48330ba5483e0bad2de3b3fad484f ]

KMSAN reports unitialized variable when registering the hook,
   reg->hook_ops_type == NF_HOOK_OP_BPF)
        ~~~~~~~~~~~ undefined

This is a small structure, just use kzalloc to make sure this
won't happen again when new fields get added to nf_hook_ops.

Fixes: 7b4b2fa37587 ("netfilter: annotate nf_tables base hook ops")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a29313e0aaa4d..e21ec3ad80939 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2059,7 +2059,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	struct nft_hook *hook;
 	int err;
 
-	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
+	hook = kzalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
 	if (!hook) {
 		err = -ENOMEM;
 		goto err_hook_alloc;
-- 
2.43.0



