Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363AF1C7274;
	Tue, 15 Oct 2024 12:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993674; cv=none; b=fvDpMfKZ6vjB+hM18cJKMaNppXs6sQ23VzZ20ou6pyjhGIr+AewIaW8gYabLrpfNJJ50e/cxxAxRxs2xHjKTMN6uTsTsQzjkO0Nw6hbYqN8U6wZ6d8H7OSJO4GM8HAwY0sWasoyVReasGmQMGvi1REphrgoNkF6EX+NIXD80YwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993674; c=relaxed/simple;
	bh=3hwgLBpwCz2Ze/9lyu4IiI1EWInU/Zf/gkvt7oE+IIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEESrZa4iYRK/d7PEjp2Xk0ddf9o8x8P6HCRaKXgp6uXR7zI870Y47MI5eXnkJwmqxjy6yntY2ChyhtqQFe+BMXEc+JTK10dsScJdylf5rKjxROHPKJ6fWA7c5cIomwsw8onLVU2DlfwuMUSrPn87EpVCopgN38qnKZ8ZRV9SgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFckj6kT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFckj6kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915D7C4CEC6;
	Tue, 15 Oct 2024 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993674;
	bh=3hwgLBpwCz2Ze/9lyu4IiI1EWInU/Zf/gkvt7oE+IIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFckj6kT4BRDM3hVkDbNi2L2311SM6fTdQtVgEljbW0EuUzvd5iQFslDXBckrr2Gb
	 7YhpQKW2KpU+M+GO48WeoqQbfSPxKwrvHC9lXBLdpSAnOozJml+EKdAwwYrjyHAF+D
	 I7uw4gvoBXKy1laQLCYz6YL3iJ5C/90CkJTf7FWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Andi Shyti <andi.shyti@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/691] spi: s3c64xx: fix timeout counters in flush_fifo
Date: Tue, 15 Oct 2024 13:27:08 +0200
Message-ID: <20241015112459.391748501@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 90c70d53e85e2..246a40b492757 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -216,7 +216,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 	loops = msecs_to_loops(1);
 	do {
 		val = readl(regs + S3C64XX_SPI_STATUS);
-	} while (TX_FIFO_LVL(val, sdd) && loops--);
+	} while (TX_FIFO_LVL(val, sdd) && --loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
@@ -229,7 +229,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 			readl(regs + S3C64XX_SPI_RX_DATA);
 		else
 			break;
-	} while (loops--);
+	} while (--loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
-- 
2.43.0



