Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2354B26CE04;
	Thu, 15 Jan 2026 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498620; cv=none; b=teafGP0e2nXsUPUxG96ztt86fXrYUl7dmIPR5yX93cOyk5Zh0LfvC2PQt55WOqo/Xrxw70I9E3G9xx0WcE5Az8Azs1NtmksesfhYSbHfQZIb+KZgVHTTHdIaWZ9JyOjp0Cb/iZaTWQ2Z17LGAUejNLuMBqW2s4sONZUImR2vMko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498620; c=relaxed/simple;
	bh=T3miKeCfnkG9He/JUCmpGDgF3AYmToHCrg+dWN5e1Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScqtxJJTx3XKyQZkWUrnPhXaYxgqXenTulURy9ohDAx64H+MmrHcLWJypZRiXqZSnyBvxkL7vijrA5oDpfh3wNC48ALr8nm+XRVCRlcxTmKGRzcXiJF8SEUQpFkGBQUzQj2ejyLOSs6cVIPlGZK1WIZmEVmxa4bd5pfkP/wpmSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiZ4Ih4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiZ4Ih4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EB7C16AAE;
	Thu, 15 Jan 2026 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498620;
	bh=T3miKeCfnkG9He/JUCmpGDgF3AYmToHCrg+dWN5e1Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiZ4Ih4z7UlRdfJMYY6c0WxFNdcExvnjczQ90tPN0Cp9Iyx5257sUFjLC2gZ4S7Pw
	 C9O3tBvfpEhDdmfhxa3zujgcL7TJrdQvkQSXo54X+qxXuocmcJ3MgvOv4AasiWajDb
	 IFlFgmX6LZwD79hqCWZpXtxOE60vyx2oHe8wkqug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/554] PCI: brcmstb: Fix disabling L0s capability
Date: Thu, 15 Jan 2026 17:48:49 +0100
Message-ID: <20260115164303.043389051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Quinlan <james.quinlan@broadcom.com>

[ Upstream commit 9583f9d22991d2cfb5cc59a2552040c4ae98d998 ]

caab002d5069 ("PCI: brcmstb: Disable L0s component of ASPM if requested")
set PCI_EXP_LNKCAP_ASPM_L1 and (optionally) PCI_EXP_LNKCAP_ASPM_L0S in
PCI_EXP_LNKCAP (aka PCIE_RC_CFG_PRIV1_LINK_CAPABILITY in brcmstb).

But instead of using PCI_EXP_LNKCAP_ASPM_L1 and PCI_EXP_LNKCAP_ASPM_L0S
directly, it used PCIE_LINK_STATE_L1 and PCIE_LINK_STATE_L0S, which are
Linux-created values that only coincidentally matched the PCIe spec.
b478e162f227 ("PCI/ASPM: Consolidate link state defines") later changed
them so they no longer matched the PCIe spec, so the bits ended up in the
wrong place in PCI_EXP_LNKCAP.

Use PCI_EXP_LNKCAP_ASPM_L0S to clear L0s support when there's an
'aspm-no-l0s' property.  Rely on brcmstb hardware to advertise L0s and/or
L1 support otherwise.

Fixes: caab002d5069 ("PCI: brcmstb: Disable L0s component of ASPM if requested")
Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Closes: https://lore.kernel.org/linux-pci/20250925194424.GA2197200@bhelgaas
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
[mani: reworded subject and description, added closes tag and CCed stable]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251003170436.1446030-1-james.quinlan@broadcom.com
[ Adjust context in variable declaration ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-brcmstb.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -44,7 +44,6 @@
 #define  PCIE_RC_CFG_PRIV1_ID_VAL3_CLASS_CODE_MASK	0xffffff
 
 #define PCIE_RC_CFG_PRIV1_LINK_CAPABILITY			0x04dc
-#define  PCIE_RC_CFG_PRIV1_LINK_CAPABILITY_ASPM_SUPPORT_MASK	0xc00
 
 #define PCIE_RC_DL_MDIO_ADDR				0x1100
 #define PCIE_RC_DL_MDIO_WR_DATA				0x1104
@@ -873,7 +872,7 @@ static int brcm_pcie_setup(struct brcm_p
 	int num_out_wins = 0;
 	u16 nlw, cls, lnksta;
 	int i, ret, memc;
-	u32 tmp, burst, aspm_support;
+	u32 tmp, burst;
 
 	/* Reset the bridge */
 	pcie->bridge_sw_init_set(pcie, 1);
@@ -995,12 +994,9 @@ static int brcm_pcie_setup(struct brcm_p
 	}
 
 	/* Don't advertise L0s capability if 'aspm-no-l0s' */
-	aspm_support = PCIE_LINK_STATE_L1;
-	if (!of_property_read_bool(pcie->np, "aspm-no-l0s"))
-		aspm_support |= PCIE_LINK_STATE_L0S;
 	tmp = readl(base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
-	u32p_replace_bits(&tmp, aspm_support,
-		PCIE_RC_CFG_PRIV1_LINK_CAPABILITY_ASPM_SUPPORT_MASK);
+	if (of_property_read_bool(pcie->np, "aspm-no-l0s"))
+		tmp &= ~PCI_EXP_LNKCAP_ASPM_L0S;
 	writel(tmp, base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
 
 	/*


