Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591FC3328EC;
	Fri, 17 Oct 2025 15:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714542; cv=none; b=hSMKeNmMUheDMEYEj67Z1f2ikGIrDaTtr6eHnR/4kiqxwGhRLGMlDCzBDmBZwzn025mRbJHQMaa+xtIyO6qDGnkcwUtjy8TAxlyZTfT5L+LnQpmLZFOKQ50mS/y9iOatovYAy/nN75Ui6U/ldcDqpUkE5h3qQuQkRfVv+N8neEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714542; c=relaxed/simple;
	bh=eD+hD/awVNVP61Ad//xgSneMCc8Uz8msrCTQhF1Xowo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sW30QbpxbbeyAEsw8lZTGSamyJuMYs4Cs55P/xCgEAOaYuyixyJMbmxtiSEEHuE4APnBxKr0y3IdLT0ZsCNFefvfVuFi6iV3h1giSVx8E2YZ5MdeQEab9ZEMJ3c7AEYlPBHmrpdGLpvQIK12l8lOx5m6y4KuPU/CfFqY9umXVwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCqm00yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCqm00yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2591C113D0;
	Fri, 17 Oct 2025 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714542;
	bh=eD+hD/awVNVP61Ad//xgSneMCc8Uz8msrCTQhF1Xowo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCqm00yyYna1QIy9XwJgB9EHL+68R7FDh6s+08FsrQqJSdbAHoL7cr+4Lld/HPujS
	 SeLXpI5hs499PKmv9RPAMSTy17O3F6kenmx0oBZFtBJTHlktJfMtXBhx6Flxec3bpD
	 JwHwo6039fY4D/KB2RABcm3T8ubyKom3Su3z6ejc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.12 182/277] PCI: j721e: Fix programming sequence of "strap" settings
Date: Fri, 17 Oct 2025 16:53:09 +0200
Message-ID: <20251017145153.771720546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
@@ -277,6 +277,25 @@ static int j721e_pcie_ctrl_init(struct j
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
@@ -295,6 +314,12 @@ static int j721e_pcie_ctrl_init(struct j
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


