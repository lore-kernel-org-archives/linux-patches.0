Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF1328B58;
	Fri,  9 Jan 2026 12:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960740; cv=none; b=DkRDrhuOHhwB3C/z3EhGm5PlHWH2xZCdA2F76V56NMtzm+JIU9d113Mb5liL3Z6hkx3qJAfkj4U6uLeHE24Ih0KE7rLMrbIVZrVAxHwetJuhsbsJ885SUzPKtjoGOD2yI5GTarcnlwGUw+e4Yr3kX/iXjhqfncLJjwiKNcq8Gfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960740; c=relaxed/simple;
	bh=F1Z1rOLyiDblID/8WnJrGhYcqCcxdi8e9neK2nxSmoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpV6CbCkUHvsA+tE8qPfaf3E+BaxZyAzhvKk4TinsOEnrjs+NMePE6Ma4Nn9obg1yuppaOYFYzuH719xhtrM1IMUh8gNwLxA9Syuh+f0ZL2490YUGZOLn+GT6vcgT7OVkfyQii47RJ5J1QP+7eGYAU9v2cDfbOhhnao8pc1cHag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9xXS6Xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9xXS6Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4975C4CEF1;
	Fri,  9 Jan 2026 12:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960740;
	bh=F1Z1rOLyiDblID/8WnJrGhYcqCcxdi8e9neK2nxSmoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9xXS6XuWXclWyxPnfqskH98qQWKgW84B2Rxe0ImIXAif5AQOtsvrcc9ISOLgGbB0
	 GDOL7g8L1nYMtA3RuLsi1XeQ2RtBHllYnHu+sS/vvQVs5EDuBg21holl7PzWnE9L87
	 QvQ4NuyI7b7JaayIpwvtForBFbYKcT2TdYKn3sZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 509/737] net: openvswitch: Avoid needlessly taking the RTNL on vport destroy
Date: Fri,  9 Jan 2026 12:40:48 +0100
Message-ID: <20260109112153.145706397@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 5498227676303e3ffa9a3a46214af96bc3e81314 ]

The openvswitch teardown code will immediately call
ovs_netdev_detach_dev() in response to a NETDEV_UNREGISTER notification.
It will then start the dp_notify_work workqueue, which will later end up
calling the vport destroy() callback. This callback takes the RTNL to do
another ovs_netdev_detach_port(), which in this case is unnecessary.
This causes extra pressure on the RTNL, in some cases leading to
"unregister_netdevice: waiting for XX to become free" warnings on
teardown.

We can straight-forwardly avoid the extra RTNL lock acquisition by
checking the device flags before taking the lock, and skip the locking
altogether if the IFF_OVS_DATAPATH flag has already been unset.

Fixes: b07c26511e94 ("openvswitch: fix vport-netdev unregister")
Tested-by: Adrian Moreno <amorenoz@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20251211115006.228876-1-toke@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport-netdev.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 903537a5da22..3c41d53bb9e9 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -153,10 +153,19 @@ void ovs_netdev_detach_dev(struct vport *vport)
 
 static void netdev_destroy(struct vport *vport)
 {
-	rtnl_lock();
-	if (netif_is_ovs_port(vport->dev))
-		ovs_netdev_detach_dev(vport);
-	rtnl_unlock();
+	/* When called from ovs_db_notify_wq() after a dp_device_event(), the
+	 * port has already been detached, so we can avoid taking the RTNL by
+	 * checking this first.
+	 */
+	if (netif_is_ovs_port(vport->dev)) {
+		rtnl_lock();
+		/* Check again while holding the lock to ensure we don't race
+		 * with the netdev notifier and detach twice.
+		 */
+		if (netif_is_ovs_port(vport->dev))
+			ovs_netdev_detach_dev(vport);
+		rtnl_unlock();
+	}
 
 	call_rcu(&vport->rcu, vport_netdev_free);
 }
-- 
2.51.0



