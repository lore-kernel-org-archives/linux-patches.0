Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48267322551;
	Mon, 18 Aug 2025 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523090; cv=none; b=qv9ptK87X9V8kJ1+I/siEdirrxdVhnK9yajzE2ButpQ6MIjP0REAbLmRbZ41ouwzxRLqV87FG00S9HFi1+BIrd0X1DQVBnb35vm2Fkdkj3AS+EuzC4C8DcwvdswC3qHHFXcD3g49LiMbNFYs8jRImmjpOvyBPwCoFiuWA8TWW0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523090; c=relaxed/simple;
	bh=Qdv0DNEac48T2egtxfxI4Lh0HUfcV/rPQpWm9YnAEoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVJvRZx6PclcyD1gYl6o+9KZZOlsxLwMiAehUvfhVY3SWwpm5/fvGK/DhOKJOawqMSGyi9KNbuQ/yJBNsY2ikIGqp6h5cGKQ7bNbrd+N4zCtXAI9rqtPSsZYjbOxQl7xqqp3SmjUbY4m3qoGiZ4/DaF8kzObUSb4mG4zXQJeXZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrWEaUA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrWEaUA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F710C4CEEB;
	Mon, 18 Aug 2025 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523089;
	bh=Qdv0DNEac48T2egtxfxI4Lh0HUfcV/rPQpWm9YnAEoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrWEaUA4GLdnKFr7QhgeQugG9zjgugZofwwjaZE+Fe2Uhk9J47H1nn5pkhi4Jhcd1
	 SEBDd0y8Mtj19UKXGa9cpo+gLDPJYX9iO12xvaQ0S35UwImgm2Asc+dX9xCxrty5Ej
	 axPtYRXMMxaT7cNFKcsTqjXa44jZTJidLxNDhmuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+e67ea9c235b13b4f0020@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 067/515] net: lapbether: ignore ops-locked netdevs
Date: Mon, 18 Aug 2025 14:40:53 +0200
Message-ID: <20250818124500.978007305@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 53898ebabe843bfa7baea9dae152797d5d0563c9 ]

Syzkaller managed to trigger lock dependency in xsk_notify via
register_netdevice. As discussed in [0], using register_netdevice
in the notifiers is problematic so skip adding lapbeth for ops-locked
devices.

       xsk_notifier+0xa4/0x280 net/xdp/xsk.c:1645
       notifier_call_chain+0xbc/0x410 kernel/notifier.c:85
       call_netdevice_notifiers_info+0xbe/0x140 net/core/dev.c:2230
       call_netdevice_notifiers_extack net/core/dev.c:2268 [inline]
       call_netdevice_notifiers net/core/dev.c:2282 [inline]
       unregister_netdevice_many_notify+0xf9d/0x2700 net/core/dev.c:12077
       unregister_netdevice_many net/core/dev.c:12140 [inline]
       unregister_netdevice_queue+0x305/0x3f0 net/core/dev.c:11984
       register_netdevice+0x18f1/0x2270 net/core/dev.c:11149
       lapbeth_new_device drivers/net/wan/lapbether.c:420 [inline]
       lapbeth_device_event+0x5b1/0xbe0 drivers/net/wan/lapbether.c:462
       notifier_call_chain+0xbc/0x410 kernel/notifier.c:85
       call_netdevice_notifiers_info+0xbe/0x140 net/core/dev.c:2230
       call_netdevice_notifiers_extack net/core/dev.c:2268 [inline]
       call_netdevice_notifiers net/core/dev.c:2282 [inline]
       __dev_notify_flags+0x12c/0x2e0 net/core/dev.c:9497
       netif_change_flags+0x108/0x160 net/core/dev.c:9526
       dev_change_flags+0xba/0x250 net/core/dev_api.c:68
       devinet_ioctl+0x11d5/0x1f50 net/ipv4/devinet.c:1200
       inet_ioctl+0x3a7/0x3f0 net/ipv4/af_inet.c:1001

0: https://lore.kernel.org/netdev/20250625140357.6203d0af@kernel.org/
Fixes: 4c975fd70002 ("net: hold instance lock during NETDEV_REGISTER/UP")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: syzbot+e67ea9c235b13b4f0020@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e67ea9c235b13b4f0020
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250806213726.1383379-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 995a7207bdf8..f357a7ac70ac 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -81,7 +81,7 @@ static struct lapbethdev *lapbeth_get_x25_dev(struct net_device *dev)
 
 static __inline__ int dev_is_ethdev(struct net_device *dev)
 {
-	return dev->type == ARPHRD_ETHER && strncmp(dev->name, "dummy", 5);
+	return dev->type == ARPHRD_ETHER && !netdev_need_ops_lock(dev);
 }
 
 /* ------------------------------------------------------------------------ */
-- 
2.50.1



