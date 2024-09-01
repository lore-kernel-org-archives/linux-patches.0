Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB217F394;
	Sun,  1 Sep 2024 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207834; cv=none; b=JoLNSDz/DArWqv7JO3FmLqNjb6v4ygCn80jnX3SxqhuQ+tLSIVyDjlshSM2wnfLJRAugZyLxKzhDg5HLtJSv5E8noVV8ZABdnJCYYpLidAGMf0dmnXtuAyVRgDUppyigu3oONrGm/V4V1oCJw/o2mn07qavtiF3+IDOe6eylb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207834; c=relaxed/simple;
	bh=DAhVyLlVw78+Q7fIvIasemk0AZb7mN/6Eo2/EIv0Vnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mm0mK+bs2c5amWRnk/x/DU3+QJYAuw5TJl7mRdGjYeNzUiuFLR7vtMtY06vGtQG2x5bmecO7Hl1nzsaD/BJyH3tQcUOVTZFJpoegdGNbI1yqpDERKADaOrrmVOn4tmx6K3p+QDiBeyZ9Hojvist9QGyG4hfhF3rz6BdmOnVyqTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQK98LK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQK98LK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FB5C4CEC3;
	Sun,  1 Sep 2024 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207834;
	bh=DAhVyLlVw78+Q7fIvIasemk0AZb7mN/6Eo2/EIv0Vnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQK98LK/kok+/cO11HqpdI2gRsqjiJVBudAigk+aN3s+CjkZUQTHrLsofhw26PxG6
	 TLsxBxqjrVQ+Km7rl1l0VFbe+k0SV7JCrU1xF7jFjUktHyx5jRX4bP+L7xsJ04sCau
	 wbECYfMbahGfDYdkShMrT6Q29epIiHT7KEZ5Bs6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/98] net: xilinx: axienet: Always disable promiscuous mode
Date: Sun,  1 Sep 2024 18:16:30 +0200
Message-ID: <20240901160805.962577652@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 299162a74939f..71593b1a90e87 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -375,6 +375,10 @@ static void axienet_set_multicast_list(struct net_device *ndev)
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



