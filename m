Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570E13A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DW4kmPmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5B0C433C9;
	Wed, 15 Nov 2023 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077295;
	bh=Kc9XiUrTLV81auMzpX64UP9Eo4VNUGTv/c5mzaFHtzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW4kmPmbHY0QhaoQtrWF4wcZG5SfIkaGuPp5hru5kAoNc+oKG5bhPywfgYTQSvGZl
	 3emoD9A+qM8TjYKoTVu3Z4C0f+UK2VnM9FvzkI8EsYbKQrNsAN5a93rkyl0dgWpI/i
	 LiaL5Jq+oO9xBejLr8rjRw42LUANtgiA6Neyla9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/603] drm: bridge: samsung-dsim: Fix waiting for empty cmd transfer FIFO on older Exynos
Date: Wed, 15 Nov 2023 14:12:41 -0500
Message-ID: <20231115191628.235677581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 15f389da11257b806da75a070cfa41ca0cc15aae ]

Samsung DSIM used in older Exynos SoCs (like Exynos 4210, 4x12, 3250)
doesn't report empty level of packer header FIFO. In case of those SoCs,
use the old way of waiting for empty command tranfsfer FIFO, removed
recently by commit 14806c641582 ("drm: bridge: samsung-dsim: Drain command transfer FIFO before transfer").

Fixes: 14806c641582 ("drm: bridge: samsung-dsim: Drain command transfer FIFO before transfer")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230809145641.3213210-1-m.szyprowski@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c | 18 ++++++++++++++++--
 include/drm/bridge/samsung-dsim.h     |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/samsung-dsim.c b/drivers/gpu/drm/bridge/samsung-dsim.c
index 6f2ca74238d14..19bdb32dbc9aa 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -413,6 +413,7 @@ static const struct samsung_dsim_driver_data exynos3_dsi_driver_data = {
 	.m_min = 41,
 	.m_max = 125,
 	.min_freq = 500,
+	.has_broken_fifoctrl_emptyhdr = 1,
 };
 
 static const struct samsung_dsim_driver_data exynos4_dsi_driver_data = {
@@ -429,6 +430,7 @@ static const struct samsung_dsim_driver_data exynos4_dsi_driver_data = {
 	.m_min = 41,
 	.m_max = 125,
 	.min_freq = 500,
+	.has_broken_fifoctrl_emptyhdr = 1,
 };
 
 static const struct samsung_dsim_driver_data exynos5_dsi_driver_data = {
@@ -1010,8 +1012,20 @@ static int samsung_dsim_wait_for_hdr_fifo(struct samsung_dsim *dsi)
 	do {
 		u32 reg = samsung_dsim_read(dsi, DSIM_FIFOCTRL_REG);
 
-		if (reg & DSIM_SFR_HEADER_EMPTY)
-			return 0;
+		if (!dsi->driver_data->has_broken_fifoctrl_emptyhdr) {
+			if (reg & DSIM_SFR_HEADER_EMPTY)
+				return 0;
+		} else {
+			if (!(reg & DSIM_SFR_HEADER_FULL)) {
+				/*
+				 * Wait a little bit, so the pending data can
+				 * actually leave the FIFO to avoid overflow.
+				 */
+				if (!cond_resched())
+					usleep_range(950, 1050);
+				return 0;
+			}
+		}
 
 		if (!cond_resched())
 			usleep_range(950, 1050);
diff --git a/include/drm/bridge/samsung-dsim.h b/include/drm/bridge/samsung-dsim.h
index 05100e91ecb96..6fc9bb2979e45 100644
--- a/include/drm/bridge/samsung-dsim.h
+++ b/include/drm/bridge/samsung-dsim.h
@@ -53,6 +53,7 @@ struct samsung_dsim_driver_data {
 	unsigned int plltmr_reg;
 	unsigned int has_freqband:1;
 	unsigned int has_clklane_stop:1;
+	unsigned int has_broken_fifoctrl_emptyhdr:1;
 	unsigned int num_clks;
 	unsigned int min_freq;
 	unsigned int max_freq;
-- 
2.42.0



