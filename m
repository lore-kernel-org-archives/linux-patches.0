Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C3831987D;
	Tue,  2 Sep 2025 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820095; cv=none; b=WPxRHDHkLx/Bwjt+YoZft1/r+jHhjPrue5eKyUt6jJ7K8RjSpTNGuCYciYfxBhwHDrKmSRUrfZMpJ8bagGGT62j7l1czZLkkNSnNw/MtcZKw2hiyUNh5iLle6wNRI5owSIIud9wD17ZKMVKe6H5cimc97deW2e2TU6DU8FgufO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820095; c=relaxed/simple;
	bh=E3FFS4ppZZGBfUp+W6PHGC3YixzxxEkQn+Myt3V3X90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNHVcZ4Yy0s3Iv+mo4mgrmZD5bdK4in372vKZRqcrfbGD7tfGRA+8Gze2v3rJg1Bna2NHmP4Us/FcgPAXIaF7Yol+wuIoWnZu9wZgnVEMEohWofoHzR2NpvyiIdxM+y+Iu2L8BULlmoRSpUQzzW568ulk0dhYBBMz69va9sfLEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g52cGK2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g52cGK2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AF4C4CEED;
	Tue,  2 Sep 2025 13:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820095;
	bh=E3FFS4ppZZGBfUp+W6PHGC3YixzxxEkQn+Myt3V3X90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g52cGK2+POQmaSyRP69ypvEFtNFWvfubQEWSJybB3rbAfFWJuxyGpB9Cky3eydruR
	 pGPN0p5paqLizTkFBJYjDuHqrTiJXIC2jcM02eJ6ZsMRcOUU0gOOjQTebenjjH5dzF
	 Zp7XDCdd2jaOcdRvthhKfu6ojL4eiqlzj9eziBN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>
Subject: [PATCH 6.12 91/95] PCI: dwc: Ensure that dw_pcie_wait_for_link() waits 100 ms after link up
Date: Tue,  2 Sep 2025 15:21:07 +0200
Message-ID: <20250902131943.094194915@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit 80dc18a0cba8dea42614f021b20a04354b213d86 upstream.

As per PCIe r6.0, sec 6.6.1, a Downstream Port that supports Link speeds
greater than 5.0 GT/s, software must wait a minimum of 100 ms after Link
training completes before sending a Configuration Request.

Add this delay in dw_pcie_wait_for_link(), after the link is reported as
up. The delay will only be performed in the success case where the link
came up.

DWC glue drivers that have a link up IRQ (drivers that set
use_linkup_irq = true) do not call dw_pcie_wait_for_link(), instead they
perform this delay in their threaded link up IRQ handler.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Link: https://patch.msgid.link/20250625102347.1205584-14-cassel@kernel.org
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -655,6 +655,14 @@ int dw_pcie_wait_for_link(struct dw_pcie
 		return -ETIMEDOUT;
 	}
 
+	/*
+	 * As per PCIe r6.0, sec 6.6.1, a Downstream Port that supports Link
+	 * speeds greater than 5.0 GT/s, software must wait a minimum of 100 ms
+	 * after Link training completes before sending a Configuration Request.
+	 */
+	if (pci->max_link_speed > 2)
+		msleep(PCIE_RESET_CONFIG_WAIT_MS);
+
 	offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
 	val = dw_pcie_readw_dbi(pci, offset + PCI_EXP_LNKSTA);
 


