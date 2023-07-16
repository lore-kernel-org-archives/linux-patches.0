Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996FF8F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FC6C433C9;
	Sun, 16 Jul 2023 20:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538282;
	bh=a+Ht65i+TOptcDvSAPVjApQH813d/w0a91YkuQF7cGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBKdhzr2YTEEF8l5rsfbBGcY8hQkoT/cQAOS5ZZndJFif+DnWx6moUGLI0tCbe4BR
	 znrXgCpQEGQgRu0CwMJJrWVyiiEzPfCVoD++we2MC+0XrQPZ4eQ1hNoawA0fx47+Cb
	 8eExzoKhqAt9ksqQzHgkq23DwXrMxdFFPZnWZRqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 352/800] drm/i915: No 10bit gamma on desktop gen3 parts
Date: Sun, 16 Jul 2023 21:43:25 +0200
Message-ID: <20230716194957.255346725@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 19db2062094c75c64039d820c2547aad4dcfd905 ]

Apparently desktop gen3 parts don't support the
10bit gamma mode at all. Stop claiming otherwise.

As is the case with pipe A on gen3 mobile parts, the
PIPECONF gamma mode bit can be set but it has no
effect on the output.

PNV seems to be the only slight exception, but generally
the desktop PNV variant looks more like a mobile part so
this is not entirely surprising.

Fixes: 67630bacae23 ("drm/i915: Add 10bit gamma mode for gen2/3")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230531135625.3467-1-ville.syrjala@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/display/intel_display_device.c  | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.c b/drivers/gpu/drm/i915/display/intel_display_device.c
index 3e2f4cd0b9f56..8c57d48e8270f 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.c
+++ b/drivers/gpu/drm/i915/display/intel_display_device.c
@@ -216,7 +216,6 @@ static const struct intel_display_device_info i865g_display = {
 	.has_overlay = 1, \
 	I9XX_PIPE_OFFSETS, \
 	I9XX_CURSOR_OFFSETS, \
-	I9XX_COLORS, \
 	\
 	.__runtime_defaults.ip.ver = 3, \
 	.__runtime_defaults.pipe_mask = BIT(PIPE_A) | BIT(PIPE_B), \
@@ -225,12 +224,14 @@ static const struct intel_display_device_info i865g_display = {
 
 static const struct intel_display_device_info i915g_display = {
 	GEN3_DISPLAY,
+	I845_COLORS,
 	.cursor_needs_physical = 1,
 	.overlay_needs_physical = 1,
 };
 
 static const struct intel_display_device_info i915gm_display = {
 	GEN3_DISPLAY,
+	I9XX_COLORS,
 	.cursor_needs_physical = 1,
 	.overlay_needs_physical = 1,
 	.supports_tv = 1,
@@ -240,6 +241,7 @@ static const struct intel_display_device_info i915gm_display = {
 
 static const struct intel_display_device_info i945g_display = {
 	GEN3_DISPLAY,
+	I845_COLORS,
 	.has_hotplug = 1,
 	.cursor_needs_physical = 1,
 	.overlay_needs_physical = 1,
@@ -247,6 +249,7 @@ static const struct intel_display_device_info i945g_display = {
 
 static const struct intel_display_device_info i945gm_display = {
 	GEN3_DISPLAY,
+	I9XX_COLORS,
 	.has_hotplug = 1,
 	.cursor_needs_physical = 1,
 	.overlay_needs_physical = 1,
@@ -257,6 +260,13 @@ static const struct intel_display_device_info i945gm_display = {
 
 static const struct intel_display_device_info g33_display = {
 	GEN3_DISPLAY,
+	I845_COLORS,
+	.has_hotplug = 1,
+};
+
+static const struct intel_display_device_info pnv_display = {
+	GEN3_DISPLAY,
+	I9XX_COLORS,
 	.has_hotplug = 1,
 };
 
@@ -669,8 +679,8 @@ static const struct {
 	INTEL_I965GM_IDS(&i965gm_display),
 	INTEL_GM45_IDS(&gm45_display),
 	INTEL_G45_IDS(&g45_display),
-	INTEL_PINEVIEW_G_IDS(&g33_display),
-	INTEL_PINEVIEW_M_IDS(&g33_display),
+	INTEL_PINEVIEW_G_IDS(&pnv_display),
+	INTEL_PINEVIEW_M_IDS(&pnv_display),
 	INTEL_IRONLAKE_D_IDS(&ilk_d_display),
 	INTEL_IRONLAKE_M_IDS(&ilk_m_display),
 	INTEL_SNB_D_IDS(&snb_display),
-- 
2.39.2



