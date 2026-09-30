Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46136A37E;
	Wed, 30 Sep 2026 17:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788329; cv=none; b=Iqvj+BC/ZMnSl8yO4FUCDItYHw4HhMywVBv3xEGLYE7t7X+xKPWRzA/YTtuNbSXfyu5MfPIH3SlbsDK/1NR/ZkA5nugKVJ0kHv1zLN2f1b6x8sOZtdykvk9Gmg/9tS6FR8q0x41U1U+N0MzfHAAwp72U0b0sjgdQlQ6iN37F+DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788329; c=relaxed/simple;
	bh=xzQZWgBnHNRplQ1CNVa+Mv1mc6J+j8iE7qillQWNPJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3b1i98aOFLZka/888md+Wb5HAZDp253gCy+UZrcQ1+Lm7B1Vo8osJHct7/sHgbAGkqVxU4gPRtgTG7ivRpGD8qD5WEIoJ3qezUszq31zGIiXrFXdM9kYMhPE3X6JQqPNTPlJd/40omfz1rwWXFP7YruotmChILq9ZoxFKUyftY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILuaXrXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILuaXrXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD891F000FF;
	Wed, 30 Sep 2026 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788328;
	bh=qnb4k5wz7tDVxqQnB9Ju+KNUTaO69/+RdR8vohJRgHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILuaXrXGhH1pz7Hbd3oJdWXIQ/rRHzTh92Zb5qMstG8r5okNpk2N4Vyc2zRzNbNE2
	 auTAVj7AaRbLG6ScWEZfMaqpxwBym+SUmYhhcUMyn+2keq/4vJBDLmMtJtlufegXo/
	 RmE8U6UcGI29Eucg7Qyikl1BVShxkyEjreMsWW88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/877] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Wed, 30 Sep 2026 17:16:37 +0200
Message-ID: <20260930152416.595771882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



