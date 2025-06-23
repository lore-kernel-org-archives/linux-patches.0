Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20500218580;
	Mon, 23 Jun 2025 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716407; cv=none; b=M045NXdxzZZcNwm2OIslBHroLjGku9uxEV4cx329mjhYpPjah+VLnR43dDZN+Uvk4MNYXGtn7TRhO70C0y53ZCXVLvEmswlAxe/Qe2KIKtnZUPgE1GXTIkujz3DmVcMpkZ8+LmpZOc2IV2wnT4zEGtEQ2+XxSwqbz/8qDAwP76c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716407; c=relaxed/simple;
	bh=2BKWwUGQbEHHoT5f8/yih74R4izNgoQgraji8tzdm9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WpHxEu1gd2XYUBqVK0G6qDKOv9vW8/KFipnt3BtQmY35JdF6jeFsB9J+LvXgo31UlKk2rLzl+CIXK8A6BOjQ5Jn+7lO9LjfuMRuWst4vQDXH4pMO7QLXtZ0Rv+EgzBqDf/+0quYf6uHL2sGWFbwcNAaoiPKdcWVIeM3FxaqVfZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0fS8Wlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0fS8Wlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC755C4CEEA;
	Mon, 23 Jun 2025 22:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716407;
	bh=2BKWwUGQbEHHoT5f8/yih74R4izNgoQgraji8tzdm9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0fS8Wlr2yA6BaYWZoeHr7CV1uDkwC7PYkWFRDItVYQ6seYBep++n0nrNuMGVScYt
	 64+4rExzxmzR9ZINKUuJiXeyTkExrnmbjkUyB1yAE8JAAUKhpZ9isztXEEq4PMjHE0
	 dE4mYdFxW0r4ZFVqOY+wOD/NzwlXjvE1ggora6Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 521/592] hwmon: (ltc4282) avoid repeated register write
Date: Mon, 23 Jun 2025 15:07:59 +0200
Message-ID: <20250623130712.827720218@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit c25892b7a1744355e16281cd24a9b59ec15ec974 ]

The fault enabled bits were being mistankenly enabled twice in case the FW
property is present. Remove one of the writes.

Fixes: cbc29538dbf7 ("hwmon: Add driver for LTC4282")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20250611-fix-ltc4282-repetead-write-v1-1-fe46edd08cf1@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index 7f38d26962396..f607fe8f79370 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1511,13 +1511,6 @@ static int ltc4282_setup(struct ltc4282_state *st, struct device *dev)
 			return ret;
 	}
 
-	if (device_property_read_bool(dev, "adi,fault-log-enable")) {
-		ret = regmap_set_bits(st->map, LTC4282_ADC_CTRL,
-				      LTC4282_FAULT_LOG_EN_MASK);
-		if (ret)
-			return ret;
-	}
-
 	if (device_property_read_bool(dev, "adi,fault-log-enable")) {
 		ret = regmap_set_bits(st->map, LTC4282_ADC_CTRL, LTC4282_FAULT_LOG_EN_MASK);
 		if (ret)
-- 
2.39.5



