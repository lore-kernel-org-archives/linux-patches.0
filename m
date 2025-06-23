Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B9250BEC;
	Mon, 23 Jun 2025 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685331; cv=none; b=OiQ7w3ynRFflhuNGK4LI/aCDuAVyWki9arE5hFrjs/Vddp33UFEOCvpo68bvwhep/wxj0Z4fN0rPzd6cIB6BK8M//d04YlbRqDFZNvGTquyaSPKJAXf9VriP7ahmep05PmqayHBtpomIKA1T8OE4hWTUBzx2RaBaA0juqL1UKaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685331; c=relaxed/simple;
	bh=QSSmpiv5FBe9B/o8u996/+lNauUB17u7wHMbTonn32I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rivN5C7F/kTqy1ozJPtyr52CovRM7NUiYbMX/l0KprgFR3dpXwWhDEoxZCrAOKRcA2U9LCXcGVcu4kgq4d1Cwal9uC5+7JimS9e76jqHHAWCEVL/YhNrMGR1NYEbXzmNoGXsAXnRlFlXyYqajPhYCz0fzeGLisYpCQUeowdaqzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QnvSio+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QnvSio+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04D2C4CEEA;
	Mon, 23 Jun 2025 13:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685331;
	bh=QSSmpiv5FBe9B/o8u996/+lNauUB17u7wHMbTonn32I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QnvSio+xfdUGtk9C06uOSjBg66IylBbFzWeiecOiYBfGEcHdkeOpErDz7t3yp3Nn
	 QOXQOjMxExSkQ7RMlDLBtJw32Qp5aFly9e8odkVurx9Gvn9JQs2csaWs1A7ogFxwiA
	 0deUBv1axjnvaFb/Iq0N+ozYTTJkRcFXwD5hczxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Michael Walle <michael@walle.cc>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/222] net: mdio: C22 is now optional, EOPNOTSUPP if not provided
Date: Mon, 23 Jun 2025 15:07:01 +0200
Message-ID: <20250623130614.689593769@linuxfoundation.org>
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
index fdf8221f46fa5..e5c25beae21e0 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -565,7 +565,10 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
-	retval = bus->read(bus, addr, regnum);
+	if (bus->read)
+		retval = bus->read(bus, addr, regnum);
+	else
+		retval = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
 
@@ -590,7 +593,10 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
 
-	err = bus->write(bus, addr, regnum, val);
+	if (bus->write)
+		err = bus->write(bus, addr, regnum, val);
+	else
+		err = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
 
-- 
2.39.5



