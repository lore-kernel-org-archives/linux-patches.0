Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF1317332C;
	Tue, 26 Aug 2025 11:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208433; cv=none; b=m3gpasZT4N81IPGbLwNQBb+abbPM7O83Zq+W+DL/8lGjABsGWuPROrYm39vVfjHzXBa+OLzmBdiXPNCZ6pO7n+TW5i8maFAr8qlF6Ys4T2678yootG8cnfQZU/BSZoHmwqo2m+iuIeCoHXmw9H6gBCVZI0LNHoeHV5qVPR2erdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208433; c=relaxed/simple;
	bh=fi3CghU7dlqmNOH3fXt055E2yEglUn7UquPqYQAWhxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDnK7wFwwTgc4XBPhaQ2vxsXVnGRMqY6iALZExV2F5QnQTSCpWZV+oXZE/EbpwzGtb/I1GOalNCXqx8AzuE3Kf+3Aa5rhebru3/ld1OxaBQOjsbzEG/Ydxyl1xQ4EyMPSsGz8z41vS/cF9TDrVNS0HWX5vp2lMV8dd87YYYhCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sclP2X4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sclP2X4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F67C4CEF1;
	Tue, 26 Aug 2025 11:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208433;
	bh=fi3CghU7dlqmNOH3fXt055E2yEglUn7UquPqYQAWhxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sclP2X4QA3W8ebabAHWMYyKzYyi1178xs7ZQUwrmeJOtYxYn/ptWb1ZYxqdb4tvUk
	 W7dQIYrknT04+knh5drePEgUvjsHMeNbaWG8//jFFGifDj9xziCWnEnvX/8mhYZLYi
	 YJGV2v7qK9IWar/vIXabfDDpSRWKt+epg66iJ/gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 078/322] PCI: imx6: Remove apps_reset toggling from imx_pcie_{assert/deassert}_core_reset
Date: Tue, 26 Aug 2025 13:08:13 +0200
Message-ID: <20250826110917.536845895@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

commit d31eb217425591e100b475fad6360cd3da2073c6 upstream.

apps_reset corresponds to LTSSM_EN in i.MX7, i.MX8MQ, i.MX8MM and i.MX8MP
platforms. Since assertion/de-assertion of apps_reset is done in
imx_pcie_ltssm_enable() and imx_pcie_ltssm_disable(), remove it from
imx_pcie_assert_core_reset() and imx_pcie_deassert_core_reset().

This also fixes a failure in enumerating the PI7C9X2G608GP (hotplug) chip
reliably on i.MX8MM, as reported by Tim.

It should be noted that only i.MX7D, i.MX8MQ, i.MX8MM, and i.MX8MP
platforms have the apps_reset logic, so this change doesn't have any effect
on other platforms.

Fixes: ef61c7d8d032 ("PCI: imx6: Deassert apps_reset in imx_pcie_deassert_core_reset()")
Reported-by: Tim Harvey <tharvey@gateworks.com>
Closes: https://lore.kernel.org/all/CAJ+vNU3ohR2YKTwC4xoYrc1z-neDoH2TTZcMHDy+poj9=jSy+w@mail.gmail.com/
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded commit subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tim Harvey <tharvey@gateworks.com> # imx8mp-venice-gw74xx (i.MX8MP + hotplug capable switch)
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250709033722.2924372-2-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -778,7 +778,6 @@ static int imx7d_pcie_core_reset(struct
 static void imx_pcie_assert_core_reset(struct imx_pcie *imx_pcie)
 {
 	reset_control_assert(imx_pcie->pciephy_reset);
-	reset_control_assert(imx_pcie->apps_reset);
 
 	if (imx_pcie->drvdata->core_reset)
 		imx_pcie->drvdata->core_reset(imx_pcie, true);
@@ -790,7 +789,6 @@ static void imx_pcie_assert_core_reset(s
 static int imx_pcie_deassert_core_reset(struct imx_pcie *imx_pcie)
 {
 	reset_control_deassert(imx_pcie->pciephy_reset);
-	reset_control_deassert(imx_pcie->apps_reset);
 
 	if (imx_pcie->drvdata->core_reset)
 		imx_pcie->drvdata->core_reset(imx_pcie, false);
@@ -997,6 +995,9 @@ static int imx_pcie_host_init(struct dw_
 		}
 	}
 
+	/* Make sure that PCIe LTSSM is cleared */
+	imx_pcie_ltssm_disable(dev);
+
 	ret = imx_pcie_deassert_core_reset(imx_pcie);
 	if (ret < 0) {
 		dev_err(dev, "pcie deassert core reset failed: %d\n", ret);


