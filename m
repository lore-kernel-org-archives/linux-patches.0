Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4006626FDB7;
	Tue, 27 May 2025 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368034; cv=none; b=EtzqgBHPk0bEx/gWRNq/HvHxXMxXjnPtChTNcIJkVyr7LIkhMOp3xjMftgPT4oLasIFzyeNDT5w3/UcJw4kbbZmRdKjQZ418p1/d2BtLpP3E1A3m6E3VSK1sA/6qcuQp/Ps7mJgOItM+28LqydKYV4zZ8uQCOXJ7ssVnQBXd4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368034; c=relaxed/simple;
	bh=3QXGoRPh5b6VzkEimMaOJaiWqN3d296UMl1n4a+J6IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcPYWw5Fu7mTG4oZEfAcAx2SA/+i60/gMr/5CVW7PzT58L0FYUmbNvF9qlV2d6QwPVFogaueJMxfbS15NxrjCUuyVOQPkePnHDlYhcGmv369/lCh+dCATbcEUFp3HcnU/CrT2QHbxix6x9nMj1J6MeQALyH1E7exhfVjFGaoj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzC2D8Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzC2D8Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6646C4CEE9;
	Tue, 27 May 2025 17:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368034;
	bh=3QXGoRPh5b6VzkEimMaOJaiWqN3d296UMl1n4a+J6IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzC2D8TvLBSOnX7O+gwv2Exo5ec8KFQ0HlP+Z6OuFgFU7H78y/c2QGhOv2O6714k5
	 DunzYdb+Zbt+ymTxmLdkTOqhibuWJTcc9xEjjrk2Jh/H+c3MZhNl+kjT43SBSHFp5m
	 vnUoP22VWAebp7sQBOpMt8UPhQ6bMJctAQ/XHR+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 547/783] iio: dac: ad3552r-hs: use instruction mode for configuration
Date: Tue, 27 May 2025 18:25:44 +0200
Message-ID: <20250527162535.433280621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit 21889245fb538123ac9968eea0018f878b44c8c8 ]

Use "instruction" mode over initial configuration and all other
non-streaming operations.

DAC boots in streaming mode as default, and the driver is not
changing this mode.

Instruction r/w is still working because instruction is processed
from the DAC after chip select is deasserted, this works until
loop mode is 0 or greater than the instruction size.

All initial operations should be more safely done in instruction
mode, a mode provided for this.

Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250114-wip-bl-ad3552r-axi-v0-iio-testing-carlos-v4-6-979402e33545@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad3552r-hs.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad3552r-hs.c b/drivers/iio/dac/ad3552r-hs.c
index 8974df6256708..67957fc21696a 100644
--- a/drivers/iio/dac/ad3552r-hs.c
+++ b/drivers/iio/dac/ad3552r-hs.c
@@ -137,13 +137,20 @@ static int ad3552r_hs_buffer_postenable(struct iio_dev *indio_dev)
 	if (ret)
 		return ret;
 
+	/* Primary region access, set streaming mode (now in SPI + SDR). */
+	ret = ad3552r_qspi_update_reg_bits(st,
+					   AD3552R_REG_ADDR_INTERFACE_CONFIG_B,
+					   AD3552R_MASK_SINGLE_INST, 0, 1);
+	if (ret)
+		return ret;
+
 	/* Inform DAC chip to switch into DDR mode */
 	ret = ad3552r_qspi_update_reg_bits(st,
 					   AD3552R_REG_ADDR_INTERFACE_CONFIG_D,
 					   AD3552R_MASK_SPI_CONFIG_DDR,
 					   AD3552R_MASK_SPI_CONFIG_DDR, 1);
 	if (ret)
-		return ret;
+		goto exit_err_ddr;
 
 	/* Inform DAC IP to go for DDR mode from now on */
 	ret = iio_backend_ddr_enable(st->back);
@@ -174,6 +181,11 @@ static int ad3552r_hs_buffer_postenable(struct iio_dev *indio_dev)
 
 	iio_backend_ddr_disable(st->back);
 
+exit_err_ddr:
+	ad3552r_qspi_update_reg_bits(st, AD3552R_REG_ADDR_INTERFACE_CONFIG_B,
+				     AD3552R_MASK_SINGLE_INST,
+				     AD3552R_MASK_SINGLE_INST, 1);
+
 	return ret;
 }
 
@@ -198,6 +210,14 @@ static int ad3552r_hs_buffer_predisable(struct iio_dev *indio_dev)
 	if (ret)
 		return ret;
 
+	/* Back to single instruction mode, disabling loop. */
+	ret = ad3552r_qspi_update_reg_bits(st,
+					   AD3552R_REG_ADDR_INTERFACE_CONFIG_B,
+					   AD3552R_MASK_SINGLE_INST,
+					   AD3552R_MASK_SINGLE_INST, 1);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -308,6 +328,13 @@ static int ad3552r_hs_setup(struct ad3552r_hs_state *st)
 	if (ret)
 		return ret;
 
+	ret = st->data->bus_reg_write(st->back,
+				      AD3552R_REG_ADDR_INTERFACE_CONFIG_B,
+				      AD3552R_MASK_SINGLE_INST |
+				      AD3552R_MASK_SHORT_INSTRUCTION, 1);
+	if (ret)
+		return ret;
+
 	ret = ad3552r_hs_scratch_pad_test(st);
 	if (ret)
 		return ret;
-- 
2.39.5



