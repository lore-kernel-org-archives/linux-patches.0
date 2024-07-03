Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BA913AA2C;
	Wed,  3 Jul 2024 11:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004409; cv=none; b=gvYcSIDvXd4gmbfCkaWe/fzHxqFBQJHlPwf3SH6U/QQ5rcrQex+pSLi5MqVUHSS/vxZsKuYKR6fFE0SDWp0akplX8xNtqKWFdcB9CoO8/oA1KGSiCXiUAMOyNIUtVdYmtsYvETQIIjyZvrI6mHhCXmIGiwhuNDrtzSvQvtDHAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004409; c=relaxed/simple;
	bh=c9ffZNxpPa0fJqM6WfU9I/RHtd3NDMP5m1xKnC+ouR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+oQ/pgV66M+I/BBHy9KxNIt4BZ21KMzhrRdcEKmniKK9+S2TX+20gLKTgD+vRwiDvLIOkTGalsk03TLqNpBi00NHnE39lw6R8SsMelnwilrF1OEjNgbRRRCGgAnVCqhodvaA0ajvgwamTxs0PB34I/RcYwiGBUvMqC0Ayhxw78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha4C3uAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha4C3uAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D698C2BD10;
	Wed,  3 Jul 2024 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004409;
	bh=c9ffZNxpPa0fJqM6WfU9I/RHtd3NDMP5m1xKnC+ouR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha4C3uAATie2V/UAADvv4hdnOvQfOiOYM0089ZQrG8WKod0YeDV9cf2R+fuevsWRw
	 xLao/P6ELw+Fd4HDdR5+Q2vHnkd73tZ76xLam1U+VAe2TJBybPESTt5ei9g9cuouIC
	 91OQygZ1UsfvF3E2240lYu0w8xdxSgo9X1G9ZEeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/290] mmc: davinci: Dont strip remove function when driver is builtin
Date: Wed,  3 Jul 2024 12:36:54 +0200
Message-ID: <20240703102905.449411011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 55c421b364482b61c4c45313a535e61ed5ae4ea3 ]

Using __exit for the remove function results in the remove callback being
discarded with CONFIG_MMC_DAVINCI=y. When such a device gets unbound (e.g.
using sysfs or hotplug), the driver is just removed without the cleanup
being performed. This results in resource leaks. Fix it by compiling in the
remove callback unconditionally.

This also fixes a W=1 modpost warning:

WARNING: modpost: drivers/mmc/host/davinci_mmc: section mismatch in
reference: davinci_mmcsd_driver+0x10 (section: .data) ->
davinci_mmcsd_remove (section: .exit.text)

Fixes: b4cff4549b7a ("DaVinci: MMC: MMC/SD controller driver for DaVinci family")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240324114017.231936-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/davinci_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1347,7 +1347,7 @@ ioremap_fail:
 	return ret;
 }
 
-static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
+static int davinci_mmcsd_remove(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
@@ -1404,7 +1404,7 @@ static struct platform_driver davinci_mm
 		.of_match_table = davinci_mmc_dt_ids,
 	},
 	.probe		= davinci_mmcsd_probe,
-	.remove		= __exit_p(davinci_mmcsd_remove),
+	.remove		= davinci_mmcsd_remove,
 	.id_table	= davinci_mmc_devtype,
 };
 


