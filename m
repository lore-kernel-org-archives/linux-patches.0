Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A417D15E8B;
	Mon, 30 Dec 2024 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573736; cv=none; b=BdrE2U9AeEpNx2VcG3qiCskE+OO0mvv85Sc90BNCrdnhq3yoc0lC6dUw+cLr43cxEJr/APTU1X2rqICt6ovkdS08jaKmRdEBP56XCXHpP7iqB4IYD9dqDiEITmKolaTrla37K3W417MsOXKpHRY38KX9jVebbLqLxrr18Pzfn0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573736; c=relaxed/simple;
	bh=cJ2uNtrexrqovOIjwkyYjBnRz2ypbSF6ZL1OOp4zGFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8HmiQ1/yPUQGEFfGK75Zx1BKWvWa7k8Kvi8ZSS9q37eP06NV4kfD8w4Uq2YoUeNOySwf9U+5txhQLa7OuRybXAV3WV7ffmpGtLdElOSSywo6GvQps8sDVpWAF0OVLcQu7zlN/VVWSUxOGa8b1tJITY+oGApx+MCYLQcxDwMC1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqkztR8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqkztR8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2930AC4CED0;
	Mon, 30 Dec 2024 15:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573736;
	bh=cJ2uNtrexrqovOIjwkyYjBnRz2ypbSF6ZL1OOp4zGFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqkztR8n1B2IX6xhhzbbpbdnDywwv4nQC+KMCbcIanhJldcaDkpkTziZlBhFvTAku
	 0jp4ocaoIX6RuVr8YOZKyysKiQSalMREtQ/LCAG1QHYwIdmRyB1L1jP1djLsK2qcOy
	 zpIsDIARBntD5+AJseKLfZHcv7fRnJTr4DEROm1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 20/86] phy: usb: Toggle the PHY power during init
Date: Mon, 30 Dec 2024 16:42:28 +0100
Message-ID: <20241230154212.490711618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

commit 0a92ea87bdd6f77ca4e17fe19649882cf5209edd upstream.

When bringing up the PHY, it might be in a bad state if left powered.
One case is we lose the PLL lock if the PLL is gated while the PHY
is powered. Toggle the PHY power so we can start from a known state.

Fixes: 4e5b9c9a73b3 ("phy: usb: Add support for new Synopsys USB controller on the 7216")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20241024213540.1059412-1-justin.chen@broadcom.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -323,6 +323,12 @@ static void usb_init_common_7216(struct
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


