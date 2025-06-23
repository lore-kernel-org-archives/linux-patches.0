Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE311253F08;
	Mon, 23 Jun 2025 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685652; cv=none; b=bCpQnY3NfbeyooPArT+qRe6lVOhjm339HcbDXdbZGJrh+/sAEsMqKBut4pyZ74xCypf8GPBdybh8VdtD/C/WEKzSd9Qt00sGe6/MkfTQSZ2NxrBLXlB16CWBDJX0XeOivF9RxOqZ4C1lc/iWR79ZKOdiXWRCzr7gsSTRFFTFyVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685652; c=relaxed/simple;
	bh=VE33V5B1LNjgFEHT2drbtH387GO/VNDWw0HBht60/wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhB/rzbjpSheEkxjFwOOfClx4fZXVTSJBPCCsOMJca0XYtEtV0+JaeS+jKOyFEdUf+gwj4raKVYMjUBbDkq+KKHVcW13rd5q4CB/8pUAtHbdCxUQweR7ziT4OqmcnQzaxtdopKzctAJ2emOJQ9cOzm/WaQGp3ePad8wE7hgozKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1f75labO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1f75labO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72930C4CEEA;
	Mon, 23 Jun 2025 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685651;
	bh=VE33V5B1LNjgFEHT2drbtH387GO/VNDWw0HBht60/wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1f75labOjprWabV82/dL+lYLSD+Lj0NurHKAZJbXd+kRxmrS4bCPli0JjZOZzrKlc
	 ovtlFdLBDeh8Np8GEWaw/BlCsQHu1W33nnbel03Qc75q86R8FvSlDayYxqhDt79Uow
	 uR2Wt/dFkj43Ldz8gAVO1P77iOYuAT6QEyK+0kfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayushi Makhija <quic_amakhija@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 250/592] drm/bridge: anx7625: change the gpiod_set_value API
Date: Mon, 23 Jun 2025 15:03:28 +0200
Message-ID: <20250623130706.242542553@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayushi Makhija <quic_amakhija@quicinc.com>

[ Upstream commit 50935044e58e563cdcfd556d62f27bc8744dd64e ]

Use gpiod_set_value_cansleep() instead of gpiod_set_value()
to fix the below call trace in the boot log:

[    5.690534] Call trace:
[    5.690536]  gpiod_set_value+0x40/0xa4
[    5.690540]  anx7625_runtime_pm_resume+0xa0/0x324 [anx7625]
[    5.690545]  __rpm_callback+0x48/0x1d8
[    5.690549]  rpm_callback+0x6c/0x78

Certain GPIO controllers require access via message-based buses
such as I2C or SPI, which may cause the GPIOs to enter a sleep
state. Therefore, use the gpiod_set_value_cansleep().

Signed-off-by: Ayushi Makhija <quic_amakhija@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250505094245.2660750-7-quic_amakhija@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 99ef3f27ae429..95d5a4e265788 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1257,10 +1257,10 @@ static void anx7625_power_on(struct anx7625_data *ctx)
 	usleep_range(11000, 12000);
 
 	/* Power on pin enable */
-	gpiod_set_value(ctx->pdata.gpio_p_on, 1);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_p_on, 1);
 	usleep_range(10000, 11000);
 	/* Power reset pin enable */
-	gpiod_set_value(ctx->pdata.gpio_reset, 1);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_reset, 1);
 	usleep_range(10000, 11000);
 
 	DRM_DEV_DEBUG_DRIVER(dev, "power on !\n");
@@ -1280,9 +1280,9 @@ static void anx7625_power_standby(struct anx7625_data *ctx)
 		return;
 	}
 
-	gpiod_set_value(ctx->pdata.gpio_reset, 0);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_reset, 0);
 	usleep_range(1000, 1100);
-	gpiod_set_value(ctx->pdata.gpio_p_on, 0);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_p_on, 0);
 	usleep_range(1000, 1100);
 
 	ret = regulator_bulk_disable(ARRAY_SIZE(ctx->pdata.supplies),
-- 
2.39.5



