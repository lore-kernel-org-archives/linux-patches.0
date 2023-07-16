Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66E18F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E4DC433C8;
	Sun, 16 Jul 2023 20:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538487;
	bh=7oXSZxL4iLMZr1YXHc1AByR1VeHToOFHm/BNnKmO+OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04UC6AKydKSO66yGCaogF8XQsYJfN88hImQ6Uww0e+yP+FlP2Rd1hQyCxviziBX1y
	 nBql+D7XFBuqh9+//XS9F6z24rEeL2Pw6KecVlcbLYEKAea/G3sgilHowlSzGHkSAd
	 R2ysftg8kuvpaX/F8yPBoZJXvGg83zJI4kfdYdm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 469/800] platform/x86/intel/pmc/mtl: Put devices in D3 during resume
Date: Sun, 16 Jul 2023 21:45:22 +0200
Message-ID: <20230716194959.975316047@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit f2b689ab2f8cc089cc7659c323f282e6a1fb6d64 ]

An earlier commit placed some driverless devices in D3 during boot so that
they don't block package cstate entry on Meteor Lake. Also place these
devices in D3 after resume from suspend.

Fixes: 336ba968d3e3 ("platform/x86/intel/pmc/mtl: Put GNA/IPU/VPU devices in D3")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20230607233849.239047-2-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/mtl.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/mtl.c b/drivers/platform/x86/intel/pmc/mtl.c
index e8cc156412ce5..2b00ad9da621b 100644
--- a/drivers/platform/x86/intel/pmc/mtl.c
+++ b/drivers/platform/x86/intel/pmc/mtl.c
@@ -68,16 +68,29 @@ static void mtl_set_device_d3(unsigned int device)
 	}
 }
 
+/*
+ * Set power state of select devices that do not have drivers to D3
+ * so that they do not block Package C entry.
+ */
+static void mtl_d3_fixup(void)
+{
+	mtl_set_device_d3(MTL_GNA_PCI_DEV);
+	mtl_set_device_d3(MTL_IPU_PCI_DEV);
+	mtl_set_device_d3(MTL_VPU_PCI_DEV);
+}
+
+static int mtl_resume(struct pmc_dev *pmcdev)
+{
+	mtl_d3_fixup();
+	return pmc_core_resume_common(pmcdev);
+}
+
 void mtl_core_init(struct pmc_dev *pmcdev)
 {
 	pmcdev->map = &mtl_reg_map;
 	pmcdev->core_configure = mtl_core_configure;
 
-	/*
-	 * Set power state of select devices that do not have drivers to D3
-	 * so that they do not block Package C entry.
-	 */
-	mtl_set_device_d3(MTL_GNA_PCI_DEV);
-	mtl_set_device_d3(MTL_IPU_PCI_DEV);
-	mtl_set_device_d3(MTL_VPU_PCI_DEV);
+	mtl_d3_fixup();
+
+	pmcdev->resume = mtl_resume;
 }
-- 
2.39.2



