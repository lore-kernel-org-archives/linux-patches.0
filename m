Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB452580F2;
	Mon, 13 Oct 2025 15:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368537; cv=none; b=PiNpgRju+dT0GAMndcOQm4WiK1o4sXXtY4FSoWs4zVyfG/OOjFDjmRO1xlmOxvR303IY7XOL4Z85sJlXhbOXRjV8rZwd6F1sMP5nrGsRwZKZqxrYGmb94eOSTljEUBWOjUXjcClGjzvDxuvzYt48KrW5GLFs/rXhZFA8Ec6XQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368537; c=relaxed/simple;
	bh=QrmdgupOwnAcELOuuXGTiV0vi308PSAkxHGd/pyR15k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAfmv+uv35GNE/91o31Ik534bBLkghg3X0mOKJYrSSxLESo7t+R8t5iaouKolmepSaYs9I3R27VP0ub+xOb7fj6M8BhbEi08p84vnmBUhARAzsJY8muM58NttrFUtDWZlh/nr0ebyE080BfE5tpLD7S1AqUajlnqc+aNv++M+RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtMdN3fC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtMdN3fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67882C4CEE7;
	Mon, 13 Oct 2025 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368537;
	bh=QrmdgupOwnAcELOuuXGTiV0vi308PSAkxHGd/pyR15k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtMdN3fC0AwkUv9U/QoaCIy4sz25RRbCMFNxgD1yAHILWpwMGyydv8pdUiZjSd3Cd
	 8mm+GuQXyKLxC+XABzzfXLhnKdVxF0IUKX0sFUFognr6ykmvILdeyV8XMH6Q/GWmxM
	 Nv0Jg+JvQ7EnYwZK1gLfXZpe2AyWeECJuixByV5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/262] PCI: rcar-gen4: Assure reset occurs before DBI access
Date: Mon, 13 Oct 2025 16:45:37 +0200
Message-ID: <20251013144333.270349671@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 5382008e366ec..30d16f85f6465 100644
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



