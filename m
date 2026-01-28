Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092973033F4;
	Wed, 28 Jan 2026 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615682; cv=none; b=CpeeFu646oniwsvZgXS9Gqm0/L1JZPjdbalKAh4No3uiHX5vLSTzEisJVWupzztl1iZvN99RMN2yH2fTKqMDdwvyJetcnhYWznsdsMjRBbgJYrxQLYzrBBE4pVxZqyTLcVLGXPGQJ+wAxdNfIsdrTQpfS0yqnX6Sec2Fa+LwOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615682; c=relaxed/simple;
	bh=C8K3LrlWfrtqKvkD144qdJ/+O0gyk1Qs/C2xJY3npiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlDS4m7e7ObT2C++ZNhaMrRXvQhm80KzcR17l+EpxjWeDBBTFXOoyrry3s9EBXHESto4cO3XvrcWZJiG395nzCDTdh2+Bffn8k4fwWucg2pSjrrIvEQbGGZGsudLbGazM8sm9bN1Mo6EesGYgioLGCczc53eA2ICSFz1YbIQw2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3MDl79n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3MDl79n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3DCC4CEF1;
	Wed, 28 Jan 2026 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615681;
	bh=C8K3LrlWfrtqKvkD144qdJ/+O0gyk1Qs/C2xJY3npiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3MDl79nsnmZnK/b0ePjTnbQ6uVl0T4tQHyQa4zUpzrvPL3N7FDblsT2dXvTCsj+B
	 JVEKTvknQ3Htvuga7ARGzq5esI+2aXg73KwV03uETcw+L3DkUGcngdWIMIgHf6c9uj
	 86cmrbFupcJnbNMNavvhZd8LXYES0jHqgx2s6kCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/227] iio: adc: ad7280a: handle spi_setup() errors in probe()
Date: Wed, 28 Jan 2026 16:22:07 +0100
Message-ID: <20260128145347.293258379@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit 6b39824ac4c15783787e6434449772bfb2e31214 ]

The probe() function ignored the return value of spi_setup(), leaving SPI
configuration failures undetected. If spi_setup() fails, the driver should
stop initialization and propagate the error to the caller.

Add proper error handling: check the return value of spi_setup() and return
it on failure.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2051f25d2a26 ("iio: adc: New driver for AD7280A Lithium Ion Battery Monitoring System")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7280a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7280a.c b/drivers/iio/adc/ad7280a.c
index 50a6ff7c8b1c7..ba12a3796e2b1 100644
--- a/drivers/iio/adc/ad7280a.c
+++ b/drivers/iio/adc/ad7280a.c
@@ -1024,7 +1024,9 @@ static int ad7280_probe(struct spi_device *spi)
 
 	st->spi->max_speed_hz = AD7280A_MAX_SPI_CLK_HZ;
 	st->spi->mode = SPI_MODE_1;
-	spi_setup(st->spi);
+	ret = spi_setup(st->spi);
+	if (ret < 0)
+		return ret;
 
 	st->ctrl_lb = FIELD_PREP(AD7280A_CTRL_LB_ACQ_TIME_MSK, st->acquisition_time) |
 		FIELD_PREP(AD7280A_CTRL_LB_THERMISTOR_MSK, st->thermistor_term_en);
-- 
2.51.0



