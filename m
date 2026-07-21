Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8653B52FF;
	Tue, 21 Jul 2026 22:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672014; cv=none; b=SKWraPfQqbH+QtQxQrf4bmheFKMoXrzrLk9G6AsNTWTS9/HLzBQ9sEa3l903gGtc2IIQKARFnYojbCRld1LUg+rm0uo1Tpk0AwkhHnVqkIG07jAzfc7M6wsR3zlHq073hZ1nUaMDxxZpx4Y1k9rTw4h86S2m9LGn0a1lWufpbUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672014; c=relaxed/simple;
	bh=kabwmLGYScUX3pXat9nMZ3BYjV1fTQIS5SjOpwpp99c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWF0UydHbrbOukBTApKCMyzAdXCwFO3e47h3a8XkYvjH/z8xahJ1jyHWffKb0uY1+aojkyzyB46vjHif7vJ18A5Mj1iZCxrz6RMkRvxTeL8ArcK6w9BXcul+lGvJp4BD4VJloAR3SpfvQlSr7otIhl7lGUPRi/rffWA84pv5M/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAucmLq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAucmLq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93ED1F000E9;
	Tue, 21 Jul 2026 22:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672013;
	bh=eHBfXj6/lijdlhgt8PGLCl1OPEMlBCfmGvenxBld6Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAucmLq80gBVffD8z8WQwSHK78tXc7iobLC9KQ6QL7bXHwtaYcKYhc9VpEn72nvwB
	 kqNIuyFk8KFSrFPcXfkyAfV3OuL/CxG/4YzzLGXJjqYORr+QIEvbXAKLAji3dwaUot
	 BxTyIY+Lt6mi/Da67eXbfdZioqb3yE93/tCni7y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 465/843] ipv6: Fix null-ptr-deref in fib6_nh_mtu_change().
Date: Tue, 21 Jul 2026 17:21:40 +0200
Message-ID: <20260721152416.496676585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 46c3b8191aad3d032776bf3bebf03efdf5f4b905 ]

fib6_nh_mtu_change() re-fetches idev via __in6_dev_get(arg->dev) and
dereferences idev->cnf.mtu6 without a NULL check. addrconf_ifdown()
clears dev->ip6_ptr with RCU_INIT_POINTER() after rt6_disable_ip() has
released tb6_lock, so the RA-driven MTU walk can observe a NULL idev and
oops. The caller rt6_mtu_change_route() guards its own __in6_dev_get(),
but this re-fetch is unguarded; nexthop-backed routes survive
addrconf_ifdown()'s flush, so the walk still reaches it after ip6_ptr is
nulled.

Return 0 when idev is NULL, matching rt6_mtu_change_route() and the
fib6_mtu() fix in commit 5ad509c1fdad ("ipv6: Fix null-ptr-deref in
fib6_mtu().").

  Oops: general protection fault, ... KASAN: null-ptr-deref in range
        [0x00000000000002a8-0x00000000000002af]
  RIP: 0010:fib6_nh_mtu_change+0x203/0x990
   rt6_mtu_change_route+0x141/0x1d0
   __fib6_clean_all+0xd0/0x160
   rt6_mtu_change+0xb4/0x100
   ndisc_router_discovery+0x24b5/0x2cb0
   icmpv6_rcv+0x12e9/0x1710
   ipv6_rcv+0x39b/0x410

Fixes: c0b220cf7d80 ("ipv6: Refactor exception functions")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260619045334.2427073-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 907b3282924678..cb1cf7d5946ff4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4941,6 +4941,9 @@ static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
 		struct inet6_dev *idev = __in6_dev_get(arg->dev);
 		u32 mtu = f6i->fib6_pmtu;
 
+		if (!idev)
+			return 0;
+
 		if (mtu >= arg->mtu ||
 		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
 			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
-- 
2.53.0



