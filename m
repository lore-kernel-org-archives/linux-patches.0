Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A9119CCF8;
	Thu,  6 Jun 2024 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683074; cv=none; b=bMFZtN+4WhgMvAqbpBLneaBkIJyhmrUuLCegf+cW+D+hM7Alm4i/mArza25pUwq9qxy6aPNX05izc1WGcFnm8bvaoD2eb/8hFzLEkdxav65RwK97t/TFIZnZe0Fq2/tZexeJsLj29WmaUC4NdL/DqNZZXoCcsD2LySA2J8OZL8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683074; c=relaxed/simple;
	bh=n8KmhSGMDuRiOAeCPoISsGXQJf8MSOY/n42CTWACYvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoneuVAgxP6npQA/CgBKPf73xvoKIatkcOlFNolYnVplCGkZjYOioKHxLGo4ZDDo/kAWsnFanYFtnydp80MbMhzOpxZpklg4fTlvaWy9Z4TowZIfsJaj0H9OHia7dS1+Qaq1KulBwadVbWU4sduAents60OJDjIRtyG/07slbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLL4i0qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLL4i0qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F54BC32786;
	Thu,  6 Jun 2024 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683073;
	bh=n8KmhSGMDuRiOAeCPoISsGXQJf8MSOY/n42CTWACYvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLL4i0qs9qy9vkMBOLNnRYunSAx70/WxRhd6v90R1Lu4FX4AmmYoG0XHvNVn5of3j
	 8Ec/LKbZmw/r2nJ+S6XUG3tpFQn9ALoZ5G0q9Hr+b+CJZwlxJfEEZSUOYrYHkS7k+e
	 h+HDlrrg4W06ifzo7FK1n+K5ipK2/jn2r56PMgKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 337/374] netfilter: nft_fib: allow from forward/input without iif selector
Date: Thu,  6 Jun 2024 16:05:16 +0200
Message-ID: <20240606131703.141377654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Garver <eric@garver.life>

[ Upstream commit e8ded22ef0f4831279c363c264cd41cd9d59ca9e ]

This removes the restriction of needing iif selector in the
forward/input hooks for fib lookups when requested result is
oif/oifname.

Removing this restriction allows "loose" lookups from the forward hooks.

Fixes: be8be04e5ddb ("netfilter: nft_fib: reverse path filter for policy-based routing on iif")
Signed-off-by: Eric Garver <eric@garver.life>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_fib.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 37cfe6dd712d8..b58f62195ff3e 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
-		hooks = (1 << NF_INET_PRE_ROUTING);
-		if (priv->flags & NFTA_FIB_F_IIF) {
-			hooks |= (1 << NF_INET_LOCAL_IN) |
-				 (1 << NF_INET_FORWARD);
-		}
+		hooks = (1 << NF_INET_PRE_ROUTING) |
+			(1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_FORWARD);
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
 		if (priv->flags & NFTA_FIB_F_IIF)
-- 
2.43.0



