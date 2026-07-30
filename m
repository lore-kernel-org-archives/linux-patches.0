Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305237A85D;
	Thu, 30 Jul 2026 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424200; cv=none; b=cx7WTEEl+vC40te97VdzBEIbaXCIklhR0u4FoFFH6yhK7eK5moiXwvvoOLi79m2fVLkE6kGPClTtT86WaWhWcjDs640pu0269CCsF2JzpEMD2CHr4d9V8YoZ5X+l+tshoIahZGHSU0oJyq1W+pqjZeQnDOZkUUuy/TO8Hn7Q4Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424200; c=relaxed/simple;
	bh=54vEZ+UbTJ/8l6+wKQAzjk3MqiShYdAgWFIqHHBA/30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbYVK+Z0JyKyg3iNwvaBLafvejBKreExwVcGoIqwLVIeRTuunZYlAqlELIJBOZ7iwM7vnPEZbDUBLJiJ5J3MDirXQjU9hLq8CK9ba4/WqDHV/ED+PQawrQ7AW51LBMFohcEnDRF78yk0tULC345KgYHwf6ysguMzH3HrKBoSa6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oH+mkxCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oH+mkxCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B21F000E9;
	Thu, 30 Jul 2026 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424199;
	bh=3Ylcq6eMKWjiZ1Ea+Ve6bJLDQ8BU1/wxLODwphzqcgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oH+mkxClXCArelf4F3oEhbEcbc0GFLdpxC5puc8i7B1UaxKLIFmBd1SpB+39GBxIm
	 lNNYbsccn+tXFJop0Kq6Wtf8W/1D576AKxyiVtHi/RbQ1D6Uusn6ctoG7sZEmC7Ylo
	 sx4aY0JFOyRRzRvmY+socjn1eCYw8xXKd6RSXry0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/675] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Thu, 30 Jul 2026 16:10:38 +0200
Message-ID: <20260730141451.671003635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 440e274da4d1b93c7df2cb0ce893c3009dd4db55 ]

In raw6_icmp_error(), raw_v6_match() is called with inet6_iif(skb) passed
to both the 'dif' and 'sdif' arguments. This is a copy-paste or typo error,
as the last argument should represent the secondary interface index (sdif).

This mismatch breaks ICMPv6 error handling for IPv6 raw sockets in VRF
(Virtual Routing and Forwarding) environments. When a raw socket is bound
to a VRF master device, raw_v6_match() fails to find a match because it is
not given the correct sdif value, causing the socket to miss relevant
ICMPv6 error notifications.

Fix this by properly passing inet6_sdif(skb) as the last argument to
raw_v6_match().

Fixes: 5108ab4bf446fa ("net: ipv6: add second dif to raw socket lookups")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260717143230.1836-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index c534848933ee64..6cb8e32a3061f2 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -348,7 +348,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
-				  inet6_iif(skb), inet6_iif(skb)))
+				  inet6_iif(skb), inet6_sdif(skb)))
 			continue;
 		rawv6_err(sk, skb, type, code, inner_offset, info);
 	}
-- 
2.53.0



