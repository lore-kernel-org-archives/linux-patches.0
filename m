Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F69A1A9B54;
	Mon, 30 Dec 2024 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573507; cv=none; b=OUYif78KxNRejokE8lsbElLJXwq8JXqjBPrkXhSwoENcyZy/UhLKAnDFeYux/yW5Y3lTOac7YtuCodi+FHeMGAQScrZ1KYFXLx2ZJNsvyvbxkheXlFe/P+Stcq8tiStKbfaWyobYLy/VXJtst450nnVdO6CrOa4c0aM01pKzHGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573507; c=relaxed/simple;
	bh=KltV8SDvt6ZEipwr2+fgn8iDOmc+PoACKNw9/sifcJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtZcRE6Lyjnli1cyAzg4KCJ96nnt8VC0B04fHzP7tusSNYR7gSxh31mvQ2nCL5EykNFOfZSDFgbFc1ZcitS/jE+jiLnaOB/CDXOU/5RIj7mNPQXDkaq68s9sy7fx6hQO+Wa6Tcyc0czXi9ZZHpoBcxuLa7mUq1jkind3x5fdzRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq3Up16L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq3Up16L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A740AC4CED0;
	Mon, 30 Dec 2024 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573507;
	bh=KltV8SDvt6ZEipwr2+fgn8iDOmc+PoACKNw9/sifcJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq3Up16LjjD2jg3k3N4g/Ce7V9IVRuKCqL0eCGMV5nuXc5f5x6HkS4yxVKqk8na5I
	 VB3sH2zB3aYbgOML9YNYAic+6xqkfMGf/pqulxYNNt4J2nBS39rUMkQ5J6EJToJPhF
	 9ENRNnGhvYv4hj6xhAcWX78FvHLHELkeE1gYqyQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 16/60] phy: usb: Toggle the PHY power during init
Date: Mon, 30 Dec 2024 16:42:26 +0100
Message-ID: <20241230154207.904078359@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,6 +309,12 @@ static void usb_init_common_7216(struct
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


