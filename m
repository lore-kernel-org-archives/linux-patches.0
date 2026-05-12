Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ABA33ADBA;
	Tue, 12 May 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609466; cv=none; b=hNcb6nuwuW19K2xcS3m8hHPKJ5CIyfl9yg+a1JESX7AKnOr4l9pkjuvAzGUyxFuBl60LW1HNa+vFHcr381XZUwWBesN8uKtV7vKPQ+5jTqZpbv6M0yXaltx3q5U01IhzgF8FDLkAYFa1RQqtiIb9pmGuaGxHyVJx6ESwdBhDXKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609466; c=relaxed/simple;
	bh=7wHNW4ooLxSSh8urSJ89cKcj4tlTig3Y+cFK5V4tcS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLyALi86EivtylXqzOqEmqAracprW29x/oWxmTQyCcy9yz2QPpE/ZcMo5IVjqfpIGv4Dnc9f+uzUgoxrttWgm4Vcml+tUvfJ8sxhB2kRiptk/UPfCLdKQ9a5UM4NxHoF0h203huRXNhTR4v/tqq+N00a5f7/v1O147Icc5Xi7Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wk+2wNnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wk+2wNnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B154C2BCB0;
	Tue, 12 May 2026 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609466;
	bh=7wHNW4ooLxSSh8urSJ89cKcj4tlTig3Y+cFK5V4tcS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wk+2wNnHFxwL5BgZsthR/IrBA2uPypJaUIBErEoIjXvex6W2sTU5p0oxjloQr+IAf
	 /Yl1sbXfBjcm5HBnzryNQKNfBGkI8YXALOCJt+TAiI0RgwyW48VkOhzZeDhUsmQ/s3
	 sTY6nxySxTJXa9OFlit00/CH5agi+X1GJH2Kl4GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: [PATCH 7.0 165/307] clk: imx: imx8-acm: fix flags for acm clocks
Date: Tue, 12 May 2026 19:39:20 +0200
Message-ID: <20260512173943.605683216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


