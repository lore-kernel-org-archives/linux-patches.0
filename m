Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C889187543;
	Mon, 12 Aug 2024 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480297; cv=none; b=RYc1OIt00zRTu7uqdNa2/9S2G6XtN5RAZqw9Wfh3PUw2qPx/jAujn2DrnA2L8lJbQcd7jvlBPzJRJ30YKT1AQIlafLPiKHQ6/oBQooIMXR3loAB2DnMF7ZgZtsccg0ge/4ZsTyA9KV3B8zAcowxMldfIS9TmLuwhU7fE9fyMgEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480297; c=relaxed/simple;
	bh=/O1nVAxHz1Rd7PVHtHfVJHkrzyr9+rEuKStsNy3NPzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2JCvphXtJ3Eka6wiUooWNfK+qMbfPNyeFlcS6RgW3ZsRPuIVlr7ULAxf6/MedVbRshgSTXmEmQHeYnQKZdr4FfVc2/5Bkp0TselNikxdqM7uVngFyb0vBnLIDPG9RE6IkeBkCzhGOObCIkqzEdh4iRI3v8JqZna4hQVWoPfpSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziMPa5Pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziMPa5Pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D26C32782;
	Mon, 12 Aug 2024 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480297;
	bh=/O1nVAxHz1Rd7PVHtHfVJHkrzyr9+rEuKStsNy3NPzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziMPa5PiT44NxAhOxm+2kzQ6qy0VvpjMk1/P8lbUa4vuT/bd1vl+aPdCtJGOyIbnw
	 fJaEKL+Tic5f0ohPqgix+/1OpPslNn68J8LIqSbMcLULYy4D8XfrEtLbET/tvvqjWB
	 FNrSChTlTRSFVTmGZH86136APNubFpw/5RmQZ1PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 123/263] media: ipu-bridge: fix ipu6 Kconfig dependencies
Date: Mon, 12 Aug 2024 18:02:04 +0200
Message-ID: <20240812160151.256949033@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit d7b5f7537c8282e1e1919408d0b6c69877fd35f8 upstream.

Commit 4670c8c3fb04 ("media: ipu-bridge: Fix Kconfig dependencies") changed
how IPU_BRIDGE dependencies are handled for all drivers, but the IPU6
variant was added the old way, which causes build time warnings when I2C is
turned off:

WARNING: unmet direct dependencies detected for IPU_BRIDGE
  Depends on [n]: MEDIA_SUPPORT [=m] && PCI [=y] && MEDIA_PCI_SUPPORT [=y] && (ACPI [=y] || COMPILE_TEST [=y]) && I2C [=n]
  Selected by [m]:
  - VIDEO_INTEL_IPU6 [=m] && MEDIA_SUPPORT [=m] && PCI [=y] && MEDIA_PCI_SUPPORT [=y] && (ACPI [=y] || COMPILE_TEST [=y]) && VIDEO_DEV [=m] && X86 [=y] && X86_64 [=y] && HAS_DMA [=y]

To make it consistent with the other IPU drivers as well as avoid this
warning, change the 'select' into 'depends on'.

Fixes: c70281cc83d6 ("media: intel/ipu6: add Kconfig and Makefile")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[Sakari Ailus: Alternatively depend on !IPU_BRIDGE.]
Cc: stable@vger.kernel.org # for v6.10
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu6/Kconfig b/drivers/media/pci/intel/ipu6/Kconfig
index 154343080c82..b7ab24b89836 100644
--- a/drivers/media/pci/intel/ipu6/Kconfig
+++ b/drivers/media/pci/intel/ipu6/Kconfig
@@ -3,13 +3,13 @@ config VIDEO_INTEL_IPU6
 	depends on ACPI || COMPILE_TEST
 	depends on VIDEO_DEV
 	depends on X86 && X86_64 && HAS_DMA
+	depends on IPU_BRIDGE || !IPU_BRIDGE
 	select DMA_OPS
 	select IOMMU_IOVA
 	select VIDEO_V4L2_SUBDEV_API
 	select MEDIA_CONTROLLER
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
-	select IPU_BRIDGE
 	help
 	  This is the 6th Gen Intel Image Processing Unit, found in Intel SoCs
 	  and used for capturing images and video from camera sensors.
-- 
2.46.0



