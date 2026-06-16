Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF69331A44;
	Tue, 16 Jun 2026 18:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635580; cv=none; b=s3goEHTlftTOxUIm45Z21/dHH0IAfoCSPd9Z3j8tQk39bRCxApL7pjcFpsVzhpCdRnL3PdCAURB6eRx/ggWbWCp9R27C5UJI0V/cSWl0reuzzJiL/OXpeNOOgo9nbp5AZBN2oU/Kccb5Qap7pF/81+mPSXRePCSNynkb9CaJj6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635580; c=relaxed/simple;
	bh=ys23uhD38OrleZ/NywCcb6wIkKsk+H0j/niiPw5BpWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaGstag7m0yQGk3RGBr6hBTfJssKDkG4r7INmM0weQRK2cAOXR75NjBpQTAY4IG4LmyWtg4Idr4sw9VujM9xbQyG8UXuxlyZkTUUirOKOOiRhsLw8moRSywSbzC7TExWDC2FTyGWV1y1Vg5Z+D/SEPJ/fTGgrq9+mnBDWas2uG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt65BNEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt65BNEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A2C1F000E9;
	Tue, 16 Jun 2026 18:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635578;
	bh=NJZcb/fJ5fNmH1css+K2vN/U3rsNFya80BBRr+XYrXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tt65BNEwmO+Hzp8mAfOusviSXfewPYqHkqgtwheFMHLPjeLnAyQNumRDj5FHMf80L
	 6NSPCUr5MH6dcP3By3lFae1vEJtFf1u3ZhgKEn+i5udKV3pmytZCEb/WgNmNoMsCXk
	 eFMJbTpGxFLH0Lsmmu0a4kvqqWsUjdlPWHwmlNoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 075/342] ip6: vti: Use ip6_tnl.net in vti6_changelink().
Date: Tue, 16 Jun 2026 20:26:11 +0530
Message-ID: <20260616145051.738373650@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
@@ -725,10 +725,11 @@ vti6_tnl_change(struct ip6_tnl *t, const
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
@@ -1040,11 +1041,12 @@ static int vti6_changelink(struct net_de
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
 


