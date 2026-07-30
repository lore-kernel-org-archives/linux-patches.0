Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A6936D50D;
	Thu, 30 Jul 2026 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424226; cv=none; b=fW1ihrXdyk1gjswLx9IltA/K8aWI9MHqoDZnNncoCSBOMKNdDvXmwyvQ66dAwwyFjqhLFqlVjr0+xW0OfKme0/GtVbTp6gzDWg4ARkDseQbU510/MQp4nS3BkMg9Wrt1BuM5Oz3hDU7G9UNHgo8Zv6JQ1gYIqWjtZ6ISrtMdU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424226; c=relaxed/simple;
	bh=FsQuo7PNlb77kTs4QETBUajp8jBxMlHxrl2fTaMnVbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyMicUhoucgAL6OLJVcC4IlM2ZLFT7h58v9UAwECiyFLD9fUP7qNLaZykBgtsevNImTsEB/RhIbHo2+9j8DpHnmA1jzVAYS6JfK9KvUqeq4zjsUMY57KNT04AOA/JbZEqlrRFfHFFO+YsRPtoqATIThGKJ19/37fkA70r0qG+t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR0Ejcec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR0Ejcec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3091F000E9;
	Thu, 30 Jul 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424224;
	bh=OUF20ATiRI0go94M6QR+/njNROb1K+yGB3ZTkA5ubLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JR0Ejcec9HY7BGQ3yECPxsFU2YSFGYZ3ukviNkLA5rmJb3mM0pzC8UIUB7McpsXZT
	 91tR9NseNCoXYPlrQsgn/LxfdUWeckm5iqc/zYMY5k50QUyJgU174S/FVlO5FBW4LR
	 hCb2d48KCQpeyzZ8GMqF8hor3Y5XkViSvxb9xV58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+84d4a405ed798b40c96d@syzkaller.appspotmail.com,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/675] ipv6: Change allocation flags to match rcu_read_lock section requirements
Date: Thu, 30 Jul 2026 16:10:42 +0200
Message-ID: <20260730141451.757464144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit 313a123e1fca8827bb463db1f4bb211309764563 ]

Since the call to __ip6_del_rt_siblings has been converted under
rcu read lock and it only has one call point
we should no longer block or yield.

Our stack trace from the syzbot reproducer looks as follows:

__ip6_del_rt_siblings
  rtnl_notify (Here we pass gfp_any() -> GFP_KERNEL)
    nlmsg_notify
      nlmsg_multicast
        nlmsg_multicast_filtered
          netlink_broadcast_filtered (GFP_KERNEL passed from earlier)

netlink_broadcast_filtered can yield if GFP_KERNEL
is passed, which we do not want to happen.

Fix this by changing the allocation flag of rtnl_notify.

Also change the flag passed to nlmsg_new. Even though it
is not related to the syzbot generated bug it still falls
under the same requirements.

Reported-by: syzbot+84d4a405ed798b40c96d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=84d4a405ed798b40c96d
Fixes: bd11ff421d36 ("ipv6: Get rid of RTNL for SIOCDELRT and RTM_DELROUTE.")
Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260719105759.558050-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ef66a3c86febbf..a45747bfb31a06 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4011,7 +4011,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 		struct fib6_node *fn;
 
 		/* prefer to send a single notification with all hops */
-		skb = nlmsg_new(rt6_nlmsg_size(rt), gfp_any());
+		skb = nlmsg_new(rt6_nlmsg_size(rt), GFP_ATOMIC);
 		if (skb) {
 			u32 seq = info->nlh ? info->nlh->nlmsg_seq : 0;
 
@@ -4067,7 +4067,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 
 	if (skb) {
 		rtnl_notify(skb, net, info->portid, RTNLGRP_IPV6_ROUTE,
-			    info->nlh, gfp_any());
+			    info->nlh, GFP_ATOMIC);
 	}
 	return err;
 }
-- 
2.53.0



