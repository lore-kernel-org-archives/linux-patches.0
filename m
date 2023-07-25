Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319A1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9836C433C7;
	Tue, 25 Jul 2023 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283682;
	bh=xJGyyhFic/yxs9i+oDOE5mH6+UnpnsTPmVqc9xHgdAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVGQenHU7vsw1T2Wsk4jPqFY3JzUnB6KphV0DO793O2zrYKOmMLaY2nzUvlPTi5o/
	 jde2btDq2GU2LF8oH2fOXDrg3GXBtUl7lqO/kJAJJ3l3Oe75DQbeLCE/Q9qyQKW9Vo
	 P8quTyS0cjteuVM5dK7DkBcp7WcU9FBL1i3pvExA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Kochetkov <fido_max@inbox.ru>,
	Robert Hancock <robert.hancock@calian.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/509] net: axienet: Move reset before 64-bit DMA detection
Date: Tue, 25 Jul 2023 12:40:23 +0200
Message-ID: <20230725104557.554790690@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit f1bc9fc4a06de0108e0dca2a9a7e99ba1fc632f9 ]

64-bit DMA detection will fail if axienet was started before (by boot
loader, boot ROM, etc). In this state axienet will not start properly.
XAXIDMA_TX_CDESC_OFFSET + 4 register (MM2S_CURDESC_MSB) is used to detect
64-bit DMA capability here. But datasheet says: When DMACR.RS is 1
(axienet is in enabled state), CURDESC_PTR becomes Read Only (RO) and
is used to fetch the first descriptor. So iowrite32()/ioread32() trick
to this register to detect 64-bit DMA will not work.
So move axienet reset before 64-bit DMA detection.

Fixes: f735c40ed93c ("net: axienet: Autodetect 64-bit DMA capability")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/20230622192245.116864-1-fido_max@inbox.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3d91baf2e55aa..9d362283196aa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2009,6 +2009,11 @@ static int axienet_probe(struct platform_device *pdev)
 		goto cleanup_clk;
 	}
 
+	/* Reset core now that clocks are enabled, prior to accessing MDIO */
+	ret = __axienet_device_reset(lp);
+	if (ret)
+		goto cleanup_clk;
+
 	/* Autodetect the need for 64-bit DMA pointers.
 	 * When the IP is configured for a bus width bigger than 32 bits,
 	 * writing the MSB registers is mandatory, even if they are all 0.
@@ -2055,11 +2060,6 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
 
-	/* Reset core now that clocks are enabled, prior to accessing MDIO */
-	ret = __axienet_device_reset(lp);
-	if (ret)
-		goto cleanup_clk;
-
 	ret = axienet_mdio_setup(lp);
 	if (ret)
 		dev_warn(&pdev->dev,
-- 
2.39.2



