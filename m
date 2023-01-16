Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE386FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC19BC433EF;
	Mon, 16 Jan 2023 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889148;
	bh=AtQf7UXy4e5miJGevgJx5fo8AEb76RW/4ga+2w92Vj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9F9sPqVnzH2ayDIdzcP2ynAOK5pjKCM9WmYQCEKwn+FZS4NwwrwE4cQLcL7giaRF
	 WDwwuIK+Q6F+vcSQ4Ox+XkyB99I0wLZPcNXbcDMo8ef2sy2/X0H5jIP0+53oV3z8T6
	 0ESxeojCvyD+iHPdTeR3zM3FVx703DCa5U03m6dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 247/338] drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
Date: Mon, 16 Jan 2023 16:52:00 +0100
Message-Id: <20230116154831.840693689@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 0ad811cc08a937d875cbad0149c1bab17f84ba05 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/sti/sti_hda.c:637:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = sti_hda_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/sti/sti_dvo.c:376:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = sti_dvo_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/sti/sti_hdmi.c:1035:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = sti_hdmi_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
type of 'enum drm_mode_status', not 'int'. Adjust the return type of
sti_{dvo,hda,hdmi}_connector_mode_valid() to match the prototype's to
resolve the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102155623.3042869-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_dvo.c  | 5 +++--
 drivers/gpu/drm/sti/sti_hda.c  | 5 +++--
 drivers/gpu/drm/sti/sti_hdmi.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_dvo.c b/drivers/gpu/drm/sti/sti_dvo.c
index 872a06670b34..ed6ee8815af6 100644
--- a/drivers/gpu/drm/sti/sti_dvo.c
+++ b/drivers/gpu/drm/sti/sti_dvo.c
@@ -346,8 +346,9 @@ static int sti_dvo_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_dvo_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_dvo_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 9a7a9aa5445e..e13fa348e8c8 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -596,8 +596,9 @@ static int sti_hda_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_hda_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_hda_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index c5b2f36c5feb..acc80b1849d3 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -988,8 +988,9 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_hdmi_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_hdmi_connector_mode_valid(struct drm_connector *connector,
+			      struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
-- 
2.35.1



