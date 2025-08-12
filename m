Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342862FDC55;
	Tue, 12 Aug 2025 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021533; cv=none; b=iJVDIBvT4gm2B9Qk17nDPz/ql5R2R0iZraH/NgUdSJMMMhQ4bzW53c3h2IBe+WMCQLXN96UZ4vpqfHWj6n7Nh1sbBQHzOEs6puKYz2Uwv4LwAiknNM4prXm+DFmeAx1JkLy+E0WMZedEhDICfDWJbeN39x8cCVFQZyC7zsFYoGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021533; c=relaxed/simple;
	bh=oSc9oivqbtF/rN5xJx/h8bciU6sWvbL2+Fa/BwVptRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvXwQLZlvo9c8i9h3HeXnGXNaxlWE46f8ScuQtJeN2/GNPcEjuaI9+erXk6N5cEN4CBhqDbMUPGo2xJp+V8IhvgfAo1v1/vmAVof9YbdH8ra3JuCGG+DnRLIbTdm6+ZCTbJlWj3IqbBrgabTBbAYTAi38Ea6bgmEi0uhF3wueD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdOEm1NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdOEm1NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7808C4CEF1;
	Tue, 12 Aug 2025 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021533;
	bh=oSc9oivqbtF/rN5xJx/h8bciU6sWvbL2+Fa/BwVptRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdOEm1NXqPIU/Hip8TLAJR77ZAK1XN+08aPg73AjVmsqM+39K+sfBVmQUED59q9bg
	 r2ZpcJKuNsUQM3mBFWeYnEd8iW2hjR4nu34XnVOo+OcHOQ7ZWmvsdEfnbqvnG3x6rP
	 q+Nx8qqOYVsoN4N7yJGR8/yp4iNdIPJGzKJu/GXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/262] ASoC: fsl_xcvr: get channel status data when PHY is not exists
Date: Tue, 12 Aug 2025 19:28:57 +0200
Message-ID: <20250812172959.445798585@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ca592e20659e0304ebd8f4dabb273da4f9385848 ]

There is no PHY for the XCVR module on i.MX93, the channel status needs
to be obtained from FSL_XCVR_RX_CS_DATA_* registers. And channel status
acknowledge (CSA) bit should be set once channel status is processed.

Fixes: e240b9329a30 ("ASoC: fsl_xcvr: Add support for i.MX93 platform")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250710030405.3370671-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index c46f64557a7f..1d7791c7fb4e 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1197,6 +1197,26 @@ static irqreturn_t irq0_isr(int irq, void *devid)
 				/* clear CS control register */
 				memset_io(reg_ctrl, 0, sizeof(val));
 			}
+		} else {
+			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_0,
+				    (u32 *)&xcvr->rx_iec958.status[0]);
+			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_1,
+				    (u32 *)&xcvr->rx_iec958.status[4]);
+			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_2,
+				    (u32 *)&xcvr->rx_iec958.status[8]);
+			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_3,
+				    (u32 *)&xcvr->rx_iec958.status[12]);
+			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_4,
+				    (u32 *)&xcvr->rx_iec958.status[16]);
+			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_5,
+				    (u32 *)&xcvr->rx_iec958.status[20]);
+			for (i = 0; i < 6; i++) {
+				val = *(u32 *)(xcvr->rx_iec958.status + i * 4);
+				*(u32 *)(xcvr->rx_iec958.status + i * 4) =
+					bitrev32(val);
+			}
+			regmap_set_bits(xcvr->regmap, FSL_XCVR_RX_DPTH_CTRL,
+					FSL_XCVR_RX_DPTH_CTRL_CSA);
 		}
 	}
 	if (isr & FSL_XCVR_IRQ_NEW_UD) {
-- 
2.39.5



