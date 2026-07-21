Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC940587A;
	Tue, 21 Jul 2026 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655817; cv=none; b=gNcGpB367yAXd+BJYeK6ZnkooA8LPaiY5bV1o/y3x7NRDfk3i94WpkmFoJP7tOxnXli47827kbZkCyG98ci6A7LyLrYoYm19F7o4iavy33Xdi1hmiqBttTYPT15W6JeUKLaleSbxkUVlsw4uuCCgzXWYnWKaOufYZ8TESlRo+UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655817; c=relaxed/simple;
	bh=KBiOG2RBwsKVWQVGKyf5ixGYqJW/33QIQo+BjQVCT9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDBSF3anabMzRacbd87XifQcudvlrHhqx/YEMeAN6noJrzaIXyv7KBdL+o6lGTswqiHvJYw2R3/RLw4BwjLFrYyqp2udC43Uy+gdLre9XmJtaRXm+6QvgHxOTOTD+nIQyUFVPOZ5xOkCQx94hsqvd4s1g8Ipha49wwbrTfCsEDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TojRNy0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TojRNy0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9D01F00A3A;
	Tue, 21 Jul 2026 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655815;
	bh=0vwEpL2iXApT/dRawl3P8lp7x3lAfE8m/k1U/PW/Mko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TojRNy0Zys4FD+ZKri9ZrPiUEwPFd+uR+zUnuEu5HmmYmL7c/qpNmJv+S7SzG4t8I
	 bZelRt0gcLY8E+wflp4T7pyUEQn1mfJ2RTHjoZJjQOEyL7ivb7gLTVm1OUrAH/r3/P
	 suEPq278r5/l0H4vpebVLHtCD+p0m8tFKMiNUQUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0153/1611] ipv6: addrconf: bail out of dad_failure when state is no longer POSTDAD
Date: Tue, 21 Jul 2026 17:04:29 +0200
Message-ID: <20260721152518.320849356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index b2e1328371d3f6..c8c82891fe14c9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2168,16 +2168,18 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 	struct net *net = dev_net(idev->dev);
 	int max_addresses;
 
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
@@ -2225,6 +2227,11 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
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



