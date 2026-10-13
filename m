Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8837D1DE8AE;
	Tue, 13 Oct 2026 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895609; cv=none; b=KYah5Jo2xhAXtcM57THIqDoZnNp8aaBUKIxUW+NgIqPNy8MwISWelB5ZPLoTJ4hLwxUSrLEtwnLZnmmf3iIWrbOKGC8VdAEpCXuziaDm/JyuxUZ2u0DkwxQ2qFFDy89jQfoAQx/gCYjxiSM4oPS+6crNV9pqQglVZlsfTpuIIv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895609; c=relaxed/simple;
	bh=BXrl0kr52ZWtxxij2dPisNeRdQjE5fSJr4qSTavZqvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6SU7n+uprAkXHNAt9Uj/tCoZxg+JdYpUkeigr3i8hObhDjQuW1igCwJFRfMrOwWqEtSzzjxv8Qj7RWUUfYGs8zLrrIJFiHPPPXvVF1WK8+PPRhkG+t7qOw7qwmZGkCx4MAW4IJZG6vUGSTUMB0iVrCczafftNxKbuUAIfDU7aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYiLELuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYiLELuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EF81F000FF;
	Tue, 13 Oct 2026 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895608;
	bh=3FANWSEzXJQtjpCJiu2S4xwyBzC387qAWdPFvQ4NquU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYiLELuojm0ZL2HiPknTcf3j4veMn8faiIjXokDWie9xSwPe169vZVbPpP1FRvz8u
	 /sIoXI9SBcPxpPGQ16Y9A27f4ZSBBSJclhA4Tujr9BvAzwMPXocSXzcd+VKkV+GVWV
	 VQp9op7pfT3JIXXtvjHe2tLwLJ47QIg5FG3/OyRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/497] iio: adc: axp288: Add TS bias override for Haier HV103H
Date: Tue, 13 Oct 2026 13:38:20 +0200
Message-ID: <20261013112915.808591781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>

[ Upstream commit 0f300db7b7315b2c7ea0e2d4437b88de162d191f ]

The Haier HV103H firmware configures the AXP288 TS pin bias
current to 60 uA. This causes the battery temperature reading to
cross the charging temperature threshold under load, incorrectly
stopping battery charging.

Setting the TS bias current to 80 uA fixes the temperature
measurement and prevents charging from being incorrectly disabled.

Add a DMI quirk to use the 80 uA TS bias current on the Haier
HV103H.

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
Fixes: 048058399f19 ("iio: adc: axp288: Override TS pin bias current for some models") # Add necessary infrastructure
Signed-off-by: Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Adjusted context to preserve the existing `{}` DMI table terminator instead of `{ }`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/axp288_adc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 8c3acc0cd7e99..9cfe2e8c8484a 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -207,6 +207,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Haier HV103H */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "Haier"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "HV103H"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{}
 };
 
-- 
2.53.0



