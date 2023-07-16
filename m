Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D4E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267EEC433C7;
	Sun, 16 Jul 2023 20:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540158;
	bh=ov6jnpQwA0T6VfwXWdOWIydfLauGYeMoVYSJJ/129Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOFMHrek9/1fQJxRQCUUVFN/hizLRlO1xLsIgiWe5mljYfEiDjEgAAw3I0vAzz2IZ
	 Xr5h553uTWAzMS0yzYMyPXF5lZZcCAIqGk+ve8e/Gbo4VH9tIXC6fiAuJDpagmkY6W
	 kcfn0WSA2VPMdg83pCjtXFBKH3Jf50bwJvXf6GXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/591] drm/msm/dsi: Remove incorrect references to slice_count
Date: Sun, 16 Jul 2023 21:46:43 +0200
Message-ID: <20230716194930.728539850@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 155fa3a91d64221eb0885fd221cc8085dbef908f ]

Currently, slice_count is being used to calculate word count and
pkt_per_line. Instead, these values should be calculated using slice per
packet, which is not the same as slice_count.

Slice count represents the number of slices per interface, and its value
will not always match that of slice per packet. For example, it is possible
to have cases where there are multiple slices per interface but the panel
specifies only one slice per packet.

Thus, use the default value of one slice per packet and remove slice_count
from the aforementioned calculations.

Fixes: 08802f515c3c ("drm/msm/dsi: Add support for DSC configuration")
Fixes: bc6b6ff8135c ("drm/msm/dsi: Use DSC slice(s) packet size to compute word count")
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/541965/
Link: https://lore.kernel.org/r/20230405-add-dsc-support-v6-5-95eab864d1b6@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index ef988e4c21045..b433ccfe4d7da 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -853,18 +853,17 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	 */
 	slice_per_intf = DIV_ROUND_UP(hdisplay, dsc->slice_width);
 
-	/*
-	 * If slice_count is greater than slice_per_intf
-	 * then default to 1. This can happen during partial
-	 * update.
-	 */
-	if (dsc->slice_count > slice_per_intf)
-		dsc->slice_count = 1;
-
 	total_bytes_per_intf = dsc->slice_chunk_size * slice_per_intf;
 
 	eol_byte_num = total_bytes_per_intf % 3;
-	pkt_per_line = slice_per_intf / dsc->slice_count;
+
+	/*
+	 * Typically, pkt_per_line = slice_per_intf * slice_per_pkt.
+	 *
+	 * Since the current driver only supports slice_per_pkt = 1,
+	 * pkt_per_line will be equal to slice per intf for now.
+	 */
+	pkt_per_line = slice_per_intf;
 
 	if (is_cmd_mode) /* packet data type */
 		reg = DSI_COMMAND_COMPRESSION_MODE_CTRL_STREAM0_DATATYPE(MIPI_DSI_DCS_LONG_WRITE);
@@ -988,7 +987,14 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		if (!msm_host->dsc)
 			wc = hdisplay * dsi_get_bpp(msm_host->format) / 8 + 1;
 		else
-			wc = msm_host->dsc->slice_chunk_size * msm_host->dsc->slice_count + 1;
+			/*
+			 * When DSC is enabled, WC = slice_chunk_size * slice_per_pkt + 1.
+			 * Currently, the driver only supports default value of slice_per_pkt = 1
+			 *
+			 * TODO: Expand mipi_dsi_device struct to hold slice_per_pkt info
+			 *       and adjust DSC math to account for slice_per_pkt.
+			 */
+			wc = msm_host->dsc->slice_chunk_size + 1;
 
 		dsi_write(msm_host, REG_DSI_CMD_MDP_STREAM0_CTRL,
 			DSI_CMD_MDP_STREAM0_CTRL_WORD_COUNT(wc) |
-- 
2.39.2



