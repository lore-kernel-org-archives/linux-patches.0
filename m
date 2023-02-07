Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BFE3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DA3C4339B;
	Tue,  7 Feb 2023 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774829;
	bh=AUebvd6v4scMe9/e/pcvhHI853JwgDvh+p9dUrOVVrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DU4YM7vE/cAwPHpvScmFjqSptjqXRcqjFp3R8cs57OVLVaGaunih89Jcyk+g1MfwE
	 YGyyEMSwX7JG28Oklrd7RHw20MBGajpJkgo2XXow+1GAYMSXoG3wFxv/iT4XXJm0Dn
	 4qtxI8syk5KLxc21GtpmP2JpmJ52p7MIS9awBuAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Kalb <andre.kalb@sma.de>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/208] net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices
Date: Tue,  7 Feb 2023 13:55:01 +0100
Message-Id: <20230207125636.411686291@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andre Kalb <andre.kalb@sma.de>

[ Upstream commit 422ae7d9c7221e8d4c8526d0f54106307d69d2dc ]

The probe() function is only used for the DP83822 PHY, leaving the
private data pointer uninitialized for the smaller DP83825/26 models.
While all uses of the private data structure are hidden in 82822 specific
callbacks, configuring the interrupt is shared across all models.
This causes a NULL pointer dereference on the smaller PHYs as it accesses
the private data unchecked. Verifying the pointer avoids that.

Fixes: 5dc39fd5ef35 ("net: phy: DP83822: Add ability to advertise Fiber connection")
Signed-off-by: Andre Kalb <andre.kalb@sma.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/Y9FzniUhUtbaGKU7@pc6682
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index b60db8b6f477..267e6fd3d444 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -233,7 +233,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 
-		if (!dp83822->fx_enabled)
+		/* Private data pointer is NULL on DP83825/26 */
+		if (!dp83822 || !dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_COMPLETE_INT_EN |
 				       DP83822_DUP_MODE_CHANGE_INT_EN |
 				       DP83822_SPEED_CHANGED_INT_EN;
@@ -253,7 +254,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_PAGE_RX_INT_EN |
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
-		if (!dp83822->fx_enabled)
+		/* Private data pointer is NULL on DP83825/26 */
+		if (!dp83822 || !dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
-- 
2.39.0



