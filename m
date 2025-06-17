Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71991FBEA8;
	Tue, 17 Jun 2025 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177707; cv=none; b=FEp3qkZpopCqjFV5viNkseUMX0k+aVvowV3QBHQ8xS4BCD7R2YGuPa8vodokhZxg5FnIJI8wry+eu2o5AZHj1N4l7OYl2DNDJZTJojoKxBUEQy8QNbN6kBFwbsBMXBA0mP66pgoDeM3O51TsLLJQKIg8Cr1HL7ll2+2Cu+mllow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177707; c=relaxed/simple;
	bh=zCt400L9Y4ciene1f82nKC5UnSqtOe+XXZqv39OrMwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiGfimwHA3IlSljZ03DbK9tETuoIQZB8AOK7g6EDG9XlZyJshribarjjQBty8jhJH35fwKEznoVwoybSVQCfBVUzhkTHVmu82Kn9R3SlTFWwZjNSHsjp9aBMYBImIZ17rTDYnhQHiTwbuZStCjwS2M1UzXkuNzw7KE6LU69CDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1l4StGfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l4StGfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D671C4CEE3;
	Tue, 17 Jun 2025 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177707;
	bh=zCt400L9Y4ciene1f82nKC5UnSqtOe+XXZqv39OrMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l4StGfa3ovv5pHYHZiy83B2rCxIDmX0hQ6KJo+BCPkZ1zm8t3FNL9ZOALvh1j2SM
	 e/QCXjmMifX/qmJhOws2xh3iVkoyCal4rpggWRNt01YCl6F2HkVDzedgQFu6hgczvc
	 oBzXjVUhtBpdoQEustzLEm6tsuUOkSdp3/zlvzU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 331/780] net: lan743x: Fix PHY reset handling during initialization and WOL
Date: Tue, 17 Jun 2025 17:20:39 +0200
Message-ID: <20250617152504.930767357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit 82d1096ca8b5dbb3158d707e6fb3ad21c3403a49 ]

Remove lan743x_phy_init from lan743x_hardware_init as it resets the PHY
registers, causing WOL to fail on subsequent attempts. Add a call to
lan743x_hw_reset_phy in the probe function to ensure the PHY is reset
during device initialization.

Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250526053048.287095-3-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index da5bd54208dd5..7f36443832ada 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1346,11 +1346,6 @@ static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 				  50000, 1000000);
 }
 
-static int lan743x_phy_init(struct lan743x_adapter *adapter)
-{
-	return lan743x_hw_reset_phy(adapter);
-}
-
 static void lan743x_phy_interface_select(struct lan743x_adapter *adapter)
 {
 	u32 id_rev;
@@ -3534,10 +3529,6 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 	if (ret)
 		return ret;
 
-	ret = lan743x_phy_init(adapter);
-	if (ret)
-		return ret;
-
 	ret = lan743x_ptp_init(adapter);
 	if (ret)
 		return ret;
@@ -3674,6 +3665,10 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 	if (ret)
 		goto cleanup_pci;
 
+	ret = lan743x_hw_reset_phy(adapter);
+	if (ret)
+		goto cleanup_pci;
+
 	ret = lan743x_hardware_init(adapter, pdev);
 	if (ret)
 		goto cleanup_pci;
-- 
2.39.5



