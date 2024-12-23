Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB2012D1F1;
	Mon, 23 Dec 2024 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969635; cv=none; b=HMoqespS/a/eFitgG0KtJc95XhqZ568Ymz1AkoWfYWHlqZC1uT4JYh1c7UO9gWoSFqHJocQ1TETNYVEdyULDcft1J6a5EuRgkPanx+ewdA+3TwhVM2TjOxIZvZ0ihVpJtHgsev3liKLYIC1R6315cNF9VuKFv9apWEHPEG8lFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969635; c=relaxed/simple;
	bh=7s8mmow+rCtZHoZLMue2155cW1iBwrXcuimwWBq+D8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLIzORVWdhmTeKPwYFdOq0tRyhr3PMpuWi79joSXdLQpJCh+9belif9WbUNij7ssj09kmldKDUO9A0MUTKTon5Fx+pELRrfpjoAmHW7661m+z2XXa2Pmucm+uFzjI5+f2Q8fUkXLeDaItHDcPRBK2JsX+VVemFiGR6adbah/qFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaDJ6T1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaDJ6T1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B83C4CED4;
	Mon, 23 Dec 2024 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969633;
	bh=7s8mmow+rCtZHoZLMue2155cW1iBwrXcuimwWBq+D8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaDJ6T1PH/+zlekI+r4hRfGQR4KBl8allyzJHfl/Dofgw+btOYZ88ZhICkmGQAMIR
	 YG2bkJZqjGzilduuP5aJiRwdG5J/kjVi5xBFyu+ZlbKHQrmy0/vVkcldQYI2CCLT2Q
	 IHAfmz44CLljdPK2RD8CKjCnpYYiVfJ+HGUQ5ht4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/160] firmware: arm_scmi: Fix i.MX build dependency
Date: Mon, 23 Dec 2024 16:56:54 +0100
Message-ID: <20241223155408.745357574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 514b2262ade48a0503ac6aa03c3bfb8c5be69b21 ]

The newly added SCMI vendor driver references functions in the
protocol driver but needs a Kconfig dependency to ensure it can link,
essentially the Kconfig dependency needs to be reversed to match the
link time dependency:

  |  arm-linux-gnueabi-ld: sound/soc/fsl/fsl_mqs.o: in function `fsl_mqs_sm_write':
  |  	fsl_mqs.c:(.text+0x1aa): undefined reference to `scmi_imx_misc_ctrl_set'
  |  arm-linux-gnueabi-ld: sound/soc/fsl/fsl_mqs.o: in function `fsl_mqs_sm_read':
  |  	fsl_mqs.c:(.text+0x1ee): undefined reference to `scmi_imx_misc_ctrl_get'

This however only works after changing the dependency in the SND_SOC_FSL_MQS
driver as well, which uses 'select IMX_SCMI_MISC_DRV' to turn on a
driver it depends on. This is generally a bad idea, so the best solution
is to change that into a dependency.

To allow the ASoC driver to keep building with the SCMI support, this
needs to be an optional dependency that enforces the link-time
dependency if IMX_SCMI_MISC_DRV is a loadable module but not
depend on it if that is disabled.

Fixes: 61c9f03e22fc ("firmware: arm_scmi: Add initial support for i.MX MISC protocol")
Fixes: 101c9023594a ("ASoC: fsl_mqs: Support accessing registers by scmi interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Message-Id: <20241115230555.2435004-1-arnd@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/vendors/imx/Kconfig | 1 +
 drivers/firmware/imx/Kconfig                  | 1 -
 sound/soc/fsl/Kconfig                         | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/vendors/imx/Kconfig b/drivers/firmware/arm_scmi/vendors/imx/Kconfig
index 2883ed24a84d..a01bf5e47301 100644
--- a/drivers/firmware/arm_scmi/vendors/imx/Kconfig
+++ b/drivers/firmware/arm_scmi/vendors/imx/Kconfig
@@ -15,6 +15,7 @@ config IMX_SCMI_BBM_EXT
 config IMX_SCMI_MISC_EXT
 	tristate "i.MX SCMI MISC EXTENSION"
 	depends on ARM_SCMI_PROTOCOL || (COMPILE_TEST && OF)
+	depends on IMX_SCMI_MISC_DRV
 	default y if ARCH_MXC
 	help
 	  This enables i.MX System MISC control logic such as gpio expander
diff --git a/drivers/firmware/imx/Kconfig b/drivers/firmware/imx/Kconfig
index 477d3f32d99a..907cd149c40a 100644
--- a/drivers/firmware/imx/Kconfig
+++ b/drivers/firmware/imx/Kconfig
@@ -25,7 +25,6 @@ config IMX_SCU
 
 config IMX_SCMI_MISC_DRV
 	tristate "IMX SCMI MISC Protocol driver"
-	depends on IMX_SCMI_MISC_EXT || COMPILE_TEST
 	default y if ARCH_MXC
 	help
 	  The System Controller Management Interface firmware (SCMI FW) is
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index e283751abfef..678540b78280 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -29,6 +29,7 @@ config SND_SOC_FSL_SAI
 config SND_SOC_FSL_MQS
 	tristate "Medium Quality Sound (MQS) module support"
 	depends on SND_SOC_FSL_SAI
+	depends on IMX_SCMI_MISC_DRV || !IMX_SCMI_MISC_DRV
 	select REGMAP_MMIO
 	help
 	  Say Y if you want to add Medium Quality Sound (MQS)
-- 
2.39.5



