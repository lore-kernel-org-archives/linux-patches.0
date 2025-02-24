Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0BD1B7F4;
	Mon, 24 Feb 2025 14:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408925; cv=none; b=uJcmmoWvVe7efCGzYsI6nutcZUL3FYJTu5/xkJbMYdqiqNeh3weTk6nSvLA4ft/7FfOUNiwEMVjd0cUVzQIfBMFRxdYxu/mgji8lX2rIAuj0uzPvu09QyNBMH0e6iKyUx76Sp1rVCisPvpjj8XeANQwMNu3dYPiVh0DkAiaQV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408925; c=relaxed/simple;
	bh=gZ4cRY1G3NKKHi5Zokh3mU1qPnzLvEsOpbij6BD3MTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHkP+1EcXbXKAQ5BvU7DzO6rW+d5JykukEvWWm/FH2QMLflZVCmNmUfahost5rRlA05/GbsFrxk+L06fCDoflAidbNWM93yjTzBaTZags2DWEsAVgbr6sYzJ5Mr20cDgnx1VrweoI1zKotnYvBZx2PENpNS0UsrM8Wj7oEhtsUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmjoXx00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmjoXx00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65977C4CED6;
	Mon, 24 Feb 2025 14:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408924;
	bh=gZ4cRY1G3NKKHi5Zokh3mU1qPnzLvEsOpbij6BD3MTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmjoXx002iwghzfaqc+Y4n0Y0BXxg/H4SqfPbRHHtDcwArsj58szGEtNp/AxTLPvs
	 tovApcOQo3qNpYa1Fm9jbSEmISwogbcY0VSZxvE8kiBSciUofj8ZsWeLUqrengLrAe
	 T62UA/V4HrV2HJwPEAHjnXkrAHgb3pRxbOhSCYb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 045/138] arp: switch to dev_getbyhwaddr() in arp_req_set_public()
Date: Mon, 24 Feb 2025 15:34:35 +0100
Message-ID: <20250224142606.241338774@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4eae0ee0f1e6256d0b0b9dd6e72f1d9cf8f72e08 ]

The arp_req_set_public() function is called with the rtnl lock held,
which provides enough synchronization protection. This makes the RCU
variant of dev_getbyhwaddr() unnecessary. Switch to using the simpler
dev_getbyhwaddr() function since we already have the required rtnl
locking.

This change helps maintain consistency in the networking code by using
the appropriate helper function for the existing locking context.
Since we're not holding the RCU read lock in arp_req_set_public()
existing code could trigger false positive locking warnings.

Fixes: 941666c2e3e0 ("net: RCU conversion of dev_getbyhwaddr() and arp_ioctl()")
Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250218-arm_fix_selftest-v5-2-d3d6892db9e1@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index f23a1ec6694cb..814300eee39de 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1077,7 +1077,7 @@ static int arp_req_set_public(struct net *net, struct arpreq *r,
 	__be32 mask = ((struct sockaddr_in *)&r->arp_netmask)->sin_addr.s_addr;
 
 	if (!dev && (r->arp_flags & ATF_COM)) {
-		dev = dev_getbyhwaddr_rcu(net, r->arp_ha.sa_family,
+		dev = dev_getbyhwaddr(net, r->arp_ha.sa_family,
 				      r->arp_ha.sa_data);
 		if (!dev)
 			return -ENODEV;
-- 
2.39.5



