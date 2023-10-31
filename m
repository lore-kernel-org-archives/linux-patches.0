Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DF0208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFnBrEsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502ECC433C7;
	Tue, 31 Oct 2023 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774556;
	bh=WxiGTgOZgWNes9L2T+ramggoe/TdJjxhE4gPIMOFglk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFnBrEsTicwwL+EedXC9O2T70fqj07DFjFL5fq5DN9upC6iuulYXeCJxurNlZ68ei
	 kZA8p/gH/q4tw9ONZg1xyJ7int88pTRy64xYq3N0rFIcv5QEnojXOUild4YMbYA4hS
	 xUXvWkssVprW5oR0AxDjM4A8sqAB4/fQ7Ygx9ix4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	O'Griofa
Subject: [PATCH 6.5 086/112] iio: adc: xilinx-xadc: Dont clobber preset voltage/temperature thresholds
Date: Tue, 31 Oct 2023 18:01:27 +0100
Message-ID: <20231031165904.021874719@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

commit 8d6b3ea4d9eaca80982442b68a292ce50ce0a135 upstream.

In the probe function, the driver was reading out the thresholds already
set in the core, which can be configured by the user in the Vivado tools
when the FPGA image is built. However, it later clobbered those values
with zero or maximum values. In particular, the overtemperature shutdown
threshold register was overwritten with the max value, which effectively
prevents the FPGA from shutting down when the desired threshold was
eached, potentially risking hardware damage in that case.

Remove this code to leave the preconfigured default threshold values
intact.

The code was also disabling all alarms regardless of what enable state
they were left in by the FPGA image, including the overtemperature
shutdown feature. Leave these bits in their original state so they are
not unconditionally disabled.

Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Tested-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Link: https://lore.kernel.org/r/20230915001019.2862964-2-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-xadc-core.c |   22 ----------------------
 1 file changed, 22 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1423,28 +1423,6 @@ static int xadc_probe(struct platform_de
 	if (ret)
 		return ret;
 
-	/* Disable all alarms */
-	ret = xadc_update_adc_reg(xadc, XADC_REG_CONF1, XADC_CONF1_ALARM_MASK,
-				  XADC_CONF1_ALARM_MASK);
-	if (ret)
-		return ret;
-
-	/* Set thresholds to min/max */
-	for (i = 0; i < 16; i++) {
-		/*
-		 * Set max voltage threshold and both temperature thresholds to
-		 * 0xffff, min voltage threshold to 0.
-		 */
-		if (i % 8 < 4 || i == 7)
-			xadc->threshold[i] = 0xffff;
-		else
-			xadc->threshold[i] = 0;
-		ret = xadc_write_adc_reg(xadc, XADC_REG_THRESHOLD(i),
-			xadc->threshold[i]);
-		if (ret)
-			return ret;
-	}
-
 	/* Go to non-buffered mode */
 	xadc_postdisable(indio_dev);
 


