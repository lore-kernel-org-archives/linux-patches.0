Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C181AD3FA;
	Mon, 23 Jun 2025 21:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715614; cv=none; b=A208DMoGs1ZgjWGnvYTU+GSA3PfhtB7IMCHSLyd3B6YMUa5hv868tqcAfz3/PuyrlKUhPjhwvvUKb2Eri4ihPIO+pNC9GFIm/dFxSHTsOpQSUOdp4N51tGj7MAknegibdZiiyGydXawF64ljx/DGvWbFVwMgCt/wTkCYyjZO5Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715614; c=relaxed/simple;
	bh=NcI4uyj5oaoKsMj2GEfRd/BVYwcOFZI5wZqqxbKLxL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlilQDbjsfjK2v0wPJhxgqz5TI0Tn3ltJ3kaFLKbybphmYa+MdoX9bpyXnkgqqPFMsCvS4FPjoSvtUVKB3k86/kJlLN6OxKgaS1F6xMQrqDf4wqY82UFMKK7KndwT8DVFCY6TIqaT2JXasQyMf6VtPP/vy9/WvF3TBzc/+PENys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woSPSOq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woSPSOq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917F7C4CEEA;
	Mon, 23 Jun 2025 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715613;
	bh=NcI4uyj5oaoKsMj2GEfRd/BVYwcOFZI5wZqqxbKLxL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woSPSOq4fu7FLNGQfRjoOgxR+DFgc9M/F6tsg2lyYVTktHIt5uiB4BDIMszzQILqz
	 1ucV21hNTOCRcCh+/oqB2rSXfFVtnN9lzSzBsKMv0sCBBqd9Rxj/oGe447nz5mpboG
	 M/GWNNjOVDHfcOUbuYFUTzXWd1n4DK26O34OwugQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Wenjing Shan <wenjing.shan@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 251/508] net/mdiobus: Fix potential out-of-bounds read/write access
Date: Mon, 23 Jun 2025 15:04:56 +0200
Message-ID: <20250623130651.425590776@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index ee5fc73cbe075..7a2dce8d12433 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -764,6 +764,9 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->read)
 		retval = bus->read(bus, addr, regnum);
 	else
@@ -793,6 +796,9 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
+	if (addr >= PHY_MAX_ADDR)
+		return -ENXIO;
+
 	if (bus->write)
 		err = bus->write(bus, addr, regnum, val);
 	else
-- 
2.39.5



