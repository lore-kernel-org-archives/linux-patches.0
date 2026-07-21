Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CEE413D9C;
	Tue, 21 Jul 2026 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660424; cv=none; b=slFT2BM7OjqJBzkQNrMd6R5ebk5EG7YupqHa9+N3Z5c6buoM19W4Yci6SyjUB4OkxTL94neZ92dXZO00LIaXiKeMO2zawJnWXeF/krg+4zQCI/7CTUGKGsQBR6DHLrJv2R3vEdb1ZDcBuTjpHWCWoK3XThRrvfm5BMn36qVM2zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660424; c=relaxed/simple;
	bh=jRoQPIrri8RFBTlaruv95coch9phlJhDjnmm48sB6rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLOh+FF9It/Ki5rwBjHvBEUz1QQ4vyfQxgMRNu728kfK1/T6vM87OrLWg4XM5yRL/NIVxmMFGOOZjWi8m3BTbXEFk91wdkZ9R9HSeuJPbxMRWTsUnVZLcSUtE3gM7iw16qfr+t6pzACtIQFnNy4hntVazuZuu6WqVAGtJGI/S+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfmEJ6f+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfmEJ6f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCAA1F000E9;
	Tue, 21 Jul 2026 19:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660422;
	bh=p8HTeuy41U/+oWJEhXaGF04K0NSk7UsLK3/11FForfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfmEJ6f+1ij4rWpM8AWEPcVeOFEO/3IKDn8qqFjJYZijSyNZZ/LSmWcqs4knTqfmg
	 0ASGbPAhNqEtuIq6dtc0/gJyssIVwVUl0Bv+p/TABh2kfX7drI/m6qJg7CzzGeRALX
	 XNkQlX+0VHC36CNKtNOMw2b4KUWUnNyccC1DPHYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0975/2077] PCI: meson: Add missing remove callback
Date: Tue, 21 Jul 2026 17:10:48 +0200
Message-ID: <20260721152615.814295188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d495bcc3a41ae..225d887cd0a3e1 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -453,6 +453,14 @@ static int meson_pcie_probe(struct platform_device *pdev)
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
@@ -466,6 +474,7 @@ MODULE_DEVICE_TABLE(of, meson_pcie_of_match);
 
 static struct platform_driver meson_pcie_driver = {
 	.probe = meson_pcie_probe,
+	.remove = meson_pcie_remove,
 	.driver = {
 		.name = "meson-pcie",
 		.of_match_table = meson_pcie_of_match,
-- 
2.53.0



