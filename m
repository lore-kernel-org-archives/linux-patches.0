Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA823B7742;
	Mon,  4 May 2026 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903750; cv=none; b=ZQIoL4RZAwF5xmMdpfMNE4Dqj4WJ+rzksJyrREQ+a2DVhaO1i5WefJ4rU+P8muBwSaXaoVIxmlFTN1F6n5he4pcov5ZdVc35fMW4ZjgV7AfSq3mkijrHRvoT0k1mEvmGxeFDLATqAyEsLYkG87Ug7cjaIU5YD6Dd6NVkGSJO8gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903750; c=relaxed/simple;
	bh=iT0eMMuT3diDsmA2aKKH0rPwRXJTW46qJ6xe3AUD0U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVFhhyyMMBZfqJKBjl7gEaM7S0tS0i7aRmPQhkYJjpuckE6BFtlseHCb8KC7W6k5m+eD5A6zB5t/gpxmEihEWyRLGuyJnOKQQ9F0AZlQqF91tUAaJvN8r5hBl7tiSzlL9W9fxqHfW3rbc/iEhAaxvib3Y6b0wR1Nns62h+iYBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c74t2/tS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c74t2/tS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AA5C2BCB8;
	Mon,  4 May 2026 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903750;
	bh=iT0eMMuT3diDsmA2aKKH0rPwRXJTW46qJ6xe3AUD0U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c74t2/tS9qNTIX2zYLJK+oCrssrKpCtqdNsi9aw4D+obzWpVDvvddJJcGEPTGCJvx
	 DpiNP2U8nY+kLqB7bLBr6fiiSHbFkGMBQfbylyVV2Zh4BpC+vS1drWA2aXtqdUfdli
	 mlSKA+IOCSWWlMmsh5Cpq4Meu6FoT/cie5/LlBEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 046/275] PCI: imx6: Skip waiting for L2/L3 Ready on i.MX6SX
Date: Mon,  4 May 2026 15:49:46 +0200
Message-ID: <20260504135144.651758755@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

commit 5f73cf1db829c21b7fd44a8d2587cd395b1b2d76 upstream.

On i.MX6SX, the LTSSM registers become inaccessible after the
PME_Turn_Off message is sent to the link. So there is no way to verify
whether the link has entered L2/L3 Ready state or not.

Hence, set IMX_PCIE_FLAG_SKIP_L23_READY flag for i.MX6SX SoC to skip the
L2/L3 Ready state polling and let the DWC core wait for 10ms after sending
the PME_Turn_Off message as per the PCIe spec r6.0, sec 5.3.3.2.1.

Fixes: a528d1a72597 ("PCI: imx6: Use DWC common suspend resume method")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260228080925.1558395-1-hongxing.zhu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1844,6 +1844,7 @@ static const struct imx_pcie_drvdata drv
 		.variant = IMX6SX,
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
 			 IMX_PCIE_FLAG_SPEED_CHANGE_WORKAROUND |
+			 IMX_PCIE_FLAG_SKIP_L23_READY |
 			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.ltssm_off = IOMUXC_GPR12,


