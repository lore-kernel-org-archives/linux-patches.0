Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE11B1DEFC8;
	Tue,  8 Oct 2024 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392109; cv=none; b=SkCGEXiOmkiUoTtxVq+vziJfKCAXmDNGCdn3BiVMGgwW+zvYf+l9yKBhELyyn7mae2h6R9/8Bc5SCDr3oGdpeaH+2Ilsb2rfIPc/+qisuW31J1aWruB4WbrNB9MoU67ebmiO8To8O2JW775EAVDrXTtjcGin42EM7/23wLvmc10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392109; c=relaxed/simple;
	bh=uuzNveNYoyjEEAXMOeik+jjPgdcJlp0eqUEltQxUfXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvcKVlWLp+N9rZvJEg/hdnJ+k2KuhZuf+dG2dfUnt0+kP7YgZnwa4CWv9Wy5NVn7okNec25M6vOS3LwzFOa/cqXxIPv0Xttit84fKB9ryHBWBlcSibOB/UmXMJNC171YIGVTsC4EMt7+YzvOesAAsB55ceFA2TdmIV7MMNIQSmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEqZnnun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEqZnnun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A78C4CECE;
	Tue,  8 Oct 2024 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392109;
	bh=uuzNveNYoyjEEAXMOeik+jjPgdcJlp0eqUEltQxUfXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEqZnnun3fe+kfBZXOlD4vsfA9/e/8UnWD5ZqixB80XBFBxIOnFwxD+NtmJCxie5e
	 7Cdp+zlkXqgtdunildVLXdciOxcOSvr3pg6TcgWzZdztJNQeanOnh+MWrWf9MPDqeP
	 TPukCjys8W3qmGhycCysvMMKjWMG5iQWJaoXyqiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Andi Shyti <andi.shyti@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 319/558] spi: s3c64xx: fix timeout counters in flush_fifo
Date: Tue,  8 Oct 2024 14:05:49 +0200
Message-ID: <20241008115714.861280272@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 833c58c88e408..6ab416a339669 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -245,7 +245,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 	loops = msecs_to_loops(1);
 	do {
 		val = readl(regs + S3C64XX_SPI_STATUS);
-	} while (TX_FIFO_LVL(val, sdd) && loops--);
+	} while (TX_FIFO_LVL(val, sdd) && --loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing TX FIFO\n");
@@ -258,7 +258,7 @@ static void s3c64xx_flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 			readl(regs + S3C64XX_SPI_RX_DATA);
 		else
 			break;
-	} while (loops--);
+	} while (--loops);
 
 	if (loops == 0)
 		dev_warn(&sdd->pdev->dev, "Timed out flushing RX FIFO\n");
-- 
2.43.0



