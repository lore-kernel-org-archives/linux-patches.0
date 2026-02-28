Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A45392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301095; cv=none; b=MDp7NgJk9IkV8nLYTpMuDgg3sYrPx1ws7dmYZDmyuPWvgMtyG+wzy118h+yWIsJWlNjSkU7R63oZxhCFv1CURmgtlYf7pPY/t2BT3q0LzrFySoUEfM9KNmkY+4QyDX8mrlS4WJgG0QHjCK7/cZD8bv7fojCEwoBniBf0oy7ApBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301095; c=relaxed/simple;
	bh=W15cyp0xaAgC3j6Km803kuRKxO/r6w2fW0XBj3f2/Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx2u88qitmBu6ZFWVFodkodhOiIuD+XD6SPk3CQnpIi0RQFGRpHskvZ9rKtRFL1o4HyI17qHlhdeSbCg2GW1pOcZXpcR5sKpZn072HReN86FXtnT7/OvXFIScWSAU+iauu9F8niew7Fh4CdDZ8KOKJRpXthchsRxB67hwdZVDbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGde6ZBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGde6ZBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91531C116D0;
	Sat, 28 Feb 2026 17:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301095;
	bh=W15cyp0xaAgC3j6Km803kuRKxO/r6w2fW0XBj3f2/Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGde6ZBK1NdLgWGtDWDIIYuM8V7KEqhaF1eYvkRYYidwwjch0foFW+CjRu9sbyCoq
	 ry2NJLusx/amXlbZeUSIfQ+wO90tmYlm3qlchtN2htoVU4/DDGZwYnLo5jhDy6M1vB
	 NL1ZeM57msGvmSxzplz3vqT7/5FlmVwD8UoGJn4BpQLzl28/bhQsdlknwnf06rsZ/K
	 ERPO88oGQgGg5DPvwLEPv3YiTWmRSPLeHp6X3s8BzEIkM6K+V1OZc2I9zjCcckbfdm
	 JKa8LbJrGuuLXswCBZJbcsZw0g5AtQv0y/3sI3QHCdsz6aybf6QDR6Gn8Bd5YASrjE
	 K6ayRCSReMEVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 246/752] ipv6: exthdrs: annotate data-race over multiple sysctl
Date: Sat, 28 Feb 2026 12:39:17 -0500
Message-ID: <20260228174750.1542406-246-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 978b67d28358b0b4eacfa94453d1ad4e09b123ad ]

Following four sysctls can change under us, add missing READ_ONCE().

- ipv6.sysctl.max_dst_opts_len
- ipv6.sysctl.max_dst_opts_cnt
- ipv6.sysctl.max_hbh_opts_len
- ipv6.sysctl.max_hbh_opts_cnt

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a23eb8734e151..54088fa0c09d0 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -314,7 +314,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_dst_opts_len)
+	if (extlen > READ_ONCE(net->ipv6.sysctl.max_dst_opts_len))
 		goto fail_and_free;
 
 	opt->lastopt = opt->dst1 = skb_network_header_len(skb);
@@ -322,7 +322,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ip6_parse_tlv(false, skb, net->ipv6.sysctl.max_dst_opts_cnt)) {
+	if (ip6_parse_tlv(false, skb,
+			  READ_ONCE(net->ipv6.sysctl.max_dst_opts_cnt))) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -1049,11 +1050,12 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_hbh_opts_len)
+	if (extlen > READ_ONCE(net->ipv6.sysctl.max_hbh_opts_len))
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ip6_parse_tlv(true, skb, net->ipv6.sysctl.max_hbh_opts_cnt)) {
+	if (ip6_parse_tlv(true, skb,
+			  READ_ONCE(net->ipv6.sysctl.max_hbh_opts_cnt))) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.51.0

