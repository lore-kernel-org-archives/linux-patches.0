Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD93336EE5;
	Fri, 17 Oct 2025 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715629; cv=none; b=X1ijj5X1BKNamFMRYH8gV1rOzZKVkLOOnmW5qJ4KXfSjFVLDpwtxAbb3P7y8s7M+AzdefFGLXpwItX6w3BOXXo1TXE5D51c5cP5TK+MsY9EOKwBFAeDoko8D/074M2gr3Tnb5awGJliq/ldisKwAyx06UeHU8UqMPIpRSZXleYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715629; c=relaxed/simple;
	bh=MsGVUmrIxp3DF8NLfxPeDgdZAn7W7uAiVkf+Jv/Pigg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbKg/c9dYD/3PS7rB5r3DRmEaYZKMOnoFCKK7JQ1IrgIDvTtJxBtJ929LSlGrofsSYVXn+ItoUuHOpPiLgnZTP4KlsbL8O6Yg/z+gFVpxVV3j3OITInNISQR5mcLrxQjmAKv9i/nZrATlCNGMmBRadvJ3MabDjWFb5cgSxSRNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAXalWDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAXalWDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99154C4CEE7;
	Fri, 17 Oct 2025 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715629;
	bh=MsGVUmrIxp3DF8NLfxPeDgdZAn7W7uAiVkf+Jv/Pigg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAXalWDisJCyzmAMXz7pub/KoHSdyjrau0A/QPlZciGATcH3g6C3D2L6iNsHKOYkK
	 7vJAAAxeBnwqOwYQdvZVtkJdTsWpyYBmP5NlIitwGygy7vnz8O2Nc8r9rjgnI+XGRX
	 LyfxegBnRMLiGhrdnnVf/XRv/SH/QZDt/cQGS/rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.17 283/371] PCI: j721e: Fix programming sequence of "strap" settings
Date: Fri, 17 Oct 2025 16:54:18 +0200
Message-ID: <20251017145212.314002896@linuxfoundation.org>
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit f842d3313ba179d4005096357289c7ad09cec575 upstream.

The Cadence PCIe Controller integrated in the TI K3 SoCs supports both
Root-Complex and Endpoint modes of operation. The Glue Layer allows
"strapping" the Mode of operation of the Controller, the Link Speed
and the Link Width. This is enabled by programming the "PCIEn_CTRL"
register (n corresponds to the PCIe instance) within the CTRL_MMR
memory-mapped register space. The "reset-values" of the registers are
also different depending on the mode of operation.

Since the PCIe Controller latches onto the "reset-values" immediately
after being powered on, if the Glue Layer configuration is not done while
the PCIe Controller is off, it will result in the PCIe Controller latching
onto the wrong "reset-values". In practice, this will show up as a wrong
representation of the PCIe Controller's capability structures in the PCIe
Configuration Space. Some such capabilities which are supported by the PCIe
Controller in the Root-Complex mode but are incorrectly latched onto as
being unsupported are:
- Link Bandwidth Notification
- Alternate Routing ID (ARI) Forwarding Support
- Next capability offset within Advanced Error Reporting (AER) capability

Fix this by powering off the PCIe Controller before programming the "strap"
settings and powering it on after that. The runtime PM APIs namely
pm_runtime_put_sync() and pm_runtime_get_sync() will decrement and
increment the usage counter respectively, causing GENPD to power off and
power on the PCIe Controller.

Fixes: f3e25911a430 ("PCI: j721e: Add TI J721E PCIe driver")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250908120828.1471776-1-s-vadapalli@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/cadence/pci-j721e.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -284,6 +284,25 @@ static int j721e_pcie_ctrl_init(struct j
 	if (!ret)
 		offset = args.args[0];
 
+	/*
+	 * The PCIe Controller's registers have different "reset-values"
+	 * depending on the "strap" settings programmed into the PCIEn_CTRL
+	 * register within the CTRL_MMR memory-mapped register space.
+	 * The registers latch onto a "reset-value" based on the "strap"
+	 * settings sampled after the PCIe Controller is powered on.
+	 * To ensure that the "reset-values" are sampled accurately, power
+	 * off the PCIe Controller before programming the "strap" settings
+	 * and power it on after that. The runtime PM APIs namely
+	 * pm_runtime_put_sync() and pm_runtime_get_sync() will decrement and
+	 * increment the usage counter respectively, causing GENPD to power off
+	 * and power on the PCIe Controller.
+	 */
+	ret = pm_runtime_put_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to power off PCIe Controller\n");
+		return ret;
+	}
+
 	ret = j721e_pcie_set_mode(pcie, syscon, offset);
 	if (ret < 0) {
 		dev_err(dev, "Failed to set pci mode\n");
@@ -302,6 +321,12 @@ static int j721e_pcie_ctrl_init(struct j
 		return ret;
 	}
 
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to power on PCIe Controller\n");
+		return ret;
+	}
+
 	/* Enable ACSPCIE refclk output if the optional property exists */
 	syscon = syscon_regmap_lookup_by_phandle_optional(node,
 						"ti,syscon-acspcie-proxy-ctrl");


