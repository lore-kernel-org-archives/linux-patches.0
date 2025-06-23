Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA31DF98B;
	Mon, 23 Jun 2025 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713199; cv=none; b=QQvdOwuOYIR83B6ens28vWnsPOXhK6tet1uQhd4B6cmHI6Y4akUxP46Tpj9peCmLxkbeW/7QIQiWhzsMJM0gJcv5dMo8npW5x+N2cuu5AU1pmqwNzbmjcMQ3qeqq8e5Kmiyay/hf5GjnzY6CcMEbLd/cf6+9w940vG9lPj7Q9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713199; c=relaxed/simple;
	bh=2BrSaO17kNP17HosRIQ2EZrrJNDeWsYrfwucquLg71s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtGfTocbtxxyH05wzanVlEPm70yQEUUF8S6+rT4uZGWTsDO1qBTMLymbFizjcg56JeEORXr7qUZ5FGIHV/GcLGL6ope22pXgtHSD8iQIqGXYWv27p+MwJ5UyPdLEUxXCw9QJiSJx7pQpvj1HnA97k92qBla5lFTqReqGSVse1H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwSqrzaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwSqrzaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AFBC4CEED;
	Mon, 23 Jun 2025 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713199;
	bh=2BrSaO17kNP17HosRIQ2EZrrJNDeWsYrfwucquLg71s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwSqrzaY6rglX8UuE8VtaU3Lq3RPnHuwLFVNwLlEEAPeKJyiLagsbkqY9VPtFnAAK
	 PUVItH6D26F0fzAGOMV+YMuZHsO0aj1F90wH4jvg3q6epcMVWyVTeyetBsOSkjModt
	 BuTxFhNdQiLbcyhtsPxrQ5xLzTWxwCP37I2nqh6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Wenjing Shan <wenjing.shan@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/355] net/mdiobus: Fix potential out-of-bounds read/write access
Date: Mon, 23 Jun 2025 15:05:32 +0200
Message-ID: <20250623130630.676593593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Raczynski <j.raczynski@samsung.com>

[ Upstream commit 0e629694126ca388916f059453a1c36adde219c4 ]

When using publicly available tools like 'mdio-tools' to read/write data
from/to network interface and its PHY via mdiobus, there is no verification of
parameters passed to the ioctl and it accepts any mdio address.
Currently there is support for 32 addresses in kernel via PHY_MAX_ADDR define,
but it is possible to pass higher value than that via ioctl.
While read/write operation should generally fail in this case,
mdiobus provides stats array, where wrong address may allow out-of-bounds
read/write.

Fix that by adding address verification before read/write operation.
While this excludes this access from any statistics, it improves security of
read/write operation.

Fixes: 080bb352fad00 ("net: phy: Maintain MDIO device and bus statistics")
Signed-off-by: Jakub Raczynski <j.raczynski@samsung.com>
Reported-by: Wenjing Shan <wenjing.shan@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 743a63eca7840..d15deb3281edb 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -754,6 +754,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->read)
 		retval = bus->read(bus, addr, regnum);
 	else
@@ -783,6 +786,9 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->write)
 		err = bus->write(bus, addr, regnum, val);
 	else
-- 
2.39.5



