Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B571E86C;
	Mon,  1 Apr 2024 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989574; cv=none; b=S5bDE3R4KcJ9m/ls3IqWa+R/NVhMQWbMpNbccAEACY1htSk2pwOIAREByCHMooxoSUN93i0GHXEVEB14nKLiFrTPJWbh5Vklzk/FdI3G4vNHl6CzKahYQiMRYJtfZ7xnZtU3pccZOJPrGGJTGu8/SjFHg/yy8EA1kU7XvK3vx7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989574; c=relaxed/simple;
	bh=OiHroSHK2Q+yytq06RWKY5G+gC4+q3386C6wntv0kWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F93tTllTRwg6lUruaQRTx9/Q2+ohz8iCF00rzy69emieqqpUDJNqfpsWlXjPbsP6H4VITJqQ9gNDPvKdCNNgAssAbLwaalClVdYgBRglJJZjRi5w3YOLzxzTojfKFDHl71E/jzpt7LuCFW8s6oqyOTfrqyZkWzJ+4Q17XhIUkLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3GuI8l5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3GuI8l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B64C433F1;
	Mon,  1 Apr 2024 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989574;
	bh=OiHroSHK2Q+yytq06RWKY5G+gC4+q3386C6wntv0kWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3GuI8l5RsHqwl1hG3UzPtuPjZxmx6nei6DcS5tGm3oQvVJ/sJI4+F31Lu1S32NPC
	 2rOFbR41pCsTNo8f4if3abNvEkq6iQSSajnFt0T4qKfAeZHZe2/TieM3vzHOU7LO/I
	 vQU66J6ZgQRubuCg1dqjCXJ84q8KSR2r15AKzdSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/396] iio: adc: rockchip_saradc: use mask for write_enable bitfield
Date: Mon,  1 Apr 2024 17:41:50 +0200
Message-ID: <20240401152549.743146314@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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



