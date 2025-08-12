Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116FA223DFF;
	Tue, 12 Aug 2025 19:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026032; cv=none; b=shyU7//XC5+B0W7+QdpixGZNPrp14UEpb3utRJeTSVTGonu//r+Y01FPfg9Jk9Q+Sy3K0jFuVEpRgJlt0UUMqCYdess4PcZwSFw3iHDHatxwVykG+m/lp4rmp2PWh1M8DSjKx1kcVdP4zq0T0HwVCLv7hXoGmqOZ4XVo9Kgwtsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026032; c=relaxed/simple;
	bh=kCE8Mh4/sT8ElqS4hK5Mph2Xh/YJXrjhADchPekXxyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A91ozC8o9TubjULsBt8zVCPRVu5z6cMXYumCpXmoKKuD8Btq+TUbeyAnFq0vuE5wQ7o3Kd0ZDVTxjo/flTy41yQ9MqzLQVJ5tLu5BVmpSABM3EQskPiSScAmGzZdeYbSaAWdScahpiBFz+nzje8yl40P+zMattlllW34o1rg040=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aOW6Ern; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aOW6Ern"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA4DC4CEF0;
	Tue, 12 Aug 2025 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026031;
	bh=kCE8Mh4/sT8ElqS4hK5Mph2Xh/YJXrjhADchPekXxyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aOW6Ern1GCB2wgdDhhRzFoh2wFKiBIfh3+C9K3Nc6AB3Xzu4W+0r9HqCu6KFfh8F
	 3MH83OzBZiEByXTHXvigL39jLVQyC+XJ0n88UquvbC0ZI5WPitXYYp0tpYAGsrA83L
	 GuQYfYiTZDniwR4K1+DUHdD+eqwPKLfBakpZakcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 215/480] ipv6: fix possible infinite loop in fib6_info_uses_dev()
Date: Tue, 12 Aug 2025 19:47:03 +0200
Message-ID: <20250812174406.327345136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8d8ce1b515a0a6af72b30502670a406cfb75073 ]

fib6_info_uses_dev() seems to rely on RCU without an explicit
protection.

Like the prior fix in rt6_nlmsg_size(),
we need to make sure fib6_del_route() or fib6_add_rt2node()
have not removed the anchor from the list, or we risk an infinite loop.

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250725140725.3626540-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ebb4abd5e69e..506afe11fe3c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5884,16 +5884,21 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	if (f6i->fib6_nh->fib_nh_dev == dev)
 		return true;
 
-	if (f6i->fib6_nsiblings) {
-		struct fib6_info *sibling, *next_sibling;
+	if (READ_ONCE(f6i->fib6_nsiblings)) {
+		const struct fib6_info *sibling;
 
-		list_for_each_entry_safe(sibling, next_sibling,
-					 &f6i->fib6_siblings, fib6_siblings) {
-			if (sibling->fib6_nh->fib_nh_dev == dev)
+		rcu_read_lock();
+		list_for_each_entry_rcu(sibling, &f6i->fib6_siblings,
+					fib6_siblings) {
+			if (sibling->fib6_nh->fib_nh_dev == dev) {
+				rcu_read_unlock();
 				return true;
+			}
+			if (!READ_ONCE(f6i->fib6_nsiblings))
+				break;
 		}
+		rcu_read_unlock();
 	}
-
 	return false;
 }
 
-- 
2.39.5



