Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D415330B30;
	Fri, 17 Oct 2025 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715695; cv=none; b=NBBx/2yU7QYS2tz2sTGFn9wqAToVBXpOFBWTZyvHeFM8UaN6awjp0Q9sckkFGpgE/QjCyRSYlfGAlBTwNsFeFb+CMcpESEywTRSI/HFXf59vqQmbW1CnMQv2IRG2a2Qa/dvT2pDx6fUKQV99kwzPdeDJV4vBueHJYNxhhzusPAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715695; c=relaxed/simple;
	bh=1Htt8wIo7DV7bUp68eZLEe2kyhvnehkKs/ezxOb6MFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex8YR7n7TP2Z/ZOIDOZmhOyQqKAht75m/nTDLpM7Rbr4JVNCoY4GJb/roJ5Y0WMs1dSTBMdysyklIILh6pEEcZnZgBDOO+66SHOOgs99or6GTQg2j5vUfh0Os5WSV0GWZPWgWH2M2gnYk42LJUaLux3avRXjXOs1zA3WPgtKgFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Y6qk6L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Y6qk6L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FAEC4CEE7;
	Fri, 17 Oct 2025 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715695;
	bh=1Htt8wIo7DV7bUp68eZLEe2kyhvnehkKs/ezxOb6MFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Y6qk6L/CBzhFoYXKE1xLM/apIGWzIlPL0ljR7EgQ8TTS8p9OCdnwQBZiiNRdAFiC
	 yL2isvIhjoqJuOn4wsqjaHFz0erw4kdPJE5jD3RZn/oUDuVeVCEGGMU09FQXLqeR/4
	 lsimwJPRh2vaEzzZbTHbaeUZgxbqeXOt+VhIy3sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nurminen <jani.nurminen@windriver.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.17 273/371] PCI: xilinx-nwl: Fix ECAM programming
Date: Fri, 17 Oct 2025 16:54:08 +0200
Message-ID: <20251017145211.951542077@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nurminen <jani.nurminen@windriver.com>

commit 98a4f5b7359205ced1b6a626df3963bf7c5e5052 upstream.

When PCIe has been set up by the bootloader, the ecam_size field in the
E_ECAM_CONTROL register already contains a value.

The driver previously programmed it to 0xc (for 16 busses; 16 MB), but
bumped to 0x10 (for 256 busses; 256 MB) by the commit 2fccd11518f1 ("PCI:
xilinx-nwl: Modify ECAM size to enable support for 256 buses").

Regardless of what the bootloader has programmed, the driver ORs in a
new maximal value without doing a proper RMW sequence. This can lead to
problems.

For example, if the bootloader programs in 0xc and the driver uses 0x10,
the ORed result is 0x1c, which is beyond the ecam_max_size limit of 0x10
(from E_ECAM_CAPABILITIES).

Avoid the problems by doing a proper RMW.

Fixes: 2fccd11518f1 ("PCI: xilinx-nwl: Modify ECAM size to enable support for 256 buses")
Signed-off-by: Jani Nurminen <jani.nurminen@windriver.com>
[mani: added stable tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/e83a2af2-af0b-4670-bcf5-ad408571c2b0@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -718,9 +718,10 @@ static int nwl_pcie_bridge_init(struct n
 	nwl_bridge_writel(pcie, nwl_bridge_readl(pcie, E_ECAM_CONTROL) |
 			  E_ECAM_CR_ENABLE, E_ECAM_CONTROL);
 
-	nwl_bridge_writel(pcie, nwl_bridge_readl(pcie, E_ECAM_CONTROL) |
-			  (NWL_ECAM_MAX_SIZE << E_ECAM_SIZE_SHIFT),
-			  E_ECAM_CONTROL);
+	ecam_val = nwl_bridge_readl(pcie, E_ECAM_CONTROL);
+	ecam_val &= ~E_ECAM_SIZE_LOC;
+	ecam_val |= NWL_ECAM_MAX_SIZE << E_ECAM_SIZE_SHIFT;
+	nwl_bridge_writel(pcie, ecam_val, E_ECAM_CONTROL);
 
 	nwl_bridge_writel(pcie, lower_32_bits(pcie->phys_ecam_base),
 			  E_ECAM_BASE_LO);


