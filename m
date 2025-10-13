Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D57A30B515;
	Mon, 13 Oct 2025 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369611; cv=none; b=Cv01FJ/60s2fRE7YTlpoM5jc27nBolr1fek+JiDD/Lr+j5/0Ihc4z1EJ+dCFGJElPdxtl78Kf22Ce+BXDiQlqdCtuuyy03LRQ66McXG9Od3El52gBqcoaWbqAWS7G9A7+jBQpgje9fVK8BmzfqALIZj/LSizPph/65/zW4ADu90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369611; c=relaxed/simple;
	bh=MsLO+LqsKY1b5bfTs4mAC48U4SlrJaN23tj9a2BaS/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbQLZIRVlhYN5fstYnURJADAM/74pwvQnDFQDe1MTv17w4mFYiKZo6BMFunB9MkdvU0MG80Ma1wxkM96zjp9vJYXiscwwYI/EKAaU2hyOTr5RjmiOHx67W4wmYBrPV5S45HOHZD5Yg4FINM0Px8xGIBfHgRbaeNOYxqX2TSp/pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zouniV0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zouniV0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA5FC4CEE7;
	Mon, 13 Oct 2025 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369611;
	bh=MsLO+LqsKY1b5bfTs4mAC48U4SlrJaN23tj9a2BaS/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zouniV0xHtONQzRzb06DefrnDmRRIccSFuGDXK2IpzNzagOpNRfQPM+ripyjWumUN
	 VFjsBUDV4UqGN7lFnyVeQ7hGJ2YJs7oARLVPCkH5YWeoDYtLyNHyhC4sO6nNzrQw3K
	 cr2TN+F/0z983dGjjV0UnXsIGomuty55Dk3DECpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 274/563] cdx: dont select CONFIG_GENERIC_MSI_IRQ
Date: Mon, 13 Oct 2025 16:42:15 +0200
Message-ID: <20251013144421.199688854@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Nipun Gupta <nipun.gupta@amd.com>

[ Upstream commit ab1d8dda32e9507ca3bfb6b43661aeaa27f7bd82 ]

x86 does not use CONFIG_GENERIC_MSI_IRQ, and trying to enable it anyway
results in a build failure:

In file included from include/linux/ssb/ssb.h:10,
                 from drivers/ssb/pcihost_wrapper.c:18:
include/linux/gpio/driver.h:41:33: error: field 'msiinfo' has incomplete type
   41 |         msi_alloc_info_t        msiinfo;
      |                                 ^~~~~~~
In file included from include/linux/kvm_host.h:19,
                 from arch/x86/events/intel/core.c:17:
include/linux/msi.h:528:33: error: field 'alloc_info' has incomplete type
  528 |         msi_alloc_info_t        alloc_info;

Change the driver to actually build without this symbol and remove the
incorrect 'select' statements.

Fixes: e8b18c11731d ("cdx: Fix missing GENERIC_MSI_IRQ on compile test")
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://lore.kernel.org/r/20250826043852.2206008-1-nipun.gupta@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdx/Kconfig                     | 1 -
 drivers/cdx/cdx.c                       | 4 ++--
 drivers/cdx/controller/Kconfig          | 1 -
 drivers/cdx/controller/cdx_controller.c | 3 ++-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cdx/Kconfig b/drivers/cdx/Kconfig
index 3af41f51cf38b..1f1e360507d7d 100644
--- a/drivers/cdx/Kconfig
+++ b/drivers/cdx/Kconfig
@@ -8,7 +8,6 @@
 config CDX_BUS
 	bool "CDX Bus driver"
 	depends on OF && ARM64 || COMPILE_TEST
-	select GENERIC_MSI_IRQ
 	help
 	  Driver to enable Composable DMA Transfer(CDX) Bus. CDX bus
 	  exposes Fabric devices which uses composable DMA IP to the
diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index 092306ca2541c..3d50f8cd9c0bd 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -310,7 +310,7 @@ static int cdx_probe(struct device *dev)
 	 * Setup MSI device data so that generic MSI alloc/free can
 	 * be used by the device driver.
 	 */
-	if (cdx->msi_domain) {
+	if (IS_ENABLED(CONFIG_GENERIC_MSI_IRQ) && cdx->msi_domain) {
 		error = msi_setup_device_data(&cdx_dev->dev);
 		if (error)
 			return error;
@@ -833,7 +833,7 @@ int cdx_device_add(struct cdx_dev_params *dev_params)
 		     ((cdx->id << CDX_CONTROLLER_ID_SHIFT) | (cdx_dev->bus_num & CDX_BUS_NUM_MASK)),
 		     cdx_dev->dev_num);
 
-	if (cdx->msi_domain) {
+	if (IS_ENABLED(CONFIG_GENERIC_MSI_IRQ) && cdx->msi_domain) {
 		cdx_dev->num_msi = dev_params->num_msi;
 		dev_set_msi_domain(&cdx_dev->dev, cdx->msi_domain);
 	}
diff --git a/drivers/cdx/controller/Kconfig b/drivers/cdx/controller/Kconfig
index 0641a4c21e660..a480b62cbd1f7 100644
--- a/drivers/cdx/controller/Kconfig
+++ b/drivers/cdx/controller/Kconfig
@@ -10,7 +10,6 @@ if CDX_BUS
 config CDX_CONTROLLER
 	tristate "CDX bus controller"
 	depends on HAS_DMA
-	select GENERIC_MSI_IRQ
 	select REMOTEPROC
 	select RPMSG
 	help
diff --git a/drivers/cdx/controller/cdx_controller.c b/drivers/cdx/controller/cdx_controller.c
index fca83141e3e66..5e3fd89b6b561 100644
--- a/drivers/cdx/controller/cdx_controller.c
+++ b/drivers/cdx/controller/cdx_controller.c
@@ -193,7 +193,8 @@ static int xlnx_cdx_probe(struct platform_device *pdev)
 	cdx->ops = &cdx_ops;
 
 	/* Create MSI domain */
-	cdx->msi_domain = cdx_msi_domain_init(&pdev->dev);
+	if (IS_ENABLED(CONFIG_GENERIC_MSI_IRQ))
+		cdx->msi_domain = cdx_msi_domain_init(&pdev->dev);
 	if (!cdx->msi_domain) {
 		ret = dev_err_probe(&pdev->dev, -ENODEV, "cdx_msi_domain_init() failed");
 		goto cdx_msi_fail;
-- 
2.51.0



