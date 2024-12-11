Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8106C1BEF82
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 04:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891162; cv=none; b=B0dt2o7UeQE7jMfzJhOQJ6Fal+3ToQ6AJXXXeFuraHyaRJlYKEjgY8wh0Guyhbxbw2YRHnezP0hq/CDlcbtxacc8Vym3YADQyKPVz5v6dtMIDb1b9tNzt36sRe/wEKNB8Qu7MVMTSobTfLJHnO58k4ZG8aq1mphEdUwhOMihElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891162; c=relaxed/simple;
	bh=gEy4PdXHcLW6bVpR1HZwEBdg2KFlp8dORqXLqvC8W5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ho/aUBSAgNNkvg1IJJL61/KuPQuMoEXvEZZeemO44xHIxIBlZC+BVeBhFThLsb66VS70X2jsoexX2ELCrM/unjSwFCam8d26PI541pm4AEX7d3Ueh5IO6C5OzzpWZWMOnfvcu7u60IfzGNHBLGEuGJsEfBuShmrwBmgzkfT3Gqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=nNjuE/gy; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="nNjuE/gy"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E63893FE69;
	Wed, 11 Dec 2024 04:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733891157;
	bh=WWCfs3oKeQRKA8JpGtEQ0pOum3mzD4aUQKDdT/L8G1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=nNjuE/gyuqEllP4IZ6bZ7bYPrTW92Mu1xOdiufYDikbF+W5zObTGMjaVxQdFu+YfZ
	 kWzRIjAXeLRMtDjd+E/6CkkSNjC5ZzRxVvSbUxuJAQyOxWcagkIlZH/dxLsACcTWiB
	 F4GfJ2YShIJ/ZRsqx5WgG/9aq+20sQKHqFdHQ7KUIyZBJmO2MmjSaaP+jDq1sijSUZ
	 d0Jpz1X4ZkXqrLAgYRsKlPFhoek3tm9jWu6TTEGy5fbLk6BG4eXH26ygOubBrmo/d6
	 vwa5flsdwzJrRTQt4lDxv1xFk80HtxRyuz+zDq5uDnb4p9jL9rfFWrPCl2YLOn6k/p
	 1sj/UKGlc6gYg==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stable-kernel][5.15.y][PATCH 2/5] serial: sc16is7xx: remove wasteful static buffer in sc16is7xx_regmap_name()
Date: Wed, 11 Dec 2024 12:25:41 +0800
Message-Id: <20241211042545.202482-3-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241211042545.202482-1-hui.wang@canonical.com>
References: <20241211042545.202482-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 6bcab3c8acc88e265c570dea969fd04f137c8a4c upstream.

Using a static buffer inside sc16is7xx_regmap_name() was a convenient and
simple way to set the regmap name without having to allocate and free a
buffer each time it is called. The drawback is that the static buffer
wastes memory for nothing once regmap is fully initialized.

Remove static buffer and use constant strings instead.

This also avoids a truncation warning when using "%d" or "%u" in snprintf
which was flagged by kernel test robot.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org> # 6.1.x: 3837a03 serial: sc16is7xx: improve regmap debugfs by using one regmap per port
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/tty/serial/sc16is7xx.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 88adbd9d5002..35001cc7ec90 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1450,13 +1450,15 @@ static struct regmap_config regcfg = {
 	.max_register = SC16IS7XX_EFCR_REG,
 };
 
-static const char *sc16is7xx_regmap_name(unsigned int port_id)
+static const char *sc16is7xx_regmap_name(u8 port_id)
 {
-	static char buf[6];
-
-	snprintf(buf, sizeof(buf), "port%d", port_id);
-
-	return buf;
+	switch (port_id) {
+	case 0:	return "port0";
+	case 1:	return "port1";
+	default:
+		WARN_ON(true);
+		return NULL;
+	}
 }
 
 static unsigned int sc16is7xx_regmap_port_mask(unsigned int port_id)
-- 
2.34.1

