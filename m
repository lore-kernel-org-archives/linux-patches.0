Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF031481B8;
	Mon,  1 Apr 2024 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989645; cv=none; b=AeajSw4NGcKjwTADZ4MSvUulQvBbEFFZYjoi7W/Eju6k3u8COEVjA/sucZZ5wZuzt4RrAulqTjAoGZNCP2fv2uDhqUQdawVJjB3xlzJcE2BKCtuDOS6vTQGOXLMTCzSbZsB5lbvJEYlmPO4Sp12eNC4R/1IbQfEXBpvhRgldrqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989645; c=relaxed/simple;
	bh=UM8RnadtpIG3qsly399S6c+WFVuvS3UgVMZeKlV1mOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5YfbAMedV92gzHEh88jQKTKoIMK46ohrmd2zozlPaZ4C7SKxKVIPpgYkkEkI7KCHm+Vw3wfeUsQsV84CwHqGkuw32QO32bGV+3oNNsiJMYLtiTEqqRkt68Rs4BSzXkDFnG3ms4NB3A8+NVbIuLNu4T0JYj/YzUi6u7AG91YEGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVxQOfGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVxQOfGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FCC433F1;
	Mon,  1 Apr 2024 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989644;
	bh=UM8RnadtpIG3qsly399S6c+WFVuvS3UgVMZeKlV1mOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVxQOfGATo9dZaHbeMPBFhxopjhwUmoY3phX7m8dNb+aYs5H50qJV3sLPNQiAIfvt
	 MJVYD9DIRlUcbH/66IBeOSzcSnpcFLIN4p7KxraF8Whagx80YEtUQpAsJRXR1k21PJ
	 jub5+5drWyA6l07IjooDoz1cWxelbZwB7XLAUcbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/396] phy: tegra: xusb: Add API to retrieve the port number of phy
Date: Mon,  1 Apr 2024 17:42:39 +0200
Message-ID: <20240401152551.198127405@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit d843f031d9e90462253015bc0bd9e3852d206bf2 ]

This patch introduces a new API, tegra_xusb_padctl_get_port_number,
to the Tegra XUSB Pad Controller driver. This API is used to identify
the USB port that is associated with a given PHY.

The function takes a PHY pointer for either a USB2 PHY or USB3 PHY as input
and returns the corresponding port number. If the PHY pointer is invalid,
it returns -ENODEV.

Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20240307030328.1487748-2-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/tegra/xusb.c       | 13 +++++++++++++
 include/linux/phy/tegra/xusb.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 142ebe0247cc0..983a6e6173bd2 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -1531,6 +1531,19 @@ int tegra_xusb_padctl_get_usb3_companion(struct tegra_xusb_padctl *padctl,
 }
 EXPORT_SYMBOL_GPL(tegra_xusb_padctl_get_usb3_companion);
 
+int tegra_xusb_padctl_get_port_number(struct phy *phy)
+{
+	struct tegra_xusb_lane *lane;
+
+	if (!phy)
+		return -ENODEV;
+
+	lane = phy_get_drvdata(phy);
+
+	return lane->index;
+}
+EXPORT_SYMBOL_GPL(tegra_xusb_padctl_get_port_number);
+
 MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
 MODULE_DESCRIPTION("Tegra XUSB Pad Controller driver");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phy/tegra/xusb.h b/include/linux/phy/tegra/xusb.h
index 70998e6dd6fdc..6ca51e0080ec0 100644
--- a/include/linux/phy/tegra/xusb.h
+++ b/include/linux/phy/tegra/xusb.h
@@ -26,6 +26,7 @@ void tegra_phy_xusb_utmi_pad_power_down(struct phy *phy);
 int tegra_phy_xusb_utmi_port_reset(struct phy *phy);
 int tegra_xusb_padctl_get_usb3_companion(struct tegra_xusb_padctl *padctl,
 					 unsigned int port);
+int tegra_xusb_padctl_get_port_number(struct phy *phy);
 int tegra_xusb_padctl_enable_phy_sleepwalk(struct tegra_xusb_padctl *padctl, struct phy *phy,
 					   enum usb_device_speed speed);
 int tegra_xusb_padctl_disable_phy_sleepwalk(struct tegra_xusb_padctl *padctl, struct phy *phy);
-- 
2.43.0



