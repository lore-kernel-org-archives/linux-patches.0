Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82211C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675AFC433F0;
	Wed, 28 Dec 2022 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245700;
	bh=WeOOt14tkYeELBrtRWfPT2/q6Bw4lnOCH2VvxZFmpcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lV+2QkYDNLUmlvllrdwiqmhQ2J/k9/i442nGD9GPfdt4RBeEINYRV36OwApoujpa9
	 PBnxkyEZUqV63NfeEq92jGlCDVOZ8pF6qIShIjyW+2iXPNMnTL/eUV8syp8Z++ul+h
	 9dfYVSSImIeO8Hsm3s25Jc+caFJ2Pk7Il4eUv/Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0940/1073] drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()
Date: Wed, 28 Dec 2022 15:42:08 +0100
Message-Id: <20221228144353.568355688@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 890d637523eec9d730e3885532fa1228ba678880 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/mediatek/mtk_hdmi.c:1407:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' with an expression of type 'int (struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = mtk_hdmi_bridge_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

->mode_valid() in 'struct drm_bridge_funcs' expects a return type of
'enum drm_mode_status', not 'int'. Adjust the return type of
mtk_hdmi_bridge_mode_valid() to match the prototype's to resolve the
warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 3196189429bc..7613b0fa2be6 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1203,9 +1203,10 @@ static enum drm_connector_status mtk_hdmi_detect(struct mtk_hdmi *hdmi)
 	return mtk_hdmi_update_plugged_status(hdmi);
 }
 
-static int mtk_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
-				      const struct drm_display_info *info,
-				      const struct drm_display_mode *mode)
+static enum drm_mode_status
+mtk_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
+			   const struct drm_display_info *info,
+			   const struct drm_display_mode *mode)
 {
 	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
 	struct drm_bridge *next_bridge;
-- 
2.35.1



