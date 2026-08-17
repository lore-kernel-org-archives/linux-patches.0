Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC17282F29;
	Mon, 17 Aug 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977814; cv=none; b=Wvx67xqNy78W+NhSNcufqC/iy3qBVAYia5cGNJaXMK2PhZIO+0qXdUJbQnWlRBJ/u+sVwK067oHpc/g/6mjLpHdLgI7UGdUcTCD+0UnVm9sxr8/bu5B+QMXVkPNZSY8G/a64MmILNoH7myjw75/07Iqh6kQue8KHIuvmwbSv0fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977814; c=relaxed/simple;
	bh=4pe0kpnmOJhgXO4YwC4zKg27i8Cq4oBXKNvEraBoVJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1h6fVcXMnRT8wVF42lUXLRgK+xOkP8ZL3Fv4m78x08wly8lPGP1LCpPZNlhOLdPDNfdjrO8u43JvnAKWpsEr3nrF3E4+wnlVxCbz5Wd6odBoIAX6Q5OYIjCqS40JsYxkIH2seWT3cvjKeajUc8pGAjLAy0Nllwdv4Qv0dcSCHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQyTEExx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQyTEExx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B7E1F000E9;
	Mon, 17 Aug 2026 14:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977813;
	bh=8/dFfI9gfS73pr+WyIEtcsgHoS7AzWUNAPSORTj0mRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQyTEExx/XIFJFOBt1E5eVTaqTVmzTIzjxjT2eGPKHZOEoItUK5n2LomlE9VfLQ4U
	 vaPB9krnZCaObbXxC54jnRhB8KtfPIgCe4w5/969qO8sYB5fNEWv63BQwAn95XW35D
	 CtL38/V9teykDzyUDu/ois4U8+Jd0sW8FzA6lr3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 442/456] vxlan: do not arm the ageing timer on a device that is down
Date: Mon, 17 Aug 2026 15:33:52 +0200
Message-ID: <20260817132556.376041553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -4319,7 +4319,7 @@ static int vxlan_changelink(struct net_d
 		spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 	}
 
-	if (conf.age_interval != vxlan->cfg.age_interval)
+	if (netif_running(dev) && conf.age_interval != vxlan->cfg.age_interval)
 		mod_timer(&vxlan->age_timer, jiffies);
 
 	netdev_adjacent_change_commit(dst->remote_dev, lowerdev, dev);


