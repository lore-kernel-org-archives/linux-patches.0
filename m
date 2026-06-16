Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17CB478E41;
	Tue, 16 Jun 2026 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630950; cv=none; b=G4NTQr/HNOL6gCXicqOzRxCDa1QNMGgmZq6dLVpIxza8wlOw6aDqwgDup2Dt15K2Xd9u+Pv6fIa2YsIhkGeOsyIf3AXbBRz+ZQhVKKAMKgnpGLKimEqauD7smSxNzmITlaUagADpZhuAji8H1GAoM2sPC78xHJ+/qzEdK/VPH6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630950; c=relaxed/simple;
	bh=NHrkX6uc4x1u4XTGMwIWgWKOGxwg8gTnZZsbqAua0ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6POSQKRBuPtE0nzAUlcg5Q9RuQr4Ku3n2K4/HMmszOC7QaVHG4WGwBaJ6yAz4vAcaqDJbHbG/QHLX8gTIH0GZw7w6jHbK2iLADhzR6xlVPg/nBnHPPbA5PNTWRpz6evQgmpCzswb0DIaEM+EBtZY/31WIatMsoiTe1TKkL68rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iifwyicm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iifwyicm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817361F000E9;
	Tue, 16 Jun 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630949;
	bh=BI+Nt9M1VL0Y7mgQhKlcQRokIjbF5PiEr7nDji2lGfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iifwyicmKgKkR9c72YFKTmpcYl34eXW3NH87gAsDkBXhHv/H4ZZLODzLGGaOzy8xc
	 kZzeH2MZ5j1syz6xJRtLbT4L4aU3rjVVDICMSwnX59qt9JOChF6fKt1JIGwV+MkD0T
	 HE3KZNhWpFx/ONuTZnjbFr6jgqTYEWqGFXFEFF8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 127/522] ip6: vti: Use ip6_tnl.net in vti6_changelink().
Date: Tue, 16 Jun 2026 20:24:34 +0530
Message-ID: <20260616145131.943516478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 11b326fb0a374f4654f9be22d0f0f7abd9f7d3fe upstream.

ip netns add ns1
ip netns add ns2
ip -n ns1 link add vti6_test type vti6 remote ::1 local ::2 key 7
ip -n ns1 link set vti6_test netns ns2
ip -n ns2 link set vti6_test type vti6 remote ::3 local ::4 key 9
ip netns del ns2
ip netns del ns1
[  132.495484] ------------[ cut here ]------------
[  132.497609] kernel BUG at net/core/dev.c:12376!

Commit 61220ab34948 ("vti6: Enable namespace changing") dropped
NETIF_F_NETNS_LOCAL from vti6 devices. A vti6 tunnel can then
move through IFLA_NET_NS_FD. After the move dev_net(dev) points
at the new netns while t->net stays at the creation netns.

vti6_changelink() and vti6_update() still use dev_net(dev) and
dev_net(t->dev). They unlink from one per netns hash and relink
into another. The creation netns is left with a stale entry.
cleanup_net() of that netns later walks freed memory.

Reachable from an unprivileged user namespace (unshare --user
--map-root-user --net). Cross tenant scope on container hosts.

Fixes: 61220ab34948 ("vti6: Enable namespace changing")
Reported-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260521130555.3421684-2-maoyixie.tju@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_vti.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -728,10 +728,11 @@ vti6_tnl_change(struct ip6_tnl *t, const
 static int vti6_update(struct ip6_tnl *t, struct __ip6_tnl_parm *p,
 		       bool keep_mtu)
 {
-	struct net *net = dev_net(t->dev);
-	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
+	struct net *net = t->net;
+	struct vti6_net *ip6n;
 	int err;
 
+	ip6n = net_generic(net, vti6_net_id);
 	vti6_tnl_unlink(ip6n, t);
 	synchronize_net();
 	err = vti6_tnl_change(t, p, keep_mtu);
@@ -1045,11 +1046,12 @@ static int vti6_changelink(struct net_de
 			   struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
-	struct ip6_tnl *t;
+	struct ip6_tnl *t = netdev_priv(dev);
+	struct net *net = t->net;
 	struct __ip6_tnl_parm p;
-	struct net *net = dev_net(dev);
-	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
+	struct vti6_net *ip6n;
 
+	ip6n = net_generic(net, vti6_net_id);
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;
 


