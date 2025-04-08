Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4F2638B8;
	Tue,  8 Apr 2025 12:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114429; cv=none; b=ghrZeAmCEgHQngc2I2rp4gPic483JkqexcF8Lytg3txBkEOnrO+84hUYh5ECi1ziQpctn3tn7nOUHEDCupGsxGe7qm2NtAUS3In6+eXkDVPGzexjJzVOZdwJnEsNDMl+eLx8OnR8U/oAw6gXuR7ObOuOqqtCXVab7JoDQF3gV78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114429; c=relaxed/simple;
	bh=4ks3joYJYg4ZgBZPDIyrmZ4Iwqh7Ass2Vizg0PzZpiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JcJYJxVQDWAHVyFlCRxMAHL+SiDWZwwCfdMDi/VTdmx7EzfQfc8smJy7HR5oJSQAIaH22cB7cQf6DuXCGMSadhogg+fyQCW2OnWiLvtds44tEYRXIoH9fz1+gEljRpBC3pX36RrS3NhHg3Gvl1Q7p12gkIMbkql2jH2V07GHFWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZRodT4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZRodT4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC09C4CEE5;
	Tue,  8 Apr 2025 12:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114429;
	bh=4ks3joYJYg4ZgBZPDIyrmZ4Iwqh7Ass2Vizg0PzZpiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZRodT4WlGC3D3BLAGT8XIvFgI72mSqSQwvF9AxYccQreCD0zwHxgX7GB6Clal7gL
	 6PQEdlmaj3T3MIPgStftfj4tBxCXUcnqQ9plGJ/xeK8RVjFi6gn89z9gKcmdvAEUIw
	 TVL860huo2o8a6mYjLTdX5pHqb32dYPN0MK2lENw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thippeswamy Havalige <thippeswamy.havalige@amd.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 103/499] PCI: xilinx-cpm: Fix IRQ domain leak in error path of probe
Date: Tue,  8 Apr 2025 12:45:15 +0200
Message-ID: <20250408104853.780942004@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index a0f5e1d67b04c..1594d9e9e637a 100644
--- a/drivers/pci/controller/pcie-xilinx-cpm.c
+++ b/drivers/pci/controller/pcie-xilinx-cpm.c
@@ -570,15 +570,17 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
 		return err;
 
 	bus = resource_list_first_type(&bridge->windows, IORESOURCE_BUS);
-	if (!bus)
-		return -ENODEV;
+	if (!bus) {
+		err = -ENODEV;
+		goto err_free_irq_domains;
+	}
 
 	port->variant = of_device_get_match_data(dev);
 
 	err = xilinx_cpm_pcie_parse_dt(port, bus->res);
 	if (err) {
 		dev_err(dev, "Parsing DT failed\n");
-		goto err_parse_dt;
+		goto err_free_irq_domains;
 	}
 
 	xilinx_cpm_pcie_init_port(port);
@@ -602,7 +604,7 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
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



