Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA088282F29;
	Mon, 17 Aug 2026 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979264; cv=none; b=c+ILqW4B0cdKYZ71ItEyi7NE6V17xR5FA5d6qzq4b45Nkn3nvmm78yJ2DS8c585sXoBy0nO0MSP7XV8zp0mAus9Y2ql0cskB+F8CzwxlaBpbZMrnRdUVNH/dADph0Bu2b5Kn13swfEdFs/lVlzscWxzAkNJUTgDygLXBuzoIevE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979264; c=relaxed/simple;
	bh=FuwG4nC+rDTlwcyyOqKVBs6iA5qhDeCY6e1YXU+bq3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1lqWIYBGqYbKymRCcyChoTRgzynlUhB3kNEwSEREsY+ovaBSoSmn+rQN9tmwzkl3IV8fgb/xWJp4SsFlinmamQxEnqjLNVGaXigqCfypa7S8nF8sIiJlMUZDOCIF+g60OkSUS79fXt9bYSxcJiogjKxCIXPmUaYt/YpMIHH+e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtx7pa5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtx7pa5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8C81F000E9;
	Mon, 17 Aug 2026 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979263;
	bh=VmpjpdHYqzmeamFPwXhUDSv/Sa8KIATcDu9uberpeqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtx7pa5vtWpajKr9EvVN0yz+GsuK9r8FgPwGh/pz6CEuBFbZL1GdHCOgqIC6B6ff6
	 xh68pvyEWY2HTKivJvX/tUST5IwssHdr+3T+nw/acjycF2st5ADOhjOvSH24MFGEWr
	 rvD1lvbojSuOJ2dHACk7zyyvbq9tm1cxXvgVZ5f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/609] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Mon, 17 Aug 2026 15:27:42 +0200
Message-ID: <20260817132549.575235144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c644300680ba67..f6f18196ed6e4a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -342,7 +342,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
-				  inet6_iif(skb), inet6_iif(skb)))
+				  inet6_iif(skb), inet6_sdif(skb)))
 			continue;
 		rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 	}
-- 
2.53.0



