Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4882248883;
	Mon, 23 Mar 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278159; cv=none; b=kILD6FDOHjvbsuZQ4/vttJdvPz0szBmr9bt2DhQ6veoU72WxBNyAh4w5CHL0FhlGZJRC9fUKzM1Ew5k4kuCTy9cflcXck6iGeF82AVcMyOa6/SNw5gZBuxxLDYAekADNIBwOEcwXUai6jh8zRidDrVYFX9Tc1wy0LQSjhZtuTcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278159; c=relaxed/simple;
	bh=H40aJHTkio0Ky9zkhqB4WkQ92WPOFBL2o+62XruVlgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btKk+WTyLwd++H1NubwzYpSnPlfu0yK8dScXXRIeyM29FnIeP+NbM/t9Tc9DtAwaomfoduiuVJDUUmw2oKmckIq8XQPXLg+NPU6lycgZxDk/YyTOmHzG/KNwQkpTWNVLfIF3RjwoTSjZAgfGG1NohHbE6i94Oe6isU/tcgSiip0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIfZIWHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIfZIWHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1CFC2BC9E;
	Mon, 23 Mar 2026 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278158;
	bh=H40aJHTkio0Ky9zkhqB4WkQ92WPOFBL2o+62XruVlgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIfZIWHVGuY1pnVeOUMAitC5b2/JwfMXANL6QXwcRbfwVe32K5vUkMBA/qimtPn7M
	 zrXG5Pnkfv0/sXux/tz3OhT1Db5sWoAKqQxzWiH2XOa68g5umByLA3TDEMQbgM14AZ
	 KqM4U1DDII9QZylKj8YptpxE0cFYFKd4CiCNSkEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/567] drm/msm/dsi: Document DSC related pclk_rate and hdisplay calculations
Date: Mon, 23 Mar 2026 14:42:18 +0100
Message-ID: <20260323134539.221450453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3b56d27ba1578c3d61f51de4102cf896a9a8617e ]

Provide actual documentation for the pclk and hdisplay calculations in
the case of DSC compression being used.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/577534/
Link: https://lore.kernel.org/r/20240208-fd_document_dsc_pclk_rate-v4-1-56fe59d0a2e0@linaro.org
Stable-dep-of: e4eb11b34d6c ("drm/msm/dsi: fix pclk rate calculation for bonded dsi")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 33 ++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index f90ccdfbb2fc7..48a39f8727441 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -529,6 +529,25 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
 	clk_disable_unprepare(msm_host->byte_clk);
 }
 
+/**
+ * dsi_adjust_pclk_for_compression() - Adjust the pclk rate for compression case
+ * @mode: The selected mode for the DSI output
+ * @dsc: DRM DSC configuration for this DSI output
+ *
+ * Adjust the pclk rate by calculating a new hdisplay proportional to
+ * the compression ratio such that:
+ *     new_hdisplay = old_hdisplay * compressed_bpp / uncompressed_bpp
+ *
+ * Porches do not need to be adjusted:
+ * - For VIDEO mode they are not compressed by DSC and are passed as is.
+ * - For CMD mode there are no actual porches. Instead these fields
+ *   currently represent the overhead to the image data transfer. As such, they
+ *   are calculated for the final mode parameters (after the compression) and
+ *   are not to be adjusted too.
+ *
+ *  FIXME: Reconsider this if/when CMD mode handling is rewritten to use
+ *  transfer time and data overhead as a starting point of the calculations.
+ */
 static unsigned long dsi_adjust_pclk_for_compression(const struct drm_display_mode *mode,
 		const struct drm_dsc_config *dsc)
 {
@@ -937,8 +956,18 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		if (ret)
 			return;
 
-		/* Divide the display by 3 but keep back/font porch and
-		 * pulse width same
+		/*
+		 * DPU sends 3 bytes per pclk cycle to DSI. If widebus is
+		 * enabled, bus width is extended to 6 bytes.
+		 *
+		 * Calculate the number of pclks needed to transmit one line of
+		 * the compressed data.
+
+		 * The back/font porch and pulse width are kept intact. For
+		 * VIDEO mode they represent timing parameters rather than
+		 * actual data transfer, see the documentation for
+		 * dsi_adjust_pclk_for_compression(). For CMD mode they are
+		 * unused anyway.
 		 */
 		h_total -= hdisplay;
 		hdisplay = DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_host->dsc), 3);
-- 
2.51.0



