Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037D1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617A8C433C9;
	Tue, 25 Jul 2023 11:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284176;
	bh=yGoFH5aYWRCZ/aN0jRpWfmn+fVNw97FqfxG4g4yOh60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al/grb0l+BFO6sgTVJxSiQ0ZswRwCZyL7R+Um8i6gjdZSGY7xGxFjJvEmohsXyiVh
	 JOnO28iFyztPxfpqse+SdlyfqHHsGXutYx9rFqBYLUqmn6ZV3QCUuVtzVTDgZJKe4k
	 ZOhOYW5XU/8x6ZD7O1k0aaCKfjMqsx6kpVMZ3+yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/509] spi: bcm-qspi: return error if neither hif_mspi nor mspi is available
Date: Tue, 25 Jul 2023 12:43:22 +0200
Message-ID: <20230725104605.792568127@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 7c1f23ad34fcdace50275a6aa1e1969b41c6233f ]

If neither a "hif_mspi" nor "mspi" resource is present, the driver will
just early exit in probe but still return success. Apart from not doing
anything meaningful, this would then also lead to a null pointer access
on removal, as platform_get_drvdata() would return NULL, which it would
then try to dereference when trying to unregister the spi master.

Fix this by unconditionally calling devm_ioremap_resource(), as it can
handle a NULL res and will then return a viable ERR_PTR() if we get one.

The "return 0;" was previously a "goto qspi_resource_err;" where then
ret was returned, but since ret was still initialized to 0 at this place
this was a valid conversion in 63c5395bb7a9 ("spi: bcm-qspi: Fix
use-after-free on unbind"). The issue was not introduced by this commit,
only made more obvious.

Fixes: fa236a7ef240 ("spi: bcm-qspi: Add Broadcom MSPI driver")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>
Link: https://lore.kernel.org/r/20230629134306.95823-1-jonas.gorski@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 766b00350e391..2c734ea0784b7 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1369,13 +1369,9 @@ int bcm_qspi_probe(struct platform_device *pdev,
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						   "mspi");
 
-	if (res) {
-		qspi->base[MSPI]  = devm_ioremap_resource(dev, res);
-		if (IS_ERR(qspi->base[MSPI]))
-			return PTR_ERR(qspi->base[MSPI]);
-	} else {
-		return 0;
-	}
+	qspi->base[MSPI]  = devm_ioremap_resource(dev, res);
+	if (IS_ERR(qspi->base[MSPI]))
+		return PTR_ERR(qspi->base[MSPI]);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "bspi");
 	if (res) {
-- 
2.39.2



