Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D32561B5;
	Mon, 24 Feb 2025 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408477; cv=none; b=tY+Yuz4QSzpp6JL2AsH9aT+KO5tO84w8MY/EdFjqmrdmi+ppX2LXS2y8G4+exumtbATRNHu/9HqhzXfrong34nqAYGp+uCNLJKytHXST7j2QHTyDUl7pzkwej9mJCAWuBtIoOguOchUQ/uW5XqEvQbhoOlj0rHaueAagWcJDMlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408477; c=relaxed/simple;
	bh=liXdX5HaPAfOqeFHGjk00k0Ns7xAH4gUF9IQ7QYfGnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/eBDQ6Myx0uqOFTtuiBFyX927i/hKABJ8jDBQz8uZFtWsAxwrnS4X95JhsC/aJ0kiSue86GiCdX+RIjdKQ3aEZr5ZfS0FS0L4BvvsgzHkHIOP9qKRlcQ/erPkQx2/o6shr5stG133LlmQUPx9fLeelJfofafcVyLKK1jK4ecLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpVE8Hvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpVE8Hvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04927C4CED6;
	Mon, 24 Feb 2025 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408477;
	bh=liXdX5HaPAfOqeFHGjk00k0Ns7xAH4gUF9IQ7QYfGnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpVE8Hvf25HBIN+Ewr04C2Q3kO8XSD4Amfq6C06cMPqfgCl0ZLsP5H3DvZhnAeOJB
	 oDk7AWiq0Gt1bLKsrzMJhydedArypYdJtx0PyNdgP/kczERjwyMfObc7UB6Y9lGzH/
	 XS911PLdq/wA+sthSm0b63XIN6qX+03Aj6s/XQYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/154] arp: switch to dev_getbyhwaddr() in arp_req_set_public()
Date: Mon, 24 Feb 2025 15:34:29 +0100
Message-ID: <20250224142609.825514678@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 59ffaa89d7b05..8fb48f42581ce 100644
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



