Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C721E51FA;
	Mon, 23 Jun 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713901; cv=none; b=V76JCAKkKXuolY8WVpTDmJy7gNapqRo0mJCkL7Z2jbcoS4NWOtFbRGLA8Yqhca8eq/HLc/ndtPwkLpAw0gLoWJmA/6bdzIhxAAKMJtWNRaKpXNBa/QpvDZdjkCymdum2k1XSiYe80I9oBxFLWDM+DCopBa9JL2Yru5WsmotpRuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713901; c=relaxed/simple;
	bh=hEjYE1Q3hgw/bT9DCpCbsehvTE2jrJxBDucCcGLLTsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEve+4Wc+8dnzieAzUamzVncptSFdZiCsWH1alp77FfOC9L/UoJ9x1r5g0hKyMLoLWsD8t572owYZjFKv3HCdD6i/EvTn6s7ZUwJz8PO6D5LS5yQWslmtsYxfKM4k7s2GhloRnyPC7mk0SFbireYgLhitXoUVg9VuM5qqPLt0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIxCJ1lB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIxCJ1lB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01FAC4CEEA;
	Mon, 23 Jun 2025 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713901;
	bh=hEjYE1Q3hgw/bT9DCpCbsehvTE2jrJxBDucCcGLLTsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIxCJ1lBa+oq6GnGllAMHtMFR/O6XgdqK6iSbtz9Mtjz+ql0ZE1YHwRYhmYlK/WR3
	 vuCUaRwSOtzVz6jsH093c/avvh4XtuQjVI4ZHHartjT5TMPuox/O0c46YwDNHe0iC4
	 9Cl7HNpPvFlwoNnuckavNgP14id7pJxKwbZjfU0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Michael Walle <michael@walle.cc>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/411] net: mdio: C22 is now optional, EOPNOTSUPP if not provided
Date: Mon, 23 Jun 2025 15:04:58 +0200
Message-ID: <20250623130637.515958665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5f89828fd9f17..c26f46c06a1b2 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -757,7 +757,10 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
-	retval = bus->read(bus, addr, regnum);
+	if (bus->read)
+		retval = bus->read(bus, addr, regnum);
+	else
+		retval = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
 	mdiobus_stats_acct(&bus->stats[addr], true, retval);
@@ -783,7 +786,10 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
-	err = bus->write(bus, addr, regnum, val);
+	if (bus->write)
+		err = bus->write(bus, addr, regnum, val);
+	else
+		err = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
 	mdiobus_stats_acct(&bus->stats[addr], false, err);
-- 
2.39.5



