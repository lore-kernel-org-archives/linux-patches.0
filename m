Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A85F33A9DA;
	Sat, 30 May 2026 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162445; cv=none; b=H1n3TOZfKUGua00Wkh/IPi6vH6gRHJp3/WMDDPT7IxTnn1YjtPYbO5xcM+za4xwu+o7Q/iC1R0pn4GIdlqS/yJAu7q+xqIVwQZHx4xLz/FCHWIoFzJ3AHVSu1Q8Hi5E++RQ02x4O1Tiyqg97wXF5nbPR7uyUFkdXB07nnuOX84g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162445; c=relaxed/simple;
	bh=LVUHbmijV4a2aPvnEYEOmoRmfIkeBj1kXgYaHSa1wPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X269hPVr/IV/xt8rftqKL+/oICm8UwmnHjhD5lH2CoEiFAeMTSfwBMPlS2vqEuHRNwQe72LEkonGUNflocf6k6ocK32qFbW2NkwnjO2bQqhi+HxRAPR/1f2m9JmrqbXWxSRYLUzmZPiUcNNU6I2OGbjEn2HxhfRr+m/VOr52/kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp6aSj+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp6aSj+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4FB1F00893;
	Sat, 30 May 2026 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162444;
	bh=UAVlwlIOsQfJuFUrE8sWYthAC4w1iV4lxf5rnZl0CgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fp6aSj+qLnMVTEw4rxjskZ4JPiacei82AuTxiu4yEOdoadt9ZqsXxp29IGQB5AcRO
	 OSM1rTBJYZTz+RuyaIRMvd3/eLvPvnot26MAj0joZNTmx4DvhtNKYBoINJjRZb8H3+
	 8ehR8LJ8ZM7SyYZibJKw1CrapBXXGHyvYbdyDua8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 923/969] phy: marvell: mvebu-a3700-utmi: fix incorrect USB2_PHY_CTRL register access
Date: Sat, 30 May 2026 18:07:27 +0200
Message-ID: <20260530160326.225839205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



