Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EBF1E9B02;
	Thu, 30 Jan 2025 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247032; cv=none; b=SQUGC/BXyqkvMmtL7HmGWihI/nl272YmDRHWxjS0Devd3uspdztH08ln+6y0xoAkDCb70uGaXlOqoomdgEnjot5dsj6MTSVarV/gMwVOIxBIodbXUlBQGKyr8HZrt0bZ3Me0uMPrrm/UQg852ar9KHxuKjC+9DSrn+I4ohunSYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247032; c=relaxed/simple;
	bh=NToUlQcKU0wy7jwVeSWpiLiuI2EvIRKsEVj+mbK4+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoO0o1yysnpeIwGq3fYVfW/1OMY9mHChryUq1tKwnB9bnpnroIzVTglGeQk4aPYyMS0JkWHNJ4UuBVBahXtiY+2QG4Fr0R+Pgno8FN11QDwVEkjMZB5oAwTng8wN8qtJRf7BLxfUvrWZVs/uZ6r77e/8YKpiopcO5riurc/53TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKWB8ciS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKWB8ciS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D904C4CEE0;
	Thu, 30 Jan 2025 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247031;
	bh=NToUlQcKU0wy7jwVeSWpiLiuI2EvIRKsEVj+mbK4+wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKWB8ciSJI97u7B4p/3eBnKMXgg1cReDGRp1LFd+CYtYGz3YhP165//nhdJN/AhlV
	 dmaRJbO3IKvn1G24MGcFDvAfp1ofT2V/vNtI2ZahjtNF64AsziyvGAdBsqbO9cmFYh
	 KDoz6F3iocM4SbjzMD/BzB6yyqnoLCEzB7Rso5D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/133] phy: usb: Toggle the PHY power during init
Date: Thu, 30 Jan 2025 15:00:47 +0100
Message-ID: <20250130140144.855522692@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 0a92ea87bdd6f77ca4e17fe19649882cf5209edd ]

When bringing up the PHY, it might be in a bad state if left powered.
One case is we lose the PLL lock if the PLL is gated while the PHY
is powered. Toggle the PHY power so we can start from a known state.

Fixes: 4e5b9c9a73b3 ("phy: usb: Add support for new Synopsys USB controller on the 7216")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20241024213540.1059412-1-justin.chen@broadcom.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
index d2524b70ea16..fa54da35719f 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -309,6 +309,12 @@ static void usb_init_common_7216(struct brcm_usb_init_params *params)
 	void __iomem *ctrl = params->regs[BRCM_REGS_CTRL];
 
 	USB_CTRL_UNSET(ctrl, USB_PM, XHC_S2_CLK_SWITCH_EN);
+
+	/*
+	 * The PHY might be in a bad state if it is already powered
+	 * up. Toggle the power just in case.
+	 */
+	USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
 	USB_CTRL_UNSET(ctrl, USB_PM, USB_PWRDN);
 
 	/* 1 millisecond - for USB clocks to settle down */
-- 
2.39.5



