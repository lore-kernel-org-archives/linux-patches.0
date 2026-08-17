Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020F52D5A01;
	Mon, 17 Aug 2026 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975669; cv=none; b=ovFHsMdnwGlkpE47NFSCsmhBFj37i7HRIpY3uEqJ8AJJAcrh9l7gwnzQpYiFYhGkB9shk4qRnAYnKOoN7EcCMCTn6VmKylXdvQS7ed6SAhj4NnCL1VY3aAplL1+1Ft68Id+OpFvwEWvgAu7cnDCAp53Ut9TbLlyZnra9VNJnwNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975669; c=relaxed/simple;
	bh=p2BuA7Q3jB30AAT0bpuQf5NiIuWwZE1GHyrKtdqxEZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nf7tnycdiQablCDilF9JK4XyP2TgqmjCDw5+xkyfdPnvFxmJqBnNixy43IvMYN4F5m4B6O4SZ8eT5IePjxlH365vxFB3YFxFEG5wPQabYS/UjiHJ4dB4Uahh9j2IwWBipGRAbfaN+7qwDLeoNJLxLPL4kZQKmWKZ0vppm/eQy2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV40oszn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV40oszn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289F11F000E9;
	Mon, 17 Aug 2026 14:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975667;
	bh=KtSGKQvI9EqEw+oh1zDiTbOOwuFOgJKwAAwMFG9UMGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZV40osznH3MURf26EvE6LjOc/nqqI1u6m3eg1vgpCo6A7ys/9pLHatX7WripUKikG
	 wzv7Exdi2NV3XpzZgk91hirr/gPleqrnR9ySIA1dM1kVKTPNBSWWLYxucO3X5e4EMl
	 TtoP4jDAWfzq2B0bQRoTo/aWb8f4PJovvjFMIuRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/389] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Mon, 17 Aug 2026 15:29:04 +0200
Message-ID: <20260817132543.268742384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 16ff46c4f300e1..719e1932363e90 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -351,7 +351,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		daddr = &ip6h->daddr;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
-				  inet6_iif(skb), inet6_iif(skb)))
+				  inet6_iif(skb), inet6_sdif(skb)))
 			continue;
 		rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 	}
-- 
2.53.0



