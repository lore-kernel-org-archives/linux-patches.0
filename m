Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C01E3ACEFF;
	Thu, 15 Jan 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495978; cv=none; b=di+pTiFPRjUu84y7yYSioWMff3kFtXi/0irZWUv2bxNPU1zd7NWn8FWEv8kCHwee8Iv0URYiJh4DaAApl5BrMiFtyn7cX1wWGEp/h6BCnPJx6k8fmh5eMkxFuTp2d16AZb9VrCXxsOIBn8v03/XGEjsomVFu/fwRWaQezkZxcdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495978; c=relaxed/simple;
	bh=lKJdHJWprXdjN5LcJ6gWscNT75n1h6oGTw/T+3dukY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBm/U4I2G1uX4Yxg3BWUImgadRGABSzVrI0jCSQTg2LJvvmfcF3qK6C+wLWw/ZTguM0Szr5pyCRyNcqC8i12gXh11Agce6DVdiWPlrL13XvDG+9sbPtJKu+5aR8FgxJaYp0mR1OAG4I/qWetgX+WPPnq8fn9WyDe41gbrMVhA1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToIaDu7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToIaDu7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D67C116D0;
	Thu, 15 Jan 2026 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495977;
	bh=lKJdHJWprXdjN5LcJ6gWscNT75n1h6oGTw/T+3dukY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToIaDu7xNQniEGtUnx4f7NiJDX8qWF3pZ1YzZAZf5M9vifmEcqFIkmG4yIVIcuFk4
	 YGUO/EX/+P3tAiKYWP5nICsifQZpI5lrgGIyJjjDA1vS9Bpjsx+sfsA+bqKD91PfO4
	 WglZam8mieKscM+Ez6k8UduHYJ0oWUqD2OGOcLWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linnaea Lavia <linnaea-von-lavia@live.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.18 033/181] PCI: meson: Report that link is up while in ASPM L0s and L1 states
Date: Thu, 15 Jan 2026 17:46:10 +0100
Message-ID: <20260115164203.523540754@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit df27c03b9e3ef2baa9e9c9f56a771d463a84489d upstream.

Previously meson_pcie_link_up() only returned true if the link was in the
L0 state.  This was incorrect because hardware autonomously manages
transitions between L0, L0s, and L1 while both components on the link stay
in D0.  Those states should all be treated as "link is active".

Returning false when the device was in L0s or L1 broke config accesses
because dw_pcie_other_conf_map_bus() fails if the link is down, which
caused errors like this:

  meson-pcie fc000000.pcie: error: wait linkup timeout
  pci 0000:01:00.0: BAR 0: error updating (0xfc700004 != 0xffffffff)

Remove the LTSSM state check, timeout, speed check, and error message from
meson_pcie_link_up(), the dw_pcie_ops.link_up() method, so it is a simple
boolean check of whether the link is active.  Timeouts and error messages
are handled at a higher level, e.g., dw_pcie_wait_for_link().

Fixes: 9c0ef6d34fdb ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Reported-by: Linnaea Lavia <linnaea-von-lavia@live.com>
Closes: https://lore.kernel.org/r/DM4PR05MB102707B8CDF84D776C39F22F2C7F0A@DM4PR05MB10270.namprd05.prod.outlook.com
[bhelgaas: squash removal of unused WAIT_LINKUP_TIMEOUT by
Martin Blumenstingl <martin.blumenstingl@googlemail.com>:
https://patch.msgid.link/20260105125625.239497-1-martin.blumenstingl@googlemail.com]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Linnaea Lavia <linnaea-von-lavia@live.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on BananaPi M2S
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251103221930.1831376-1-helgaas@kernel.org
Link: https://patch.msgid.link/20260105125625.239497-1-martin.blumenstingl@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-meson.c |   37 ++-------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -37,7 +37,6 @@
 #define PCIE_CFG_STATUS17		0x44
 #define PM_CURRENT_STATE(x)		(((x) >> 7) & 0x1)
 
-#define WAIT_LINKUP_TIMEOUT		4000
 #define PORT_CLK_RATE			100000000UL
 #define MAX_PAYLOAD_SIZE		256
 #define MAX_READ_REQ_SIZE		256
@@ -350,40 +349,10 @@ static struct pci_ops meson_pci_ops = {
 static bool meson_pcie_link_up(struct dw_pcie *pci)
 {
 	struct meson_pcie *mp = to_meson_pcie(pci);
-	struct device *dev = pci->dev;
-	u32 speed_okay = 0;
-	u32 cnt = 0;
-	u32 state12, state17, smlh_up, ltssm_up, rdlh_up;
-
-	do {
-		state12 = meson_cfg_readl(mp, PCIE_CFG_STATUS12);
-		state17 = meson_cfg_readl(mp, PCIE_CFG_STATUS17);
-		smlh_up = IS_SMLH_LINK_UP(state12);
-		rdlh_up = IS_RDLH_LINK_UP(state12);
-		ltssm_up = IS_LTSSM_UP(state12);
-
-		if (PM_CURRENT_STATE(state17) < PCIE_GEN3)
-			speed_okay = 1;
-
-		if (smlh_up)
-			dev_dbg(dev, "smlh_link_up is on\n");
-		if (rdlh_up)
-			dev_dbg(dev, "rdlh_link_up is on\n");
-		if (ltssm_up)
-			dev_dbg(dev, "ltssm_up is on\n");
-		if (speed_okay)
-			dev_dbg(dev, "speed_okay\n");
-
-		if (smlh_up && rdlh_up && ltssm_up && speed_okay)
-			return true;
+	u32 state12;
 
-		cnt++;
-
-		udelay(10);
-	} while (cnt < WAIT_LINKUP_TIMEOUT);
-
-	dev_err(dev, "error: wait linkup timeout\n");
-	return false;
+	state12 = meson_cfg_readl(mp, PCIE_CFG_STATUS12);
+	return IS_SMLH_LINK_UP(state12) && IS_RDLH_LINK_UP(state12);
 }
 
 static int meson_pcie_host_init(struct dw_pcie_rp *pp)


