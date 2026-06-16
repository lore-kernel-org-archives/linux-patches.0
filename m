Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279823D75CE;
	Tue, 16 Jun 2026 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635569; cv=none; b=cfR9zlOdjf/E7w9bUxnJ5dJS0ksQnPenpoRpGxMcwes9qAvrjrdS2ruQWu2Al8DQp/w2L4Lq2MVeg+niI9MrXGAD6mQA6lc7+HnfWw8S5iIU6BUdOkaz2GaZjC87t1ahbc8WEKu+j33FU7XbZEbk/JvGaIfTQoHHOidwIGDSK6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635569; c=relaxed/simple;
	bh=BHzIdCcqYwChEyCIBkzqlrZU0Hv/r5D6uOtemn6iCmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQzL1WY0iL3uR42T7YDs+C+l1Y1wt72H5mrbVKMCIil5ToPQGnWKC3+w1n7c8CmZI89ExYXJUFwsyRi1SCPcQxtst3/lRByv8IvnB4ulFek606vOZxrCjvSEl+d6LykcS50xwCEb2yDkzmTFMbZU02tAHrMxJ+5k3XLGupH7Hho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRu+46u+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRu+46u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45731F000E9;
	Tue, 16 Jun 2026 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635567;
	bh=SNcaryhRU9dBDjvlE53Z9DUa2CEFKmiSbUOXu+c+ebs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRu+46u++4OrONUdZIHwZctqDnokQxwONrJJE+TWQ6ED6rGfpAnWWDK7HBkYxyysO
	 h4FnAXzrhS1SU06VezsXjLbSbK8OqTqgUSbjza4yqFdwYlyFAgz81PmFf8EG5ZP/24
	 UlEYLWO1uwbPNnyisjlZwVtXTy300qXhg2cR0JD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 073/342] ip6: vti: Use ip6_tnl.net in vti6_siocdevprivate().
Date: Tue, 16 Jun 2026 20:26:09 +0530
Message-ID: <20260616145051.645951708@linuxfoundation.org>
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
@@ -836,17 +836,24 @@ vti6_ioctl(struct net_device *dev, struc
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


