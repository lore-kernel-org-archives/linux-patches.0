Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286A83161BF;
	Tue, 21 Jul 2026 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653601; cv=none; b=Tehpl4YysAdEDsX/KiXJcmYoq/LlXcARIWTNmevSsvfk9mLsg/NpUSrHpannzvjIT6sekB7xUrgF6sbz5F3nYA/YNIbBBrDzI6wA0q8URNBuH8hQVeMhr9bbS/1zUsLJKPVpHyzQbcCawVrkNJKf/Se7DNGewxJwWtKUYJDMPXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653601; c=relaxed/simple;
	bh=M5DgpyHbE7OY3/D3MNY7zOi4mClvXiWKllk8AGJT5gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E48rgf9P1edDA9ehPELbNC1NFT3V9ji1qlEEW8BliVj983mjJFdc7gXN/aW3LUeOHAMr7VT7eVX146Wb9KBtBkcF4X/hSeDk8pbmNDnbT97363A0fWgIqA6DW7zdf/l4gt4vJ6DrjOQapXs/K9Y/M/xIJRX4KkrnjWuPkuB6Eiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVZqb6X0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVZqb6X0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9543B1F000E9;
	Tue, 21 Jul 2026 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653600;
	bh=kimnry2GKy6s25mOS5IY78uqC2e2Qp4br9bBPjXbGto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVZqb6X0/B6odeOxJxXu7tZ6zE56wIqm1toa+9grzJFN5+zn8cuQjT1lrgJQ34Ry8
	 YHOGV30gW55GiRGQegPEeO851qKgw10Owk2+0Jnhn8wxqeRJ/nhLWvyBC37jzQbkuJ
	 ltjRj0l+9YuxXppEEctwjSCt5ujIpKVQWlSV39Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Neil Young <contact@ssd-disclosure.com>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1335/2077] bridge: stp: Fix a potential use-after-free when deleting a bridge
Date: Tue, 21 Jul 2026 17:16:48 +0200
Message-ID: <20260721152624.302733639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 2a00517db8de4be7df3d483b215c5544fb30a191 ]

The three STP timers are not supposed to be armed while the bridge is
administratively down. They are synchronously deactivated when the
bridge is put administratively down and the various call sites check for
'IFF_UP' before arming them.

This check is missing from br_topology_change_detection() and it is
possible to engineer a situation in which the topology change timer is
armed while the bridge is administratively down, resulting in a
use-after-free [1] when the bridge is deleted.

Fix by adding the missing check and for good measures synchronously
shutdown the three timers when the bridge is deleted.

[1]
ODEBUG: free active (active state 0) object: ffff88811662b9b0 object type: timer_list hint: br_topology_change_timer_expired (net/bridge/br_stp_timer.c:120)
WARNING: lib/debugobjects.c:629 at debug_print_object+0x1bc/0x450, CPU#9: ip/359

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Reported-by: Neil Young <contact@ssd-disclosure.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260629072117.497959-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c  | 3 +++
 net/bridge/br_stp.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index d39571e1374443..ec773e4ab92ecc 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -391,6 +391,9 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 
 	br_fdb_delete_by_port(br, NULL, 0, 1);
 
+	timer_shutdown_sync(&br->hello_timer);
+	timer_shutdown_sync(&br->topology_change_timer);
+	timer_shutdown_sync(&br->tcn_timer);
 	cancel_delayed_work_sync(&br->gc_work);
 
 	br_sysfs_delbr(br->dev);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 024210f9546830..76a2df165ffc84 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -371,7 +371,8 @@ void br_topology_change_detection(struct net_bridge *br)
 {
 	int isroot = br_is_root_bridge(br);
 
-	if (br->stp_enabled != BR_KERNEL_STP)
+	if (br->stp_enabled != BR_KERNEL_STP ||
+	    !(br->dev->flags & IFF_UP))
 		return;
 
 	br_info(br, "topology change detected, %s\n",
-- 
2.53.0



