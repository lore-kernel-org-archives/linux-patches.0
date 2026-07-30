Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8274372691;
	Thu, 30 Jul 2026 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425939; cv=none; b=mId3QBSOD9/ZF7TChmMzOVblBFgL7L66tG1KiF5Cy5OM3ypAM+t0BsNPiRGg0EkH7/AZ49p0hAMgm2NfNwmuRQ1uAOWVxrrTtnz+3sPDsmAi4xr27xChWkP3GUURJnQRJJS3u+E9LBnej4RvCBhSMU53rl0RrgAk+P5RcUlqgSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425939; c=relaxed/simple;
	bh=gYgUZecY9F8HhB7Zg8+gIg8WpWiMKd19rf/r0MhKVzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joxn87PbMDn89/j726CA8NvlkD5E3cctkMZNheKk2/LBrWAe7w/Rd2OcneXa7XvqFpiq7CP5JbRpIzKNLuZ4WLz6nxYZSe3tGrj/oBegDV8fiSNK9A3UHxQcocoYq0lWdwLqKWLexFsX3nfq6oFj1223yi/SLaAmcvaj7BodZDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlej5F7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlej5F7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5BD1F000E9;
	Thu, 30 Jul 2026 15:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425937;
	bh=RpEePTPaD+cOjETSx7NhTm9dUHAyJJT4Vhs1popSf1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlej5F7Mk0TW+DtpI7FItEoxz2lRmBKsrjNjqC4h8ZeY1PqVnf7g41H2ecZqq12pO
	 vbG6SmkKatOWTU5IskJZ85HQjnuSuYZwZhl77FJnYDNJmd1ubRaln4quwwekL6bLxv
	 arV2U8HGeCmC0y/xhLEeui1S+qo3kZxqXr2t4szk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/602] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Thu, 30 Jul 2026 16:10:37 +0200
Message-ID: <20260730141441.121767841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index d148f1b03c5d09..deaaae63bda0ab 100644
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



