Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C573F928D;
	Fri, 15 May 2026 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861216; cv=none; b=S3u1HkFxDRt7xY/6b2TwJQNbIJQGEqW5C2HBQ3WuhVrGJ3Frz5U7YidL7Ba0U1SqhNxuq79Fh3vNloQa4jpOOBOa+G/IkU+Tr5PWWe3Gk0TXykWEa6AsrjtqRHWX53qvFf768nfYjlmtD7HtYnS2svMuL4ArORVWoGFMxuRrAgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861216; c=relaxed/simple;
	bh=eUTM+/7Et1ES062NU8UuQA7Yjycklbh4qDyX7Nc5Gjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5uQ/70adUctawB9w3e88byuwTsnLJo1zJssQhJwWxjdabWAeZ1UlMovP254zOKX7qXiq/47dh/UGesjCiWXWn6JEsG5qn+LQxKbuafgHo1ou0RMSyuU7wTZ4N2REE218XYEj2ReE1l3pcvDixA0MrlaCaOcCwz5AwT3jJwfDTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzaEwHo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzaEwHo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EB3C2BCFA;
	Fri, 15 May 2026 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861216;
	bh=eUTM+/7Et1ES062NU8UuQA7Yjycklbh4qDyX7Nc5Gjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzaEwHo/zqXUA600DUlQxpQWcMauXUzDPYt4gAC76++0t2cPBt7Dg6nnFjdvhm+fC
	 UGFDYpyl8k9KLrjlnYa/YHgmgH9RTsaStD9cnh1qGBVMyNhOcJlc4i+scr/QfwU12F
	 LqUahzqPzC272FB4LUli9dhbDlGAz/t5MkzndY70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: [PATCH 6.6 241/474] clk: imx: imx8-acm: fix flags for acm clocks
Date: Fri, 15 May 2026 17:45:50 +0200
Message-ID: <20260515154720.216578286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -368,7 +368,8 @@ static int imx8_acm_clk_probe(struct pla
 	for (i = 0; i < priv->soc_data->num_sels; i++) {
 		hws[sels[i].clkid] = devm_clk_hw_register_mux_parent_data_table(dev,
 										sels[i].name, sels[i].parents,
-										sels[i].num_parents, 0,
+										sels[i].num_parents,
+										CLK_SET_RATE_NO_REPARENT,
 										base + sels[i].reg,
 										sels[i].shift, sels[i].width,
 										0, NULL, NULL);


