Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA638F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80584C433C7;
	Sun, 16 Jul 2023 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540152;
	bh=a1NOImaX3mWhClszr0YAuzE8xbrnOD4mGNSN7sg5pIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfcpVxTWCsQ5pyExHpfkCJua6SIM15UJidOkXdfbwK3RFWDd3kU3D9mnMMOBMDLgi
	 A95mTOuaS9D54lPNcZE31NKrBN3LiFgSP0k9A6M9H+RppZgTJHDIGOYJMLKMGxKJvw
	 YUTCU48wI4CzIP8fO0IQRDdwYY7XADYagd+ehmqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/591] drm/msm/dsi: Use DSC slice(s) packet size to compute word count
Date: Sun, 16 Jul 2023 21:46:41 +0200
Message-ID: <20230716194930.676863656@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit bc6b6ff8135c4b96787eda88f3baf653939a75ce ]

According to downstream the value to use for WORD_COUNT is
bytes_per_pkt, which denotes the number of bytes in a packet based on
how many slices have been configured by the panel driver times the
width of a slice times the number of bytes per pixel.

The DSC panels seen thus far use one byte per pixel, only one slice
per packet, and a slice width of half the panel width leading to the
desired bytes_per_pkt+1 value to be equal to hdisplay/2+1.  This however
isn't the case anymore for panels that configure two slices per packet,
where the value should now be hdisplay+1.

Note that the aforementioned panel (on a Sony Xperia XZ3, sdm845) with
slice_count=1 has also been tested to successfully accept slice_count=2,
which would have shown corrupted output previously.

Fixes: 08802f515c3c ("drm/msm/dsi: Add support for DSC configuration")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/515694/
Link: https://lore.kernel.org/r/20221221231943.1961117-3-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 155fa3a91d64 ("drm/msm/dsi: Remove incorrect references to slice_count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index f167a45f1fbdd..5ab5e872c3cf1 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -987,7 +987,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		if (!msm_host->dsc)
 			wc = hdisplay * dsi_get_bpp(msm_host->format) / 8 + 1;
 		else
-			wc = mode->hdisplay / 2 + 1;
+			wc = msm_host->dsc->slice_chunk_size * msm_host->dsc->slice_count + 1;
 
 		dsi_write(msm_host, REG_DSI_CMD_MDP_STREAM0_CTRL,
 			DSI_CMD_MDP_STREAM0_CTRL_WORD_COUNT(wc) |
-- 
2.39.2



