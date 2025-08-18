Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C62335BAA;
	Mon, 18 Aug 2025 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524825; cv=none; b=dCrSa/uOmAyJf3aYYOB7ijSqXs5i8wpKYkyDs/juzCB/vy0huk3N8xkcmwM+SKdSWz7gnnoTcF1Y8gKAB4yKKTpN7mgFM891L5HNQa6cuo7W1AC2NIzEprNGZ7NpDXrfl4b8QCzjelN8EUkpuVDe7DHStSEnXMqQCTNYo7Dgswc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524825; c=relaxed/simple;
	bh=lYYpiNXz9I5LSzHPXgRqW6Wrsjd3lehn00BzQPFF5LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHcLvhtBXFfyvJ9X2aPeyZJ+DmxK6Z4tEIK+xshVLmxfEWor5VC6JDrDCPx7KZouPKGIwBoxrXEU5sjc7SAyuRRBhHVEqbfSEezOMwzVBZTnk0j0eXY1q5V0sVG6qbnW8mgjOFQZm5KqIJgvtHS1ztc9fh6aZYxTbLyKvO1r1BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqhSJdSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqhSJdSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134D5C4CEEB;
	Mon, 18 Aug 2025 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524825;
	bh=lYYpiNXz9I5LSzHPXgRqW6Wrsjd3lehn00BzQPFF5LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqhSJdSpDyXEnLacAxG9HMp0JmCo2QpV4/AcJOgaRM6k+tM0aUHIYW28bwXQiP7Qq
	 SpoCnpeeChz7XKdezzbMT4/trNt3jARUnpE4Z986K2vaICPQjXuwi8Xwv1vJulOxl2
	 uTtwISGWiQlNtwbgVyeuYM0Fd71G4kAWQBQgrA8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+e6300f66a999a6612477@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 075/570] hamradio: ignore ops-locked netdevs
Date: Mon, 18 Aug 2025 14:41:02 +0200
Message-ID: <20250818124508.716021684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit c64237960819aee1766d03f446ae6de94b1e3f73 ]

Syzkaller managed to trigger lock dependency in xsk_notify via
register_netdevice. As discussed in [0], using register_netdevice
in the notifiers is problematic so skip adding hamradio for ops-locked
devices.

       xsk_notifier+0x89/0x230 net/xdp/xsk.c:1664
       notifier_call_chain+0x1b6/0x3e0 kernel/notifier.c:85
       call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
       call_netdevice_notifiers net/core/dev.c:2281 [inline]
       unregister_netdevice_many_notify+0x14d7/0x1ff0 net/core/dev.c:12156
       unregister_netdevice_many net/core/dev.c:12219 [inline]
       unregister_netdevice_queue+0x33c/0x380 net/core/dev.c:12063
       register_netdevice+0x1689/0x1ae0 net/core/dev.c:11241
       bpq_new_device drivers/net/hamradio/bpqether.c:481 [inline]
       bpq_device_event+0x491/0x600 drivers/net/hamradio/bpqether.c:523
       notifier_call_chain+0x1b6/0x3e0 kernel/notifier.c:85
       call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
       call_netdevice_notifiers net/core/dev.c:2281 [inline]
       __dev_notify_flags+0x18d/0x2e0 net/core/dev.c:-1
       netif_change_flags+0xe8/0x1a0 net/core/dev.c:9608
       dev_change_flags+0x130/0x260 net/core/dev_api.c:68
       devinet_ioctl+0xbb4/0x1b50 net/ipv4/devinet.c:1200
       inet_ioctl+0x3c0/0x4c0 net/ipv4/af_inet.c:1001

0: https://lore.kernel.org/netdev/20250625140357.6203d0af@kernel.org/
Fixes: 4c975fd70002 ("net: hold instance lock during NETDEV_REGISTER/UP")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: syzbot+e6300f66a999a6612477@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e6300f66a999a6612477
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250806213726.1383379-2-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 0e0fe32d2da4..045c5177262e 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -138,7 +138,7 @@ static inline struct net_device *bpq_get_ax25_dev(struct net_device *dev)
 
 static inline int dev_is_ethdev(struct net_device *dev)
 {
-	return dev->type == ARPHRD_ETHER && strncmp(dev->name, "dummy", 5);
+	return dev->type == ARPHRD_ETHER && !netdev_need_ops_lock(dev);
 }
 
 /* ------------------------------------------------------------------------ */
-- 
2.50.1



