Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED5E20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2426C433C7;
	Fri, 21 Jul 2023 19:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966649;
	bh=+b3SczwGhidj6BP7sLIBK0e/s6nbN7YmyVfm56HvbLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvZwPxZQFmTQpqRKBpNA4JkniYQZrIRcJYrrlFGhvTznU0/ocfovNnDiDNXEiywjf
	 pGA1eJ43bE0kVDtlf47D0/NRarQ85VhqKuZTg7OhyX827z6S+EB/00BG/aI2u7MiIx
	 GDrzgHNXnZ+bjBhNpO+ch/90IjPtAEWJnt3JZh9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/532] ipv6/addrconf: fix a potential refcount underflow for idev
Date: Fri, 21 Jul 2023 18:05:23 +0200
Message-ID: <20230721160637.236729080@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 06a0716949c22e2aefb648526580671197151acc ]

Now in addrconf_mod_rs_timer(), reference idev depends on whether
rs_timer is not pending. Then modify rs_timer timeout.

There is a time gap in [1], during which if the pending rs_timer
becomes not pending. It will miss to hold idev, but the rs_timer
is activated. Thus rs_timer callback function addrconf_rs_timer()
will be executed and put idev later without holding idev. A refcount
underflow issue for idev can be caused by this.

	if (!timer_pending(&idev->rs_timer))
		in6_dev_hold(idev);
		  <--------------[1]
	mod_timer(&idev->rs_timer, jiffies + when);

To fix the issue, hold idev if mod_timer() return 0.

Fixes: b7b1bfce0bb6 ("ipv6: split duplicate address detection and router solicitation timer")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6ba34f51c411f..e0d3909172a84 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -323,9 +323,8 @@ static void addrconf_del_dad_work(struct inet6_ifaddr *ifp)
 static void addrconf_mod_rs_timer(struct inet6_dev *idev,
 				  unsigned long when)
 {
-	if (!timer_pending(&idev->rs_timer))
+	if (!mod_timer(&idev->rs_timer, jiffies + when))
 		in6_dev_hold(idev);
-	mod_timer(&idev->rs_timer, jiffies + when);
 }
 
 static void addrconf_mod_dad_work(struct inet6_ifaddr *ifp,
-- 
2.39.2



