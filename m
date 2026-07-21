Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A39146EC82;
	Tue, 21 Jul 2026 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662574; cv=none; b=MQN6hjlG6Dlafz1Y9cD0u2bxxsu1rW4Lh2V2DNf3Uq4Y3TkD/r2c11qFD0Pr8CEJYqJVnuMeGY+TFLFiED9HJi9JUGcXDLpn3tp/qAkQdopNEiMzXWeyLggF2AddRHOZmuJ+3UmuIeIfQWKjw+lQeG4uqQqMf/XxBqaM8vPrVnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662574; c=relaxed/simple;
	bh=D8DxZLx1xvzJhaELbFcLVCEZpXi4vT76fa9j7OX/n6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJHPU/FP4nx/iApqym83wN4tANj67KjW0SlG4+9O/14XU0zuT6ZC5/0FEI3JPxj9vEAc8h/k6HGFJTX8UomixmW1tHZWL4R42b9ZFhy4PYH4GOR4TJRTr1rLvhQBWsl80sMUH3A5NI8e4TBmRKlMXI/2Mesxh3KD3dQC+JFW8V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzZBaAik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzZBaAik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CDE1F000E9;
	Tue, 21 Jul 2026 19:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662573;
	bh=h7RWqB2baNsILiC8CbCUh2E+v0jAjG6KjQEBcxtWHnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzZBaAik/8+VtC8YuEzLzJC8OYZMh88saS3Ho7ER9AGxNXi26d1y1QeOkTpSOMSnp
	 iQa/PROjon/5Xv/ufuIl/rrjQ5xM8EASHmAEya7XN1dCAKAuesnSgiv/WJMOStWtmN
	 jP1ZQAonwbXzkPQGQK1uGRws8cX3tOyz+g31bWRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0495/1276] PCI: meson: Add missing remove callback
Date: Tue, 21 Jul 2026 17:15:38 +0200
Message-ID: <20260721152457.180317358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit 4b0dc84b293984f75598881809fb2d3daf54a2a8 ]

meson_pcie_probe() powers on the PHY and registers the DesignWare host
bridge with dw_pcie_host_init(), but the driver has no remove callback.
On driver unbind or module unload, the driver core therefore proceeds to
devres cleanup without first unregistering the host bridge or powering off
the PHY.

Add a remove callback that deinitializes the DesignWare host bridge and
powers off the PHY while device-managed resources are still valid.

Fixes: 9c0ef6d34fdb ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/1a0c86ab264cdc1c79c917e984b90991af51d827.1779123847.git.shuvampandey1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-meson.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-meson.c b/drivers/pci/controller/dwc/pci-meson.c
index 8b00c7db7435bd..3fff8ed93ef3d7 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -472,6 +472,14 @@ static int meson_pcie_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static void meson_pcie_remove(struct platform_device *pdev)
+{
+	struct meson_pcie *mp = platform_get_drvdata(pdev);
+
+	dw_pcie_host_deinit(&mp->pci.pp);
+	meson_pcie_power_off(mp);
+}
+
 static const struct of_device_id meson_pcie_of_match[] = {
 	{
 		.compatible = "amlogic,axg-pcie",
@@ -485,6 +493,7 @@ MODULE_DEVICE_TABLE(of, meson_pcie_of_match);
 
 static struct platform_driver meson_pcie_driver = {
 	.probe = meson_pcie_probe,
+	.remove = meson_pcie_remove,
 	.driver = {
 		.name = "meson-pcie",
 		.of_match_table = meson_pcie_of_match,
-- 
2.53.0



