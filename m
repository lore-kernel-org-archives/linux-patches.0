Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899A92E92BA;
	Thu, 28 May 2026 20:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000530; cv=none; b=RZllsBI/aIaNhasQ/xEY21cn+M8237ZsHrescKyUfOoxWc06f3ptIUI+iWz6zSAMYLGFioPcQKkVP8vFBLxPbUCsL9Q1HTz9QlxE2J1rFoH0gFQxCzLTOcYrShopT3D9L2jeHdmJt5PBw49lqjzmQ1Zcba71LJCB5eBlq2i0CIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000530; c=relaxed/simple;
	bh=BC+TUa8BdMvceaocy+Y0/Xh5+t9d7g8GK4TGb9+DOKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6/kb5iDAAw2mqePdjETrUmwiy+cc4IskSCdV1teL2CJ2EUjYvINZKeYRJ2p3jKFB49jrrDRpMMGpWHKvwLg82BWSb40ogX9y82gB2bR1TfNOXZMR7PWJUB+D1L6zlSaGpYAUhwaWIuS2yZlOjyEl1gpCGyE6BsPz7Jv8A1DYvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2uDD0hm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2uDD0hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12D51F000E9;
	Thu, 28 May 2026 20:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000529;
	bh=1y3MqMDtsLVrV/Vi7zISgcun5tceEnGsQOBaahJNkUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2uDD0hmHNclDjG9S4DEazhgr5J5go+2VelJ6qorMUYgF0/a7v4nz+5IRSxW0c1iM
	 agFu83e5nrgaptPNG9bIxztbmrgCg3LWcLppZJG7L+5vZB1H9jrxleWl7V0g1m5E3r
	 PJ994xMXgYNU+pjmphpsR3fvs4zjc168rslv0OyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 076/272] netfilter: nft_inner: Fix IPv6 inner_thoff desync
Date: Thu, 28 May 2026 21:47:30 +0200
Message-ID: <20260528194631.503309543@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit b6a91f68ebfed9c38e0e9150f58a9b85da07181c upstream.

In nft_inner_parse_l2l3(), when processing inner IPv6 packets,
ipv6_find_hdr() correctly computes the transport header offset
traversing all extension headers, but the result is immediately
overwritten with nhoff + sizeof(_ip6h) (40 bytes), which only
accounts for the IPv6 base header. This creates a desync between
inner_thoff (wrong — points to extension header start) and l4proto
(correct — e.g., IPPROTO_TCP), enabling transport header forgery
and potential firewall bypass. This issue affects stable versions
from Linux 6.2.

For comparison, the normal (non-inner) IPv6 path correctly
preserves ipv6_find_hdr()'s result. Removing the incorrect overwrite
ensures that ipv6_find_hdr()'s calculated transport header offset is
preserved, thereby fixing the desynchronization.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:5.1 Z.ai
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_inner.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -156,7 +156,6 @@ static int nft_inner_parse_l2l3(const st
 			return -1;
 
 		if (fragoff == 0) {
-			thoff = nhoff + sizeof(_ip6h);
 			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 			ctx->inner_thoff = thoff;
 			ctx->l4proto = l4proto;


