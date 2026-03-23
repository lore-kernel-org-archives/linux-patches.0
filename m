Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5803B2FD5;
	Mon, 23 Mar 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275233; cv=none; b=bGouTYzq7TfInn4vf0LzxovjzTB0THGP58jj2lSyh6TYba/7EUaDhw3/B68wMEJnpZP/QDScXRxwrUUUm/UeilgOostRX1cbcBWQkwS2xS3UtLsiPl4KD49xiDzH6YnZYdGIHbtHrx38e7fC4zSNS0h0h2/rok/88JEPDKMifSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275233; c=relaxed/simple;
	bh=Mi7XkuYUf7dxHm+0iCHkD5V3llz3G+FFbz+AeHeWaGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gj3CajrSKB6By8J+bHm5VVL4NL863RiKp1iV/QdUJJD8et7PkZq8UrZkIfH5aOMXPoZNMEvFFm9lAnnxtjbRGAy6kCI8BXdXLjHWMLzxRjKGNHxtPbF+Y9FZPvnnBu6qW34cK9XkIcHjHBspneQ5pVKLSZABr2rK2cVbzdhJNGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns3B5rYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns3B5rYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA217C4CEF7;
	Mon, 23 Mar 2026 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275233;
	bh=Mi7XkuYUf7dxHm+0iCHkD5V3llz3G+FFbz+AeHeWaGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ns3B5rYLOEdewOH45ONMDvrlOJw1Qy+zjhF/wFdwDIdGO6GWd5XmedNU0MRw2sazD
	 oiI7Af12r9lbQ+TqCLZ8GGy6Ks2/hRFs+CNSstN6c6uZLrBdRjOwT5tk+rYNb0CSDb
	 vKClGfaa+GISefXkEdyIyqfkWCkWfEBqIkcGwkzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/460] remoteproc: mediatek: Unprepare SCP clock during system suspend
Date: Mon, 23 Mar 2026 14:40:18 +0100
Message-ID: <20260323134527.231391231@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index ae20d2221c8e0..fcd2665f7abbc 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -1544,12 +1544,51 @@ static const struct of_device_id mtk_scp_of_match[] = {
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



