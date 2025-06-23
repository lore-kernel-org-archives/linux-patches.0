Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50193FD4;
	Mon, 23 Jun 2025 21:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715237; cv=none; b=tm4BgUstdoycVi8370i+KNaRFN+XoyPkP5pSxukL0xhObTa3IDGO2PypKoODAsKsDwdsCLVXkE7Zxw2k9jV1etF19saqpR4O+jMZ8EtsX5b0FD7PciQy9OIh+i26J8fYBfQQfpgJ2+jKWt782/WosSw5esstX2rD6h+2QSX4oQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715237; c=relaxed/simple;
	bh=OtwCxS6nlQihKOc2bwJvHcIe0j5toYJGs+eqUq8lIrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyDU370tD+e80t7tDSEOno9H8GbqMl+OM9VK7Jvxelt36/fqJX+rj+JWB+vaBEBXEL3VdA8wexXO31BTafUiMSV3dpLxz+nPATqgtO/B/tReq/MuJLnZbli8RlR70TOx4PKfy6Msvlz3oGUWwC1Trs7+99u3pOYtE1ZtaIwjRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ta/54W+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ta/54W+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB85C4CEEA;
	Mon, 23 Jun 2025 21:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715237;
	bh=OtwCxS6nlQihKOc2bwJvHcIe0j5toYJGs+eqUq8lIrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ta/54W+zX1zTLLTz7Hf//zayIB2Mug7DwRSR8E54WYXvs0RDnuQ39X8iv5uVb98w3
	 7xukaf5bMqfXJLx5mmg6aTi8UxWJ6hV7Iwq5yAy9cKmGc5o315kja36Qf0AY/HkJq9
	 JO6fujqG3xI9hnLWdi4jeHL814Uf+Iw62gjI7TxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/414] power: supply: collie: Fix wakeup source leaks on device unbind
Date: Mon, 23 Jun 2025 15:05:07 +0200
Message-ID: <20250623130646.279181751@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c73d19f89cb03c43abbbfa3b9caa1b8fc719764c ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406202730.55096-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/collie_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/collie_battery.c b/drivers/power/supply/collie_battery.c
index 68390bd1004f0..3daf7befc0bf6 100644
--- a/drivers/power/supply/collie_battery.c
+++ b/drivers/power/supply/collie_battery.c
@@ -440,6 +440,7 @@ static int collie_bat_probe(struct ucb1x00_dev *dev)
 
 static void collie_bat_remove(struct ucb1x00_dev *dev)
 {
+	device_init_wakeup(&ucb->dev, 0);
 	free_irq(gpiod_to_irq(collie_bat_main.gpio_full), &collie_bat_main);
 	power_supply_unregister(collie_bat_bu.psy);
 	power_supply_unregister(collie_bat_main.psy);
-- 
2.39.5



