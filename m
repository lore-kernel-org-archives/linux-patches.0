Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336DC3D382;
	Thu, 30 Nov 2023 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jV/6Dy6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2228C433C8;
	Thu, 30 Nov 2023 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361926;
	bh=ZrZsXEvmlpBjWqCZLIy4sk29ZpurCzK5+AIi4XiTf8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV/6Dy6z2u5fifhKlVWyhYoC/rRlTHysoA3SMkDA02/tXvie4+XleEuPq1z+VNZ+G
	 PikUz/dnBU+8wqAg1/xaRJGeeFJPGqzxgQReRQKjDqq7Eaxe/t4bxIURcrlISyve+s
	 TfKrBaA8Xt46LyYpcE8hxOq47B9kbN0iREBWvkgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/69] amd-xgbe: handle corner-case during sfp hotplug
Date: Thu, 30 Nov 2023 16:22:15 +0000
Message-ID: <20231130162133.683194140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 676ec53844cbdf2f47e68a076cdff7f0ec6cbe3f ]

Force the mode change for SFI in Fixed PHY configurations. Fixed PHY
configurations needs PLL to be enabled while doing mode set. When the
SFP module isn't connected during boot, driver assumes AN is ON and
attempts auto-negotiation. However, if the connected SFP comes up in
Fixed PHY configuration the link will not come up as PLL isn't enabled
while the initial mode set command is issued. So, force the mode change
for SFI in Fixed PHY configuration to fix link issues.

Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index ca7372369b3e6..60be836b294bb 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1178,7 +1178,19 @@ static int xgbe_phy_config_fixed(struct xgbe_prv_data *pdata)
 	if (pdata->phy.duplex != DUPLEX_FULL)
 		return -EINVAL;
 
-	xgbe_set_mode(pdata, mode);
+	/* Force the mode change for SFI in Fixed PHY config.
+	 * Fixed PHY configs needs PLL to be enabled while doing mode set.
+	 * When the SFP module isn't connected during boot, driver assumes
+	 * AN is ON and attempts autonegotiation. However, if the connected
+	 * SFP comes up in Fixed PHY config, the link will not come up as
+	 * PLL isn't enabled while the initial mode set command is issued.
+	 * So, force the mode change for SFI in Fixed PHY configuration to
+	 * fix link issues.
+	 */
+	if (mode == XGBE_MODE_SFI)
+		xgbe_change_mode(pdata, mode);
+	else
+		xgbe_set_mode(pdata, mode);
 
 	return 0;
 }
-- 
2.42.0



