Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC91446AC;
	Mon,  1 Apr 2024 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988033; cv=none; b=SfkQGcvQ9VNofNVDBQOHb/5C/6WSPmMx3P/mcaIeGkOqdGkkLdGpq6fKnBeUUMcoijVc5UFULKCNbgvs7BsoEKgKwR8erMPEU3LWJTt3TEDO9DLn/x8adi9ghurJVuLEvmY9W6R5qqKglDkCGcmD57K5XQ8VcsHKzA5N2gB/S+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988033; c=relaxed/simple;
	bh=Si3i7JOhXV04+r7PFgUqzwsBDpmyNMoy04HlPIpGYxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEEjAhGMjq61C+ukMKCtv6QtYCfHV0/LuF41NU4MZC1G2HDSDXH28FNzVIByFo/VH+aCJY+Wsft70teI2PntARKYQ6gZAO+PI3avPh8oV9mQM3Wt3I0m2Cft2m58XmVOWmeH5JZdM8bISVmCRfPq6E6P0S311iKVhvuWwxZjVk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki74gOaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki74gOaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2EBC433F1;
	Mon,  1 Apr 2024 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988033;
	bh=Si3i7JOhXV04+r7PFgUqzwsBDpmyNMoy04HlPIpGYxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki74gOaLY1QKnazvo2sZ4xCp9fU+u32r2libZ1azytGsJWX/Ie5bHWBgeBOa9+y49
	 AopVvK88wwqSC/iY1NPfH8/LFe5Lb4tLgBNjVEVNvcZ1G03yiXnSEbIRL2IgU6FCt6
	 D5L9cukB8X906bRVCJh4gaJ44TSfK2teGpnssINA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 064/432] iio: adc: rockchip_saradc: use mask for write_enable bitfield
Date: Mon,  1 Apr 2024 17:40:51 +0200
Message-ID: <20240401152555.034424983@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit 5b4e4b72034f85f7a0cdd147d3d729c5a22c8764 ]

Some of the registers on the SARADCv2 have bits write protected except
if another bit is set. This is usually done by having the lowest 16 bits
store the data to write and the highest 16 bits specify which of the 16
lowest bits should have their value written to the hardware block.

The write_enable mask for the channel selection was incorrect because it
was just the value shifted by 16 bits, which means it would only ever
write bits and never clear them. So e.g. if someone starts a conversion
on channel 5, the lowest 4 bits would be 0x5, then starts a conversion
on channel 0, it would still be 5.

Instead of shifting the value by 16 as the mask, let's use the OR'ing of
the appropriate masks shifted by 16.

Note that this is not an issue currently because the only SARADCv2
currently supported has a reset defined in its Device Tree, that reset
resets the SARADC controller before starting a conversion on a channel.
However, this reset is handled as optional by the probe function and
thus proper masking should be used in the event an SARADCv2 without a
reset ever makes it upstream.

Fixes: 757953f8ec69 ("iio: adc: rockchip_saradc: Add support for RK3588")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20240223-saradcv2-chan-mask-v1-2-84b06a0f623a@theobroma-systems.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/rockchip_saradc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
index 2da8d6f3241a1..1c0042fbbb548 100644
--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -102,12 +102,12 @@ static void rockchip_saradc_start_v2(struct rockchip_saradc *info, int chn)
 	writel_relaxed(0xc, info->regs + SARADC_T_DAS_SOC);
 	writel_relaxed(0x20, info->regs + SARADC_T_PD_SOC);
 	val = FIELD_PREP(SARADC2_EN_END_INT, 1);
-	val |= val << 16;
+	val |= SARADC2_EN_END_INT << 16;
 	writel_relaxed(val, info->regs + SARADC2_END_INT_EN);
 	val = FIELD_PREP(SARADC2_START, 1) |
 	      FIELD_PREP(SARADC2_SINGLE_MODE, 1) |
 	      FIELD_PREP(SARADC2_CONV_CHANNELS, chn);
-	val |= val << 16;
+	val |= (SARADC2_START | SARADC2_SINGLE_MODE | SARADC2_CONV_CHANNELS) << 16;
 	writel(val, info->regs + SARADC2_CONV_CON);
 }
 
-- 
2.43.0



