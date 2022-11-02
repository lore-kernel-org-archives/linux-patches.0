Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1E16ADD;
	Wed,  2 Nov 2022 15:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D96C433C1;
	Wed,  2 Nov 2022 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667403738;
	bh=RTU4MJOahPxQfCprS6dXSJ2bZU9D7vmWqFb7hhBnnks=;
	h=From:To:Cc:Subject:Date:From;
	b=nj1itTaPmyeeCs1glxmOJOEgYHi2qenyZdtfMmFxDLb6RkKgSb8ximzR3or++OZvb
	 o3kRbCDxiGm7/ju/RBv5l9o1+4lm1GODplKBOpsqP8+kRC4p4mdfoSeNVRTDrDEnss
	 xJq44D1a/pEaxS7PErjZmtT1BA9cRSpIfl/mvyCS0WGFCBo7E2j1YbJUEh8nObZFje
	 OabUmowetibTC6TqsmCiZ6BoOqt5kb0vO8ZUkhz5q6xBbCBUocFknhZci0hr6yOlm2
	 OUrjI0iljGmaC2seHYbjucGiJYf8baJqougkWOhZ2RtGXZXaoZGudhGkYXCIvLNEMm
	 qPKFMarAjG8Mg==
From: Nathan Chancellor <nathan@kernel.org>
To: Stefan Agner <stefan@agner.ch>,
	Alison Wang <alison.wang@nxp.com>
Cc: dri-devel@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
Date: Wed,  2 Nov 2022 08:42:15 -0700
Message-Id: <20221102154215.78059-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c:74:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = fsl_dcu_drm_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
type of 'enum drm_mode_status', not 'int'. Adjust the return type of
fsl_dcu_drm_connector_mode_valid() to match the prototype's to resolve
the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
index 4d4a715b429d..2c2b92324a2e 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
@@ -60,8 +60,9 @@ static int fsl_dcu_drm_connector_get_modes(struct drm_connector *connector)
 	return drm_panel_get_modes(fsl_connector->panel, connector);
 }
 
-static int fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
-					    struct drm_display_mode *mode)
+static enum drm_mode_status
+fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
 {
 	if (mode->hdisplay & 0xf)
 		return MODE_ERROR;

base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.1

