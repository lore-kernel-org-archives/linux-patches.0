Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D021D3EBF35;
	Wed, 20 May 2026 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296473; cv=none; b=Y+nCMRyLtftmD2rY7sE8YZcuMDz+jFKEPye/mQm/DUHPO7ENfwrkhHuZjBaSVz4+LUeTae7L70E8aZjc38Q3OTzLsry/daAJnNBwRffe/DDl7gMcMnA1M/e1haThICHEFzlA8G2I4mnOqRcwemr57JU4zzUXrGsOVlStRmJngAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296473; c=relaxed/simple;
	bh=FSWk2sBvcfItKPVvd8l8XLOKVPOVXrtbyNHmbU/5Q5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQr3Gca0Fxm57u44N6FlnTSim3hb9/pV/ZZLqdLsJ90tKOXJ6wGTPQqWqjeCPuS5i0M62r7zfruOWXrz6Uan5XHxm36beQZk6ZIrzmS1KUW2b/jKFOqVCV0ZVq6uyV/PVVZu4Uvpyaoi20vv39a0R44v+wzZ0bYkQ7vO8nnrfMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYZQ5SWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYZQ5SWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4227B1F000E9;
	Wed, 20 May 2026 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296471;
	bh=N/NWkYxGRf9N4Gzbj+UltbBMzEA2klVhxJkLFXO+7J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYZQ5SWXPXRs0B0ZHvqJ19uAfUU3Vzl3LfVb6/XrgeWgVHc7DoYHA5NFOOHgB4tGN
	 wV1uHI9/a7wCDxnSlewAQaz+MYe6z1IV8L/rsj5nnoINdxJ8qgbExBMMQr5VRMJP19
	 GSKhp19sQIKvP0Z4+h49aUYSSTb8cBBz6i7vbDBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0811/1146] netfilter: nft_osf: restrict it to ipv4
Date: Wed, 20 May 2026 18:17:41 +0200
Message-ID: <20260520162206.579939921@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 1c0b493ef0a99..bdc2f6c90e2f7 100644
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
@@ -114,7 +119,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 
 	switch (ctx->family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6:
 	case NFPROTO_INET:
 		hooks = (1 << NF_INET_LOCAL_IN) |
 			(1 << NF_INET_PRE_ROUTING) |
-- 
2.53.0



