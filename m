Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902E0173334;
	Wed,  3 Jul 2024 11:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005373; cv=none; b=HbPszsctTSi5WfbFMZD1ilUlJ+wZo8mveoHxpHxe83vjd2fLdW70OOi33t852uPUgZ61fixC/3/l3NGQ1z8sUWJYrlv7U7aAXS3uaF5DTh8Z7EV70jBOAjO2GKd5ObXc85Oa20JXydv/VaGc7C0vbz70WvEgji4D1w2BLW7SmL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005373; c=relaxed/simple;
	bh=PAc2veNbE88avpDEVuYUQcv+/o7UQoszUeVX0tLaTnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EpZA5spxoXcOPksdxLF0gGXkmsDcMTEBeLyvz7/VVYEtyrZsxOIeJIDh6ZBGqVdPe2avHAwb/HfgVOmpLq43wT/QSTfr5u+yOe+fyndU12hBO/BwIjZ7adOJthEtLsoQuu+j9UeFXq2scY3XP/y09S34cVzeu/vNFgk445Txaq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyCk6iHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyCk6iHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3738C2BD10;
	Wed,  3 Jul 2024 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005373;
	bh=PAc2veNbE88avpDEVuYUQcv+/o7UQoszUeVX0tLaTnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyCk6iHOKwtOpA3DWkPL/Mt+Y3UZR+coCV1tLgpXaLS7bYNaNgyby9WS9/Y/CevYk
	 kyVIAOnz+fPE3lLWGtAYCGl9gunGMQ6UKJD7+1Q5ZSfLrH8Kf4fd8p097YT4uOV9KO
	 HW56XaXhjel1gX/IC4zbQy2aKb7EqtraTE/6a5Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/356] mmc: davinci: Dont strip remove function when driver is builtin
Date: Wed,  3 Jul 2024 12:36:36 +0200
Message-ID: <20240703102915.365468766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/mmc/host/davinci_mmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 36c45867eb643..e0175808c3b0d 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1347,7 +1347,7 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static void __exit davinci_mmcsd_remove(struct platform_device *pdev)
+static void davinci_mmcsd_remove(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
@@ -1402,7 +1402,7 @@ static struct platform_driver davinci_mmcsd_driver = {
 		.of_match_table = davinci_mmc_dt_ids,
 	},
 	.probe		= davinci_mmcsd_probe,
-	.remove_new	= __exit_p(davinci_mmcsd_remove),
+	.remove_new	= davinci_mmcsd_remove,
 	.id_table	= davinci_mmc_devtype,
 };
 
-- 
2.43.0



