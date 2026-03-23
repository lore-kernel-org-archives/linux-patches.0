Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811E035959;
	Mon, 23 Mar 2026 15:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278139; cv=none; b=X5THIwfmLjIGsIj1QInSscvzdbvzYhm9GuxITIHa2U6DHpnwHLID/EnBVh3gxRJNAGsQ2FPZCDGWIPdacEMsxbHABUN786rg3LvOXcx3kHO6Ol28fi9Q2MN2+JxwyC+JZX2OAVRFeocEg/fvTpFpDkLjAccieOYofJiRu3DUYHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278139; c=relaxed/simple;
	bh=OOwgefdku+LrRRVwkwmcDFN76Q3ZwheSz6Oh+VWzXxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOoBntF4eiA3daBCWujK1qqeUz3UI+fR3GIzypUmCLKqEt3Hmjdl28Vh3AWLboXMxruhPG+r0L/zBUsC6cepLg0y7FA/HROP9oriKezUcHae3FuiJiu9feia1bgTTC9gbzJhqXGvJ3/tHIqKxrm9hrT4jgjRxjOS7ziRDw40WNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDcTNeyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDcTNeyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DB2C4CEF7;
	Mon, 23 Mar 2026 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278139;
	bh=OOwgefdku+LrRRVwkwmcDFN76Q3ZwheSz6Oh+VWzXxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDcTNeyqtT7Q1bzgIh9rbl52RLR3AbimHQJ2kpz4dUjXEnSgzM2BGQIHA/MaP/UPC
	 TQuNjfwGFcDjA6AQrKVASfQLKqjuitMLMss54zYUVUKnjUcBOGp4xmbty3jl2HZ4bt
	 9SMTIqd3t6rhkJdlfe7m/tkXoG3/HADtD5peDjC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/567] remoteproc: mediatek: Unprepare SCP clock during system suspend
Date: Mon, 23 Mar 2026 14:42:13 +0100
Message-ID: <20260323134539.102460248@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 35c3f72a2d55dbf52f28f4ecae51c76be1acf545 ]

Prior to commit d935187cfb27 ("remoteproc: mediatek: Break lock
dependency to prepare_lock"), `scp->clk` was prepared and enabled only
when it needs to communicate with the SCP.  The commit d935187cfb27
moved the prepare operation to remoteproc's prepare(), keeping the clock
prepared as long as the SCP is running.

The power consumption due to the prolonged clock preparation can be
negligible when the system is running, as SCP is designed to be a very
power efficient processor.

However, the clock remains prepared even when the system enters system
suspend.  This prevents the underlying clock controller (and potentially
the parent PLLs) from shutting down, which increases power consumption
and may block the system from entering deep sleep states.

Add suspend and resume callbacks.  Unprepare the clock in suspend() if
it was active and re-prepare it in resume() to ensure the clock is
properly disabled during system suspend, while maintaining the "always
prepared" semantics while the system is active.  The driver doesn't
implement .attach() callback, hence it only checks for RPROC_RUNNING.

Fixes: d935187cfb27 ("remoteproc: mediatek: Break lock dependency to prepare_lock")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20260206033034.3031781-1-tzungbi@kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index ecbece2b5ce7c..bf7a4b975e7e1 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -1024,12 +1024,51 @@ static const struct of_device_id mtk_scp_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mtk_scp_of_match);
 
+static int __maybe_unused scp_suspend(struct device *dev)
+{
+	struct mtk_scp *scp = dev_get_drvdata(dev);
+	struct rproc *rproc = scp->rproc;
+
+	/*
+	 * Only unprepare if the SCP is running and holding the clock.
+	 *
+	 * Note: `scp_ops` doesn't implement .attach() callback, hence
+	 * `rproc->state` can never be RPROC_ATTACHED.  Otherwise, it
+	 * should also be checked here.
+	 */
+	if (rproc->state == RPROC_RUNNING)
+		clk_unprepare(scp->clk);
+	return 0;
+}
+
+static int __maybe_unused scp_resume(struct device *dev)
+{
+	struct mtk_scp *scp = dev_get_drvdata(dev);
+	struct rproc *rproc = scp->rproc;
+
+	/*
+	 * Only prepare if the SCP was running and holding the clock.
+	 *
+	 * Note: `scp_ops` doesn't implement .attach() callback, hence
+	 * `rproc->state` can never be RPROC_ATTACHED.  Otherwise, it
+	 * should also be checked here.
+	 */
+	if (rproc->state == RPROC_RUNNING)
+		return clk_prepare(scp->clk);
+	return 0;
+}
+
+static const struct dev_pm_ops scp_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(scp_suspend, scp_resume)
+};
+
 static struct platform_driver mtk_scp_driver = {
 	.probe = scp_probe,
 	.remove_new = scp_remove,
 	.driver = {
 		.name = "mtk-scp",
 		.of_match_table = mtk_scp_of_match,
+		.pm = &scp_pm_ops,
 	},
 };
 
-- 
2.51.0



