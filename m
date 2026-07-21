Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7AC403EA1;
	Tue, 21 Jul 2026 23:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674842; cv=none; b=FR9L5++CwulFBycotKs0egom+kVqPv+1e4hJhN0ICX6CjL2QDWqj2tDhnojaMARCElU/byVJMQgdEZG5rNP9wTHYmLm1XUkkGWY9qFwQX5GzRcQsIg39DIso3zGFzZzq+gfbJb5yTd2KeTd0icEekQGsu/F+i1ZakBe8R52ezQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674842; c=relaxed/simple;
	bh=zjNKTucuVCBSnat9toNQNM5TX69TryEUzAzky3gyebk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EthAUVTJ3d9HZS3TeCnEvWonAeqPXMH2nC2FhiE3qGTZohFocvA1A3sqNQuL/pdG9mCGVKyva4A0167fhSZaPXl6fLJMR960AtMK5RlIfPzjc6dtXh6F/Yi07IGy4XlD7SpyGT5O1Q96Watyl/TPuJcaAYhanfAtPPFoKvIye90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le3USFlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le3USFlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1451F000E9;
	Tue, 21 Jul 2026 23:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674841;
	bh=M5JL2lubISJ8uiMp5xuWLhhAflTRXJi6veWyDooO46o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le3USFlKuZc6mS7kVSElezrVu6tLr05UGoSGQWC8cQS9A2kiWgcmiO/M6Cr6q4ouY
	 KfedI81v1I4EjXe29qSbEOCqUlDH6t0PSRMPAOeLPmnP9VvDWXOdx56b+qGBmsCdIR
	 2v9yY/ZAJfbol3imxKk59rJumjBLAf3diTZ0+yKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Pinilla Caparros <dpini@cloudflare.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 694/699] ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()
Date: Tue, 21 Jul 2026 17:27:33 +0200
Message-ID: <20260721152411.434499879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

commit 26394fc118d6115390bd5b3a0fb17096271da227 upstream.

Some time ago 8965779d2c0e ("ipv6,mcast: always hold idev->lock before mca_lock")
switched ipv6_get_lladdr() to __ipv6_get_lladdr(), which is rcu-unsafe
version. That was OK, because idev->lock was held for these codepaths.

In 88e2ca308094 ("mld: convert ifmcaddr6 to RCU") these external locks were
removed, so we probably need to restore the original rcu-safe call.

Otherwise, we occasionally get a machine crashed/stalled with the following
in dmesg:

[ 3405.966610][T230589] general protection fault, probably for non-canonical address 0xdead00000000008c: 0000 [#1] SMP NOPTI
[ 3405.982083][T230589] CPU: 44 PID: 230589 Comm: kworker/44:3 Tainted: G           O      5.15.19-cloudflare-2022.2.1 #1
[ 3405.998061][T230589] Hardware name: SUPA-COOL-SERV
[ 3406.009552][T230589] Workqueue: mld mld_ifc_work
[ 3406.017224][T230589] RIP: 0010:__ipv6_get_lladdr+0x34/0x60
[ 3406.025780][T230589] Code: 57 10 48 83 c7 08 48 89 e5 48 39 d7 74 3e 48 8d 82 38 ff ff ff eb 13 48 8b 90 d0 00 00 00 48 8d 82 38 ff ff ff 48 39 d7 74 22 <66> 83 78 32 20 77 1b 75 e4 89 ca 23 50 2c 75 dd 48 8b 50 08 48 8b
[ 3406.055748][T230589] RSP: 0018:ffff94e4b3fc3d10 EFLAGS: 00010202
[ 3406.065617][T230589] RAX: dead00000000005a RBX: ffff94e4b3fc3d30 RCX: 0000000000000040
[ 3406.077477][T230589] RDX: dead000000000122 RSI: ffff94e4b3fc3d30 RDI: ffff8c3a31431008
[ 3406.089389][T230589] RBP: ffff94e4b3fc3d10 R08: 0000000000000000 R09: 0000000000000000
[ 3406.101445][T230589] R10: ffff8c3a31430000 R11: 000000000000000b R12: ffff8c2c37887100
[ 3406.113553][T230589] R13: ffff8c3a39537000 R14: 00000000000005dc R15: ffff8c3a31431000
[ 3406.125730][T230589] FS:  0000000000000000(0000) GS:ffff8c3b9fc80000(0000) knlGS:0000000000000000
[ 3406.138992][T230589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3406.149895][T230589] CR2: 00007f0dfea1db60 CR3: 000000387b5f2000 CR4: 0000000000350ee0
[ 3406.162421][T230589] Call Trace:
[ 3406.170235][T230589]  <TASK>
[ 3406.177736][T230589]  mld_newpack+0xfe/0x1a0
[ 3406.186686][T230589]  add_grhead+0x87/0xa0
[ 3406.195498][T230589]  add_grec+0x485/0x4e0
[ 3406.204310][T230589]  ? newidle_balance+0x126/0x3f0
[ 3406.214024][T230589]  mld_ifc_work+0x15d/0x450
[ 3406.223279][T230589]  process_one_work+0x1e6/0x380
[ 3406.232982][T230589]  worker_thread+0x50/0x3a0
[ 3406.242371][T230589]  ? rescuer_thread+0x360/0x360
[ 3406.252175][T230589]  kthread+0x127/0x150
[ 3406.261197][T230589]  ? set_kthread_struct+0x40/0x40
[ 3406.271287][T230589]  ret_from_fork+0x22/0x30
[ 3406.280812][T230589]  </TASK>
[ 3406.288937][T230589] Modules linked in: ... [last unloaded: kheaders]
[ 3406.476714][T230589] ---[ end trace 3525a7655f2f3b9e ]---

Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Reported-by: David Pinilla Caparros <dpini@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/addrconf.h |    2 --
 net/ipv6/addrconf.c    |    4 ++--
 net/ipv6/mcast.c       |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -117,8 +117,6 @@ struct inet6_ifaddr *ipv6_get_ifaddr(str
 int ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
 		       const struct in6_addr *daddr, unsigned int srcprefs,
 		       struct in6_addr *saddr);
-int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
-		      u32 banned_flags);
 int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 		    u32 banned_flags);
 bool inet_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2,
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1851,8 +1851,8 @@ out:
 }
 EXPORT_SYMBOL(ipv6_dev_get_saddr);
 
-int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
-		      u32 banned_flags)
+static int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
+			      u32 banned_flags)
 {
 	struct inet6_ifaddr *ifp;
 	int err = -EADDRNOTAVAIL;
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1776,7 +1776,7 @@ static struct sk_buff *mld_newpack(struc
 	skb_reserve(skb, hlen);
 	skb_tailroom_reserve(skb, mtu, tlen);
 
-	if (__ipv6_get_lladdr(idev, &addr_buf, IFA_F_TENTATIVE)) {
+	if (ipv6_get_lladdr(dev, &addr_buf, IFA_F_TENTATIVE)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
 		 * use unspecified address as the source address
 		 * when a valid link-local address is not available.


