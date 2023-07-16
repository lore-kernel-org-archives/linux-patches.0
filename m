Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F588F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060D5C433C8;
	Sun, 16 Jul 2023 20:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540896;
	bh=Cb3crskSi9C1IyevhmDwIyczH9Lha1jvogc3ajQ8Ud4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nH0tMV1qhtKaiKq+0c2+sxVO0KipwxGcEZZbSDGzAO+xR7XXdDSA9qkJkZrWIy2TB
	 MnB486fs9ginR3T2a3VpfWE7QmuhHKoEC0JaOMf+5LfjK7eXztv7wvEVgTmXsc07r2
	 jr6cHxztGCUQxOveNyMWq2qXQQpAx9fOXd4iv/98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 489/591] spi: bcm-qspi: return error if neither hif_mspi nor mspi is available
Date: Sun, 16 Jul 2023 21:50:28 +0200
Message-ID: <20230716194936.544678717@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index cad2d55dcd3d2..137e7315a3cfd 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1543,13 +1543,9 @@ int bcm_qspi_probe(struct platform_device *pdev,
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



