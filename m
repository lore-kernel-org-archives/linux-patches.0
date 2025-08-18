Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE831335BC3;
	Mon, 18 Aug 2025 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524823; cv=none; b=kJwBVqJbGqlLojiygJbaY1LG2339SLHSZF3PgDj55fdQX89kR1T7d+/sFDIrwxQ57uWJvaXv2cGyCOo2xOFiLCWaxNu10SEUJ62GF84WWkeQ/rU2I2vP4r9fVvD16pxAdicoyyT9hC28smt0yNAx+XQjo8E3vnyAKfTE8TbRbYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524823; c=relaxed/simple;
	bh=qUlo1UbU4wffR6w/Ybj8A2HV1YchxDO3f6OcIrYJRNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz+lUTXbaFs4UxudUg7t0o11P/DdgJ8x9BN3otyy81kmkcytGsb88vMJ+A1ji6lws4u9UccCihDwrh4bmoTisqeZeXRlyN5/9tBaW29i8o3tlDW5bEWZYgrv+uTtm58D3vDrb2cfsWOTlpcvuNBV80CNunWBTz6kEMqhyGX++cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f++PxzjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f++PxzjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9FBC4CEEB;
	Mon, 18 Aug 2025 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524822;
	bh=qUlo1UbU4wffR6w/Ybj8A2HV1YchxDO3f6OcIrYJRNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f++PxzjMkPh8p78ykzDg/216g+DLZ4/ggCuyEpOL7JO9XECm08Com2L6PwcuYkeKQ
	 Zz1Bv+0ut1m9mvqOAwifzgp2ySjxZRIw3FjHhr8Aw4TEmVLdPCdLq+9iH5RR2wsjvP
	 w9CBYAe5s32mRfoY4Oht0cQXF3KJ5bF+UAFtHCRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+e67ea9c235b13b4f0020@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 074/570] net: lapbether: ignore ops-locked netdevs
Date: Mon, 18 Aug 2025 14:41:01 +0200
Message-ID: <20250818124508.679468952@linuxfoundation.org>
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



