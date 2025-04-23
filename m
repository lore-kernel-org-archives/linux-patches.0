Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C3B1EFFB9;
	Wed, 23 Apr 2025 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420166; cv=none; b=AoxhfBDAc+YnEWgmxdzCl9eFaNlwY3SOCshARhE/pWw6FRhir6Qh1DzVOWXC1X7s8BURpIYPe40HHc5UgdFMG0KEAUmkwue1MLgOpTl94addYNguTEh4dxVTLrrSCkNXS3g7XLTvChALmgMot3y2781FHLs5HalJMdLfgDe7cI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420166; c=relaxed/simple;
	bh=/LcMsWxdnmK57ex0fXe+ddf6+MDFPcjhb70L0W4UDn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqdv8jZmH1MaKj/BOKBbntAzA89CChuI8Yyna5BiW/xzCeKnMfwiu/C0UrXYjgp4xUHbsTQAB5ki5cEq4m39fn/cxxpefY3mqsSegV+Ij+fVBSUzQXI+YUMEkemqQfmvXauqIuAfyQ83ghn9CrtF6QAcea8pLZz02VxjO+vyLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOpaxwtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOpaxwtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9961EC4CEE3;
	Wed, 23 Apr 2025 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420165;
	bh=/LcMsWxdnmK57ex0fXe+ddf6+MDFPcjhb70L0W4UDn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOpaxwtBOOOrgIu6OtCLiyrVRGWaXlQm3uOw+77FpaHQuKjZnuF5cD2dFji14GViY
	 PDfxeDY21/BjwQTsU29pxsyez//0a0OG+y8RQy6vqCPLUFThF5X5kbj3XoFDQ3nYyj
	 QD7YU63gPHgqoj1aHHXagkti46DJ9wpf73w3fh9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 050/241] net: hibmcge: fix not restore rx pause mac addr after reset issue
Date: Wed, 23 Apr 2025 16:41:54 +0200
Message-ID: <20250423142622.551344262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit ae6c1dce3244e31011ee65f89fc2484f3cf6cf85 ]

The MAC hardware supports receiving two types of
pause frames from link partner.
One is a pause frame with a destination address
of 01:80:C2:00:00:01.
The other is a pause frame whose destination address
is the address of the hibmcge driver.

01:80:C2:00:00:01 is supported by default.

In .ndo_set_mac_address(), the hibmcge driver calls
.hbg_hw_set_rx_pause_mac_addr() to set its mac address as the
destination address of the rx puase frame.
Therefore, pause frames with two types of MAC addresses can be received.

Currently, the rx pause addr does not restored after reset.
As a result, pause frames whose destination address is
the hibmcge driver address cannot be correctly received.

This patch restores the configuration by calling
.hbg_hw_set_rx_pause_mac_addr() after reset is complete.

Fixes: 3f5a61f6d504 ("net: hibmcge: Add reset supported in this module")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250410021327.590362-7-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c
index 4d1f4a33391a8..5e288db06d6f6 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c
@@ -26,12 +26,15 @@ static void hbg_restore_mac_table(struct hbg_priv *priv)
 
 static void hbg_restore_user_def_settings(struct hbg_priv *priv)
 {
+	/* The index of host mac is always 0. */
+	u64 rx_pause_addr = ether_addr_to_u64(priv->filter.mac_table[0].addr);
 	struct ethtool_pauseparam *pause_param = &priv->user_def.pause_param;
 
 	hbg_restore_mac_table(priv);
 	hbg_hw_set_mtu(priv, priv->netdev->mtu);
 	hbg_hw_set_pause_enable(priv, pause_param->tx_pause,
 				pause_param->rx_pause);
+	hbg_hw_set_rx_pause_mac_addr(priv, rx_pause_addr);
 }
 
 int hbg_rebuild(struct hbg_priv *priv)
-- 
2.39.5



