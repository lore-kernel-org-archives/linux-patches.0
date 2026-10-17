Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B93B19CF;
	Sat, 17 Oct 2026 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255618; cv=none; b=eo8aCw7hEye4BMfNJbPCXgLRmIROPbnQi8DjiBW/nuqynhQCBJPkFLJ97A13ozPYC8w5t/JnCxJv2wHWCz5fj/OXiNXXR75kLZLGNeDgWGoBm1Ogq4axsU50fi67xIBtrS5kUUl4KkOZu74hZA4Iw351XPx4itQ8xdZcmH7JZVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255618; c=relaxed/simple;
	bh=fN5E5Q68EjaZKRyrB8imCcRHA0KA4IC/Y7ooMBgOLOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KM/jaK6oXvURvkNpcJG5q7Ro/0Y/3JfE/GzOOrZeWrIJHgcnDsmdlKOnBogdgOklvAAqOnFiwiT2KkPP1V1sjoSA38OBvpbNjkeBf+sLWGEIroTdQTSS6yVwlp7sbl9SNO5xBeqOYC/3vMh1FWfEO0+oMoc+XHDsbCyvpZuqKMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yksBMOAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yksBMOAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7774B1F000C4;
	Sat, 17 Oct 2026 16:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255617;
	bh=A1hMODZje1c+G/ZsxHxzijzTiMmZJCnIz0YbayBGhIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yksBMOAYUcMxwBFml4Jy/+BPowTFKph3ui9JlHrofkQFwy9DUoYSxLr+fYBUyymqw
	 Oxvg/7MUTH3XydOK6jjDf5I2C1uL+zB0O++6GGT/D/Ogu/GhqEIR4xtrgzWN32eJcw
	 LDTBVt0psh1ZsITIAAoED5fJUxhfMosy8h6r8hSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Doeraene <anthony.doeraene@uclouvain.be>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 833/869] mpls: Set rt->rt_nhn just before returning from mpls_nh_build_multi().
Date: Sat, 17 Oct 2026 18:01:14 +0200
Message-ID: <20261017160058.234979957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 3671f0419d90b98a02f313830595ab958c8b2025 ]

Commit f0914b8436c5 ("mpls: Hold dev refcnt for mpls_nh.") added
change_nexthops() loop to call netdev_put() for the nexthop devices
before freeing mpls_route.

Then, mpls_nh_build_multi() was also changed to avoid iterating
uninitialised nexthops in mpls_rt_free_rcu().

However, setting rt->rt_nhn to 0 at the entry of mpls_nh_build_multi()
makes the following change_nexthops() no-op.

Let's set rt->rt_nhn just before returning from mpls_nh_build_multi().

Fixes: f0914b8436c5 ("mpls: Hold dev refcnt for mpls_nh.")
Reported-by: Anthony Doeraene <anthony.doeraene@uclouvain.be>
Closes: https://lore.kernel.org/netdev/036a0c95-f5d4-46ab-88e7-1eab567d7a84@uclouvain.be/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260716170609.804629-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 5c293fa655d0d..70035b1a52c48 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -929,8 +929,7 @@ static int mpls_nh_build_multi(struct mpls_route_config *cfg,
 	struct nlattr *nla_via, *nla_newdst;
 	int remaining = cfg->rc_mp_len;
 	int err = 0;
-
-	rt->rt_nhn = 0;
+	u8 nhs = 0;
 
 	change_nexthops(rt) {
 		int attrlen;
@@ -966,12 +965,15 @@ static int mpls_nh_build_multi(struct mpls_route_config *cfg,
 			rt->rt_nhn_alive--;
 
 		rtnh = rtnh_next(rtnh, &remaining);
-		rt->rt_nhn++;
+		nhs++;
 	} endfor_nexthops(rt);
 
+	rt->rt_nhn = nhs;
+
 	return 0;
 
 errout:
+	rt->rt_nhn = nhs;
 	return err;
 }
 
-- 
2.53.0



