Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8BF6DD09;
	Tue,  5 Dec 2023 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gk97RPpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50268C433CB;
	Tue,  5 Dec 2023 20:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701807224;
	bh=sjzE8QZ8uXSlrXNRxh0UBUKR87kmK2KHZp2G4Sxqhrs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Gk97RPpIZ8GZ9TGjd2N5pqzscHAF0ogln/+b3jPehBDG29/0nLH776NEkNBgWoAmO
	 tIwksCtSc8w6g6zPLQ1rKFjfq4PFtMBqCXUfkCYTjfWFncR5RFE16XqhM2utRpAR9a
	 8SNcMWweKweAPG9n9BRD+iBsTaVzOn+PvnzcRB+h83Q//P8fl9dDKR3GAtF4edaQjJ
	 sCGv1uPoL7IesyASP3lG5rI958Bt+SiiVq6QeYw6aRY4ooEBeYUNrykl8FkY9zt73u
	 bmFyPgHf9sh6vsdP7GkR3dUcPQGJsOSFqT/qq/CCvmOmUL5D4smRrMgJaPei0FraSH
	 71DETylH3Peww==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 05 Dec 2023 13:13:34 -0700
Subject: [PATCH 1/3] usb: typec: nb7vpq904m: Only select DRM_AUX_BRIDGE
 with OF
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231205-drm_aux_bridge-fixes-v1-1-d242a0ae9df4@kernel.org>
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
To: dmitry.baryshkov@linaro.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org, 
 linux@roeck-us.net, neil.armstrong@linaro.org, bryan.odonoghue@linaro.org, 
 linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1345; i=nathan@kernel.org;
 h=from:subject:message-id; bh=sjzE8QZ8uXSlrXNRxh0UBUKR87kmK2KHZp2G4Sxqhrs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5LeV7nCdxCa7boyh86aeRbD3TLZ2QnKfKe6sW9k+em
 JRqcqy1o5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzEcRHD/0wZN4PYy1f9nY4k
 6DhnWgkGMf1j/fqsevePvXov3/kd+cHI8Nz7zxddA/Yp59UVdCbGfsk55/Mn5fNqffX7NnuZPtu
 e5QAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

CONFIG_DRM_AUX_BRIDGE depends on CONFIG_OF but that dependency is not
included when CONFIG_TYPEC_MUX_NB7VPQ904M selects it, resulting in a
Kconfig warning when CONFIG_OF is disabled:

  WARNING: unmet direct dependencies detected for DRM_AUX_BRIDGE
    Depends on [n]: HAS_IOMEM [=y] && DRM_BRIDGE [=y] && OF [=n]
    Selected by [y]:
    - TYPEC_MUX_NB7VPQ904M [=y] && USB_SUPPORT [=y] && TYPEC [=y] && I2C [=y] && (DRM [=y] || DRM [=y]=n) && DRM_BRIDGE [=y]

Only select CONFIG_DRM_AUX_BRIDGE with both CONFIG_DRM_BRIDGE and
CONFIG_OF to clear up the warning.

Fixes: c5d296bad640 ("usb: typec: nb7vpq904m: switch to DRM_AUX_BRIDGE")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/usb/typec/mux/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/Kconfig b/drivers/usb/typec/mux/Kconfig
index 5120942f309d..38416fb0cc3c 100644
--- a/drivers/usb/typec/mux/Kconfig
+++ b/drivers/usb/typec/mux/Kconfig
@@ -40,7 +40,7 @@ config TYPEC_MUX_NB7VPQ904M
 	tristate "On Semiconductor NB7VPQ904M Type-C redriver driver"
 	depends on I2C
 	depends on DRM || DRM=n
-	select DRM_AUX_BRIDGE if DRM_BRIDGE
+	select DRM_AUX_BRIDGE if DRM_BRIDGE && OF
 	select REGMAP_I2C
 	help
 	  Say Y or M if your system has a On Semiconductor NB7VPQ904M Type-C

-- 
2.43.0

