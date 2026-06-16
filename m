Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461043D88F2;
	Tue, 16 Jun 2026 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633685; cv=none; b=dPsY7zZPc6T4kde2MDa5zsyQdfNm2XpM5CAzyY+onpKDlSdZgDXYS01F6VcS2e5oQN1B11zj+dOO/rqbhpVbAWHxmWT3mb9iBY0tM5VmL12MMQ1PVgoK816gJFGOIOZ1cqQdaWQ0nXyD83/eL4g2AY1buEHmgj5IJe9h+d9/cdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633685; c=relaxed/simple;
	bh=VAa0qcn/g4u+W0X9jICgHztf6U6Tx/TM8UQeAJpVxwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSpj/w7c8/QxahcVzctWZrhHGKszLzWAabjIXyqb8QtNWU9jOM99Gcl4CkbDWZPezDf7CAw0WD3iNJ+BDp9ahB6XpOrsGze0wlHnK/GvOpcLBqMDWVbuCfdPHGxlp9e4JhsTtwROP4H9bNuXXUEIVCW4VVJdUwYzhY1wc7idj+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsOqzVB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsOqzVB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5AE1F000E9;
	Tue, 16 Jun 2026 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633682;
	bh=ttAPQ/weayqsFLVFbybngtkzswN4Zwfhw3Xp9DFRl5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsOqzVB5Fo1d6gtZ2kcMXG0UJ8sL7eV4IAUHjmK9jnga4NQMutAScD94t4nZA83Jy
	 YOcHKLFixPsqX4vbTRNGLe0R8xjrbCB5JqScq+TG2zHS2vltOcpBmA6zF02W3XIgUF
	 wgdrFZ8ZA9XIU4Ek2Ue0vmr3O0UVA//2zESZgNsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 092/411] ip6: vti: Use ip6_tnl.net in vti6_changelink().
Date: Tue, 16 Jun 2026 20:25:30 +0530
Message-ID: <20260616145105.112802941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
@@ -1044,11 +1045,12 @@ static int vti6_changelink(struct net_de
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
 


