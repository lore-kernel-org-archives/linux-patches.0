Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D901A683C;
	Wed,  8 Apr 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672064; cv=none; b=O1rKDfiDTKcIeyuuXmpBC9VmV0fWM9YQZSZQf47smgn/3uqGJT7LSmFUp9kR+Gi7FTVfpWK5nJqSxZgnuBqR9r1CPkZYIxBWX8xzfQDh0gsotuj1T87e9+ESEF3Tc/czjXlnmAt186DaxkO4BUpJFxzTvRpifAaHxXxF2z6sEcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672064; c=relaxed/simple;
	bh=PvBiAAhgtGGrlggUch930ItZG0ngalsYDTDmPUJJfgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnWdXViXdsiwEFgj+bSCkd9sxY3Pclgkx6bC+X4M5M0EP/r/N8BmZRvYdnzy+92Flv3snL+obYGLba5nO0bxllgiji/HxHc5YIsPSJUpKoPc1JCByEiFsvLlGM9RcOVzaPkaoLpqMYjVpj4ZUtVsJ6tGypTj4pfZttq7bwlWfm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtyDSx02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtyDSx02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282A2C19421;
	Wed,  8 Apr 2026 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672064;
	bh=PvBiAAhgtGGrlggUch930ItZG0ngalsYDTDmPUJJfgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtyDSx02ytoRJNs7unrWABs8UrUwsRo8rJkiWd/cB1NzJZctceGIwAM48JtEt8T3U
	 fiiJtJ+Z4u9mHUXgiT+YdhvwA58nfJfAy+qxPU+ARzSxdG1CwE8okeuG+xcg112sGC
	 MNIve4HONG/i7Lg3BhZRYDrCF8ApMPlzR8AwGzU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/312] netfilter: nf_tables: reject immediate NF_QUEUE verdict
Date: Wed,  8 Apr 2026 20:01:32 +0200
Message-ID: <20260408175940.300425350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit da107398cbd4bbdb6bffecb2ce86d5c9384f4cec ]

nft_queue is always used from userspace nftables to deliver the NF_QUEUE
verdict. Immediately emitting an NF_QUEUE verdict is never used by the
userspace nft tools, so reject immediate NF_QUEUE verdicts.

The arp family does not provide queue support, but such an immediate
verdict is still reachable. Globally reject NF_QUEUE immediate verdicts
to address this issue.

Fixes: f342de4e2f33 ("netfilter: nf_tables: reject QUEUE/DROP verdict parameters")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7a862290f1b24..fb3d529ebf5ab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10468,8 +10468,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	switch (data->verdict.code) {
 	case NF_ACCEPT:
 	case NF_DROP:
-	case NF_QUEUE:
-		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -10504,6 +10502,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 		data->verdict.chain = chain;
 		break;
+	case NF_QUEUE:
+		/* The nft_queue expression is used for this purpose, an
+		 * immediate NF_QUEUE verdict should not ever be seen here.
+		 */
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
-- 
2.53.0



