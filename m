Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B053431748;
	Fri, 24 Nov 2023 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQhkOywp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C215AC433CC;
	Fri, 24 Nov 2023 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853496;
	bh=wmz59l3nKlwGq3kspWLuvwmeHrlQyuye9q9JpuOue8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQhkOywpkuzL6Bq8FRVkd2rM+E151FK7lfcSgnc0oiaWLD63SyV+e1jItkz94+r1m
	 DiXkSFsyTSPCHSz7iw7JwsSTkl2wqDG4ocUJDcEogh9vytAtHrmFH3n3Cx63rxurmn
	 SrzKZ1iDhfjNnpx5u06bLqhZ5D79DILf9NapDQt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 5.15 186/297] PCI: exynos: Dont discard .remove() callback
Date: Fri, 24 Nov 2023 17:53:48 +0000
Message-ID: <20231124172006.745436137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 83a939f0fdc208ff3639dd3d42ac9b3c35607fd2 upstream.

With CONFIG_PCI_EXYNOS=y and exynos_pcie_remove() marked with __exit, the
function is discarded from the driver. In this case a bound device can
still get unbound, e.g via sysfs. Then no cleanup code is run resulting in
resource leaks or worse.

The right thing to do is do always have the remove callback available.
This fixes the following warning by modpost:

  WARNING: modpost: drivers/pci/controller/dwc/pci-exynos: section mismatch in reference: exynos_pcie_driver+0x8 (section: .data) -> exynos_pcie_remove (section: .exit.text)

(with ARCH=x86_64 W=1 allmodconfig).

Fixes: 340cba6092c2 ("pci: Add PCIe driver for Samsung Exynos")
Link: https://lore.kernel.org/r/20231001170254.2506508-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-exynos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-exynos.c
+++ b/drivers/pci/controller/dwc/pci-exynos.c
@@ -377,7 +377,7 @@ fail_probe:
 	return ret;
 }
 
-static int __exit exynos_pcie_remove(struct platform_device *pdev)
+static int exynos_pcie_remove(struct platform_device *pdev)
 {
 	struct exynos_pcie *ep = platform_get_drvdata(pdev);
 
@@ -433,7 +433,7 @@ static const struct of_device_id exynos_
 
 static struct platform_driver exynos_pcie_driver = {
 	.probe		= exynos_pcie_probe,
-	.remove		= __exit_p(exynos_pcie_remove),
+	.remove		= exynos_pcie_remove,
 	.driver = {
 		.name	= "exynos-pcie",
 		.of_match_table = exynos_pcie_of_match,


