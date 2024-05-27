Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7166616088F;
	Mon, 27 May 2024 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837390; cv=none; b=CfDvC4Jw/SDljkCqTf3XkeE0ffVjhhzx/s2j5dKUfxgV4Le51w7QutR8ggXIeySG5Oowrpaf/hDRLslq7x/IBv1CBLDZTtuXcegIhR8/14+60ecYyG2MnMlDf6+kLFZEtt6MtreZLeCdufN2OVRM/kZlrjhwcCbRtYa/d88SpkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837390; c=relaxed/simple;
	bh=1HGpPqzqd9OILOrcBWurIQIJylL3tVYRUjfSGPC9fgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nea/CxrZ1Ar+OIwgl7bubwLueQtthcN82x+j0elgdOCQI35E9SrRz3FOz9BKJ17qaIizGiUi1GbaoRTm/nkAPx8B/G3BB8hvJZ9Y7VIN9h+NPtPOoaEurzHcaHTRvAizemu6mZt4SiMKhMWQde+oEHzjpVhuGcOVCdhxpNCQ3Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb2LJgpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb2LJgpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A425C2BBFC;
	Mon, 27 May 2024 19:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837390;
	bh=1HGpPqzqd9OILOrcBWurIQIJylL3tVYRUjfSGPC9fgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb2LJgpnM4gL1zM84iS1pm/wEDdxH2aB88PgnNjBIUWVjuSOvnYZKsU1deCervUCY
	 e21MpKRh0qENrytmHWywuqCoXFHppGCA3xq6tpxGhrWKwZcfjZ3lke0Czt2Sn9jYlQ
	 AxjlANzRC7KPp83Hg0Ts6cbh9o/ch2t2wctRTtnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 422/427] net: wangxun: fix to change Rx features
Date: Mon, 27 May 2024 20:57:49 +0200
Message-ID: <20240527185635.765589498@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 6fae161cbcb82..667a5675998cb 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2690,12 +2690,14 @@ int wx_set_features(struct net_device *netdev, netdev_features_t features)
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



