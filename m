Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001E11DF98B;
	Mon, 23 Jun 2025 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713183; cv=none; b=Clepun8QGyLLuSt1ksmY1pqUnsC1ZPnQRjvaHy1FH1x2XxJ97gRFpNVHy4cf9EXV3Sk96XJxnHTzusZ0mAUa39vf4tIITTgJZSO0xOwhwuNgxmm5IovywhOz9iAfHdL5NQUvzI6m16ZglwUQL1+oxrl1WVO/0w2F+7OZ9SfxTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713183; c=relaxed/simple;
	bh=hp36e8zGMb5ZNxGqY3mMmOwlISIwVzFnu1AVStFlqqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFHoEDl6dEUL63DIdn9it3KHyk9Ge5j66HBQ5rsknmkD1jQ97l7d2pfCE9SbfMJr1Pwtfoq7BVtvmW3Tl1hyDn4q0xlJxDutkRIi+VC2rWkD4oan+p6ERRPhv8gp6MRVsjNZCVV+oClGVCEX0c2Y5on3QGsEV/85Y3BNgrv9cX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KguZNEA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KguZNEA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB36C4CEEA;
	Mon, 23 Jun 2025 21:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713182;
	bh=hp36e8zGMb5ZNxGqY3mMmOwlISIwVzFnu1AVStFlqqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KguZNEA+IK0uH1dSqHre/RjwFsW1G02Z1XWhyPJLK5xm/NLGAudh0fca8mUUV4dU2
	 ZkN16tyQzza/izmOWXVLtbkG222klsePfEbTusHxqxV7I/+LsKC5V3wke1INd0GRmy
	 gInRNoRl1ZGTIpZEaTB436ZskFQGwSDaw9R/cpiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Michael Walle <michael@walle.cc>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/355] net: mdio: C22 is now optional, EOPNOTSUPP if not provided
Date: Mon, 23 Jun 2025 15:05:31 +0200
Message-ID: <20250623130630.647589511@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit b063b1924fd9bf0bc157cf644764dc2151d04ccc ]

When performing a C22 operation, check that the bus driver actually
provides the methods, and return -EOPNOTSUPP if not. C45 only busses
do exist, and in future their C22 methods will be NULL.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0e629694126c ("net/mdiobus: Fix potential out-of-bounds read/write access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index e9303be486556..743a63eca7840 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -754,7 +754,10 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
-	retval = bus->read(bus, addr, regnum);
+	if (bus->read)
+		retval = bus->read(bus, addr, regnum);
+	else
+		retval = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
 	mdiobus_stats_acct(&bus->stats[addr], true, retval);
@@ -780,7 +783,10 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
-	err = bus->write(bus, addr, regnum, val);
+	if (bus->write)
+		err = bus->write(bus, addr, regnum, val);
+	else
+		err = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
 	mdiobus_stats_acct(&bus->stats[addr], false, err);
-- 
2.39.5



