Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AB1221729;
	Mon,  2 Jun 2025 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872762; cv=none; b=Tj2ZF1/m6AtX4o6oUDPrnIetRd4gjNdAghNfLatrsrT7xKQkRcBQuydNCrwB1/pQoBf3AOJj2rXh77cBzBj3N4A7hKz+MJFmKWe7900ryqb8GBshy3mhtXACS1BYmaALuaGMnd0lNU/nk1S/oRFb61jtk6BAw0ZJFcqQVEJ7zpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872762; c=relaxed/simple;
	bh=o00zuSHTwCaiQo8XuN2RfiWf3Qu+RBDO3d8ZDYLIcHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekaFmJgHX+hjcbwTYVrWf+1Skyw6CvynTzRpdwUTqFw4exADTefy6W0D8RhgAaWQYHb6E5hbOzjS/gvi1yWlGHmzSuPp4qA8QcICuC/jdjRzlCxJbM1AyzSeKodWZuC7L6ceipUq02iRDlPo6Ew+h7JRZqj2TpaobxfeHBx44Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSnbr2LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSnbr2LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6A3C4CEEB;
	Mon,  2 Jun 2025 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872761;
	bh=o00zuSHTwCaiQo8XuN2RfiWf3Qu+RBDO3d8ZDYLIcHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSnbr2LLsPBbki6q3ccGn6riNRJ9TdOKFQAoavT5xQGmM9gdVn4DRuCCs13waqn9A
	 +EG1m4HPNVz8uPoauX+uoBFMzx1CTI2tX7s8xcWzJQPMhSglvq6VOXiab9tDw+cN+q
	 1th370vp+VQnq1jtlhd48QfpwQAwWnBzumX8tIrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 60/73] phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure
Date: Mon,  2 Jun 2025 15:47:46 +0200
Message-ID: <20250602134244.054102832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cb5454fbe2c8f..b505d89860b43 100644
--- a/drivers/phy/starfive/phy-jh7110-usb.c
+++ b/drivers/phy/starfive/phy-jh7110-usb.c
@@ -18,6 +18,8 @@
 #include <linux/usb/of.h>
 
 #define USB_125M_CLK_RATE		125000000
+#define USB_CLK_MODE_OFF		0x0
+#define USB_CLK_MODE_RX_NORMAL_PWR	BIT(1)
 #define USB_LS_KEEPALIVE_OFF		0x4
 #define USB_LS_KEEPALIVE_ENABLE		BIT(4)
 
@@ -78,6 +80,7 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 {
 	struct jh7110_usb2_phy *phy = phy_get_drvdata(_phy);
 	int ret;
+	unsigned int val;
 
 	ret = clk_set_rate(phy->usb_125m_clk, USB_125M_CLK_RATE);
 	if (ret)
@@ -87,6 +90,10 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
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



