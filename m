Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6209E1D63E4;
	Sat, 30 May 2026 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167138; cv=none; b=ICxVP+MxTM7IfC7zXuyjp9oFyZtGH8iwOh766WDECTy8YzRX+fMllUoKkh5hTTh/h230GEqFTtehkkCSMR/z67jF+E1srR50xZKhIkYHKpjWVWE6yh6cWv3KxUnG3NuBxZ/KhtSnTUc/kRLk0S+lttcZu+tt1mgupb6yS2PIcXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167138; c=relaxed/simple;
	bh=Rl49n76eQNNcNGJD1vTlqxf61b0cbkIpWIbZWSLonko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1APXFeAmT18sZtXdxyAH7LJ5KlL4R8ZtZH48s5dFhD0s3Ijdbk2U2aTBfja6WZ56OpKGmFk01e2Hw59g0u1EL/IXDyqhuvnnDKHVsI6KEHbnOxEyMTqbMbDLkG4u30v2v4vw83ZlIyEFWU8khbBbFRXkj5OpLMJzBDbgiquX08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWZrtViJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWZrtViJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61081F00893;
	Sat, 30 May 2026 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167137;
	bh=gV8OkSFX7TO38ZH2qdZMtBMoy1pyMBZFShc/Sr8hyjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWZrtViJQUdf7zS277BT2T0xweuFm2z0XtQID/m9hJD8mZzPrSbTIX8Hq5TvXPUqA
	 LTlTXZAaLE+c9hLNQRWSvwqDmroz3d/wtfNrkiB8Dqc1iaRIgpgQ8xHV+yMgxPfLN/
	 HWeSAuKwkyVvc/A2TE8gYZEzW5qeHP9NGBlpDMXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 573/589] phy: marvell: mvebu-a3700-utmi: fix incorrect USB2_PHY_CTRL register access
Date: Sat, 30 May 2026 18:07:34 +0200
Message-ID: <20260530160239.674744403@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 91ddf6f722084383fb05be731c0107814b055c0c ]

The mvebu_a3700_utmi_phy_power_off() function tries to modify the
USB2_PHY_CTRL register by using the IO address of the PHY IP block along
with the readl/writel IO accessors. However, the register exist in the
USB miscellaneous register space, and as such it must be accessed via
regmap like it is done in the mvebu_a3700_utmi_phy_power_on() function.

Change the code to use regmap_update_bits() for modífying the register
to fix this.

Fixes: cc8b7a0ae866 ("phy: add A3700 UTMI PHY driver")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260321-a3700-utmi-fix-usb2_phy_ctrl-access-v1-1-6005ff4b5058@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-utmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-utmi.c b/drivers/phy/marvell/phy-mvebu-a3700-utmi.c
index 8834436bc9dbc..e3a9278c06842 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-utmi.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-utmi.c
@@ -168,9 +168,8 @@ static int mvebu_a3700_utmi_phy_power_off(struct phy *phy)
 	u32 reg;
 
 	/* Disable PHY pull-up and enable USB2 suspend */
-	reg = readl(utmi->regs + USB2_PHY_CTRL(usb32));
-	reg &= ~(RB_USB2PHY_PU | RB_USB2PHY_SUSPM(usb32));
-	writel(reg, utmi->regs + USB2_PHY_CTRL(usb32));
+	regmap_update_bits(utmi->usb_misc, USB2_PHY_CTRL(usb32),
+			   RB_USB2PHY_PU | RB_USB2PHY_SUSPM(usb32), 0);
 
 	/* Power down OTG module */
 	if (usb32) {
-- 
2.53.0



