Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BC534216C;
	Fri,  7 Aug 2026 15:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116835; cv=none; b=PHR93S5YKk46tMcBJBfCSTOU4tWKVtMluzywPGO8CM711cC43q6PhGaLc36K1rJl0b7P1lPKuKu6pc9z1SWEaqUOdwmUWXZRjII98pu6Dcl5ZmRi3c8mNbI4ShwOtyRXeuN0XCvJtlL8BLr/n6fqczCeiZnKOjedOGpway0yeGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116835; c=relaxed/simple;
	bh=zq2aRQ4YdAqGUWKthkVO5ckw89FhFfkUKmsSxiIAJas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuodmWDnaymPZTgjo80/mRJYFFf9Q/wLJFkfSp7ncchG5ygD3xPrVuxd0ngP5hWz6zopYffn5+zU64QQ0U79epxZaruB2FtCz80k6hibRTmiFMd6sgYvMpZZ5QftIXwiJ1ZbgKo15WpWQw9TfQXEx0pxRtjU7IqmFZORRVKkJW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDxCLL9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDxCLL9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8667B1F00A3A;
	Fri,  7 Aug 2026 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116834;
	bh=Si/kt3ei5ejuizySIWopZ9cROZ1zj6UeEWPD1QBGAhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDxCLL9KKK/QHYdrgXwSJdK+OPH/4ucs/Sfl0w2kXAedcYHriCgNzMkcdyxeere3U
	 25qJ5Ol/mSrlXLnqYo2ToqnyKNWo13ByI3cJsqateRkkfPd5G2rMSAGYKe+eVkfQt0
	 2S4ARreAeEO+xTLh0kBcT6bwPuz05jyfrZVSxkCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 070/438] nexthop: avoid unlocked f6i_list walk in nh_rt_cache_flush
Date: Fri,  7 Aug 2026 16:34:26 +0200
Message-ID: <20260807143429.478691412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 4787a6d2629b4e8c0b6bacab1f75c1660eca44d9 ]

nh_rt_cache_flush() walks nh->f6i_list during an RTNL-serialized nexthop
replace without holding nh->lock, racing the unlocked IPv6 route
add/delete that mutate the list under nh->lock and free fib6_info
entries (nh_rt_cache_flush() is inlined into rtm_new_nexthop()):

  BUG: KASAN: slab-use-after-free in nh_rt_cache_flush (net/ipv4/nexthop.c:2243)
  Read of size 8 at addr ffff888012953e18 by task exploit/146
   nh_rt_cache_flush (net/ipv4/nexthop.c:2243)
   replace_nexthop (net/ipv4/nexthop.c:2610)
   rtm_new_nexthop (net/ipv4/nexthop.c:3323)
   rtnetlink_rcv_msg (net/core/rtnetlink.c:7076)

Unlike the other f6i_list walks, this one bumps each route's sernum via
fib6_update_sernum_upto_root(), which needs tb6_lock; taking nh->lock
around it would invert the established tb6_lock -> nh->lock order and
deadlock. As the only purpose is to invalidate cached dsts, bump the
IPv6 sernum for the whole netns with rt_genid_bump_ipv6() instead,
mirroring the rt_cache_flush() already done for IPv4 just above.

Fixes: 081efd18326e ("ipv6: Protect nh->f6i_list with spinlock and flag.")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260722002951.2614721-2-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8b1f3382a998a..1bfc429fc9607 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2223,18 +2223,18 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 static void nh_rt_cache_flush(struct net *net, struct nexthop *nh,
 			      struct nexthop *replaced_nh)
 {
-	struct fib6_info *f6i;
 	struct nh_group *nhg;
+	bool have_f6i;
 	int i;
 
 	if (!list_empty(&nh->fi_list))
 		rt_cache_flush(net);
 
-	list_for_each_entry(f6i, &nh->f6i_list, nh_list) {
-		spin_lock_bh(&f6i->fib6_table->tb6_lock);
-		fib6_update_sernum_upto_root(net, f6i);
-		spin_unlock_bh(&f6i->fib6_table->tb6_lock);
-	}
+	spin_lock_bh(&nh->lock);
+	have_f6i = !list_empty(&nh->f6i_list);
+	spin_unlock_bh(&nh->lock);
+	if (have_f6i)
+		rt_genid_bump_ipv6(net);
 
 	/* if an IPv6 group was replaced, we have to release all old
 	 * dsts to make sure all refcounts are released
-- 
2.53.0



