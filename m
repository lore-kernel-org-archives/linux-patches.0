Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D508E2F94B0;
	Tue, 17 Jun 2025 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176849; cv=none; b=DwgWmjOyn5jHGQVNC6rlOe7fMuDdT8MU4aiynZgfih6xJOvyIa4LmmacAklzloqM34LsyBaB8Pk27AA15FjMkuoQwAgymueUV6uql92oN0Ka9Z7YTiFJAugpUR95b+YBCjjBrCI32nRjTrqiUdHlDC3MlvgRfPIHGXzr+C2As08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176849; c=relaxed/simple;
	bh=GpuTkOvlFon9FPWmwptXF1mvwZrWBtNcRXEc+oF345s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAAH1xKEARGs5Ukkz8oaXaGzVStSZB5wT7GN/LVHa5PaYTw9HChfWlD9gSZ/J5skjotgXoJoDY8y5kHeQGB2zQAdr9eXxRd2G99JRqEhhHwcU0XLDdQmYQ/Ac4CLt5wLtQ17eM9OfH3oXyzi5zllz2UT+7modNAWUmPjZkysaCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyQnY2vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyQnY2vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F67C4CEE3;
	Tue, 17 Jun 2025 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176849;
	bh=GpuTkOvlFon9FPWmwptXF1mvwZrWBtNcRXEc+oF345s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyQnY2vs62ixQ/D5ML33VAU9p7vDbzSfE5lSl2lSGQADfd66RKxxwamZmK5uE5s8O
	 K/bazEdvLiONcWkzWDklZJBFJYnA1UU1BepS0XP5KDPlFTXhKGJF2sa9dnWxwClBNu
	 Qw2tk2ghtsR5nX+d2iYBoP3hbVABW7NNLJYjuAKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Wenjing Shan <wenjing.shan@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/356] net/mdiobus: Fix potential out-of-bounds clause 45 read/write access
Date: Tue, 17 Jun 2025 17:27:14 +0200
Message-ID: <20250617152351.000349066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Raczynski <j.raczynski@samsung.com>

[ Upstream commit 260388f79e94fb3026c419a208ece8358bb7b555 ]

When using publicly available tools like 'mdio-tools' to read/write data
from/to network interface and its PHY via C45 (clause 45) mdiobus,
there is no verification of parameters passed to the ioctl and
it accepts any mdio address.
Currently there is support for 32 addresses in kernel via PHY_MAX_ADDR define,
but it is possible to pass higher value than that via ioctl.
While read/write operation should generally fail in this case,
mdiobus provides stats array, where wrong address may allow out-of-bounds
read/write.

Fix that by adding address verification before C45 read/write operation.
While this excludes this access from any statistics, it improves security of
read/write operation.

Fixes: 4e4aafcddbbf ("net: mdio: Add dedicated C45 API to MDIO bus drivers")
Signed-off-by: Jakub Raczynski <j.raczynski@samsung.com>
Reported-by: Wenjing Shan <wenjing.shan@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 103998969d44c..e02706b7cc1ed 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -946,6 +946,9 @@ int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->read_c45)
 		retval = bus->read_c45(bus, addr, devad, regnum);
 	else
@@ -977,6 +980,9 @@ int __mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->write_c45)
 		err = bus->write_c45(bus, addr, devad, regnum, val);
 	else
-- 
2.39.5



