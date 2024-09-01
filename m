Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E042C6AF;
	Sun,  1 Sep 2024 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210314; cv=none; b=e3anmiCoFWzba0P92s9r+3IADm+I7USKotogvX0EoaMV7ffn23yKvfR0dD/1mmkTCeOhQGt33nXBG2oJ1ngBhTZ2q6OXobsTxCw+CO4+wK+/zkHcRCMo00nVF9a9AXYG5PEJiNnPMqmG5Jpi5oJCZYjXImslBxdpg9Ge+FNEv/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210314; c=relaxed/simple;
	bh=M50m7uDUVdC5Rswm6aQ0up/PBFSBt5VX7Ihj8oJ5gC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2Lou8v9RBijy7QTCvSxMMFLZlumsdq0Jbg8QMqRzM8LApCWr4126aqK/D/XysGasBhj76GS/cThm5v7ou4PEFs68IPjEoLql6tDyd8+8km4XOWn4LsaVPodVnGW65kk7+0za5MaE8hcsSuTtDlIGmKdEHmx8cKcGUD2lyh5tcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy/t3LWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy/t3LWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A380C4CEC4;
	Sun,  1 Sep 2024 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210314;
	bh=M50m7uDUVdC5Rswm6aQ0up/PBFSBt5VX7Ihj8oJ5gC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy/t3LWwZ8n+eyPXuxiIdfmdKKHFBvoMcVq3cTpXTDEZjzHKGuUNBNGPul12y9n2/
	 mGpvMQM3SDEXpK50hD/BJkozVhQgTrJMgPjXdPEvGOZ1HfitVPAmp1LikCzr6xCTmj
	 Xsyg1Bwj9K8ZLvWyagyiehOP3tw6vs/636fM+Nk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/215] net: xilinx: axienet: Always disable promiscuous mode
Date: Sun,  1 Sep 2024 18:17:45 +0200
Message-ID: <20240901160829.147309943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 63f33126d02fe..79f559178bb38 100644
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



