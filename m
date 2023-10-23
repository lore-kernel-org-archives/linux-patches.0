Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F5515EA5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9PqUNi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CDAC433C9;
	Mon, 23 Oct 2023 11:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061379;
	bh=enQrtwsRTi/iga77M1fOc81DLZ0jlH210A7pY/F22Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9PqUNi2BzCr4pwTBrWN7lpOw9V4di5F2cjpTTBPRwjie2eBF/9Eld8hZFilyoCYd
	 gylsUxjV5SkLJ3TjZWcBI9JtfjM1Sxr4+gzU2MZWdbsHOj4VxhwltntcvVbHLr2NCR
	 4Pbo+hYJLRohFJ5km+fwm7Pfx8eBaFLyzahWZFo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/202] Revert "spi: zynqmp-gqspi: fix clock imbalance on probe failure"
Date: Mon, 23 Oct 2023 12:55:34 +0200
Message-ID: <20231023104827.400210044@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 19f3d5d13b756b913be582a9e0d0afdeca9c397e.

Reported issues with backport, revert for now.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 12d9c5d6b9e26..ed68e237314fb 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1197,9 +1197,9 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	return 0;
 
 clk_dis_all:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
 clk_dis_pclk:
 	clk_disable_unprepare(xqspi->pclk);
@@ -1223,15 +1223,11 @@ static int zynqmp_qspi_remove(struct platform_device *pdev)
 {
 	struct zynqmp_qspi *xqspi = platform_get_drvdata(pdev);
 
-	pm_runtime_get_sync(&pdev->dev);
-
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
-
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_put_noidle(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	clk_disable_unprepare(xqspi->refclk);
 	clk_disable_unprepare(xqspi->pclk);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return 0;
 }
-- 
2.40.1



