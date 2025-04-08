Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B48268C6B;
	Tue,  8 Apr 2025 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113156; cv=none; b=UCpYrXG6UAxEgbWiYsSfAdKAJe3dKA+af5+eBdFC/PhoGmWfTU02du38WxYyltvQ7kFDa+kJ/pJvmfPBLiSU0WSCy0QwqnIeox76EL+xE9D/f7YIvi5K+ul81XwKwrIME3/VIQuZdC2RxNho76CT41c6D4tNVn7YJH31q+ytA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113156; c=relaxed/simple;
	bh=0FRFwgza53t0d2Z1USVSyF0oYLSbDxdRexafvArgSbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYm4Y5pSrUlLH1G1+kZCCtttpuKnKxeMvqCIPfiK/ANWlNe/5H3sB/BUFPJUdgRD/+in3I18EXVrXhgS3E5KqJSUqB5ZPZSteWDd1q9aN2kVaIQV9lDf3QAZTQwnc+vBKK3I5VHlp+PZNhOvGOKZkDA9d8FplwXPkPf7u0b3U2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnWrNA9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnWrNA9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9350C4CEE5;
	Tue,  8 Apr 2025 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113156;
	bh=0FRFwgza53t0d2Z1USVSyF0oYLSbDxdRexafvArgSbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnWrNA9mTvtsrA3D3Qk6QQv9PNV4NZGw1ioi8kV8r+2M1O8MrirOJDRjCYXa50TXi
	 5MNYa/PnVVCSqRkLg2VhDMkJ/cG97zPFJSwYJ4EbvjXGEneedzh0RrPNer/+LNUhjM
	 Kg/M0zR44HhknHsgTZ4ERFdN2j2tyADr+5DMvOcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thippeswamy Havalige <thippeswamy.havalige@amd.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/268] PCI: xilinx-cpm: Fix IRQ domain leak in error path of probe
Date: Tue,  8 Apr 2025 12:47:44 +0200
Message-ID: <20250408104829.931157091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a787a941674b..51379d791005b 100644
--- a/drivers/pci/controller/pcie-xilinx-cpm.c
+++ b/drivers/pci/controller/pcie-xilinx-cpm.c
@@ -594,15 +594,17 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
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
@@ -626,7 +628,7 @@ static int xilinx_cpm_pcie_probe(struct platform_device *pdev)
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



