Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35687126C02;
	Sun,  7 Sep 2025 20:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277993; cv=none; b=OO+55tomflhmusG/XNy1dj9frs4aAGKh2Hkqh+0GS9Y9yAq5A//iaBoPbT/BaDwXfYZIrnaTBhnf8t7E9pXVnJJMU4sKl/zi1q7R+eNdmYBBZw1IoQCV7ffeKrBNon9L49/hzE+MguzScu3QYHWcPkitEar6qcYqmJlJLkKE3Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277993; c=relaxed/simple;
	bh=dRcS/q3gxdY4MGvK8LBZb90mzAQ/nFHftSBm5peteOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpkyklfWH7vbjfYhBXUh6cJEhcqgMBMCIMtFkdCh2o0DSveD+eNEBTdfZneveT0Y9PSm7+RG3JNl/p6ctqppTjr99ofeZQpN0G1gSvrEa7EhyGRbym5QwOC4mbDvQwDrPxgOAf4Biymj46F/XoWzAzYVyWwfJ9t3b63YIX5rRlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ah9TZd91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ah9TZd91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ED3C4CEF0;
	Sun,  7 Sep 2025 20:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277993;
	bh=dRcS/q3gxdY4MGvK8LBZb90mzAQ/nFHftSBm5peteOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ah9TZd91/ogiFP0AjNNf7+tNNlMDJN0XK9w7PFoOXqjzVj3Wz6vstAFBluFq/6SZF
	 37mZliY3h28s+qozXTRNE8hxdxtN9dmiVmyJCJVIivarTc9juPUYQw/F6mvBc8sq17
	 bfga9a4PvRYr442H/6kBKJuLS6YFFuo23B9Kmmdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 167/183] spi: spi-qpic-snand: unregister ECC engine on probe error and device remove
Date: Sun,  7 Sep 2025 21:59:54 +0200
Message-ID: <20250907195619.784170508@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 1991a458528588ff34e98b6365362560d208710f ]

The on-host hardware ECC engine remains registered both when
the spi_register_controller() function returns with an error
and also on device removal.

Change the qcom_spi_probe() function to unregister the engine
on the error path, and add the missing unregistering call to
qcom_spi_remove() to avoid possible use-after-free issues.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Message-ID: <20250903-qpic-snand-unregister-ecceng-v1-1-ef5387b0abdc@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index e98e997680c75..cfc81327f7a44 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -1615,11 +1615,13 @@ static int qcom_spi_probe(struct platform_device *pdev)
 	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_controller failed.\n");
-		goto err_spi_init;
+		goto err_register_controller;
 	}
 
 	return 0;
 
+err_register_controller:
+	nand_ecc_unregister_on_host_hw_engine(&snandc->qspi->ecc_eng);
 err_spi_init:
 	qcom_nandc_unalloc(snandc);
 err_snand_alloc:
@@ -1641,7 +1643,7 @@ static void qcom_spi_remove(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	spi_unregister_controller(ctlr);
-
+	nand_ecc_unregister_on_host_hw_engine(&snandc->qspi->ecc_eng);
 	qcom_nandc_unalloc(snandc);
 
 	clk_disable_unprepare(snandc->aon_clk);
-- 
2.51.0



