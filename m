Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461541E0B84;
	Wed,  6 Nov 2024 13:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898539; cv=none; b=gPBX9d6yIdo3UEQcdCYW5rXyCxQqoZJ6JT8XxwPTQzdIoDslK0oPcHDka5mJdaF8zGUmIAAGVa/i5IuNWP1ZwsfiVnaWGuVycsnMsWsaCnUPr0Gauj8ENbevYBJUn7EvVkhJOkqd9JSC38VDNnKMcvGGr0DTnu0XcSUVDPhPKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898539; c=relaxed/simple;
	bh=kipuqxhVe2lwQ+jlsPlLRUSXszzXXydufFsXfNtLi2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWe16yZeft2kzp7lfXBXobfC8FWUSZ9X2L61gK13OSRl2t3XxSejrM8oqV3WXHdFGVys8fEQqz+YDEWAZ4O0JgB9/BxdSTSmlHswtkDZPteaayHQ98bCe0NGrQRVJ+8DLfVoPXHo1BXi4lIyE8H2Tr62vohuwF7Hh+04ops7OJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYR+xGPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYR+xGPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC858C4CED3;
	Wed,  6 Nov 2024 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898539;
	bh=kipuqxhVe2lwQ+jlsPlLRUSXszzXXydufFsXfNtLi2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYR+xGPhchnM9ZlH1cDdpJVowe6kQciPGuUm8sW1dm3u9Vhv0WV23Pjt/se0T+/Hj
	 mgm1FPAOOeE8ZyZcB7r9KSS9x8TXtKM1qBi4BnlZMC0OOd0JBn09fnzvc38qqk23Sz
	 q9c/DWhjsxhSf4DdULJH3uV9v5DeebMXqQ+zjCU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Andi Shyti <andi.shyti@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/462] spi: s3c64xx: fix timeout counters in flush_fifo
Date: Wed,  6 Nov 2024 13:02:08 +0100
Message-ID: <20241106120337.328103772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d9420561236c2..108a087a2777c 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -211,7 +211,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 	loops = msecs_to_loops(1);
 	do {
 		val = readl(regs + S3C64XX_SPI_STATUS);
-	} while (TX_FIFO_LVL(val, sdd) && loops--);
+	} while (TX_FIFO_LVL(val, sdd) && --loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
@@ -224,7 +224,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 			readl(regs + S3C64XX_SPI_RX_DATA);
 		else
 			break;
-	} while (loops--);
+	} while (--loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
-- 
2.43.0



