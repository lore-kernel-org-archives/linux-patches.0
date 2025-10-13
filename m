Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7792031C595;
	Mon, 13 Oct 2025 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370004; cv=none; b=JUsh8d9a7lBAKi2xD8pb96YyOuvNeY3mgPliRQR21siU+A0go0069NyvtzMJqTEyAS5KsEeUKejvKJDMlB9QTjv1BopZ7USCKQn7ME4HI7p1p3r+xROY65UblZJm6eioQ29X4h/Ye5OzzlH2vqTucBng8bHaV8WO0rEdTqeKvUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370004; c=relaxed/simple;
	bh=Gj944v7ncaRRsOJEjoQqfYW8qQFITURTFZayHhdwbsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuGZ+Bt5GQWATn7KHoBxThyI/Uraam2zJh/nyiUERB3JANMxP3rz8eectAeJUW6ZhUf6H2A72fXBM3LsyTfN6YaOQX2SOwARjdfauEIhODS5ch7l3HVazcU2nW47RhcrwFhwJQ2b1oMYCrtQ2pz9rhn1ZtgUz97UM7z6XPDna/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwqXLvGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwqXLvGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1900C4CEE7;
	Mon, 13 Oct 2025 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370004;
	bh=Gj944v7ncaRRsOJEjoQqfYW8qQFITURTFZayHhdwbsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwqXLvGXoR7CERx1LuVbbzvoDZUfYf4wcD+rYdICzyPHxlj5bvhpVAMnqb0rMv6l7
	 xSsZbJBaXXhghzFZK2vprona3Hu9kaAq1GPQAHEjU8D0Cd7O7aJslnmZdXJnvmrEak
	 ihr5aWycf6THYwv/HLFJW/z7tD8Hkd+2h/bnyk/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 443/563] PCI: rcar-gen4: Assure reset occurs before DBI access
Date: Mon, 13 Oct 2025 16:45:04 +0200
Message-ID: <20251013144427.329856587@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 0056d29f8c1b13d7e60d60cdb159767ac8f6a883 ]

Assure the reset is latched and the core is ready for DBI access. On R-Car
V4H, the PCIe reset is asynchronous and does not take effect immediately,
but needs a short time to complete. In case DBI access happens in that
short time, that access generates an SError. Make sure that condition can
never happen, read back the state of the reset, which should turn the
asynchronous reset into a synchronous one, and wait a little over 1ms to
add additional safety margin.

Fixes: 0d0c551011df ("PCI: rcar-gen4: Add R-Car Gen4 PCIe controller support for host mode")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250924005610.96484-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index d9a42fa51520a..9ac3f0f11adad 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -213,6 +213,19 @@ static int rcar_gen4_pcie_common_init(struct rcar_gen4_pcie *rcar)
 	if (ret)
 		goto err_unprepare;
 
+	/*
+	 * Assure the reset is latched and the core is ready for DBI access.
+	 * On R-Car V4H, the PCIe reset is asynchronous and does not take
+	 * effect immediately, but needs a short time to complete. In case
+	 * DBI access happens in that short time, that access generates an
+	 * SError. To make sure that condition can never happen, read back the
+	 * state of the reset, which should turn the asynchronous reset into
+	 * synchronous one, and wait a little over 1ms to add additional
+	 * safety margin.
+	 */
+	reset_control_status(dw->core_rsts[DW_PCIE_PWR_RST].rstc);
+	fsleep(1000);
+
 	if (rcar->drvdata->additional_common_init)
 		rcar->drvdata->additional_common_init(rcar);
 
-- 
2.51.0



