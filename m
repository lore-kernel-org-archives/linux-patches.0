Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB263B3C15;
	Tue, 21 Jul 2026 20:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666671; cv=none; b=j4Sx9BOg4bJaGEKhY8+yBE0mtqSmorz7RZIdObF6rL4Q5bFHt6AF85YJ0YgbNriT2WGQ/rgqs8ayst/ZA7QDwMCKR2r4Iy705INiVtr+nPXA8PugsIQkxSajDDqrdw4jfioif2lvdJ1H11Wn1FKzYMTE/WoHymjWA31hJqLjRJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666671; c=relaxed/simple;
	bh=9P6Z+qmw+cEA04MuOvDOkkZUrgYNw00QVUf2pABn0/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIP3KdNkc+QZAPtK3fLQOW767FswlIKlCRlZOePAhj36RJzo3Cowya6FXVIfwirSNqMJ0tI3PSpHuJYsZEN8oNCKST/qc8HdSSQTkTme9WAmICAWqpg8RaRYmyo0CdV61/tdlctD5LYz+3EbmgUhJ+H/u113GOp6skIxZ8w9NsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka2H8/eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka2H8/eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0101F000E9;
	Tue, 21 Jul 2026 20:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666670;
	bh=82Wl/rnn1zhSMI0fOMJbc1LQ15KmLaRcmg1i+ThkhD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka2H8/eooAASScM2/JciUBmHH2WYaUiBadD8I4pxhWRQqrBu1Pv5O1ALJgWy6EcLC
	 /Q0D7MEMu6Tsan/IO+s2KSyJso316M3Q9QcjzU/pBlJnmo+2LXWfIOyhX1kUNIeM4E
	 duWaqXSiQdnV7m4kgGQu9WGOujHrq/Mi16yjYEC4=
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
Subject: [PATCH 6.6 0770/1266] ipv6: Fix null-ptr-deref in fib6_nh_mtu_change().
Date: Tue, 21 Jul 2026 17:20:07 +0200
Message-ID: <20260721152459.093226262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c3257e8d575485..e6f1a22bc2bea2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4980,6 +4980,9 @@ static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
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



