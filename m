Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B471DEFF8;
	Tue,  8 Oct 2024 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393629; cv=none; b=OgnAvdlmEUf6lLxTdk9fkDIgXOXUznIgGtaSWd4OpgQJPkBajvrjY0Ipr8EvkcdyChMZXz2CeCg9WqwkCFf9eWWR4gBZjpVuav8BaQ442tD/JDkREDV+kL1dEKq0Q5XwXLVENku82m6G3Eey4XmjPslaVGbX2SylZmWlOThXxmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393629; c=relaxed/simple;
	bh=7pUEaIfD4D0MihuQoUdtgo6E1pnm7FXtn/h2ECwnW7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWkDw5ksLO3YRP/NprTp6r7L58I5pfezhRtSN8XX1MxqT8zjco4Fwep6xMwqNEUvV8czT8pAK0upCPqiRQVyHCnzuVzHOUaL7qeXKLJ2DqIanBrDFL7tzMFtkNqTk5R/rSwGvE4WbxWfRYXsYpg2N85HGwFs8kslcMysdVRHhek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWySGQrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWySGQrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805D5C4CECC;
	Tue,  8 Oct 2024 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393629;
	bh=7pUEaIfD4D0MihuQoUdtgo6E1pnm7FXtn/h2ECwnW7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWySGQrTJFGFIuSiRuzmEgx5Cjp4Br6Q0fl79bopRmVWRlvsQtDZE8/ranhXO9kCz
	 CCVcelBrj+hwbxiHuhASJa0SjoY+vK0L7W9iPuV4tt5x6xm8FIFHqW/2GL3RHXgz4S
	 eBV4NtUOXzhuJvbWu9cG+NjDpF11vBV0LgaSM1kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Andi Shyti <andi.shyti@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/386] spi: s3c64xx: fix timeout counters in flush_fifo
Date: Tue,  8 Oct 2024 14:07:16 +0200
Message-ID: <20241008115636.925753463@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 68a16708d2503b6303d67abd43801e2ca40c208d ]

In the s3c64xx_flush_fifo() code, the loops counter is post-decremented
in the do { } while(test && loops--) condition. This means the loops is
left at the unsigned equivalent of -1 if the loop times out. The test
after will never pass as if tests for loops == 0.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Fixes: 230d42d422e7 ("spi: Add s3c64xx SPI Controller driver")
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20240924134009.116247-2-ben.dooks@codethink.co.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 652eadbefe24c..f699ce1b40253 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -239,7 +239,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 	loops = msecs_to_loops(1);
 	do {
 		val = readl(regs + S3C64XX_SPI_STATUS);
-	} while (TX_FIFO_LVL(val, sdd) && loops--);
+	} while (TX_FIFO_LVL(val, sdd) && --loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
@@ -252,7 +252,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 			readl(regs + S3C64XX_SPI_RX_DATA);
 		else
 			break;
-	} while (loops--);
+	} while (--loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
-- 
2.43.0



