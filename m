Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E54330E84D;
	Mon, 23 Jun 2025 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685621; cv=none; b=JrVxtKOI549uXP8doTD61Ib28U5Z4QtX5zKGfhoTCo3UB83mXT7YfJRdyDeH5QFTRImABEdBVYUVBacwEhTP7j6uNKvdcbK9UyKccGlvINLp3NnmuPGbMghFjDDJKp9T0D3tZHqiB0zBgWSctCxwiwo4PGCO+UnzgFXi9mpUCLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685621; c=relaxed/simple;
	bh=pg+GJkCGyMx5uz/ss9zqCTXx7iomeCOHMNdPTlxovik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ig7F++4XI/fWHYipj6T6qwz4IK0ZAGv22DIS9f8KgMLStLwXy/T1lec0BMAJgUsmQJ6Ol+Hr2TKr31bEH0lN6aFMk9yL6XFo2Cn8+bG0jg9mN5rgjxFXslvfB3GpnwHs4lIj8lr3D2lnUUZ5RBHujBybiQbxHqpz0UfpkGsKnfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gf2NZvIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gf2NZvIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F6EC4CEEA;
	Mon, 23 Jun 2025 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685621;
	bh=pg+GJkCGyMx5uz/ss9zqCTXx7iomeCOHMNdPTlxovik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gf2NZvIjfrULSjcpRVIRcR74IVjHaMxdcq4XXnWvTJp+QVTiALV0iRkcT+QFnj4zP
	 jwjwk0q3aOD4ZBL4+FloKa76oZ8v8yWBnaisWIETGEh9fEvnnSh0WS2gMtVqpnKXYN
	 ABypd9ID/DEmGDSnb3uYXHn6S9mfTYcozsyAgtNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Wenjing Shan <wenjing.shan@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/222] net/mdiobus: Fix potential out-of-bounds read/write access
Date: Mon, 23 Jun 2025 15:07:11 +0200
Message-ID: <20250623130614.995034353@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e5c25beae21e0..931b9a6c5dc50 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -565,6 +565,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->read)
 		retval = bus->read(bus, addr, regnum);
 	else
@@ -593,6 +596,9 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->write)
 		err = bus->write(bus, addr, regnum, val);
 	else
-- 
2.39.5



