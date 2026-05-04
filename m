Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457283A63EC;
	Mon,  4 May 2026 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902966; cv=none; b=eHNMJx3XSEpzu8vXh+L0h2pY71PvXrKVClzpxq++PIVJo+6Jj47QITaHtHgay/psvtcwqYhuno3GUyk3ly5opC3xw0QQfeLBU7vlh29qmlNcjgMI8yHzmcmn8jVfc9dmRX/tgVrPkCgUUhXpbHPzns+3vJ2jp81QVLUYcwym/t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902966; c=relaxed/simple;
	bh=OY8nNM2rfqGOdE48ge74kVDiMDcNTN5TLSmZ1/sgdoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxWJiBtPERyn4lIZCgWN3wFhvorSLQFfVpkSJpYSxhJ4KhsUrIrUWmWHJ77xC8BFOYeX+2FK0m7dxJTUGeevMWvzNR37XTXWYGbCtb78O3Hx/+IwTP/HK/NbsvKwr3CuGrw5ZKJ/8wOnNv7UzEB7KuRL/scojCRkQMKOLySEzsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up4gBvU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up4gBvU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE782C2BCB8;
	Mon,  4 May 2026 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902966;
	bh=OY8nNM2rfqGOdE48ge74kVDiMDcNTN5TLSmZ1/sgdoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Up4gBvU8+Rq0eyF9Pgc+/rJANtp9svfOnUcwDPhOv2+Nq8TmjlC2nMdn7dRlBvUQs
	 zL3AK0LQFMA5VoIP1Dd1YrdLFe16LAon8V/hPi7W1lOVF6oqIaBY8Xr9pN5EOoPI0w
	 iCkuP0ApwUsiDbrcFGjAeVxlV0YG+gDlwoIJAlbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.0 051/307] PCI: imx6: Skip waiting for L2/L3 Ready on i.MX6SX
Date: Mon,  4 May 2026 15:48:56 +0200
Message-ID: <20260504135144.749750664@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1876,6 +1876,7 @@ static const struct imx_pcie_drvdata drv
 		.variant = IMX6SX,
 		.flags = IMX_PCIE_FLAG_IMX_PHY |
 			 IMX_PCIE_FLAG_SPEED_CHANGE_WORKAROUND |
+			 IMX_PCIE_FLAG_SKIP_L23_READY |
 			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
 		.gpr = "fsl,imx6q-iomuxc-gpr",
 		.ltssm_off = IOMUXC_GPR12,


