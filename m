Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66F143B6EE;
	Tue, 21 Jul 2026 22:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671425; cv=none; b=ejl1AYra1NrdOWhJ4v4nREft3WL54aGS92/v4hezBNcuFz/sx7t2rV5hMYguaLOgma7MFKt87//guaGLZFUwESV4uiOHtc18i5ucAqgr/AcKYvLjVObmChYKv9ShtgGAisF9vsKFDFvFJEH/pqw7++bc85KXvN8ZeHZxgkSFx+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671425; c=relaxed/simple;
	bh=bMRi4/iyqmtlYKU3udEjvC25R2Y9XMMdzSXgBym8Jg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpCYH0tcLXTNWgrZGXzV+oK/CFaCo0DRtABiv0m65jtAMKPlvHQUyX+8uZyWWmR4mY3aJaPb2e0MfMFMQ125oLiEKXZ/BVI1S7z3kshebFWfGMNw2jKHxMWU0JGIm961YgJVzbefmioNWGIC/B9ya/+xc38ttzQnbY+aXDFHfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuL0KDFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuL0KDFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ACC1F00A3D;
	Tue, 21 Jul 2026 22:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671424;
	bh=/7UC8M5Nhea8DrGJi/U0BCc7fvtPJ+XhzVcYtHWgUd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuL0KDFGaRwLjyDFzbhozerucs+DZGkZWZrcC5qN+/VIHrwMzFBKBu0uRK+VovEmm
	 iNVr85b8XWZI5+WnPxmqX/WTdsp2/3CCaJqMDHmvjYujzZoDzEPthWA0krQAeJgHsS
	 w/pblCwe9PEDTnk0BSQ/K5bzJwMWrjf5p2EjL9gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/843] ipv6: addrconf: bail out of dad_failure when state is no longer POSTDAD
Date: Tue, 21 Jul 2026 17:17:56 +0200
Message-ID: <20260721152411.438188912@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 627ac78f2741e2ebd2225e2e953b6964a8a9182f ]

addrconf_dad_failure() transitions ifp->state from DAD to POSTDAD
via addrconf_dad_end(), which drops ifp->lock on return.  The lock
is re-acquired after net_info_ratelimited().  A concurrent
ipv6_del_addr() can take the lock in that window, set ifp->state
to DEAD and run list_del_rcu(&ifp->if_list).

addrconf_dad_failure() then overwrites DEAD with ERRDAD at errdad:
and schedules a new dad_work.  The work calls ipv6_del_addr()
again, hitting the already-poisoned list entry:

  general protection fault: 0000 [#1] SMP NOPTI
  CPU: 4 PID: 217 Comm: kworker/4:1
  Workqueue: ipv6_addrconf addrconf_dad_work
  RIP: 0010:ipv6_del_addr+0xe9/0x280
  RAX: dead000000000122
  Call Trace:
   addrconf_dad_stop+0x113/0x140
   addrconf_dad_work+0x28c/0x430
   process_one_work+0x1eb/0x3b0
   worker_thread+0x4d/0x400
   kthread+0x104/0x140
   ret_from_fork+0x35/0x40

Fold the addrconf_dad_end() logic into addrconf_dad_failure() under
a single ifp->lock critical section.  The STABLE_PRIVACY branch
temporarily drops ifp->lock around address regeneration, so at
lock_errdad: verify the state is still POSTDAD before transitioning
to ERRDAD; bail out otherwise to avoid overwriting a state set by
another path while the lock was released.

Fixes: c15b1ccadb32 ("ipv6: move DAD and addrconf_verify processing to workqueue")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260513025509.3776405-1-lilinmao@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index df749b2f2ecd3a..4879487ecaaf27 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2124,16 +2124,18 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 	struct inet6_dev *idev = ifp->idev;
 	struct net *net = dev_net(ifp->idev->dev);
 
-	if (addrconf_dad_end(ifp)) {
+	spin_lock_bh(&ifp->lock);
+
+	if (ifp->state != INET6_IFADDR_STATE_DAD) {
+		spin_unlock_bh(&ifp->lock);
 		in6_ifa_put(ifp);
 		return;
 	}
+	ifp->state = INET6_IFADDR_STATE_POSTDAD;
 
 	net_info_ratelimited("%s: IPv6 duplicate address %pI6c used by %pM detected!\n",
 			     ifp->idev->dev->name, &ifp->addr, eth_hdr(skb)->h_source);
 
-	spin_lock_bh(&ifp->lock);
-
 	if (ifp->flags & IFA_F_STABLE_PRIVACY) {
 		struct in6_addr new_addr;
 		struct inet6_ifaddr *ifp2;
@@ -2181,6 +2183,11 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 		in6_ifa_put(ifp2);
 lock_errdad:
 		spin_lock_bh(&ifp->lock);
+		if (ifp->state != INET6_IFADDR_STATE_POSTDAD) {
+			spin_unlock_bh(&ifp->lock);
+			in6_ifa_put(ifp);
+			return;
+		}
 	}
 
 errdad:
-- 
2.53.0



