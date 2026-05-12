Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1A63E172F;
	Tue, 12 May 2026 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608011; cv=none; b=SZPHyGnJ6uB2FiI48b2pG8cmRoPcnMhNijQiaTvsNz3fsH8InauAJYK6N3x5Ahrl8ltI2oe8Uh4tjb3sdBVSTUgLhaLHNodRMG5W2CraFvgcpFqXijpOrqzbUDJyHsfKua636sSMwFt8aaU2TyfWUdjPOn/Mupf1iQV4WEDpLcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608011; c=relaxed/simple;
	bh=7nBBYfqz7SdruFsVKUFWBpQ7Te/u19dzmdw2q6JD0Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALOhkR8pNdJtR8mEcPHAqmv3ciIYhVxqf7rncVgXLYitPv1WJ4JjT09C1S9JuLNEf6M2n69QNV8l3hhiVxbXQX5/f39YEEx0X2sqMEB+h//DwKQ6BvYwu0MOACuFy6oNdXyiXbzZLJxdAbmMvUIsJsvALMVo8A66+2VED4ZysXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmGO+LXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmGO+LXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DD6C4AF09;
	Tue, 12 May 2026 17:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608011;
	bh=7nBBYfqz7SdruFsVKUFWBpQ7Te/u19dzmdw2q6JD0Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmGO+LXkL1njJwGh8kTMuAw+6fuMsrKU7Ij8Nv8WZo5Ok55hINPmPEmUtoFJI66o3
	 nRP2qHxvZ0BTTiHGbuHQcp7DpbP57PuNFR1/WUOL7BWvzXjFrCtwXGaDv/dO+MgIjD
	 /6unZExQcL53Z8PjrL32W7mIkDd88e9s1o/MmdTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: [PATCH 6.12 105/206] clk: imx: imx8-acm: fix flags for acm clocks
Date: Tue, 12 May 2026 19:39:17 +0200
Message-ID: <20260512173935.081185819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit f2c2fc93b4a3efdfcf3805ab74741826d343ff2c upstream.

Currently, the flags for the ACM clocks are set to 0. This configuration
causes the fsl-sai audio driver to fail when attempting to set the
sysclk, returning an EINVAL error. The following error messages
highlight the issue:
fsl-sai 59090000.sai: ASoC: error at snd_soc_dai_set_sysclk on 59090000.sai: -22
imx-hdmi sound-hdmi: failed to set cpu sysclk: -22

By setting the flag CLK_SET_RATE_NO_REPARENT, we signal that the ACM
driver does not support reparenting and instead relies on the clock tree
as defined in the device tree. This change resolves the issue with the
fsl-sai audio driver.

CC: stable@vger.kernel.org
Fixes: d3a0946d7ac9 ("clk: imx: imx8: add audio clock mux driver")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260212085750.3253187-1-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-imx8-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/imx/clk-imx8-acm.c
+++ b/drivers/clk/imx/clk-imx8-acm.c
@@ -371,7 +371,8 @@ static int imx8_acm_clk_probe(struct pla
 	for (i = 0; i < priv->soc_data->num_sels; i++) {
 		hws[sels[i].clkid] = devm_clk_hw_register_mux_parent_data_table(dev,
 										sels[i].name, sels[i].parents,
-										sels[i].num_parents, 0,
+										sels[i].num_parents,
+										CLK_SET_RATE_NO_REPARENT,
 										base + sels[i].reg,
 										sels[i].shift, sels[i].width,
 										0, NULL, NULL);


