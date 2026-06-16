Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BE447AF4D;
	Tue, 16 Jun 2026 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628616; cv=none; b=fCbJ/zmcNmiLnsSQRVMqaE4TwopioU8TF5BAQoCl1NV5HF9cykAOrPL3J+RrsyVAFU/ey8mni//lgR4rKNoVKGBJpruRNhrYKba6llJVan6o+aSGWIsK/rJckE0PV0FsoBcrg6jehFFVCrTuONAuVNCKbnBaWVavmqYs/QjR0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628616; c=relaxed/simple;
	bh=MnzBoFzhTLPGmxsxaloDxH/Z0uWUtDD2ChK8uhphO3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAMdKqMGWOigkdb0ncWqXqoJXA9dt1Ct5qVgG1+Bg87l9XSacBkuFrlELGyUrQgunHkItpZvSC9pFPSICGdB+du+o+yc6KA8BxVCeVc0Y/nHWbVGgE1JaRnbHJ9KfTqzv3KHdGToXWnsimBRX47R+djY/f5tTnrztB8wZSlEaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaJ2XcO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaJ2XcO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6961F000E9;
	Tue, 16 Jun 2026 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628614;
	bh=uHHi0C9kSKTORN2fRr8JWRQM0IkhNhud11UBllTS/Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GaJ2XcO0D2Yqc6ZaY4Cu3QPmWa7hXA79/rRPok7o+dFOvvQt7LfOz94n3QXkA6kXR
	 7Ybhkpecl1Qs9O0/ZWMdQlQpXh1jMBxdFJ/XtPxLkCxhBvMHh97ppzZd2Yk+KEMKri
	 RPhUJSaUWuu41pnKcSqyG+YnadHkqkN5M68OMEa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 129/452] ip6: vti: Use ip6_tnl.net in vti6_siocdevprivate().
Date: Tue, 16 Jun 2026 20:25:56 +0530
Message-ID: <20260616145124.516015637@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -838,17 +838,24 @@ vti6_siocdevprivate(struct net_device *d
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


