Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35125157052;
	Mon, 29 Jan 2024 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548502; cv=none; b=ZVx4aoZYoKpIEM9DD+NnWBQBPkIPRjahUVK81rEt9mE/zU0qwCbD49Z7Klou0sOtmrimv1ey0pKYvJPY9RF5sMW4aLmazL513Kel9X+zhMGDjTIJJ2XW3KzhKgIUPLzKo1P0D1yd/DO9GrvSAvzUwKPgnU6erVJ96ElwJpmlgBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548502; c=relaxed/simple;
	bh=usbm3fwtz6GignOAD3MxlIZbkMLChih6DbmDzBLur40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdMYU46yEzEb48NE8aRTLZhGZ/CJqKKhxoV2db/0sM6/YvBuBWyfggb9Z4SBFrEdrL+9o43jwTpezosBsbUfU4vSgLRUYXj+al0/SbPzQJR5dLxiBZymqzb6kUsmOTbXKG7Rh3CZCNfwDdFt/w3VI9dXwMfDZNnfNxR1DGfvnB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2HlzATm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2HlzATm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F223FC433F1;
	Mon, 29 Jan 2024 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548502;
	bh=usbm3fwtz6GignOAD3MxlIZbkMLChih6DbmDzBLur40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2HlzATmToEMEMOwqWw3ciBRXgzRmbc5ym/sch993WtlsYUWTRlcTRr1r+SZcsU6O
	 GcUO/9prksYvsv8c8tUH7O0WQfbr3DDuzq0Y2C9yg3a73DxifRzTOL22rqFydxEdhd
	 MFmH5qW2bbV6Xz3FWXjKFjHqkqQ2wKz7PIW1kqNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 129/331] serial: sc16is7xx: remove wasteful static buffer in sc16is7xx_regmap_name()
Date: Mon, 29 Jan 2024 09:03:13 -0800
Message-ID: <20240129170018.714581556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
---
 drivers/tty/serial/sc16is7xx.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1696,13 +1696,15 @@ static struct regmap_config regcfg = {
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


