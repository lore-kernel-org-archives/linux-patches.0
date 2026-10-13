Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144244EC65A;
	Tue, 13 Oct 2026 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893757; cv=none; b=jdtUkiFok9IQeo6aiy80x6Enx/poeqwQsMtj+7sR1Q2n50VL+3+rT6Nq/EbS6YtD17UaQg/rW1ANX9WHOSRkwl85/LHuEAYdR2AFLlvwUkg1v6nu1FBLwxD8BKolCLlh8Lt+SELdRyGNVWZCxgOO9tYpxkcUHu4equAyfDaDl3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893757; c=relaxed/simple;
	bh=BTXIo0y3z1opYQCHu+wjZnqbEGig07wzP9Bm2aApMwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7MRQKlW76UCRKKCX1xt87rBIIMqgctCR8XgYTAGzoAEop9Rm9+lD+VZRLUegjeGWsy7agf4J6kXnPzqJxUwoyyNSWzryMYmQrcgVHpgXdO+pFC1jJubgMmuKv+iWQIlmg9fOka7BW0WbVzxzm5a1wURlPw2Ia8wLQ38cWB6rPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtCLC0ps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtCLC0ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABBB1F000FF;
	Tue, 13 Oct 2026 12:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893756;
	bh=N29IsMLSdsS2QlHd7pDsM6GI9JOIG0pMc/MQjLAQr0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtCLC0psy0ZGDFTZSo/d/DVcvNHb/KzQqgHQHwOp3WnFhvaFoOvYL0MI/koqo+IGG
	 TDIy57qtZ3EU9rwl1LR9io3MM3+ChUat1d0WBIR5jQRsqWOHW0gMhAoPym35HFxnnN
	 pXOpmZynMunigp7PJPs9fy7qKywulNINhK5IVr3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 331/621] nexthop: avoid unlocked f6i_list walk in nh_rt_cache_flush
Date: Tue, 13 Oct 2026 13:35:26 +0200
Message-ID: <20261013112928.707643964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv4/nexthop.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 66d5c996866bf..7adec5cc263e4 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2219,15 +2219,18 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 static void nh_rt_cache_flush(struct net *net, struct nexthop *nh,
 			      struct nexthop *replaced_nh)
 {
-	struct fib6_info *f6i;
 	struct nh_group *nhg;
+	bool have_f6i;
 	int i;
 
 	if (!list_empty(&nh->fi_list))
 		rt_cache_flush(net);
 
-	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
-		ipv6_stub->fib6_update_sernum(net, f6i);
+	spin_lock_bh(&nh->lock);
+	have_f6i = !list_empty(&nh->f6i_list);
+	spin_unlock_bh(&nh->lock);
+	if (have_f6i)
+		rt_genid_bump_ipv6(net);
 
 	/* if an IPv6 group was replaced, we have to release all old
 	 * dsts to make sure all refcounts are released
-- 
2.53.0



