Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528633EB7F1;
	Tue, 17 Mar 2026 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765508; cv=none; b=r8qPL0ZGnzkz5yRma1RjaKMrk2lOqIp0E74EUZDNreIo3hs5nBTxZed5bujRos6RrVJ2ALfU43OB1T3oc0z2wq0dGfiDFsXe45OP7jcwk3HCTEuZDgKr9EFrY6t0RlrAXtIxUjTIMzd6Xj2W+39sjnkAPNAXq//6Bi9wq3FjVGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765508; c=relaxed/simple;
	bh=J3s+H6uD1jm7BbWsVQ0ErnW1g1qEDObktrVVQ3sHsm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ik1Vpk60N3sxsl+DrbMZ2gkV9FvsVh6aqCNTDHDm6Py9IANXK2N7T+RNbJIYCiOBE5SwpBes74CvOvrnbsCWP/XWHCfv8QGLHjpxWGfP79hGtvqPRxfQsApNAzwLRyPZsoNY3uUV3JaVdDsh2aE6sLzXumF1fIlIRPOC4qC+x7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqWx/r2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqWx/r2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71252C4CEF7;
	Tue, 17 Mar 2026 16:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765508;
	bh=J3s+H6uD1jm7BbWsVQ0ErnW1g1qEDObktrVVQ3sHsm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqWx/r2pa89BAugAJGDgYhRS8Sue7sNgWORckvmd4sx5+E9nnyCE6f9QZwTIpeQTC
	 wuTuXTQAyMkWW559IJ+i8IiB1ItbakSZFVXk6rPUEgeDLTeGSbDarMmr4Nfh71aMZD
	 sl41pmU5qIW9I5yKkLBp70btm8Hw97RvWxo+8KCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 006/378] remoteproc: mediatek: Unprepare SCP clock during system suspend
Date: Tue, 17 Mar 2026 17:29:23 +0100
Message-ID: <20260317163007.203824328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 98d00bd5200cc..b0b65aefc7190 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -1597,12 +1597,51 @@ static const struct of_device_id mtk_scp_of_match[] = {
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
 	.remove = scp_remove,
 	.driver = {
 		.name = "mtk-scp",
 		.of_match_table = mtk_scp_of_match,
+		.pm = &scp_pm_ops,
 	},
 };
 
-- 
2.51.0



