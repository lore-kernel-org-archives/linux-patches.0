Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB12F248869;
	Mon, 23 Jun 2025 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685158; cv=none; b=W4UbohvOz4Nm9TURete3bnNBuS5QftvLQlj+klNX6Io97y0eFkOlfWEGV6s7Dt3yw/VLCO0rvMlERAPQ02AfuSmqy+i9U2NiidSxjf5KKdsJ08NXC+9jyUh0MuUW2LNkXwtKwonXOmZyQc/KyONbYL6ZJCE8cNtP9RLVFkULsLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685158; c=relaxed/simple;
	bh=uExW0d+OeKMwnrryteY5gwJxHyjEw7joCKiKoIHFmtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZv+AWLm7dXGzdU7E4fVKfSPKjuYUaDBmn8EVnsFchxRFIJpLOrJq7SNpGT3PtXwsneI9q3Va/Gdyk0J8pL7rdl0aBbKLBAmw+8pSP1pzl4FGBJ0KwFAi+Gl4Pop6N9dj9XGBmdKtbiU1s+YPuptHW32rpDIkxHXDlpC7pthouU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpTiQ6JI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpTiQ6JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E399C4CEEA;
	Mon, 23 Jun 2025 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685157;
	bh=uExW0d+OeKMwnrryteY5gwJxHyjEw7joCKiKoIHFmtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpTiQ6JI7xz3MpvajIe5fjYBcU8hnQBdj5pYJzpY2nn4Gew9vFz1LqDE6K/Q91KSk
	 AIZz2QzonIWfsJgJ+UtY+Kw6QlCWh2jgOT01bXK2R1D3v1UY9ikQGLkdsXA8G3WVXQ
	 KQQzsgcw26Kp8M72x0cfX0xXV1bo3z4sVnOUiUmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 210/592] power: supply: collie: Fix wakeup source leaks on device unbind
Date: Mon, 23 Jun 2025 15:02:48 +0200
Message-ID: <20250623130705.281871427@linuxfoundation.org>
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



