Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F929BD87;
	Mon, 13 Apr 2026 16:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098184; cv=none; b=H1WFIGBr2EUQ377wlfDgFK8yrzY34QuG6q6rohyNF/M6+BN2P5XgeP+JpgqzhY7NTzs1Qhc3tAuOA3H88qyIxBHHpYwzyJ3lpY1axX8tNT5ongbT0SJ+daaxvRKYO6czZP1Baoo2cSQKqtNtFRZvv/V846usvLxbSdAI/TKgObg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098184; c=relaxed/simple;
	bh=UkC3Q6YY3lIgGy5cPLik3YR5iaKl7lYdJSQrJ5rvRUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+FlQjydhKacqOO+EWUdZxJxc78te6dO3MJkxYxl3EWsBY9DdHb9fFEpzSTEBVebbEgDaPbMKKRfTBZMSixkfV7R721JGvWM8ow7cqyW20LvBoWBS1xe+UBrg2cOTyr6h7dk5TO+ppJXWdLfxmRKYwsgCTCw+8nFuDaVpFYrIa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w24iMlaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w24iMlaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1390EC2BCAF;
	Mon, 13 Apr 2026 16:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098184;
	bh=UkC3Q6YY3lIgGy5cPLik3YR5iaKl7lYdJSQrJ5rvRUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w24iMlaW+9ZkIQjTY7t7pMiLmkEc+Vv6FJkb7yw2S/Dg+/ITTLJlhzdDAU7TvE1OM
	 TbgaZC11R5yleWnUnoh5iAzcgp/htl8mKWfQ1/Oo89uzhVmZppTePR8nBrUGgZOz1/
	 qyAJHZdOiH+Jp2JeLfiHwy7k/tyHjqP0eHNgEAwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/570] netfilter: nf_tables: reject immediate NF_QUEUE verdict
Date: Mon, 13 Apr 2026 17:59:17 +0200
Message-ID: <20260413155846.429179243@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3c845d6a340fb..53d7dd39a95bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10232,8 +10232,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	switch (data->verdict.code) {
 	case NF_ACCEPT:
 	case NF_DROP:
-	case NF_QUEUE:
-		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -10268,6 +10266,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
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



