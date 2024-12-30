Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A715E8B;
	Mon, 30 Dec 2024 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574161; cv=none; b=anmb/d5E2G3oAeU6qszo41VTcI8H5h2IgDQxG/6le80GXMDvp+68JfGX75F7LxQpelqF49bqrXG1uhi3Q+tt916O+cXGL0RNV7+0k5c4Sg4DScDkyUnXr+AYePDbdW5XE9jthbxrrBtgKaj38Pnw7MCApJ4qeqPDK8vPdZFiNVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574161; c=relaxed/simple;
	bh=v+AXN/nnXgpAdJf61DLz6i2lUFurzOV3NtIAOxbKXT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRtkg14v/mXsylGNJ8kWnLywpvP9TbrLUShNBfF77A3GHh4oU29LJHRiJtGn/S8CtXzSCKrO/PFLx21xG9gSDN6kudSgy/9jAI4iX7gPnyhZq7fhGDmi9Y5M0msNlkAVyRL0K+0Y6ro/vFOY9dgezoVh0OI4uL7xsYapkdrMKI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDDIDdWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDDIDdWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD351C4CED0;
	Mon, 30 Dec 2024 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574161;
	bh=v+AXN/nnXgpAdJf61DLz6i2lUFurzOV3NtIAOxbKXT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDDIDdWx5s4i2N43tizL8dgQtQqbQg/yIoxqM/4YOLc4fJU9ykGIhPlVPPht50IPu
	 0z+F2TFDHF+9/+43HsODtDhokGOWo8XReGg5nLietseByoRJefrG4hQ+yg0TEuHqSX
	 edFFRyxjCN1GxwfKrBjeR++FEjo2XAb4uwDAye9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 024/114] phy: usb: Toggle the PHY power during init
Date: Mon, 30 Dec 2024 16:42:21 +0100
Message-ID: <20241230154218.992816114@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -325,6 +325,12 @@ static void usb_init_common_7216(struct
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


