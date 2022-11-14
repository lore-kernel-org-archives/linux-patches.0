Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611594C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3029C433C1;
	Mon, 14 Nov 2022 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430478;
	bh=GEKTbl+Xb4gm5PiM1gfG8Mj8wVHRQEFVCKi3d5MdWg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TU8JYhetimyLQx0ySrH8tHaxUmgsijlAU4stSvdjwg5dldM3m16B05fBH0h0oEtIf
	 aonJeF4orxQvJelYAPNnsO7RQjOZkYvj0eY0bwk/1DrX/A7/VbxDCl7LXSUQOKZCUb
	 +DLdYcm0GywbHD+8R3GCvC540C0BZ+7yCE5+RI7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HW He <hw.he@mediatek.com>,
	Zhaoping Shu <zhaoping.shu@mediatek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/131] net: wwan: mhi: fix memory leak in mhi_mbim_dellink
Date: Mon, 14 Nov 2022 13:45:09 +0100
Message-Id: <20221114124450.403006871@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

[ Upstream commit 668205b9c9f94d5ed6ab00cce9a46a654c2b5d16 ]

MHI driver registers network device without setting the
needs_free_netdev flag, and does NOT call free_netdev() when
unregisters network device, which causes a memory leak.

This patch sets needs_free_netdev to true when registers
network device, which makes netdev subsystem call free_netdev()
automatically after unregister_netdevice().

Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
Signed-off-by: HW He <hw.he@mediatek.com>
Signed-off-by: Zhaoping Shu <zhaoping.shu@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 6872782e8dd8..ef70bb7c88ad 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -582,6 +582,7 @@ static void mhi_mbim_setup(struct net_device *ndev)
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = MHI_MAX_BUF_SZ - ndev->needed_headroom;
 	ndev->tx_queue_len = 1000;
+	ndev->needs_free_netdev = true;
 }
 
 static const struct wwan_ops mhi_mbim_wwan_ops = {
-- 
2.35.1



