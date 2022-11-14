Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9304C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F09C433B5;
	Mon, 14 Nov 2022 13:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430962;
	bh=yCN/iiM1viNY8rYVxmWJp3Gq4iYKURvbmIjrk1MpCVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJ/m16m4MzQFA1jZRzMhXAtdb6C4REN6LxqYaecbG9BQC+FJcS5XxhPtJaCaOYhGB
	 cIEIxGglWeMo9SZ5d+79Ve+2qlAEqNh9i86QU1wyMtMRpjRZ6pu5zV9vbsM1zWZ7QN
	 0/mNY8fjg96yvFrhcYwmAhZYyDMuFXN3Xt7KCyrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HW He <hw.he@mediatek.com>,
	Loic Poulain <loic.poulain@linaro.org>,
	Zhaoping Shu <zhaoping.shu@mediatek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/190] net: wwan: iosm: fix memory leak in ipc_wwan_dellink
Date: Mon, 14 Nov 2022 13:44:34 +0100
Message-Id: <20221114124500.981834002@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: HW He <hw.he@mediatek.com>

[ Upstream commit f25caaca424703d5a0607310f0452f978f1f78d9 ]

IOSM driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch sets needs_free_netdev to true when registers
network device, which makes netdev subsystem call free_netdev()
automatically after unregister_netdevice().

Fixes: 2a54f2c77934 ("net: iosm: net driver")
Signed-off-by: HW He <hw.he@mediatek.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Zhaoping Shu <zhaoping.shu@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 4712f01a7e33..3d70b34f96e3 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -168,6 +168,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 	iosm_dev->max_mtu = ETH_MAX_MTU;
 
 	iosm_dev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	iosm_dev->needs_free_netdev = true;
 
 	iosm_dev->netdev_ops = &ipc_inm_ops;
 }
-- 
2.35.1



