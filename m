Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6D5267F4F;
	Tue,  8 Apr 2025 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112689; cv=none; b=nwf1CFugaADiDtDdJeiLrHXXD8xNR/zNWqURnBSOqA6rWlwOZkNnsTMFTu2XT+k4iw5yttPCJsM7PEAbr4Hr4N36pat9DIzVQbvyMY6o/18zaFMIjgl+jLHvjQivbjls425axxGNAjkWGa69RfL1E2a7OPK2kIl0QyqV8wF0MKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112689; c=relaxed/simple;
	bh=2RsSZm/gutwCTFPejUP0lIEKpS6V8iPVkSzYrOkOxTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCuYEXUtX5646O2/iBDJB3+t/fI+NErUsAJwa35nOJ7LfYkPMK8exWT7qciCO2kYCnABiftGEcIW5GVN0l4SI0BKmsHeXobCpP+wi0tI3xhYbB8l3x+7l45M4xpf9Yn0D5S53vg+2xS6xzbAPHb0PiTlxwi3vmW61VCGg7tBjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsKE99cL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsKE99cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE27BC4CEE5;
	Tue,  8 Apr 2025 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112689;
	bh=2RsSZm/gutwCTFPejUP0lIEKpS6V8iPVkSzYrOkOxTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsKE99cLDeNBkM1lCeQaFTCgWmOJ2G3MEveizHu/4ZIfH3nPxYd/c/Pb/mh0HTx9o
	 +FdPdNcYRQtKxxqRh00+hCV752W4+pb7+Z9mdT95NC7mJCXY1QDYG1HkX82ljS6FKI
	 XDUhmd3f2et7YIVLTYBWZnYbJEl0z+Iqk0vzoKaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thippeswamy Havalige <thippeswamy.havalige@amd.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/279] PCI: xilinx-cpm: Fix IRQ domain leak in error path of probe
Date: Tue,  8 Apr 2025 12:49:03 +0200
Message-ID: <20250408104830.655986027@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thippeswamy Havalige <thippeswamy.havalige@amd.com>

[ Upstream commit 57b0302240741e73fe51f88404b3866e0d2933ad ]

The IRQ domain allocated for the PCIe controller is not freed if
resource_list_first_type() returns NULL, leading to a resource leak.

This fix ensures properly cleaning up the allocated IRQ domain in
the error path.

Fixes: 49e427e6bdd1 ("Merge branch 'pci/host-probe-refactor'")
Signed-off-by: Thippeswamy Havalige <thippeswamy.havalige@amd.com>
[kwilczynski: added missing Fixes: tag, refactored to use one of the goto labels]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://lore.kernel.org/r/20250224155025.782179-2-thippeswamy.havalige@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-cpm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-cpm.c b/drivers/pci/controller/pcie-xilinx-cpm.c
index 95426df032000..1e72cea8563f3 100644
--- a/drivers/pci/controller/pcie-xilinx-cpm.c
+++ b/drivers/pci/controller/pcie-xilinx-cpm.c
@@ -556,13 +556,15 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
 		return err;
 
 	bus = resource_list_first_type(&bridge->windows, IORESOURCE_BUS);
-	if (!bus)
-		return -ENODEV;
+	if (!bus) {
+		err = -ENODEV;
+		goto err_free_irq_domains;
+	}
 
 	err = xilinx_cpm_pcie_parse_dt(port, bus->res);
 	if (err) {
 		dev_err(dev, "Parsing DT failed\n");
-		goto err_parse_dt;
+		goto err_free_irq_domains;
 	}
 
 	xilinx_cpm_pcie_init_port(port);
@@ -586,7 +588,7 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
 	xilinx_cpm_free_interrupts(port);
 err_setup_irq:
 	pci_ecam_free(port->cfg);
-err_parse_dt:
+err_free_irq_domains:
 	xilinx_cpm_free_irq_domains(port);
 	return err;
 }
-- 
2.39.5



