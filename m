Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205A761FDF;
	Mon, 27 May 2024 19:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838700; cv=none; b=bB/JSA9I4i130JN32iPpWWR1+WkMXu1T2IoMKCKo9ibn5b1Ttih6bp+wggJYPTVNYm5U1TzoJLe6gku34xwn+NIZsvNFdVElXjq2MLoGsMfZddTY2vMnrYfG/EOkmUhj7zgzL87qwsS0OM0H/5miQEJP/sjvdjHPeFA15ZWiKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838700; c=relaxed/simple;
	bh=v4mtvjDMrelEFpACNQwZecDp1Zi1z5PfAmdCbZBsNq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYHirEp2yvgMlxVoSaQtFyvjz8do4TcKwrzEGJA60FyWIt7uo2WWjnRH2rxQydTP8660ULxpccqDjzdIFTrK4EejEAHVv42kf2u3KfUhgIyRL5Yn5UUQHkHylSQOCQbirnLG3uiro4pT6ZNspOdELbUNlJoEcwmF1CtokggabUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdROVFz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdROVFz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B9C2BBFC;
	Mon, 27 May 2024 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838700;
	bh=v4mtvjDMrelEFpACNQwZecDp1Zi1z5PfAmdCbZBsNq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdROVFz8XI6VtvA7HHLk1h57qKD5p1LKKFPHWp0ZM4K5mEKsuOdtQisxBE7Ev8wom
	 eb3hADtwfat5szknHDtfsjpkYoqqj66MMCvyzQii/ZHybq22bdgmZYx2trK3gflrOI
	 qrQ89XpnLNxfdrbJ/vk4JWDgXlRnFtQf0H5Lq/q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 484/493] net: wangxun: fix to change Rx features
Date: Mon, 27 May 2024 20:58:06 +0200
Message-ID: <20240527185645.969023222@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 68067f065ee730c7c67b361c3c81808d25d5a90b ]

Fix the issue where some Rx features cannot be changed.

When using ethtool -K to turn off rx offload, it returns error and
displays "Could not change any device features". And netdev->features
is not assigned a new value to actually configure the hardware.

Fixes: 6dbedcffcf54 ("net: libwx: Implement xx_set_features ops")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 08d3e4069c5fa..6aa6073476f7d 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2694,12 +2694,14 @@ int wx_set_features(struct net_device *netdev, netdev_features_t features)
 		wx->rss_enabled = false;
 	}
 
+	netdev->features = features;
+
 	if (changed &
 	    (NETIF_F_HW_VLAN_CTAG_RX |
 	     NETIF_F_HW_VLAN_STAG_RX))
 		wx_set_rx_mode(netdev);
 
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL(wx_set_features);
 
-- 
2.43.0



