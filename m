Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BA33AFCE3;
	Sat, 30 May 2026 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164494; cv=none; b=PZop8oszpLd/y8VKWCenM/D+im4d2u3FfrHa3QWpWpqxrWMQBYEKpwSolb68yCnOwh5vEVvObB0mKjTmZUh+dQEwXmIc2AWw1iztwssabbihu14QL8cKlGWkW3ejzk64fdpOFHyrYkIWXi9Ud2sHRHUgASLFmbAD5jaaMzj6Das=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164494; c=relaxed/simple;
	bh=yDanUJyU1ngofApfu+0DQuDxO1SShozO1bTMk1/euak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWurllEOLzhbvN4ftaZ//F9Apq509BfQc/PzmueNUtLjxu1xfiSXkhxhGmOekHseecr1+LyW+Hd1RRO2DRy3xGy7r21ulF6hrjUVZ10yquPLkG9o62Tr8c18fDNh7eHn0diApKvz4Hh3h58SkHTK4lBj7ApmZEesW/dlzerlA8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIKvc9jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIKvc9jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0361F00893;
	Sat, 30 May 2026 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164493;
	bh=xEol1fP9iu1uIM/6zfg39RQsdX0FHPmAsw1cqG+fSIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIKvc9jc15efCwHdJIToXfQiBirkPGvf0vCoR67tfLOZudUuuiRj3qIwBuc/02+7O
	 F//J5DWlTyWScnqOy/3BvUtQWNxS/h0Ay+1g3YLyzu9ySvCpSsE/qXdTkwMqw9IIzd
	 oFsLkLAqr+a4ii64Wqa4Emz4wghaKFrFP7tFKVpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 572/776] netfilter: nft_osf: restrict it to ipv4
Date: Sat, 30 May 2026 18:04:46 +0200
Message-ID: <20260530160254.889166400@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

[ Upstream commit b336fdbb7103fb1484e1dcb6741151d4b5a41e35 ]

This expression only supports for ipv4, restrict it.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_osf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index c9c124200a4db..8ee6a97fc7eeb 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,6 +28,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
+	if (nft_pf(pkt) != NFPROTO_IPV4) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	if (pkt->tprot != IPPROTO_TCP) {
 		regs->verdict.code = NFT_BREAK;
 		return;
@@ -119,7 +124,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 
 	switch (ctx->family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6:
 	case NFPROTO_INET:
 		hooks = (1 << NF_INET_LOCAL_IN) |
 			(1 << NF_INET_PRE_ROUTING) |
-- 
2.53.0



