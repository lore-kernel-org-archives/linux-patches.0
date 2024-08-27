Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E1B12E4D;
	Tue, 27 Aug 2024 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771444; cv=none; b=pmkcrkz9CN/jWgiyIbWuHrtZWNTYFjdF8A5E4DPCjtFoeWtkoFD90y1JhUdLAe4mrG3zDGQP7AP1P8blN0T/tFq7+bNSExzQicKgXyz6ubHcEgkhkrZxWAlJ+4UfXJ9aK90IvJAzOd2jX/FjtIVbCPFS2biQvUXV8vGNiSlpts4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771444; c=relaxed/simple;
	bh=koFcD5NsZFM88yH8dLsYj2ZMgqoqcejqHtyWwnEK0Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+9eM05cFyTSDSw48tFMwADxgZrllNk9xbgIlNwQ9OYy6Fbc9u5jDeBPDh3Gkq7qlYZHn+xKXUB6gmyK7p5IMKpOf12Dj6WwNlcMouQ1N1VHTVHdWGhcDBKe38ToXd4yp1BgAFm2arSTXL+evhIQSe5Whji12P3UMlwlyH8UCCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az07hbhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az07hbhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5668DC4DDEB;
	Tue, 27 Aug 2024 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771444;
	bh=koFcD5NsZFM88yH8dLsYj2ZMgqoqcejqHtyWwnEK0Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=az07hbhCotxzPU9GzZfr0xf/mDCs4uIL1JEHTGJfw0AtYar/5KHfvWh1go2HnEJor
	 zicAJ9jQu2SYcQ9XNa+3LS2jHPOcCF5wD8mHWxijH1Zfh6fk3wI7Z8svaCptBNXWSF
	 FLZIV+HyHuIqMURvwEfmVOdqICarUy0/peCdU3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 189/273] net: xilinx: axienet: Fix dangling multicast addresses
Date: Tue, 27 Aug 2024 16:38:33 +0200
Message-ID: <20240827143840.600163059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 797a68c9de0f5a5447baf4bd3bb9c10a3993435b ]

If a multicast address is removed but there are still some multicast
addresses, that address would remain programmed into the frame filter.
Fix this by explicitly setting the enable bit for each filter.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240822154059.1066595-3-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  1 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 21 ++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index c7d9221fafdcb..09c9f9787180b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -170,6 +170,7 @@
 #define XAE_UAW0_OFFSET		0x00000700 /* Unicast address word 0 */
 #define XAE_UAW1_OFFSET		0x00000704 /* Unicast address word 1 */
 #define XAE_FMI_OFFSET		0x00000708 /* Frame Filter Control */
+#define XAE_FFE_OFFSET		0x0000070C /* Frame Filter Enable */
 #define XAE_AF0_OFFSET		0x00000710 /* Address Filter 0 */
 #define XAE_AF1_OFFSET		0x00000714 /* Address Filter 1 */
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b2e4d0b11a7d7..559c0d60d9483 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -432,7 +432,7 @@ static int netdev_set_mac_address(struct net_device *ndev, void *p)
  */
 static void axienet_set_multicast_list(struct net_device *ndev)
 {
-	int i;
+	int i = 0;
 	u32 reg, af0reg, af1reg;
 	struct axienet_local *lp = netdev_priv(ndev);
 
@@ -454,7 +454,6 @@ static void axienet_set_multicast_list(struct net_device *ndev)
 		reg &= ~XAE_FMI_PM_MASK;
 		axienet_iow(lp, XAE_FMI_OFFSET, reg);
 
-		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
 			if (i >= XAE_MULTICAST_CAM_TABLE_NUM)
 				break;
@@ -473,6 +472,7 @@ static void axienet_set_multicast_list(struct net_device *ndev)
 			axienet_iow(lp, XAE_FMI_OFFSET, reg);
 			axienet_iow(lp, XAE_AF0_OFFSET, af0reg);
 			axienet_iow(lp, XAE_AF1_OFFSET, af1reg);
+			axienet_iow(lp, XAE_FFE_OFFSET, 1);
 			i++;
 		}
 	} else {
@@ -480,18 +480,15 @@ static void axienet_set_multicast_list(struct net_device *ndev)
 		reg &= ~XAE_FMI_PM_MASK;
 
 		axienet_iow(lp, XAE_FMI_OFFSET, reg);
-
-		for (i = 0; i < XAE_MULTICAST_CAM_TABLE_NUM; i++) {
-			reg = axienet_ior(lp, XAE_FMI_OFFSET) & 0xFFFFFF00;
-			reg |= i;
-
-			axienet_iow(lp, XAE_FMI_OFFSET, reg);
-			axienet_iow(lp, XAE_AF0_OFFSET, 0);
-			axienet_iow(lp, XAE_AF1_OFFSET, 0);
-		}
-
 		dev_info(&ndev->dev, "Promiscuous mode disabled.\n");
 	}
+
+	for (; i < XAE_MULTICAST_CAM_TABLE_NUM; i++) {
+		reg = axienet_ior(lp, XAE_FMI_OFFSET) & 0xFFFFFF00;
+		reg |= i;
+		axienet_iow(lp, XAE_FMI_OFFSET, reg);
+		axienet_iow(lp, XAE_FFE_OFFSET, 0);
+	}
 }
 
 /**
-- 
2.43.0



