Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BEF612D7;
	Tue, 20 Feb 2024 21:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463608; cv=none; b=U+XDbvoMVL6RK9dfmpT0CHD9hCoeOZlR/Dn3xNVHR/Kg+/YVCxAAGQKc+ewbLnpYpN4InzuSGJRrU/gNf6aJIz3GMSwE1Hb76OPLALsrW9RopiBJb9WqjfY8uvHdWCZjs0ACvxGmYi6Rh/+PnxIj98vkx7Yjsx8kpzyk77IjqCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463608; c=relaxed/simple;
	bh=LciKp2nG74cPOEGO8ncdx5MYTudj61arCixLoV4H10g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMbpNbv51LHCVklAAwsVvVx5Ddv76BC5pCBb8RQb4RNeieAtm0d6QcQPHPVK+FPlyUmrqxT1WdifsUvXMvEyoFgLbTLKyM2SHGzWfkQSnbu1OZbvQTqKF69dERiyKX7BRfPv2dalysN6evere5rBpURvYV7W/to7V5aPQ4R9C6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5asLVdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5asLVdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E623C433F1;
	Tue, 20 Feb 2024 21:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463608;
	bh=LciKp2nG74cPOEGO8ncdx5MYTudj61arCixLoV4H10g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5asLVdk/oz+BhHgFYcp5YHSmMKrnVz8m2KEF/j5AyVNIH0qZU150UVM+bgR1thw0
	 2iTE987ExVWrpB50O5psaQg/tB/IZzxvCu+He560EM1k4/8x3k+qiD5pwoaxAgOglo
	 nJd2mrm1JwsLzg6pJNyW4UaKgOgD9LpZmi1AJckg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Viken Dadhaniya <quic_vdadhani@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/331] i2c: qcom-geni: Correct I2C TRE sequence
Date: Tue, 20 Feb 2024 21:53:33 +0100
Message-ID: <20240220205640.622612020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Viken Dadhaniya <quic_vdadhani@quicinc.com>

[ Upstream commit 83ef106fa732aea8558253641cd98e8a895604d7 ]

For i2c read operation in GSI mode, we are getting timeout
due to malformed TRE basically incorrect TRE sequence
in gpi(drivers/dma/qcom/gpi.c) driver.

I2C driver has geni_i2c_gpi(I2C_WRITE) function which generates GO TRE and
geni_i2c_gpi(I2C_READ)generates DMA TRE. Hence to generate GO TRE before
DMA TRE, we should move geni_i2c_gpi(I2C_WRITE) before
geni_i2c_gpi(I2C_READ) inside the I2C GSI mode transfer function
i.e. geni_i2c_gpi_xfer().

TRE stands for Transfer Ring Element - which is basically an element with
size of 4 words. It contains all information like slave address,
clk divider, dma address value data size etc).

Mainly we have 3 TREs(Config, GO and DMA tre).
- CONFIG TRE : consists of internal register configuration which is
               required before start of the transfer.
- DMA TRE :    contains DDR/Memory address, called as DMA descriptor.
- GO TRE :     contains Transfer directions, slave ID, Delay flags, Length
               of the transfer.

I2c driver calls GPI driver API to config each TRE depending on the
protocol.

For read operation tre sequence will be as below which is not aligned
to hardware programming guide.

- CONFIG tre
- DMA tre
- GO tre

As per Qualcomm's internal Hardware Programming Guide, we should configure
TREs in below sequence for any RX only transfer.

- CONFIG tre
- GO tre
- DMA tre

Fixes: d8703554f4de ("i2c: qcom-geni: Add support for GPI DMA")
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # qrb5165-rb5
Co-developed-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Signed-off-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Signed-off-by: Viken Dadhaniya <quic_vdadhani@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 0a9d389df301..5cc32a465f12 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -613,20 +613,20 @@ static int geni_i2c_gpi_xfer(struct geni_i2c_dev *gi2c, struct i2c_msg msgs[], i
 
 		peripheral.addr = msgs[i].addr;
 
+		ret =  geni_i2c_gpi(gi2c, &msgs[i], &config,
+				    &tx_addr, &tx_buf, I2C_WRITE, gi2c->tx_c);
+		if (ret)
+			goto err;
+
 		if (msgs[i].flags & I2C_M_RD) {
 			ret =  geni_i2c_gpi(gi2c, &msgs[i], &config,
 					    &rx_addr, &rx_buf, I2C_READ, gi2c->rx_c);
 			if (ret)
 				goto err;
-		}
-
-		ret =  geni_i2c_gpi(gi2c, &msgs[i], &config,
-				    &tx_addr, &tx_buf, I2C_WRITE, gi2c->tx_c);
-		if (ret)
-			goto err;
 
-		if (msgs[i].flags & I2C_M_RD)
 			dma_async_issue_pending(gi2c->rx_c);
+		}
+
 		dma_async_issue_pending(gi2c->tx_c);
 
 		timeout = wait_for_completion_timeout(&gi2c->done, XFER_TIMEOUT);
-- 
2.43.0



