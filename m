Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDCA7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CF5C433C1;
	Wed,  2 Nov 2022 03:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358520;
	bh=Mve9tX5ZDtNQHTqiWGvWjiBRdpI3FCU+nq0NjtQlPC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOvGtgBewjdkPsrVunMoGguXb6GGWvy7PBhf7q6ZkPjxsa+AXxRe5RzvTay1HyWsO
	 7kPuClipIwn7Ug3tYjkiTqMOrxOq2NLNgOopQhjandF6NPB97jFvOtpWZFuap/7EKb
	 iWqLRv8MOQB0NqAuodsCC4zAKY/89B5TJmiPl5J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Julian Anastasov <ja@ssi.bg>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/132] nh: fix scope used to find saddr when adding non gw nh
Date: Wed,  2 Nov 2022 03:33:39 +0100
Message-Id: <20221102022102.637328773@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit bac0f937c343d651874f83b265ca8f5070ed4f06 ]

As explained by Julian, fib_nh_scope is related to fib_nh_gw4, but
fib_info_update_nhc_saddr() needs the scope of the route, which is
the scope "before" fib_nh_scope, ie fib_nh_scope - 1.

This patch fixes the problem described in commit 747c14307214 ("ip: fix
dflt addr selection for connected nexthop").

Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Link: https://lore.kernel.org/netdev/6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg/
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index cc8f120149f6..6cc7d347ec0a 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2535,7 +2535,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	if (!err) {
 		nh->nh_flags = fib_nh->fib_nh_flags;
 		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
-					  fib_nh->fib_nh_scope);
+					  !fib_nh->fib_nh_scope ? 0 : fib_nh->fib_nh_scope - 1);
 	} else {
 		fib_nh_release(net, fib_nh);
 	}
-- 
2.35.1



