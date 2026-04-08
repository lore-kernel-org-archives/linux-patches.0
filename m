Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE733D9041;
	Wed,  8 Apr 2026 18:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674430; cv=none; b=lvEinvVUNo/KVAc6V/exwwP8SiIWPcRcosoZ18jbz7AuzgIHkgjtwqLl8SiprDqLKEH8b1zUQcNgSL04w2Zj8rn7iYRFEeBuST8o2i3thLaO7VhxRrcwuARCS0LNcp0HPqEGwyWUeEhzKXkyz480kjckL65BypRuE6zYkxctPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674430; c=relaxed/simple;
	bh=q6ZEkMyzwMeh5jan9I3KzzXvpOtTSVh5MbY6muRloLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOqp9vzas7GOp2Ey/mLz6RrJHuIQALV6dJwJrIkPJHx006PELg+x1yPRQ8C6NL5h+/MUgIVL80yxZ4LoguULngCHCz3DKFPSeFzrD2u1h/0+puLQxEJkbSU5O+b5heJc/s6n79c+0RYHoGup9/PwTnmE5a0hgkt19ZWBqhifixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkg7C9eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkg7C9eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459C9C19421;
	Wed,  8 Apr 2026 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674430;
	bh=q6ZEkMyzwMeh5jan9I3KzzXvpOtTSVh5MbY6muRloLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkg7C9eonEtfb1PXHMdBA1qSAlTZmHf7m24Fcl70e/w8F7rk0BiiATK8vhJdP1joR
	 v5qrrAC1NJ2ka/ZiVq4oeBFoEP623EgzvRlzS/BrjnlGYT2h3H/7My7UhP3n3nulYj
	 Q6O3uuz0rsN546iA3X0fDqgDVhDvE9sk3UzvcM0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 094/311] netfilter: nf_tables: reject immediate NF_QUEUE verdict
Date: Wed,  8 Apr 2026 20:01:34 +0200
Message-ID: <20260408175942.924858648@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index fdbb1e20499bd..0349787e18465 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11667,8 +11667,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	switch (data->verdict.code) {
 	case NF_ACCEPT:
 	case NF_DROP:
-	case NF_QUEUE:
-		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -11703,6 +11701,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
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



