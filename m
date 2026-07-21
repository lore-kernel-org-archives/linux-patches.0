Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C38B43E08F;
	Tue, 21 Jul 2026 22:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672220; cv=none; b=s3l+wbPGebbupqeGh+cBakBr4AcoYg+SMFXiWnu455ueweSzqVUaQkj83w+K/MCO7jjGZJjBLYc1ppXkcTGLmKQgpkaq+p8jznuc8LRWNDkyIqvqf80/ftyrAZwX00EMi6ub6X1pxhIRZOAcRVw+mRh0JkYUQylqTnhaefoANR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672220; c=relaxed/simple;
	bh=wsQly1CcUPWjr2xP+qy12L7BbFMPfPWvh+PKW24rK08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQOiGTyMq25IStCOHMxxxgrA+7OwXM+vd0vMi66WjV5smk1I9b6dy5SSiXH8rtaOAe5nTu/5+eBoSe4F2fOpXxgqYsa3updpn3Ia9QSQsqJrFJSbIvknOAgIYlRTVUWvo+ON+9rNyxZt4iFV3JO6OUShSV6/Joykj5t+l8RNNwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7vbfnaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7vbfnaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B040C1F000E9;
	Tue, 21 Jul 2026 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672219;
	bh=IfCS/g/Vdm/KsiXBrwRYgSwVWz7s/WKNDHojcCihuQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7vbfnaOU7410Y3KLunHKuAtlh6RVpfUm5zRBjZT7S8rzuJSPHpZ/wQMjBcONBfkz
	 37bNlY8DuhIylV5KDVSvYpA4u2QY15GbP1hD0WBx5Q4OSHbImFaIcbdwrc6s7dwg3M
	 YbDZhUiwsBMzE1rDQabyLP773uLfTl6uumeur8us=
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
Subject: [PATCH 5.15 499/843] bridge: stp: Fix a potential use-after-free when deleting a bridge
Date: Tue, 21 Jul 2026 17:22:14 +0200
Message-ID: <20260721152417.257490987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 1f70441cbada89..7fb8014b846993 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -381,6 +381,9 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 
 	br_fdb_delete_by_port(br, NULL, 0, 1);
 
+	timer_shutdown_sync(&br->hello_timer);
+	timer_shutdown_sync(&br->topology_change_timer);
+	timer_shutdown_sync(&br->tcn_timer);
 	cancel_delayed_work_sync(&br->gc_work);
 
 	br_sysfs_delbr(br->dev);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1d80f34a139c33..9bfdef0b04513c 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -365,7 +365,8 @@ void br_topology_change_detection(struct net_bridge *br)
 {
 	int isroot = br_is_root_bridge(br);
 
-	if (br->stp_enabled != BR_KERNEL_STP)
+	if (br->stp_enabled != BR_KERNEL_STP ||
+	    !(br->dev->flags & IFF_UP))
 		return;
 
 	br_info(br, "topology change detected, %s\n",
-- 
2.53.0



