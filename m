Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A82FA624;
	Tue, 17 Jun 2025 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179355; cv=none; b=uKFV0eNus0ra25y8u+V376m14Bt5Mjigca+QlVqRJPJY0wYaMM1QsDSi+C8KOxlP/IZElTe4kTHD7QhtB02XpnyG7PiETjncs/gtEHfoAqi+eVRrMmrlYm8z+EALBKcEl02so61kL6tpewva/G8Jo6J+NaaZXUO3C8lEcTQD350=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179355; c=relaxed/simple;
	bh=wUeSev2eFUkS0OkrCuN4XxiD4d08gPGamXvUlSDjeaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2iuFjd7lmcWEgrA4QlKkWVjB3alpksl5oJKNZ1LFzRVPH9QkcoM/9oPtVqgaqOchP+FXR6O33XEElEQoa9fRMxmUy2YUdsYCPo26CgMfS5A130YSR+QZkOyetk7Qc4Vo5zx+djaGMByGKFkfk+msftS2rGehKmeO+9ig2ap8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ2u82Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ2u82Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5B0C4CEE3;
	Tue, 17 Jun 2025 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179355;
	bh=wUeSev2eFUkS0OkrCuN4XxiD4d08gPGamXvUlSDjeaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ2u82ApMAcTVm5pIvNH7Ls/gbwNm/E8e1vfoNcn6LLednhkwvAbmmyUkCsy002UL
	 5xaYRqX0DkQjPgSgZSNFtnehyGBQ7Z4BklV3UfHKFuMd9fNLfkm+4iuDqrogmwgB1N
	 aHwSvk0iher673j58ZotY+oWvzvmduy69RzdqNsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Wenjing Shan <wenjing.shan@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 703/780] net/mdiobus: Fix potential out-of-bounds read/write access
Date: Tue, 17 Jun 2025 17:26:51 +0200
Message-ID: <20250617152520.126469435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index ede596c1a69d1..adb17ec937151 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -903,6 +903,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->read)
 		retval = bus->read(bus, addr, regnum);
 	else
@@ -932,6 +935,9 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->write)
 		err = bus->write(bus, addr, regnum, val);
 	else
-- 
2.39.5



