Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC40335BA3;
	Mon, 18 Aug 2025 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525142; cv=none; b=iPvV5Xu/A44lSyCTrPGS4bKlgr3CTxzGysJ7ksJteRd8NTPD+D6nPlGt1zc9xowAt80scM6hnYsnX3zEywp0bZivs3L+WRAsCd2/wcTTPGtpi/H9sGv5kEfkaArTlXp3EouccnZVW+qbFia0NE/HmRsczGWb+ytE3Ac6/P0RyKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525142; c=relaxed/simple;
	bh=2BDNpRZGnHESDxz6qxj8OBE3eEvPuLKV2LLwPGjVKIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfwsBwNFQMUrGpZ110vFZGtioiPImchyrS79Qk/p0C3IWAT45/O7sJ3X0BZJb4lBzXsI67Jfotb7Px+QRaly5AXrC7BoPokIgUNZ8i7BwY4eI5gqoEBLxF/U2BRvea/McI8rqrTmTfAHXA1Nlrc/JCfi9DQ5zslhpyo8/7H9rFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hbb/DfA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hbb/DfA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6EAC4CEEB;
	Mon, 18 Aug 2025 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525141;
	bh=2BDNpRZGnHESDxz6qxj8OBE3eEvPuLKV2LLwPGjVKIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hbb/DfA+ZfUSqLD+NQ9SEgqDX52ff5ji9q9UZQyvLps5CRzeY4+88hjlAvq17UJzc
	 gW4U0x8l4jnsAmUJXdPKxXlJMguxq7UuGR5TsHxKQyFuQvidnyU/gR85sdcMLIqDXe
	 7zfzhgx+ZBCcVTXIH0UoLCw+QoZpI4KAglBvkKyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Hiago De Franco <hiago.franco@toradex.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 139/570] remoteproc: imx_rproc: skip clock enable when M-core is managed by the SCU
Date: Mon, 18 Aug 2025 14:42:06 +0200
Message-ID: <20250818124511.174024388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiago De Franco <hiago.franco@toradex.com>

[ Upstream commit 496deecb020d14ba89ba7084fbc3024f91687023 ]

For the i.MX8X and i.MX8 family SoCs, when the Cortex-M core is powered
up and started by the Cortex-A core using the bootloader (e.g., via the
U-Boot bootaux command), both M-core and Linux run within the same SCFW
(System Controller Firmware) partition. With that, Linux has permission
to control the M-core.

But once the M-core is started by the bootloader, the SCFW automatically
enables its clock and sets the clock rate. If Linux later attempts to
enable the same clock via clk_prepare_enable(), the SCFW returns a
'LOCKED' error, as the clock is already configured by the SCFW. This
causes the probe function in imx_rproc.c to fail, leading to the M-core
power domain being shut down while the core is still running. This
results in a fault from the SCU (System Controller Unit) and triggers a
system reset.

To address this issue, ignore handling the clk for i.MX8X and i.MX8
M-core, as SCFW already takes care of enabling and configuring the
clock.

Suggested-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Hiago De Franco <hiago.franco@toradex.com>
Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20250629172512.14857-3-hiagofranco@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 74299af1d7f1..627e57a88db2 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1029,8 +1029,8 @@ static int imx_rproc_clk_enable(struct imx_rproc *priv)
 	struct device *dev = priv->dev;
 	int ret;
 
-	/* Remote core is not under control of Linux */
-	if (dcfg->method == IMX_RPROC_NONE)
+	/* Remote core is not under control of Linux or it is managed by SCU API */
+	if (dcfg->method == IMX_RPROC_NONE || dcfg->method == IMX_RPROC_SCU_API)
 		return 0;
 
 	priv->clk = devm_clk_get(dev, NULL);
-- 
2.39.5



