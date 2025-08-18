Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A330322551;
	Mon, 18 Aug 2025 13:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523093; cv=none; b=kE52zEzjL1kl1STMOUwMq8gk6OgJJhTZwaU8TqL5jeE4SB7AkogUrYGYQago4u9nCbWaOVKhRZ1tTOes65+ayx0e8Y0SCU9MUb5OwlzJAIzvwLWf2YWSCPOeoqylPW156e+Dxarm0uqoRS3unW+0w8nElIOiM9Ys7ZrHfKBuCG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523093; c=relaxed/simple;
	bh=2gh+dNSgY6LAcVro4sUQKe/b9NFUGSKHLEG+QEVSWgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE/q/fj9tfUqIVK9C0/84Diz+FwHliC2g9U536jnbxfEzO2r0EujCNNOgKwwNNpjKfQjtk7e61wrFtipyalxM+pjTh34c1BHBzLBi6uEx86pXevo7B1fJXEStyfke1Kt4aNauLJVLcfroxY3z3BaQT+xVrEsp+/G7QUCzEjHeuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnZHSgip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnZHSgip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05F9C4CEEB;
	Mon, 18 Aug 2025 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523093;
	bh=2gh+dNSgY6LAcVro4sUQKe/b9NFUGSKHLEG+QEVSWgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnZHSgiplSalLsapeA6NOER75KdfySS2GRM8z5eTCTRhy8+PyEKhjNF3ocKoEu+Kz
	 VHJDJjS2kaahGjR7AE4/Uw9J/FAxJX/8t84K4tgP8GeOY8uacO64qkc/6ksbeytUTD
	 gpV5LbJi6qsf3GSFnLedz7n9F2qrA2nU0ETmneD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+e6300f66a999a6612477@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 068/515] hamradio: ignore ops-locked netdevs
Date: Mon, 18 Aug 2025 14:40:54 +0200
Message-ID: <20250818124501.013794510@linuxfoundation.org>
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



