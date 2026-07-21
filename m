Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BC0472530;
	Tue, 21 Jul 2026 20:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665689; cv=none; b=TCYk8gLaWOzkfyGWHATeitEtMewSeJlpjpZdFZIrhUOkYtqzVb4SYv8Lus8fEmB+zM5IRXvu1M0MAuc/mL6aW4/26Pzap4Ho+I2Ejm6UE6elIsQccpNaSsnp7YECDRMnQXWUJ9nYel3p69njPYgCJWfI490Wf7gsfEkcskPKKe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665689; c=relaxed/simple;
	bh=UrJfQAovpqJg6guj2rltNRvw+YZtxuGJyyFFRbNixNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubaun9yBvF54uiGf847pv2ZjPkRG+Rwzj1qu4hGpRg4fN9ClcI2+aVMxk7Cn1YFHhcwlNrd6OCpYn0KQbI9c0kv8Fiel4dqFTtmxEI9Hw1nvV7VTF3rH1T7DEDVcjLUdrMknIZEMJCTzYc/6bLuEpZ+cfm8Vlan4Vdrdnuxy+Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si2HN4mV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si2HN4mV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F691F000E9;
	Tue, 21 Jul 2026 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665686;
	bh=iBgOruhbNQgjKJY00vicw77Jshk5pH3GVFbQnFyn+nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=si2HN4mVN0ZjOUiTjp5H6oLwHDTQqENeko4SeIXLN8H9+s3NbE1JQLa9pJWQd6627
	 dz7c4UC5OgE0mjbv1TxkYwPODyVJmSFisadny07YUh/2nzvTmwY4wV4/NQaq5Uni3P
	 cbiq789YJbpgQW61ansxT/34DASqPt7EIbzxoHkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin He <helin52@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0397/1266] drm/hisilicon/hibmc: use clock to look up the PLL value
Date: Tue, 21 Jul 2026 17:13:54 +0200
Message-ID: <20260721152450.713769641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin He <helin52@huawei.com>

[ Upstream commit 99ef3a4f1c1813cabd50bb3e8522e85e00838bb2 ]

In the past, we use width and height to look up our PLL value.
But actually the actual clock check is also necessnary. There are
some resolutions that width and height same, but its clock different.
Add the clock check when using pll_table to determine the PLL value.

