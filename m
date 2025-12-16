Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD0A347FF4;
	Tue, 16 Dec 2025 11:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885121; cv=none; b=JMSzXjDcict2bgytmGcF1mXJ9lk4r9vwWcYc99M7hB+O5QC7WYvILMKiVDn5IMosIghirAk4nGAAj5P/sPNLJjyZKEp1sn8Z+xfVrY1XTE+xC1WBy9BRtIVbRpfZL7ZGwL7VK638xm6l+F7D4YQ7RmHZ1MlCoIPJpYd3FTIyF80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885121; c=relaxed/simple;
	bh=85kn43mF8euOyTplU44l51mpDJKrtZNNXlu+2/nw1to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQyzgpTn2LVqpTQ8HV7x/ukqvRTrwj52DHeq0k433FM8kLIanOfQvs713QxF5vJuN7yeYzUhMaMlCkTcKVlY7rRoZ3yL7dZWGrz3qhENMC1NuKwE/SmqbtAKp8fBnFY6WKKomTNJJB33ofiLWTD9t/PF5EpafY+6V2uFDoUXsCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOGrVdd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOGrVdd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2FFC4CEF1;
	Tue, 16 Dec 2025 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885121;
	bh=85kn43mF8euOyTplU44l51mpDJKrtZNNXlu+2/nw1to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOGrVdd9BqqXHD2ytEL9FSvqA+BgWGV0RKfk87mukynum5EAH+5lGPD/HKlRMCcQu
	 0/Zw4gOCvLDmQjBdbJcf2/fWUbtTNoQ6PuVCbFd3XPNNike5g6llJStRHzKTftb9xT
	 bBlRPTSK+eLQminAJ5DD1IRRGKIxPthLjJW5iV2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Hiago De Franco <hiago.franco@toradex.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 027/507] remoteproc: imx_rproc: Fix runtime PM cleanup and improve remove path
Date: Tue, 16 Dec 2025 12:07:48 +0100
Message-ID: <20251216111346.519575908@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 80405a34e1f8975cdb2d7d8679bca7f768861035 ]

Proper cleanup should be done when rproc_add() fails by invoking both
pm_runtime_disable() and pm_runtime_put_noidle() to avoid leaving the
device in an inconsistent power state.

Fix it by adding pm_runtime_put_noidle() and pm_runtime_disable()
in the error path.

Also Update the remove() callback to use pm_runtime_put_noidle() instead of
pm_runtime_put(), to clearly indicate that only need to restore the usage
count.

Fixes: a876a3aacc43 ("remoteproc: imx_rproc: detect and attach to pre-booted remote cores")
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Hiago De Franco <hiago.franco@toradex.com>
Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250926-imx_rproc_v3-v3-1-4c0ec279cc5f@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index a6eef0080ca9e..2eaff813a5b9f 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1174,11 +1174,16 @@ static int imx_rproc_probe(struct platform_device *pdev)
 	ret = rproc_add(rproc);
 	if (ret) {
 		dev_err(dev, "rproc_add failed\n");
-		goto err_put_clk;
+		goto err_put_pm;
 	}
 
 	return 0;
 
+err_put_pm:
+	if (dcfg->method == IMX_RPROC_SCU_API) {
+		pm_runtime_disable(dev);
+		pm_runtime_put_noidle(dev);
+	}
 err_put_clk:
 	clk_disable_unprepare(priv->clk);
 err_put_scu:
@@ -1198,7 +1203,7 @@ static void imx_rproc_remove(struct platform_device *pdev)
 
 	if (priv->dcfg->method == IMX_RPROC_SCU_API) {
 		pm_runtime_disable(priv->dev);
-		pm_runtime_put(priv->dev);
+		pm_runtime_put_noidle(priv->dev);
 	}
 	clk_disable_unprepare(priv->clk);
 	rproc_del(rproc);
-- 
2.51.0



