Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5048344E648;
	Thu, 30 Jul 2026 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427529; cv=none; b=Pk6jnrJog8oqPDIKTmlBJ8ZuJj3SDBhYVUpsCXn2RmeIEGB5cBltGAnqKi6rSq0bSoWSlwVYvDPf3Hday96gJ6P4vgQ/UlHDfsLkR/mJynM08slJEth0sheRGkVzE4BwhId9iduiIXTO3vWPF6OwjSyId58wMUGNyuErNY7OwFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427529; c=relaxed/simple;
	bh=07I56vxr1t0lOCu9dd7DCGYhSfurzYDTdL444Mye730=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nc1IaC+BFtkenSKXb78XOpvgmyZNwo1L3gs+lXOq0I3AWiKzTsuk1R4miJ/v8ILu6QoqUvY13EszosMCGHJ2hGHGhJ4f7e17O9j3Cwn/BxwiKpY7ETFSvVw9E9un1KDP7KmL/rfY4J+SPSXCrlzze0NfiEhBSM+5w5NtaIa37kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBYu18s2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBYu18s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DF01F000E9;
	Thu, 30 Jul 2026 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427528;
	bh=Qzi13fBPTdpJTGlyAvXR+IL8l/47T7ojoOlFqnqOs3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBYu18s2DwQRWduUQJoWVCCDcIPbKHnM1Vnql8eaxkCIB+mMbBHKTv0uO75+W1tUF
	 3RdeUtz2a5iGqEqyvaNFMfQqUE8tnfFW+a0/Hj2XuqM3RDk3emDSY0bWmoxg9Ty64q
	 Sfnirt2ZGRmVmCZ/d68olDeR5ELY+x6KR0x0UjsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/484] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Thu, 30 Jul 2026 16:11:39 +0200
Message-ID: <20260730141427.855621029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 7d72633ea01982..95d7dd7a4d0483 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -341,7 +341,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
-				  inet6_iif(skb), inet6_iif(skb)))
+				  inet6_iif(skb), inet6_sdif(skb)))
 			continue;
 		rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 	}
-- 
2.53.0



