Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A416311D;
	Tue, 14 May 2024 11:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685964; cv=none; b=c2z7o0K/r8PoyZSpx0QM6OILCBGFTWbR0JXeGjl9OC/2qszlcRRInKkbs4K9IMywbtacvgZVFo/M0dCJctcfLVInNq324Zx2LRPmMAV3GmBFyYi1lnm71dtwKReMEyBs8l5PotYECQtoO4j0J+R7iFO63bHC+XoSiImAmkZ/RQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685964; c=relaxed/simple;
	bh=PdcfOHWMKkw3zMOBkfuRTCI+lBFENx3Zy75XZ4WBeOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJqZ5zf0Vv0vy0Cw1dnJfEN7Ur2bzeRQNwEzpgcsjQSnMoY9UMgoKRSCWvkNaLmtXdTNQwUj/XGy5sNVBRNVbLVZXwo6BerSB/QJW3J4GCBIBEP+yQQ35r9nZdCOf5eTzqPRvvQ314KmwRAuwMYGKBHoHd0fY3unRjFIff5v12o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyHYEPeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyHYEPeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF73C2BD10;
	Tue, 14 May 2024 11:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685964;
	bh=PdcfOHWMKkw3zMOBkfuRTCI+lBFENx3Zy75XZ4WBeOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyHYEPeQ7xllXPKNR63JoDZnb8cQ4n8JKvucTp2dszKsKHmR6+P2dydsw2fit0rhA
	 kfPMNdwLKcRaH/8oqO4n1Kuh3ZED5+7RaY5v7NGlPvGHb4DPGS42AuNtYZb2tw/7Zo
	 XahNzITBb/2XJBPM0NV6Dp1Qq1BPhjMCjIHJ+jJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 286/301] spi: microchip-core-qspi: fix setting spi bus clock rate
Date: Tue, 14 May 2024 12:19:17 +0200
Message-ID: <20240514101043.061072145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

commit ef13561d2b163ac0ae6befa53bca58a26dc3320b upstream.

Before ORing the new clock rate with the control register value read
from the hardware, the existing clock rate needs to be masked off as
otherwise the existing value will interfere with the new one.

CC: stable@vger.kernel.org
Fixes: 8596124c4c1b ("spi: microchip-core-qspi: Add support for microchip fpga qspi controllers")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240508-fox-unpiloted-b97e1535627b@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -283,6 +283,7 @@ static int mchp_coreqspi_setup_clock(str
 	}
 
 	control = readl_relaxed(qspi->regs + REG_CONTROL);
+	control &= ~CONTROL_CLKRATE_MASK;
 	control |= baud_rate_val << CONTROL_CLKRATE_SHIFT;
 	writel_relaxed(control, qspi->regs + REG_CONTROL);
 	control = readl_relaxed(qspi->regs + REG_CONTROL);


