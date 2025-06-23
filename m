Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC0C72624;
	Mon, 23 Jun 2025 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715599; cv=none; b=nJJdnvoJhuyt3PZoEjCQCITpE1Wb6T7LUALjSpzgQP1S6K8TtFlvOZFK+zEWPXBQTXxXeexN+F9g+FCzwXHfJBNwO2lsNO/DazVhhEOAjBA2B8isNxkb/r9M7RzH1cMtZTlXZ9qcwizL9o02Gj7aKiz2dg5BGyDKUmTcX5uohRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715599; c=relaxed/simple;
	bh=qEx1ZBXTJvQtSyT4ve+LghMoINbolIlWued+FkUSUC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLln5x3qoRQ49xhTTPepVrNvDJZ0zEyoKf3QM6gDkJTcb4Mlkra/iMYkW4j0kyYsd0zin0Y1teQw0mrVObFUJJUWk16ygdgX+StBq/qFPq4Ch044lbJmxYebvEk7d7QdUdHiiZgJPNXk71vbWOXVf8gjM6KzFpg/KfSLzfzwzLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywChuHKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywChuHKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0A0C4CEEA;
	Mon, 23 Jun 2025 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715599;
	bh=qEx1ZBXTJvQtSyT4ve+LghMoINbolIlWued+FkUSUC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywChuHKsKf48KI3VMql4lGTsC66yurdepWCvRu/r9fn62XCHnGZq/TtfDA0NyPR4p
	 42VnF2IvIGcak7GBfNajLKJPT/QPSFuqOUuxsiy+CZAIesWTO9IZE53io7hg2p9QEf
	 vJEvISXLN2VTx1NBZWVvdp7mbMV+TgxP9wZe59u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Michael Walle <michael@walle.cc>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/508] net: mdio: C22 is now optional, EOPNOTSUPP if not provided
Date: Mon, 23 Jun 2025 15:04:55 +0200
Message-ID: <20250623130651.402240137@linuxfoundation.org>
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
index 16e021b477f06..ee5fc73cbe075 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -764,7 +764,10 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
-	retval = bus->read(bus, addr, regnum);
+	if (bus->read)
+		retval = bus->read(bus, addr, regnum);
+	else
+		retval = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
 	mdiobus_stats_acct(&bus->stats[addr], true, retval);
@@ -790,7 +793,10 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
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



