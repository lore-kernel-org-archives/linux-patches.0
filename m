Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B74208A7;
	Sun,  1 Sep 2024 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209750; cv=none; b=IXTpEene84pwjzVfWwrbLPLFXZWxoCZwP1RhIerCTkazN74w0ewLbtOvni75yUq9TTWSNgMzx2oIALr2CJaBDdQsrQiv5zgpqCs5DNPjcZWAJr/P0rl11vBNxOhwVqRBvHyLC/MeuCv2tsGOQSdZdPj8GB+xreCZTTP+lV84+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209750; c=relaxed/simple;
	bh=m4BQ9uNEAhFPen6EWHRbOn64UcJK2arU9H+skXC3i9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXsHX7vP+F5SHuorzAtz0CLYyB1oAPADD/aOqmsryXXifuaEMoaszD7YJq9+nvCtEMz5UX5XWO/qifyAcbMsEMCXjYXUStJMZu7nETZ8Lslq16OwwVGbQM6Yl++K3l4UR39qYKaEtfd9Vog5WXdQ2P/FIwiAAhrVhcGPxj4Hi40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz3MQZ8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz3MQZ8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFDFC4CEC3;
	Sun,  1 Sep 2024 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209750;
	bh=m4BQ9uNEAhFPen6EWHRbOn64UcJK2arU9H+skXC3i9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tz3MQZ8J/hW8L9Pbur4dqiZjymVMwcZb8pwnJwV90TvfnhKxlh8Zr3YQZk9GlAZ5y
	 zxWx1Bie2t9LMNimJm5jJLD491XmVW/snxnEXuk6r2ZICmFIz8H1wK4X5h0tHKHNQ7
	 QXDQGPD8u7Ov+VUQ2q8gVEIA5JrhlunjDcPHx48A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/151] net: xilinx: axienet: Always disable promiscuous mode
Date: Sun,  1 Sep 2024 18:17:42 +0200
Message-ID: <20240901160817.948289368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 4ae738dfef2c0323752ab81786e2d298c9939321 ]

If promiscuous mode is disabled when there are fewer than four multicast
addresses, then it will not be reflected in the hardware. Fix this by
always clearing the promiscuous mode flag even when we program multicast
addresses.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240822154059.1066595-2-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 2a5a3f8761c30..b814ef1da3c73 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -427,6 +427,10 @@ static void axienet_set_multicast_list(struct net_device *ndev)
 	} else if (!netdev_mc_empty(ndev)) {
 		struct netdev_hw_addr *ha;
 
+		reg = axienet_ior(lp, XAE_FMI_OFFSET);
+		reg &= ~XAE_FMI_PM_MASK;
+		axienet_iow(lp, XAE_FMI_OFFSET, reg);
+
 		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
 			if (i >= XAE_MULTICAST_CAM_TABLE_NUM)
-- 
2.43.0



