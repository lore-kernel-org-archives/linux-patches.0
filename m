Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DB63DA7DD;
	Wed, 30 Sep 2026 19:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796050; cv=none; b=CO+QVhEJnGkhzoGGrdtzgIgWak6X0s0VIh+IWVN5GKC5nNcVTojO4TYxtnDGW/pNFFMshmjWzyT/zAbKJqs82sy/+w0iS+2jYPfl+bjlUFT7o3psmAmMdKiM3rdK8GlwpuuBzQXbaOHJxPLRf8LcBk4keL9VTyxZevvW6Y1C0Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796050; c=relaxed/simple;
	bh=xwdqKR9a5HWvUIYTsMLZbpB5WmsGjF5PT5Ss3n/p3wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q91x74ICAHXDf+YhRYXMIkr1M22Omr3b5AmQ5StfIZ213vDSKCgvwFzJ25gA993evgCSDR2ReU7P/xcClJmtJWfJ9SPCpAyida8/oMG3wjADwTdwAY5NJd9lkUbKYYRqcc1LxjxZXA0Ypgru5EYvqh4Ja5QP1xEwEInIjYeeK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rwuapLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rwuapLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FFA1F000FF;
	Wed, 30 Sep 2026 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796049;
	bh=YgGbuGIVTr2FjHHDEpAvP57cspZbTkBaQXCbje0Z5AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rwuapLx+huPlzdsRfiMbZeMJFlP7MMGvSls9vlpP6wjeOHnsv/Wdrn25atiG4A9h
	 IaUbOTNr4gO2KstHXAGvpDg1+y57UdnsQMO04yYzYEJ0UInSour6DbO1hld+QAdd1X
	 cKUZ1HJjAEnZb1v7Sucn+pBS/Rrtpc09g3eI0zrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0776/1193] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Wed, 30 Sep 2026 17:24:20 +0200
Message-ID: <20260930152451.494281465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

[ Upstream commit d313499df66159b4b7971d760d16729598ab7e5a ]

nft_nat_setup_netmap() builds the mapped address in an on-stack
union nf_inet_addr. For an IPv4 mapping it writes only the 4-byte .ip
member and the loop runs a single 32-bit iteration, but it then copies
the whole 16-byte union into range->min_addr and range->max_addr, so the
upper 12 bytes reach nf_nat_setup_info() uninitialised.

KMSAN reports an uninit-value in nf_nat_setup_info() reached from
nft_nat_eval(). The IPv6 path fills all 16 bytes and is not affected.

Zero-initialise new_addr.

Fixes: 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e32cd9fbc7c2e..cdbd800cac969 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -64,8 +64,8 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 				 const struct nft_pktinfo *pkt,
 				 const struct nft_nat *priv)
 {
+	union nf_inet_addr new_addr = {};
 	struct sk_buff *skb = pkt->skb;
-	union nf_inet_addr new_addr;
 	__be32 netmask;
 	int i, len = 0;
 
-- 
2.53.0



