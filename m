Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7442E4271;
	Tue, 22 Jul 2025 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192345; cv=none; b=eGXobKwzCrRKvSzAmunDtgKpvjxPBC7ppOUJQyaRVc3bxwmeSmfqErBXjNHIG+l3fFEl4ZzU0h6VMKOzF3ZQlZ0XDeStO1Js9ZDzK+s/xQhdLUjItuyDFFVENL29QhWY5Nh6ji22dZnqYphykodJmAUMSfcOIa8SopJyT88QqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192345; c=relaxed/simple;
	bh=gC/Y/9/PfGrHsw341OG2pEPmA3QkFv9u5r/LA2M/ueo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKKo81qbjahdEY7GWVjpEu5eAWimoaYBU3Gwt4mKP0d7KpPouPM4i6ut1D9Sw/qYIiOw9lKw1qnK9v7mvALPfFDRg5ieqhSDYKvTh1TE9QxjhbLN3vczJsaEi9tRl4b2TUzLeHc42tVYt/YRZGvSCUEBP6QgtZOz7+RysmlxFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSBGBxmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSBGBxmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AB6C4CEEB;
	Tue, 22 Jul 2025 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192345;
	bh=gC/Y/9/PfGrHsw341OG2pEPmA3QkFv9u5r/LA2M/ueo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSBGBxmT6qLkImFc9ky1iYwyXaO/TDRdc002Fu3iRpu7WtGLfRroPIwwHTkNwoJKd
	 uKIGrrzSpZAR6cxqe6vITnhaKhG/cVLhVqR2PQhC0d0LAPwBBY9x8ep0S+uumyMDwC
	 VXwzF3ADd3C11iY6M59yKbhHItUz8XUBXpiVRyaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 002/111] phy: tegra: xusb: Decouple CYA_TRK_CODE_UPDATE_ON_IDLE from trk_hw_mode
Date: Tue, 22 Jul 2025 15:43:37 +0200
Message-ID: <20250722134333.475673986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

commit 24c63c590adca310e0df95c77cf7aa5552bc3fc5 upstream.

The logic that drives the pad calibration values resides in the
controller reset domain and so the calibration values are only being
captured when the controller is out of reset. However, by clearing the
CYA_TRK_CODE_UPDATE_ON_IDLE bit, the calibration values can be set
while the controller is in reset.

The CYA_TRK_CODE_UPDATE_ON_IDLE bit was previously cleared based on the
trk_hw_mode flag, but this dependency is not necessary. Instead,
introduce a new flag, trk_update_on_idle, to independently control this
bit.

Fixes: d8163a32ca95 ("phy: tegra: xusb: Add Tegra234 support")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20250519090929.3132456-2-waynec@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |   14 ++++++++------
 drivers/phy/tegra/xusb.h          |    1 +
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -648,14 +648,15 @@ static void tegra186_utmi_bias_pad_power
 		udelay(100);
 	}
 
-	if (padctl->soc->trk_hw_mode) {
-		value = padctl_readl(padctl, XUSB_PADCTL_USB2_BIAS_PAD_CTL2);
-		value |= USB2_TRK_HW_MODE;
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_BIAS_PAD_CTL2);
+	if (padctl->soc->trk_update_on_idle)
 		value &= ~CYA_TRK_CODE_UPDATE_ON_IDLE;
-		padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL2);
-	} else {
+	if (padctl->soc->trk_hw_mode)
+		value |= USB2_TRK_HW_MODE;
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL2);
+
+	if (!padctl->soc->trk_hw_mode)
 		clk_disable_unprepare(priv->usb2_trk_clk);
-	}
 }
 
 static void tegra186_utmi_bias_pad_power_off(struct tegra_xusb_padctl *padctl)
@@ -1726,6 +1727,7 @@ const struct tegra_xusb_padctl_soc tegra
 	.supports_gen2 = true,
 	.poll_trk_completed = true,
 	.trk_hw_mode = true,
+	.trk_update_on_idle = true,
 	.supports_lp_cfg_en = true,
 };
 EXPORT_SYMBOL_GPL(tegra234_xusb_padctl_soc);
--- a/drivers/phy/tegra/xusb.h
+++ b/drivers/phy/tegra/xusb.h
@@ -434,6 +434,7 @@ struct tegra_xusb_padctl_soc {
 	bool need_fake_usb3_port;
 	bool poll_trk_completed;
 	bool trk_hw_mode;
+	bool trk_update_on_idle;
 	bool supports_lp_cfg_en;
 };
 


