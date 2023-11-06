Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF62208C0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPynPOIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0581C433C7;
	Mon,  6 Nov 2023 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277501;
	bh=BXzyk2069wlZfWUZlBnEaz+jfidzL5ON1R0A0IYwRHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPynPOIzYTv2B+pkAeOBp1wC6ggE5+fmlczK9nNrhcaBFD9NeNq4zym6pCOZjJGKv
	 KX57Jh59siXCavvc4Lp2lp4aIXEDmrGitdzZ+zVRKN/XagUkjh0opC/42JLEios5G8
	 XyJ90eTysFuT044OTMR1hcrQ4giWYJHQLR7EYZv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	O'Griofa
Subject: [PATCH 5.10 43/95] iio: adc: xilinx-xadc: Dont clobber preset voltage/temperature thresholds
Date: Mon,  6 Nov 2023 14:04:11 +0100
Message-ID: <20231106130306.275999971@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 8d6b3ea4d9eaca80982442b68a292ce50ce0a135 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-xadc-core.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index fec266682e91d..30b5a17ce41a7 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1334,28 +1334,6 @@ static int xadc_probe(struct platform_device *pdev)
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
 
-- 
2.42.0



