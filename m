Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48E63164B7;
	Thu, 28 May 2026 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998597; cv=none; b=lYf0ugfFg9vdJw0AeR3SBRjvWKCSB4bAoLM9/MelRp//fqnua5vFhDjbaz8noxPv7D9Ic0/Zxez8PFBym4LuphfXHwLHP/4cswHYYJhmj4eM2sP49gjR08aNhJtoUnBl9o/bwfoVn1WKlZliI6+AlC3QIzD4JvHY+YOoMxihFJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998597; c=relaxed/simple;
	bh=xPLLcZiBFdHI6SL8+sG5VOIpzkD0UcCxKtJjvkR164M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SR3/qAkf781K3mHfaFV0fYW38HHgFsH6rnZBwNNuuO6wlhJevuXiPI4r5k0J8dF51c/dHONu2QkgZkICBJmEGHCiu4VSoIP0iz3quYGSQL5x+VGlViC135c8Z7gRsEJYhVpNghn93RHP0TbQHM2s2SKNCEHI6rel3CZVtSYhBfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHJG2L6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHJG2L6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1129B1F000E9;
	Thu, 28 May 2026 20:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998596;
	bh=Ml7nDnUqe7qsd4ssNYYzyjc+4K9Thzo+HccQaKaUBSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHJG2L6Fx84uaaDVfIv4X5TS1pY31VIHWW+h4ucbRDJt7T24OL9vtbnUGM/Q9H+rX
	 kPL32zVTbdW3P3gx2w0v3j91JG+ri6kzS3UReqWIJ9542MNI/2ZHJl1uwfhxSSp/Ml
	 9tlnUu7u40qpFnTAwIGX5+4Y4ejCY7WTH5CKDFHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 229/461] phy: marvell: mvebu-a3700-utmi: fix incorrect USB2_PHY_CTRL register access
Date: Thu, 28 May 2026 21:45:58 +0200
Message-ID: <20260528194653.764108041@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 04f4fb4bed702..f882bc57649c7 100644
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



