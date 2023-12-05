Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85E76DD12;
	Tue,  5 Dec 2023 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvFqtazG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D60C433CC;
	Tue,  5 Dec 2023 20:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701807225;
	bh=Qsn40tjxGnHVFA1jtVU5KxpxGSX5I9OlgqeJmtQV+pE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BvFqtazGHji0TaHDeq1hSb6lnVDQzR/XRr/aw1IpvJ64L61Vr+hL+kfsuIsj93qqI
	 Tvby1wYvoqxhyvf78+b7Dv8u/WpPrBMyn/v5eDXzSI9edmiNwaAi9q3TIEK+azmFRM
	 tIapLI1hnGdzx0/XBukZ3tJe+dhrdRWx0imR+WDifaqVuN0KcX1kgAIX1Lgsq/VHGQ
	 kho0Jms0T/hx/5n+0c0lTkobYe54tPennEDHETCUty67FmqwdvHIfj0lvRuMqWXB2g
	 eUa8IxT6P897xe/4C9Rcc+/lMXKWX1gaMWc/P6JdVoMxuT8PEsPKwn9irrI47tAJLl
	 kPMlHTi9hwkrA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 05 Dec 2023 13:13:35 -0700
Subject: [PATCH 2/3] usb: typec: qcom-pmic-typec: Only select
 DRM_AUX_HPD_BRIDGE with OF
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231205-drm_aux_bridge-fixes-v1-2-d242a0ae9df4@kernel.org>
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
To: dmitry.baryshkov@linaro.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org, 
 linux@roeck-us.net, neil.armstrong@linaro.org, bryan.odonoghue@linaro.org, 
 linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1470; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Qsn40tjxGnHVFA1jtVU5KxpxGSX5I9OlgqeJmtQV+pE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5LeX7k668cWGadpD1xd1SwQwRroSIKvMFJ1UzGoV5f
 2fw3VzXUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZSz87wz9rOnzdYZe69Y467
 Xv8/XjBndU/iPON3ZpGsEdpG56J1DzL8M9wwdeLqPznW9hYpysU6YV7bNTRfivr8SWQNW2XcX2X
 FCwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

CONFIG_DRM_AUX_HPD_BRIDGE depends on CONFIG_OF but that dependency is
not included when CONFIG_TYPEC_QCOM_PMIC selects it, resulting in a
Kconfig warning when CONFIG_OF is disabled:

  WARNING: unmet direct dependencies detected for DRM_AUX_HPD_BRIDGE
    Depends on [n]: HAS_IOMEM [=y] && DRM_BRIDGE [=y] && OF [=n]
    Selected by [m]:
    - TYPEC_QCOM_PMIC [=m] && USB_SUPPORT [=y] && TYPEC [=m] && TYPEC_TCPM [=m] && (ARCH_QCOM || COMPILE_TEST [=y]) && (DRM [=m] || DRM [=m]=n) && DRM_BRIDGE [=y]

Only select CONFIG_DRM_AUX_HPD_BRIDGE with both CONFIG_DRM_BRIDGE and
CONFIG_OF to clear up the warning.

Fixes: 7d9f1b72b296 ("usb: typec: qcom-pmic-typec: switch to DRM_AUX_HPD_BRIDGE")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/usb/typec/tcpm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/Kconfig b/drivers/usb/typec/tcpm/Kconfig
index 64d5421c69e6..8cdd84ca5d6f 100644
--- a/drivers/usb/typec/tcpm/Kconfig
+++ b/drivers/usb/typec/tcpm/Kconfig
@@ -80,7 +80,7 @@ config TYPEC_QCOM_PMIC
 	tristate "Qualcomm PMIC USB Type-C Port Controller Manager driver"
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on DRM || DRM=n
-	select DRM_AUX_HPD_BRIDGE if DRM_BRIDGE
+	select DRM_AUX_HPD_BRIDGE if DRM_BRIDGE && OF
 	help
 	  A Type-C port and Power Delivery driver which aggregates two
 	  discrete pieces of silicon in the PM8150b PMIC block: the

-- 
2.43.0