Fixes: da52605eea8f ("drm/hisilicon/hibmc: Add support for display engine")
Signed-off-by: Lin He <helin52@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509032302.2057227-5-shiyongbang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_de.c    | 80 +++++++++++--------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
index 89bed78f14666a..db7fce4e8cc344 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c
@@ -32,26 +32,43 @@ struct hibmc_display_panel_pll {
 struct hibmc_dislay_pll_config {
 	u64 hdisplay;
 	u64 vdisplay;
+	int clock;
 	u32 pll1_config_value;
 	u32 pll2_config_value;
 };
 
 static const struct hibmc_dislay_pll_config hibmc_pll_table[] = {
-	{640, 480, CRT_PLL1_HS_25MHZ, CRT_PLL2_HS_25MHZ},
-	{800, 600, CRT_PLL1_HS_40MHZ, CRT_PLL2_HS_40MHZ},
-	{1024, 768, CRT_PLL1_HS_65MHZ, CRT_PLL2_HS_65MHZ},
-	{1152, 864, CRT_PLL1_HS_80MHZ_1152, CRT_PLL2_HS_80MHZ},
-	{1280, 768, CRT_PLL1_HS_80MHZ, CRT_PLL2_HS_80MHZ},
-	{1280, 720, CRT_PLL1_HS_74MHZ, CRT_PLL2_HS_74MHZ},
-	{1280, 960, CRT_PLL1_HS_108MHZ, CRT_PLL2_HS_108MHZ},
-	{1280, 1024, CRT_PLL1_HS_108MHZ, CRT_PLL2_HS_108MHZ},
-	{1440, 900, CRT_PLL1_HS_106MHZ, CRT_PLL2_HS_106MHZ},
-	{1600, 900, CRT_PLL1_HS_108MHZ, CRT_PLL2_HS_108MHZ},
-	{1600, 1200, CRT_PLL1_HS_162MHZ, CRT_PLL2_HS_162MHZ},
-	{1920, 1080, CRT_PLL1_HS_148MHZ, CRT_PLL2_HS_148MHZ},
-	{1920, 1200, CRT_PLL1_HS_193MHZ, CRT_PLL2_HS_193MHZ},
+	{640, 480, 25000, CRT_PLL1_HS_25MHZ, CRT_PLL2_HS_25MHZ},
+	{800, 600, 40000, CRT_PLL1_HS_40MHZ, CRT_PLL2_HS_40MHZ},
+	{1024, 768, 65000, CRT_PLL1_HS_65MHZ, CRT_PLL2_HS_65MHZ},
+	{1152, 864, 78750, CRT_PLL1_HS_80MHZ_1152, CRT_PLL2_HS_80MHZ},
+	{1280, 768, 80000, CRT_PLL1_HS_80MHZ, CRT_PLL2_HS_80MHZ},
+	{1280, 720, 74375, CRT_PLL1_HS_74MHZ, CRT_PLL2_HS_74MHZ},
+	{1280, 960, 108000, CRT_PLL1_HS_108MHZ, CRT_PLL2_HS_108MHZ},
+	{1280, 1024, 108000, CRT_PLL1_HS_108MHZ, CRT_PLL2_HS_108MHZ},
+	{1440, 900, 105952, CRT_PLL1_HS_106MHZ, CRT_PLL2_HS_106MHZ},
+	{1600, 900, 108000, CRT_PLL1_HS_108MHZ, CRT_PLL2_HS_108MHZ},
+	{1600, 1200, 162500, CRT_PLL1_HS_162MHZ, CRT_PLL2_HS_162MHZ},
+	{1920, 1080, 148750, CRT_PLL1_HS_148MHZ, CRT_PLL2_HS_148MHZ},
+	{1920, 1200, 193750, CRT_PLL1_HS_193MHZ, CRT_PLL2_HS_193MHZ},
 };
 
+static int hibmc_get_best_clock_idx(const struct drm_display_mode *mode)
+{
+	int i, diff;
+
+	for (i = 0; i < ARRAY_SIZE(hibmc_pll_table); i++) {
+		if (hibmc_pll_table[i].hdisplay == mode->hdisplay &&
+		    hibmc_pll_table[i].vdisplay == mode->vdisplay) {
+			diff = abs(mode->clock - hibmc_pll_table[i].clock);
+			if (diff < mode->clock / 100) /* tolerance 1/100 */
+				return i;
+		}
+	}
+
+	return -MODE_CLOCK_RANGE;
+}
+
 static int hibmc_plane_atomic_check(struct drm_plane *plane,
 				    struct drm_atomic_state *state)
 {
@@ -214,19 +231,15 @@ static enum drm_mode_status
 hibmc_crtc_mode_valid(struct drm_crtc *crtc,
 		      const struct drm_display_mode *mode)
 {
-	size_t i = 0;
 	int vrefresh = drm_mode_vrefresh(mode);
 
 	if (vrefresh < 59 || vrefresh > 61)
 		return MODE_NOCLOCK;
 
-	for (i = 0; i < ARRAY_SIZE(hibmc_pll_table); i++) {
-		if (hibmc_pll_table[i].hdisplay == mode->hdisplay &&
-		    hibmc_pll_table[i].vdisplay == mode->vdisplay)
-			return MODE_OK;
-	}
+	if (hibmc_get_best_clock_idx(mode) >= 0)
+		return MODE_OK;
 
-	return MODE_BAD;
+	return MODE_CLOCK_RANGE;
 }
 
 static u32 format_pll_reg(void)
@@ -281,23 +294,20 @@ static void set_vclock_hisilicon(struct drm_device *dev, u64 pll)
 	writel(val, priv->mmio + CRT_PLL1_HS);
 }
 
-static void get_pll_config(u64 x, u64 y, u32 *pll1, u32 *pll2)
+static void get_pll_config(struct drm_display_mode *mode, u32 *pll1, u32 *pll2)
 {
-	size_t i;
-	size_t count = ARRAY_SIZE(hibmc_pll_table);
-
-	for (i = 0; i < count; i++) {
-		if (hibmc_pll_table[i].hdisplay == x &&
-		    hibmc_pll_table[i].vdisplay == y) {
-			*pll1 = hibmc_pll_table[i].pll1_config_value;
-			*pll2 = hibmc_pll_table[i].pll2_config_value;
-			return;
-		}
+	int idx;
+
+	idx = hibmc_get_best_clock_idx(mode);
+	if (idx < 0) {
+		/* if found none, we use default value */
+		*pll1 = CRT_PLL1_HS_25MHZ;
+		*pll2 = CRT_PLL2_HS_25MHZ;
+		return;
 	}
 
-	/* if found none, we use default value */
-	*pll1 = CRT_PLL1_HS_25MHZ;
-	*pll2 = CRT_PLL2_HS_25MHZ;
+	*pll1 = hibmc_pll_table[idx].pll1_config_value;
+	*pll2 = hibmc_pll_table[idx].pll2_config_value;
 }
 
 /*
@@ -319,7 +329,7 @@ static u32 display_ctrl_adjust(struct drm_device *dev,
 	x = mode->hdisplay;
 	y = mode->vdisplay;
 
-	get_pll_config(x, y, &pll1, &pll2);
+	get_pll_config(mode, &pll1, &pll2);
 	writel(pll2, priv->mmio + CRT_PLL2_HS);
 	set_vclock_hisilicon(dev, pll1);
 
-- 
2.53.0



