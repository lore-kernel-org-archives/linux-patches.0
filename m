Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0840A367F36;
	Wed, 28 Jan 2026 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614157; cv=none; b=A7yjGzeiLD9YvS6fOp5xFyvwPgNsDUmk7M1s6VbtiXWoRhnOJUPrEZBU2WmMlvhRrSHFVN7tHfsfisI5qGJTeSBuaMp2NPP8NtzKSSfVYJyrC3VwVZhxZFdJYxVBDSKuDr1kcx+yiVE/UFJ9esAU4rmlwbad3U6BJMzMboU+onw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614157; c=relaxed/simple;
	bh=RrWsvwSfN//Yn4RB7k4H8hTMAkOBCfaIl9UyF/WS3xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSVGHaOcCysiKmod9VR4jjfhQyqhJFMDtaCEavzKJ7J1s2NPu107JTrFfvAtI9asyZq6cticxoaQMQZR8+OqAB+7Px4Gb4EXAvak+t64ZPdwVIO/MY9VWmRxMrycnZ97poBJREcKVtmTigzI9JbW5Zw+uIKtupAHMF9uLfQnbe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqKL2f0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqKL2f0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77060C4CEF1;
	Wed, 28 Jan 2026 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614156;
	bh=RrWsvwSfN//Yn4RB7k4H8hTMAkOBCfaIl9UyF/WS3xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqKL2f0HTj3P7dHB5rG+JPEFwJXzM01gfRTVnCCC5IOYkID+ubkuS9SPJUqksjfEI
	 hb4JzPZvBNca+rHuNgUjhP/BTGP0mvmAWjnFY29n8Pothz8+P85r08zBZ1t7GNUgnx
	 kPLnaeUa8lm/mLFamkn/+YQRuzK2PKPzo1ioKEds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 053/254] phy: freescale: imx8m-pcie: assert phy reset during power on
Date: Wed, 28 Jan 2026 16:20:29 +0100
Message-ID: <20260128145346.609142037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


