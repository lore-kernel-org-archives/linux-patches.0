Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F93612FF;
	Tue, 16 Dec 2025 12:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886893; cv=none; b=F1qOmys6rVHTN+h4knRxc1rGH2bHi53QJF5YdqzPc+Z+pSMMeYQL5QoYzMqu3FejniUJw7ZJaqh2S9ZELuu/YClbRPVGFywZD5Co8KYBqQO/Iau8qp+914UyVcOFylziMzLpeFvzFPmsbdjshsTHCQ7lScm6xZuJgMxpzM5buzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886893; c=relaxed/simple;
	bh=LcpBFF6EEwrD/tJmzQwtBiuvoAdeHC/Qii7+w2QW3cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM6KRAJSzKjop4cfHZzHcsADyT9pY2bpRqTQpE6Nt3l14oXK0VUu/7PLUGMDr8J9Ct9VhnSzFC7uO7bhnF5sPJs6j1NeQH/nXIXoO27+pBLEQ7rlhhMxbgLDv4YHM4IpCqDpFXzIrOhhEalnB+Jmx+L4SHIAgLvPqJipj6TaqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpNixAy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpNixAy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E86C4CEF5;
	Tue, 16 Dec 2025 12:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886893;
	bh=LcpBFF6EEwrD/tJmzQwtBiuvoAdeHC/Qii7+w2QW3cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpNixAy1lrnHhbwN4COkEvUefuVY5OFGKQHKQjy+E7qseSQI9G01jhhoC0TsyE2Gl
	 B+2JgFBX0/6L0UiTWV/p+4HSpmMNjiVIxuL03gcFS9aHjuyVuI/+kDaOIUURjS/Ea5
	 UEFNbcHrUaXzv1jGv9R26B416nKGPDHI5+TKVjOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Hiago De Franco <hiago.franco@toradex.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/614] remoteproc: imx_rproc: Fix runtime PM cleanup and improve remove path
Date: Tue, 16 Dec 2025 12:06:39 +0100
Message-ID: <20251216111402.472945481@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bb25221a4a898..8424e6ea5569b 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1136,11 +1136,16 @@ static int imx_rproc_probe(struct platform_device *pdev)
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
@@ -1160,7 +1165,7 @@ static void imx_rproc_remove(struct platform_device *pdev)
 
 	if (priv->dcfg->method == IMX_RPROC_SCU_API) {
 		pm_runtime_disable(priv->dev);
-		pm_runtime_put(priv->dev);
+		pm_runtime_put_noidle(priv->dev);
 	}
 	clk_disable_unprepare(priv->clk);
 	rproc_del(rproc);
-- 
2.51.0



