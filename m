Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F107A144D11;
	Thu, 13 Jun 2024 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279343; cv=none; b=k+CwDRGiVGDNZcPUwlL/UxebaXwMBa5f50mtZ8Y/ZcWZCkA9L4CSsmD4xgWwQ9sBtROhgEh7WwcvVf5q9IX35sEOLI/Z0KIdwJD6SxjKe+gXOPLB4CyaSDeYLQAPj3s/7Oz6Lj90VjOw85VDap5d+jWJ2xYm5sSNEaf55SLdu8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279343; c=relaxed/simple;
	bh=D89kVTW0nzvAU4Po5j0RyJdjO7VnC+u0mYXDA0aUNmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebEAJ95QgCD13czrZy6hrI5F0Hht8uKicUw/V7e/shJLSNpxzK+JKQOS/2qSv2FNJ+q8PX8fgA1gBdPhOLGXTzJXoUhCXk59dojWklq5olnNNXpRRaVHCwh0t7akhWd27zLLsPr+AQuX0zBMaYMgAsD9FdT7aaRMqZmbUsSmbkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4v0kdGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4v0kdGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F132C2BBFC;
	Thu, 13 Jun 2024 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279342;
	bh=D89kVTW0nzvAU4Po5j0RyJdjO7VnC+u0mYXDA0aUNmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4v0kdGSFU3+FkoxaytBd9cVyDluV5QiRJQB8Sd98BGcvjy0EfOBjQmfQzvEk9qaf
	 Rs/3JJ6IciTB5CDjP8Y3CHUGCbdbQ0EOESjVHaUKNvDWg//U5HEWJwVH0dzAZC5aJo
	 P8jycD5WcIDhmHw9Gy/MIimTO4Zk8rWdSUYS25SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 043/157] mmc: davinci: Dont strip remove function when driver is builtin
Date: Thu, 13 Jun 2024 13:32:48 +0200
Message-ID: <20240613113229.093228337@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 55c421b364482b61c4c45313a535e61ed5ae4ea3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/davinci_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1337,7 +1337,7 @@ ioremap_fail:
 	return ret;
 }
 
-static void __exit davinci_mmcsd_remove(struct platform_device *pdev)
+static void davinci_mmcsd_remove(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
@@ -1392,7 +1392,7 @@ static struct platform_driver davinci_mm
 		.of_match_table = davinci_mmc_dt_ids,
 	},
 	.probe		= davinci_mmcsd_probe,
-	.remove_new	= __exit_p(davinci_mmcsd_remove),
+	.remove_new	= davinci_mmcsd_remove,
 	.id_table	= davinci_mmc_devtype,
 };
 


