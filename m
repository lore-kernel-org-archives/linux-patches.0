Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9725A198E70;
	Thu,  6 Jun 2024 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683445; cv=none; b=pdS1Yk1ML6B+UPvO0VJuvQ0IPiSoc7Yt6zxPGK6t/pLJssH9t/J++PhzIszfpwD4yeqA0RL5PcqArCfhnYc6UMd54mG1/DuTVgBv2UKX4sWzGLkJsUqXVh5lWIZJLj6bQCyqnSQdykYnZGpIx2Lz+GiCxRsxov9chhSSF1hFMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683445; c=relaxed/simple;
	bh=g4asM2f2VTEZaFRCRTQ8rQTmUNDSrIiAj/9ziJCM5mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBrEAx+cqKu4ijuk3mO8PAazoFDTIzoOrGAK3BA6YGBt7ka70F1vtGhzvqfUOKYUDClXtIqbmypvCABPIP0kp7BjpP4RmtHR6gbnPE8zTHjsYdv+KnZrKpv1uE4KjYs6ZhQfz2TOGhIlMiJX0r1ifWV5QdZ1/NBODs7zlEwW8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1btvGEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1btvGEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6801EC4AF07;
	Thu,  6 Jun 2024 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683445;
	bh=g4asM2f2VTEZaFRCRTQ8rQTmUNDSrIiAj/9ziJCM5mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1btvGEFBHuYyzxUckVH5xeFx65D+6UI/2ObI99eb+osOqqxeLlZQEHzUd5dAbCBc
	 dP9CkXkmYb1RqtY9KUgIcDkRU8kY5MbgEm69lo59+uxpYVWKC27mgwuDHasVvybHLe
	 zhKIDvqz4mlY6XtQBp7zvIsYOVzmzcUravfe6eTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 389/744] net: wangxun: fix to change Rx features
Date: Thu,  6 Jun 2024 16:01:01 +0200
Message-ID: <20240606131744.942617277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be434c833c69c..e9310d9ca67c9 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2646,12 +2646,14 @@ int wx_set_features(struct net_device *netdev, netdev_features_t features)
 	else
 		wr32m(wx, WX_RDB_RA_CTL, WX_RDB_RA_CTL_RSS_EN, 0);
 
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



