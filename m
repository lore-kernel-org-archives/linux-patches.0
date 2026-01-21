Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7243624DB;
	Wed, 21 Jan 2026 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019673; cv=none; b=uwG1MfRwoP9THXBYq6+eftS2W+/1KMsqoE7bdwe2eP29Ke0Ku8AtMz+XRawn3Rr5ZQoyF6JwuUPYGTH/ddsFyNed+vCckgRqmwuCl79rqT7cX8aWMWG8jKJfF9HystK+pgBZ7Bg1/FDVSBHxv9oFgS9K7DiM68aLPRJbvfrFmx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019673; c=relaxed/simple;
	bh=l4aCG+AYp05DBQGWUiimrRKah4ilpKsBhe5TyYqsSNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDcrTno+zIiqYEwDW9ow/HCVfoLuMTHo3+XgwTzj2sr0SN6ybgLBoBcLMUFmiRfJNlPVjKytiJcGD/r/BAw/N8+yRbYNBaTTLpMDOlHAzFNxOtyOZBAASHNcstYIMYWPluj7IeHCUcsNC0cM2VeBMQkyri24yZEPS9qqfGPkQzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9aOqB/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9aOqB/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11C5C19422;
	Wed, 21 Jan 2026 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019673;
	bh=l4aCG+AYp05DBQGWUiimrRKah4ilpKsBhe5TyYqsSNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9aOqB/dY+i29pVenVW8xyMLOpa+WmgR2xYCxWdopQ2qn63yVfznHGGx1pBfKpAyV
	 NxsNTR1KAhuBJbVPj5sIw4f6UG4mAX/1WeKhC5ywvxjBGwWrO/7CkuTWnnl79BDogZ
	 JMOTWddxLStUOYQy0gmTkaMTwB66l8ocieKkBEU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 075/139] phy: freescale: imx8m-pcie: assert phy reset during power on
Date: Wed, 21 Jan 2026 19:15:23 +0100
Message-ID: <20260121181414.154881159@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rafael Beims <rafael.beims@toradex.com>

commit f2ec4723defbc66a50e0abafa830ae9f8bceb0d7 upstream.

After U-Boot initializes PCIe with "pcie enum", Linux fails to detect
an NVMe disk on some boot cycles with:

  phy phy-32f00000.pcie-phy.0: phy poweron failed --> -110

Discussion with NXP identified that the iMX8MP PCIe PHY PLL may fail to
lock when re-initialized without a reset cycle [1].

The issue reproduces on 7% of tested hardware platforms, with a 30-40%
failure rate per affected device across boot cycles.

Insert a reset cycle in the power-on routine to ensure the PHY is
initialized from a known state.

[1] https://community.nxp.com/t5/i-MX-Processors/iMX8MP-PCIe-initialization-in-U-Boot/m-p/2248437#M242401

Signed-off-by: Rafael Beims <rafael.beims@toradex.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251223150254.1075221-1-rafael@beims.me
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -89,7 +89,8 @@ static int imx8_pcie_phy_power_on(struct
 			writel(imx8_phy->tx_deemph_gen2,
 			       imx8_phy->base + PCIE_PHY_TRSV_REG6);
 		break;
-	case IMX8MP: /* Do nothing. */
+	case IMX8MP:
+		reset_control_assert(imx8_phy->reset);
 		break;
 	}
 


