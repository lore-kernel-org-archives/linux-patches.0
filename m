Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4601043B4AA;
	Mon, 17 Aug 2026 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974518; cv=none; b=X9QOYCvml0OwSRvstGPFDIezYAW5AWUzTE+UzqksEkLg7nsfAVRss5ubA2wCpn9XnRX2IdqYtB/ItT4gQY6Ya8W8JKnBCExTRAB3eJjIkPF067/Xj14RjntICTlgqS+wr2ceVLO3Eb1ubDGxL6giI9kt2Df7TWuqTdO/TA7LFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974518; c=relaxed/simple;
	bh=okECKwuS7EcBQwlULs9T0Dz41+p0Ic0njqk4mdL2YAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN3U3nKsVJ3zr5URgyp7P+pRLZZQqJMAbaY+c4/Y96jVrWCmoLVRsmhuXydj/yVvfeXK9Z7wID1eFs1r4vO3f0vakOBdT2DvyEMd9arFCIEFvBZWwJ78cuKwJ6CIBAlEkuAOZvIyooHJbZKFaax2gVzhrEEmJURpv2veUufigjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phUmB6wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phUmB6wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A741F00A3E;
	Mon, 17 Aug 2026 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974515;
	bh=JHYFRJotAnnDbHXwh4KXoc4PmhpLCKD84x3kcQNUMoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phUmB6wbpOlnzLpRlw56Go671Qe3jRDbZeg9+8ewrJ8iyB9jKiog0i8tLWIK09Zd9
	 ra6uf9EoKC7ucaiT9W5HDYuAwrEh8tOFDL76v8DXLkurhZjVqqs2AgwF/1pgOYwV5c
	 u/71PPmrkMoXeJqikBFbe698uLuIxHHouAwpO9SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 232/271] vxlan: do not arm the ageing timer on a device that is down
Date: Mon, 17 Aug 2026 15:32:37 +0200
Message-ID: <20260817132546.304947955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit b37971686ec59fb027fa4910ba16805e68fddb97 upstream.

vxlan_changelink() arms vxlan->age_timer whenever the requested ageing
interval differs from the configured one:

	if (conf.age_interval != vxlan->cfg.age_interval)
		mod_timer(&vxlan->age_timer, jiffies);

There is no netif_running() test, so the timer is armed even on a device
that was never brought up.  The only synchronous cancel in the driver is
the timer_delete_sync() in vxlan_stop(), which is .ndo_stop.
netif_close_many() drops devices without IFF_UP before
__dev_close_many() runs, so that cancel is skipped for such a device.

vxlan_setup() sets dev->needs_free_netdev = true and age_timer is a
member of struct vxlan_dev, so free_netdev() releases the allocation the
timer lives in while it is still queued on a timer_base.
expire_timers() unlinks the entry before it loads timer->function, so
the timer core writes through the freed object's list pointers:

  BUG: KASAN: slab-use-after-free in __run_timers+0x208/0x654
  Write of size 8 at addr ffff00001adace68 by task true/192
   __asan_store8+0x84/0xac
   __run_timers+0x208/0x654
   run_timer_softirq+0x154/0x18c
  Allocated by task 189:
   alloc_netdev_mqs+0x64/0x720
   rtnl_create_link+0x4ac/0x520
   rtnl_newlink+0x758/0xd00
  Freed by task 191:
   netdev_release+0x40/0x58
   netdev_run_todo+0x4a4/0x8c0
   rtnl_dellink+0x200/0x4e8

The rtnl operations involved are netns-scoped, so an unprivileged user
can perform them in a new user and network namespace.

Arming the timer on a down device never had an effect: vxlan_cleanup()
returns early on !netif_running(), and vxlan_open() arms the timer for
any non-zero interval once the device is brought up.  Add the missing
test.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 40051c4dcad5 ("vxlan: Allow changing ageing time")
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260809111829.78834-1-baul.lee@xbow.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -4501,7 +4501,7 @@ static int vxlan_changelink(struct net_d
 	if (change_igmp && vxlan_addr_multicast(&dst->remote_ip))
 		err = vxlan_multicast_leave(vxlan);
 
-	if (conf.age_interval != vxlan->cfg.age_interval)
+	if (netif_running(dev) && conf.age_interval != vxlan->cfg.age_interval)
 		mod_timer(&vxlan->age_timer, jiffies);
 
 	netdev_adjacent_change_commit(dst->remote_dev, lowerdev, dev);


