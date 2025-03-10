Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9F32356CC;
	Mon, 10 Mar 2025 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630606; cv=none; b=uVelY1/7ub9fefKVRdGtMluhcvlKcd3rp5s6isFaWgZFmlFuCAjIDGjMl4DVWjNnckS1fGFzY8hGnZzMUN3TwKOP3uwkWBAQDTeGE3w/9wpet0CaI+U5UjxvApcgLVlYgkyCjGvsNSi86dLxbIAKkdnmEz2hne8IHbvGOW20VCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630606; c=relaxed/simple;
	bh=08lbthVK5vneiyLKKHzM/eaEUUsc1/IBOjGygeuVjOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAbhyfDUdi6A6r04k0jCnYV9Qy3Brtn/knC0MnLugVu9ni7OKmzxpE46YYobNh4dh0zpAzBb7anlkjc8eszJ187om2lmq1QkJ/u0X+ClqH4CwcvOn+4iI3gaLug0NT383SLHRp3a33M6HRcW/Ieq6nNOfY9RiwdqsxsXX8nate8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnTRO/7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnTRO/7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF1BC4CEE5;
	Mon, 10 Mar 2025 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630606;
	bh=08lbthVK5vneiyLKKHzM/eaEUUsc1/IBOjGygeuVjOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnTRO/7LwL9RRLWTLL6H6Vie+G+qj9GSjR8dmqL80wAKSwVFExRk/4y8UwyUtO0jD
	 Zc1Bqytn1BNHDJPh7tFljjy3VJIK0rlYWvZbLBk4wB0gYKxWQDE16zCQuFtdgwd0pC
	 ISUy9ablYnUgMtlCk+VCrkWd1uufsHcpm5/jDo3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 472/620] arp: switch to dev_getbyhwaddr() in arp_req_set_public()
Date: Mon, 10 Mar 2025 18:05:18 +0100
Message-ID: <20250310170604.209195631@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6879e0b70c769..ef69321886798 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1009,7 +1009,7 @@ static int arp_req_set_public(struct net *net, struct arpreq *r,
 	if (mask && mask != htonl(0xFFFFFFFF))
 		return -EINVAL;
 	if (!dev && (r->arp_flags & ATF_COM)) {
-		dev = dev_getbyhwaddr_rcu(net, r->arp_ha.sa_family,
+		dev = dev_getbyhwaddr(net, r->arp_ha.sa_family,
 				      r->arp_ha.sa_data);
 		if (!dev)
 			return -ENODEV;
-- 
2.39.5



