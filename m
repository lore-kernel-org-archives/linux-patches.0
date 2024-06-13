Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8514600D;
	Thu, 13 Jun 2024 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280512; cv=none; b=h5Guk2ZmbFyVfCdtm/CQ74KcDY6lANuKHL0yAaMQkwNM0JHAIbXr09xmg8Ctp7Kj+AAB//oifs/jL8y0goRtde3PNJahCwM9L252Oae7BqzyYHo8jdebPTqxkRRz2CncqtLC2g3Vqrr0m28mhK7VL3h3xcZoj1ZjyzSM5g5v6qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280512; c=relaxed/simple;
	bh=z54+IXJd2D7Q5EgB9hmlEweBGB3omQmg2+7PXSVCo0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UG1FJhm7u5FDV+nvTa3Dsg00WQK0e88hH6jzOQYVJ3unjNO92uFnNVMd7EeZoVaorR1gX6dQ1EikniuyVzMQMeNO3bMrG+0RJuj79/gy4hMakPMbLx4HLtOUTiRVVarQw6Fmg9ctaWZX2v+OWy/Mnb3vPHF/BbLjdlEr6tMERbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTnvEsTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTnvEsTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C14C32786;
	Thu, 13 Jun 2024 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280512;
	bh=z54+IXJd2D7Q5EgB9hmlEweBGB3omQmg2+7PXSVCo0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTnvEsTVAggwWqhoXNlbIT+iNxd0DN+P2Lg5R19HvwtTxp/rDwTPUjl+2q7PKK5N1
	 DREwOJT+3mtdbAgCv5Rlro6NdO4LD1vgBn1gvRgv5Dc54+2tQNnQkvYXhFKfmzRW2Q
	 S8plxoj5Bafpts6A4c29sZjCx3JuVB107Zb5QCnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 047/137] mmc: davinci: Dont strip remove function when driver is builtin
Date: Thu, 13 Jun 2024 13:33:47 +0200
Message-ID: <20240613113225.120222516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1344,7 +1344,7 @@ ioremap_fail:
 	return ret;
 }
 
-static void __exit davinci_mmcsd_remove(struct platform_device *pdev)
+static void davinci_mmcsd_remove(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
@@ -1399,7 +1399,7 @@ static struct platform_driver davinci_mm
 		.of_match_table = davinci_mmc_dt_ids,
 	},
 	.probe		= davinci_mmcsd_probe,
-	.remove_new	= __exit_p(davinci_mmcsd_remove),
+	.remove_new	= davinci_mmcsd_remove,
 	.id_table	= davinci_mmc_devtype,
 };
 


