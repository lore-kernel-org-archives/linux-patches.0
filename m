Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3159B1E98EF;
	Sun,  7 Jun 2026 10:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829042; cv=none; b=mP2h1SofwybAS22OFAk4UH8mKzGTCncMfU2jSHUyKZ1yQmLMwB3GYxNL8oJbe4/EZbevive3Ne0S2fdodfSQ7RxWDr6dF2EbR1qhL1v/ZDxQRFWAcbI2eTPTzznrJckZY1Cjcs5OKY+h2erDBqZ4lQjw9h2cKc8jRzLPEeGjyeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829042; c=relaxed/simple;
	bh=toRBTPbVQ9QvarUcXOtZA7Frmey27JhxNBICPlbQcm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhxbShdM5dfPB6iv8qsoBOl8sni4KSgj+Wfd80f62YmzGD/btaTfLAyBNfog7ulLz6O01QaiKaK4JVqK3F+YkjqSGBoTIqr685NFbVKfNuCsi7oHkGrVgUQQSeSGuXTwlIL6uB6n0xA3QQB999q14zPYfhX/7ohlhZV+oHyKG58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSc5n1cJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSc5n1cJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959081F00893;
	Sun,  7 Jun 2026 10:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829041;
	bh=270w0kQnl+soGM6z8bB8m5P+sa732lShod5mCAG6hCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSc5n1cJNvJIo7qhxNoU56fZVi0KmvUnS0uW3FdIU5eHjYhvQfUwLjIOyLmWyPkM+
	 w+xQEotD//TKIq0Oukpw3sfmQSn3iuAZobobtxF3bL772aVBms1B5uE+LAVpY4hXpo
	 xLvnzn9VRY206PhEXP1OJeI9ND7oIhtpq7+Ue1rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 189/307] ip6: vti: Use ip6_tnl.net in vti6_siocdevprivate().
Date: Sun,  7 Jun 2026 11:59:46 +0200
Message-ID: <20260607095734.662790770@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 8b484efd5cb4eeef9021a661e198edc5349dacf6 upstream.

After patch 1/2 in this series, vti6_update() unlinks and relinks
the tunnel through t->net. vti6_siocdevprivate() still uses
dev_net(dev) for the collision lookup. For a tunnel moved through
IFLA_NET_NS_FD, dev_net(dev) is the new netns, not t->net.

SIOCCHGTUNNEL on a migrated tunnel then runs:

  net = dev_net(dev)                    /* migrated netns */
  t   = vti6_locate(net, &p1, false)    /* misses target in t->net */
  ...
  t   = netdev_priv(dev)
  vti6_update(t, &p1, false)            /* mutates t->net's hash */

A caller in the migrated netns picks params that match a tunnel
in the creation netns. The lookup in dev_net(dev) finds nothing.
vti6_update() prepends the migrated tunnel at the head of the
creation netns hash bucket for those params. Later lookups in
the creation netns resolve to the migrated device. xfrm receive
delivers the matched packets through a device the caller controls.

Reachable from an unprivileged user namespace (unshare --user
--map-root-user --net). Cross tenant scope on container hosts.

Switch the SIOCCHGTUNNEL path on a non fallback device to use
t->net for the lookup. The lookup now matches the netns
vti6_update() operates on.

Also add ns_capable(self->net->user_ns, CAP_NET_ADMIN) before
the lookup. The check at the top of the case is against
dev_net(dev)->user_ns, which after migration is the attacker's
netns. A caller there can pick params absent from self->net,
the lookup returns NULL, t becomes self, and vti6_update()
inserts the device into the creation netns hash. The new check
requires CAP_NET_ADMIN in the creation netns user_ns too.

SIOCADDTUNNEL and SIOCCHGTUNNEL on the fallback device keep
dev_net(dev), which equals init_net there.

Fixes: 61220ab34948 ("vti6: Enable namespace changing")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: Xiao Liang <shaw.leon@gmail.com>
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260521130555.3421684-3-maoyixie.tju@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_vti.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -834,17 +834,24 @@ vti6_siocdevprivate(struct net_device *d
 		if (p.proto != IPPROTO_IPV6  && p.proto != 0)
 			break;
 		vti6_parm_from_user(&p1, &p);
-		t = vti6_locate(net, &p1, cmd == SIOCADDTUNNEL);
 		if (dev != ip6n->fb_tnl_dev && cmd == SIOCCHGTUNNEL) {
+			struct ip6_tnl *self = netdev_priv(dev);
+
+			err = -EPERM;
+			if (!ns_capable(self->net->user_ns, CAP_NET_ADMIN))
+				break;
+			t = vti6_locate(self->net, &p1, false);
 			if (t) {
 				if (t->dev != dev) {
 					err = -EEXIST;
 					break;
 				}
 			} else
-				t = netdev_priv(dev);
+				t = self;
 
 			err = vti6_update(t, &p1, false);
+		} else {
+			t = vti6_locate(net, &p1, cmd == SIOCADDTUNNEL);
 		}
 		if (t) {
 			err = 0;


