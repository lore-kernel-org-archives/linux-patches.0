Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569D2EE286;
	Thu,  3 Jul 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555955; cv=none; b=fvk8UzchTgJwSG0RYuUXld54YRlY4V7NlXMpsmTx8mcxp758n8+3QiQyLYnWs4e1Q4HtNPuu+B3wkR6PDsuM/FawaEm/dsAppkIFped6O0iii3TPdcyu8Lt0gA5AE6U+o+Q0ySTjY1ns7plN+JaGHbcBMidFpaxgOyVeeGNyxfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555955; c=relaxed/simple;
	bh=ts9LY2EZe23ERyTbUiltZQHvt1DtBrVI7fPvNV23yMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNJrSeUO2IalYj2xTWXJU9JjB3G1MQDTi1HcPdUyX5k+QF6yXWJmKTwhF+9zTM6TKMW1iE0zdqXVFTO+6KytpxjWe2IH9LucMX8jf1oHUZF7iMC0Hlno3lSXA9yyfpfWoMCX9WqL5Mkh268uMpT6xOkBhr4jopyvWBZUnOvPiNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZAS6VLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZAS6VLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC098C4CEEE;
	Thu,  3 Jul 2025 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555955;
	bh=ts9LY2EZe23ERyTbUiltZQHvt1DtBrVI7fPvNV23yMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZAS6VLIq/Qz8H69ma2XV3gEGzN0+wrPqDQV81epsC3Yj/oPuOSFYGvMf5FHfn/bJ
	 padQ/Khx2TPEnJd3MGhiFh7RekAljqEE988rYO4J8M+SVhMfkk+H/gZzy7HeqBLWOj
	 tYU+qZbEGf7m1DEUralOnjbWuXsyaXC1Wwcn0+L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/132] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:41:35 +0200
Message-ID: <20250703143939.634906027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d905d06e64b0eb3da43af6186c132f5282197998 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-3-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max14577.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index d44ad6f337425..61a5ccafa18e0 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -467,6 +467,7 @@ static void max14577_i2c_remove(struct i2c_client *i2c)
 {
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
+	device_init_wakeup(max14577->dev, false);
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
-- 
2.39.5



