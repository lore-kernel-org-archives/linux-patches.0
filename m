Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6E221299;
	Mon,  2 Jun 2025 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874369; cv=none; b=cViPshDPZgKg0Ku1HmJmVUdemZman6QcYewWfaSQgpPmf9J0XUbD7UtteJQOeVIbWN7c4puUTuCT4a8V9Uv6hb4Gu2mXhhq7t7JqqDzK7LIHpcFADrHMS3+Eo14sz5ErJd2zjZJ3Iy+973jxKzkzP7/Poe12fmcP3wOfXl+A6Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874369; c=relaxed/simple;
	bh=P4vgKvB1+JF/fOV1As6kEBDmsic07XYwPBy+iy/eXsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR0EWR7RwboSfQme0rKKap+IhuIH+R1gqDOgW2RXxN1LrLt+qK2ZpJWw1SuiiQxqbGAYUoFbMtC0UIlH1jzH8mFpI2HDN+EAnpgHmXk63YGX/UGc09cbg4QxivX7FEdpvqWrOEWeDFPToSBxua2gr6u3BDGvr79PzGIg6Zsbo6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2ewTri1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2ewTri1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC23C4CEEB;
	Mon,  2 Jun 2025 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874369;
	bh=P4vgKvB1+JF/fOV1As6kEBDmsic07XYwPBy+iy/eXsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2ewTri1EivbZkHdGSYWNfWaWWf08peejd/rza5UYKTRCEtNniNFo8zPBQZ0kfunn
	 fPvmPkjWuNT8QUcmxc3rh6jU/V30tIBClbTGOuUHqO9hJX0GwnSsfXb5KoVfL0x6ZQ
	 7Io4b/6OUjReOdiUhzzHCrP5hyImBOI7ARlvN1Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 437/444] phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure
Date: Mon,  2 Jun 2025 15:48:21 +0200
Message-ID: <20250602134358.675164037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 3f097adb9b6c804636bcf8d01e0e7bc037bee0d3 ]

JH7110 USB 2.0 host fails to detect USB 2.0 devices occasionally. With a
long time of debugging and testing, we found that setting Rx clock gating
control signal to normal power consumption mode can solve this problem.

Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Link: https://lore.kernel.org/r/20250422101244.51686-1-hal.feng@starfivetech.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/starfive/phy-jh7110-usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/phy/starfive/phy-jh7110-usb.c b/drivers/phy/starfive/phy-jh7110-usb.c
index 633912f8a05d0..bf52b41110db8 100644
--- a/drivers/phy/starfive/phy-jh7110-usb.c
+++ b/drivers/phy/starfive/phy-jh7110-usb.c
@@ -16,6 +16,8 @@
 #include <linux/usb/of.h>
 
 #define USB_125M_CLK_RATE		125000000
+#define USB_CLK_MODE_OFF		0x0
+#define USB_CLK_MODE_RX_NORMAL_PWR	BIT(1)
 #define USB_LS_KEEPALIVE_OFF		0x4
 #define USB_LS_KEEPALIVE_ENABLE		BIT(4)
 
@@ -68,6 +70,7 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 {
 	struct jh7110_usb2_phy *phy = phy_get_drvdata(_phy);
 	int ret;
+	unsigned int val;
 
 	ret = clk_set_rate(phy->usb_125m_clk, USB_125M_CLK_RATE);
 	if (ret)
@@ -77,6 +80,10 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 	if (ret)
 		return ret;
 
+	val = readl(phy->regs + USB_CLK_MODE_OFF);
+	val |= USB_CLK_MODE_RX_NORMAL_PWR;
+	writel(val, phy->regs + USB_CLK_MODE_OFF);
+
 	return 0;
 }
 
-- 
2.39.5



