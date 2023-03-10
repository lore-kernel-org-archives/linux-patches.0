Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043478820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D74EC4339B;
	Fri, 10 Mar 2023 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460074;
	bh=exwLfqQycfDGk8H6RC5k8M+2tOIF3/IPei/w20ctD0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKkJuZLniJSrS8PzRt5vDo3oI/a0DfE23gMeOWft9GrgNLYz71HmUO4NsVSDSs5RV
	 e/6Fkddapk+GypDzZO2/Of/2KO0rZT/XRemnSlHsTND/+TwDZOJGvcwXGiV2V9rO6o
	 RsdER6bajhHyjKxPd/hK506kF3nUFAcZEnZjNeW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinlei Lee <xinlei.lee@mediatek.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/529] drm/mediatek: dsi: Reduce the time of dsi from LP11 to sending cmd
Date: Fri, 10 Mar 2023 14:35:28 +0100
Message-Id: <20230310133813.540481392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xinlei Lee <xinlei.lee@mediatek.com>

[ Upstream commit 91aeaed2c1147e3b1157dc084d23f190856a6c23 ]

According to Figure 16 Turnaround Procedure on page 36 in [1], you
can see the status of LP-00 -> LP10 -> LP11. This state can correspond
to the state of DSI from LP00 -> LP11 in mtk_dsi_lane_ready function
in mtk_dsi.c.

LP-00 -> LP10 -> LP11 takes about 2*TLPX time (refer to [1] page 51
to see that TLPX is 50ns)

The delay at the end of the mtk_dsi_lane_ready function should be
greater than the 2*TLPX specified by the DSI spec, and less than
the time specified by the DSI_RX (generally 6ms to 40ms), to avoid
problems caused by the RX specification

[1]:mipi_D-PHY_specification_v1-1

Fixes: 39e8d062b03c ("drm/mediatek: Keep dsi as LP00 before dcs cmds transfer")
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/1673330093-6771-2-git-send-email-xinlei.lee@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 146c4d04f572d..a6e71b7b69b83 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -704,7 +704,7 @@ static void mtk_dsi_lane_ready(struct mtk_dsi *dsi)
 		mtk_dsi_clk_ulp_mode_leave(dsi);
 		mtk_dsi_lane0_ulp_mode_leave(dsi);
 		mtk_dsi_clk_hs_mode(dsi, 0);
-		msleep(20);
+		usleep_range(1000, 3000);
 		/* The reaction time after pulling up the mipi signal for dsi_rx */
 	}
 }
-- 
2.39.2



