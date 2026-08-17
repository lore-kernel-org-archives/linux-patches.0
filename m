Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1803AFD16;
	Mon, 17 Aug 2026 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976872; cv=none; b=eObOd6P1WMrWa7LsQ9yBGiFmRvV4v5+83Vf2jt2zB/dJg1DDz7AMLTYyVKP+6XSpq0Pe8DX+RpPcUQ/9I65TRrvf1rnpBxPmr0Z9DMajnt1r3EPtK7m0frvyh8UWrsMBC++3AyEagG4byHr/PMbEVLt2FgNjebBhlY0fJS35Ui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976872; c=relaxed/simple;
	bh=Mq3YiqTr15wqLJjB22+VBiLet6Warjhjq++c47Qk1NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH7euYtGp/YgbfnSE8XTWtuzGZc0DColGwNOuNeFXjxxmKHl4mqwf4gG/X8EHuFfF5EUPQTuc8/cry+XOcDueg1GLf1ebyeoG9I2K4CHlFm397sFRMuzC5VbU5h/e15rLlb4L3FjXPBseRmQCd7dvUoARzhzQ8ojKAMao/ZrCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk8DWa23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk8DWa23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECBF1F000E9;
	Mon, 17 Aug 2026 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976871;
	bh=JLj9HMbA9gwO0PgXtvyHdDLWsL1bR2B9dgb27/6tFO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk8DWa231ZhqEzhtyrF8RFBaF017x2C0XinC6JfNTpxyYpJSCj4qfAa1gXK1r4d55
	 7nSbsKO25D5OYjZRZocF3Dtm43Kxpfb4/0SjtRy8AMdlmZLNk+m2wv5h6gEDJDVykc
	 RYGVYSV2vzBi+phC6d2fZ6a8m0+v8x24A5do/rbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/456] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Mon, 17 Aug 2026 15:28:42 +0200
Message-ID: <20260817132545.268430192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7e816853cd1cd4..f6b7a637df053c 100644
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



