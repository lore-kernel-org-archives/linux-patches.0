Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF49269B1B;
	Tue,  8 Apr 2025 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115627; cv=none; b=crP6UDBklw0gUBSv4D0X/IMuzBxAY+8ADUzcyC9yxcyXbLvh+4NOU7N5rXKG+9VOBXUHMZKdpS/8pJqnyMau501LqBZOiLNUCqipQy+8L/xsRFQwbabd0f1C9T4a4Kx1ZvgjKeqOfiAbo0/fIWcVOI7ONiGnKDOEyDq9o2+EjyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115627; c=relaxed/simple;
	bh=QBmXkt3w/9q2rqBM5mtmuGMm3nmK++faGgcy3Ve2tGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAwj7/PUhFT7dzlO6TKFUbc+P0IFaIQsRAw2/2GOZlzJjbTPBShrYdfW1xmH229tZUSlSMX9LPgmCs7ic1WUQST/xMi/iGwh/TY0oe0S3V5scJZHpmxlYVrGkR9z/sYS9DsOcscf0ry8gpimOPHHvVet7AqrJV4vnVsfODV3FaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+04Kj+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+04Kj+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A92C4CEE5;
	Tue,  8 Apr 2025 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115626;
	bh=QBmXkt3w/9q2rqBM5mtmuGMm3nmK++faGgcy3Ve2tGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+04Kj+nzADZ1E1yNiSux7khjARWwOeU+8Jsytt3VoexQOWJDKHL7hgzCghwM8k/4
	 kjjMYLUZ9g6YKbcYuAk9YTDdqvFR8ljh595yjlfGK18fuO4mDNTMmhPB48ppVC4Rrw
	 JARwwhCXaau3yXRoiePqDtvdGImF6ycY0nqlXfAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thippeswamy Havalige <thippeswamy.havalige@amd.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/204] PCI: xilinx-cpm: Fix IRQ domain leak in error path of probe
Date: Tue,  8 Apr 2025 12:49:35 +0200
Message-ID: <20250408104821.667957255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4ab48041eb6d..53cf701bb228a 100644
--- a/drivers/pci/controller/pcie-xilinx-cpm.c
+++ b/drivers/pci/controller/pcie-xilinx-cpm.c
@@ -595,15 +595,17 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
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
@@ -627,7 +629,7 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
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



