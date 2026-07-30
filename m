Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CE43D75C4;
	Thu, 30 Jul 2026 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422146; cv=none; b=uFLen5moUgzr3+6JkHz45INiq+swH38O7sOew52pmtny1VOARpHNXtXADzyHRA4PerQP5IXXL08CqgyyBpgcZhpE5FqnFhyYL2sIoTMRQ8OSa6Jg+sqqFPmIkUNr52/nq1HpslK3rP5yBiw6vE0RpaYwTbUZbJEXUNCIeYtnV5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422146; c=relaxed/simple;
	bh=p7Mp1pepc/d91MuTzJX7N+4Pvh8EjylYYTQHYq36MW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkGqZxPmPVcB2U/9Zu8raJje/eGBMYtOaYOSC6KGj7jyRvKfczSbT+j8jFu3gyAu30H3F+I7tjRCmjk09h5yHWqrunf2S9edlfq0kT51bFmkHNBN5Bpbv4GV8huzyxrOsw11waAJml7CnPjnCg9bmRviZPqdcJMBIVcoL7bZHrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKM1hUDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKM1hUDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012851F000E9;
	Thu, 30 Jul 2026 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422145;
	bh=8U73e7b3bVfE+bb+K753h2ua4slkC4WO2vEV9TbWL1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKM1hUDx9Nx2z3upaqjZJxw/a6DLfUJUImVmO4LP6izx5BlMzVuwc08FFKfczLBwR
	 wEpga3VESlxFMz0sYR0XdM5t/4tiKllCab6zmL/h558DAQfFYxfSE+sw5MWfuvDna4
	 PxOY24V8f5egTwHeXxEkkyqXd4gLeLRRkE9ZpJm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 340/744] net: ipv6: fix dif and sdif mismatch in raw6_icmp_error
Date: Thu, 30 Jul 2026 16:10:13 +0200
Message-ID: <20260730141451.508572763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3cc58698cbbd3a..b88d364e78aae9 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -349,7 +349,7 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
-				  inet6_iif(skb), inet6_iif(skb)))
+				  inet6_iif(skb), inet6_sdif(skb)))
 			continue;
 		rawv6_err(sk, skb, type, code, inner_offset, info);
 	}
-- 
2.53.0



