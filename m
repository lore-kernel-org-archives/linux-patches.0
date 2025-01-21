Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7261F63FD;
	Tue, 21 Jan 2025 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483058; cv=none; b=r/W2wvuBchb+K8YFMN7p9Sl3EP09kZkld850LlYcVep7sszqgJXQlQrXA6uPesTbbMWsu4ABs2HILOViGi7CJiLjFJNj5WyW1BGrAm9f8yrlZWbYfGFfZddo6Rfc8VDc14iWPNm2M9iZJ72B5fGhAsI193w96eWZVDpj6drEJTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483058; c=relaxed/simple;
	bh=JLvwYs+EK3PXsZBq2SZwdtAXJ1SlgWe11lxBPusU528=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN95nkBA/t3C/ah4yoeTuBlhVI8bpXkjoO9SUzfcMgUbuYhORxuOVtQk9lRJd5vye0dI0/Hh2E9anMJlEnXipHB4m268sjUliJrBxns02o1Jr3kazy7uLnB1Aa7flggpS7F92H4jsvCvMrq/DHp2rP5+UsYfardZmgGPQzhZ9Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JliOpd7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JliOpd7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66018C4CEE0;
	Tue, 21 Jan 2025 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483057;
	bh=JLvwYs+EK3PXsZBq2SZwdtAXJ1SlgWe11lxBPusU528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JliOpd7L97mebU4tWeJSICuf3h5fWprLDbm7+azkgM/QUAwzZR2D7FkNnm2QxJl4L
	 Qwd9RQzTbMt+KXP4mJbN+Z1wLl+0u1ciBSiuIjDHq4rpzNJIpU8xu/2RWuvu3NgQl/
	 cC/b9rhbj1smwZCr+dkIn5YG7a2AyxFHyjT2vdMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/127] phy: usb: Toggle the PHY power during init
Date: Tue, 21 Jan 2025 18:52:24 +0100
Message-ID: <20250121174532.442494785@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



