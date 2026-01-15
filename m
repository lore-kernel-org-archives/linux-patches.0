Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5144D3A0E9A;
	Thu, 15 Jan 2026 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497784; cv=none; b=r5YAobtJmp5VHcOHlDYpU1YEphEBJktDk9J+jRcCwXfiN4ATvdSDQfISc8MnugwMHiLCbECos0Fwx+f884cbPJPdO6YOtiKPa0lcCMsFdYtd1n72vTW7jUcYGJiy4+OV3b6S0lY8l+8BdfvEwRodMuWNBBAieAYu6765jRA/IrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497784; c=relaxed/simple;
	bh=cmTueW8AgUpAOIoP6kZ6k3zSG3y5PL7hfGTmDcq4FsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccHd2ZhV0EBiGujLqID7uPHzq6sj5jmS5MjTRF5/tmcMvwVngpGJtSE70lG76DUqdAwGwC7I3/LU2P1gK2A6WgZ/DstIbEjYkW0VfkxZgUUEuX4pvE2POCo6R6ykW4jN2EXVW0OfxpuqR6OKYyeqiRLLREgIhq/QQfu3gLaEAkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2QTC/Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2QTC/Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2173C116D0;
	Thu, 15 Jan 2026 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497784;
	bh=cmTueW8AgUpAOIoP6kZ6k3zSG3y5PL7hfGTmDcq4FsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2QTC/DtQE9rZbi782fVo1WC0bCHqYKLTSRmGqKkur+0ei1SVTtgEhUJWgoZ5xsuq
	 1mNO7NPwhT81xEgecQ0zEbDY9t3ZcF3W4qKS4rD54tTX/xdbJfzmRvbSxe5uDjswPN
	 FC3UdRnmw+01UYNaNZWSgnbEHnHmEGncTk/uGT1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 201/554] ASoC: fsl_xcvr: get channel status data when PHY is not exists
Date: Thu, 15 Jan 2026 17:44:27 +0100
Message-ID: <20260115164253.532512299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit ca592e20659e0304ebd8f4dabb273da4f9385848 upstream.

There is no PHY for the XCVR module on i.MX93, the channel status needs
to be obtained from FSL_XCVR_RX_CS_DATA_* registers. And channel status
acknowledge (CSA) bit should be set once channel status is processed.

Fixes: e240b9329a30 ("ASoC: fsl_xcvr: Add support for i.MX93 platform")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250710030405.3370671-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_xcvr.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1165,6 +1165,26 @@ static irqreturn_t irq0_isr(int irq, voi
 				/* clear CS control register */
 				writel_relaxed(0, reg_ctrl);
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


