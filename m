Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FA3336EDA;
	Fri,  9 Jan 2026 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962034; cv=none; b=GaZs6wlB5daA3CgBtfeJoB+/g3L9T9nVgpJdUcsGCIK8WHq516Zn3VKSNrpwcbIvcYkUkHenJparR1YC6xjLiGfw1zr9VHBwbJxQCsYddwYcaRqLjEancL18OQMZRnEfohy7GXAJqw1sYavcRvF8WStuB1RvZ8QrpU+OsaT5fK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962034; c=relaxed/simple;
	bh=/NkByLhiYW+D/zIBOBZQ1hUoX3oGDVAkP7Wkb6h0s0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwHTAl5vxBIQJzIi4ziIiF6ejUAJwxds5gt57SeozdZ3m/HEibG8o7OxUx4Uv/Cch861qRURP8M1R7zfbGunHR1BMZ7vMaqR+ioG4uTxE8lVCsIyx5V/qyF3CdQz7h7EiFknMPevCRUHCHvbios1L0tt4+taPY3zoxu/a1ZtwNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5Pl/MkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5Pl/MkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5ACC4CEF1;
	Fri,  9 Jan 2026 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962034;
	bh=/NkByLhiYW+D/zIBOBZQ1hUoX3oGDVAkP7Wkb6h0s0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5Pl/MkJfOax57l1kXAC90QoIf1F2YLzR4o6dU4rfhMNbBn3dHtKYVUQ/9PMslUvz
	 4AXcYc4HoGrkGDZEl0zi88H9oYQvp6cAKNxQz+T/K5Hp2bP8EMSSwvYFy9xr+c7/k8
	 0j6A4EQZFIkToJ+s6kmb7o4wZbDwmB+XKvP439J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 224/634] ASoC: fsl_xcvr: get channel status data when PHY is not exists
Date: Fri,  9 Jan 2026 12:38:22 +0100
Message-ID: <20260109112125.861394477@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1166,6 +1166,26 @@ static irqreturn_t irq0_isr(int irq, voi
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


