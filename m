Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081861B4120;
	Mon, 23 Dec 2024 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970686; cv=none; b=g0XuJ/GCDIo7YHahFi9Ivje7o9HvIgyid05qR2d1qV6eEI++BJBf9wWGmCJ04j9coYb/X97RWJIecN5UDnWOCyQ8iEfHturKuskfD3wy7pJq7pbKmNr6CniLeQq2JswPrp01CF8dpnMz8T+a5N5dZGY32E1iKcsLpafAZbnuDnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970686; c=relaxed/simple;
	bh=PxjRoWHyQ66bQWifQkZ9B9uAkaq8O5xQc/if2pmi/Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aS606gvWdeuDLktK+KbS5J4diBHqQqNwKUwFpfm2aAjUvFLICeIihlhi0HgerocViDf+NvexuwRAZf/w1iV9D/KoiQiOPssIrrNP/I/0hMab+8Jril/6F1adR6oE7uNhn/N0ggOpgSfVDXzd55IfTBF+dJvVjHMcMgxiy1h+lm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/IgZfy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/IgZfy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CABBC4CEDC;
	Mon, 23 Dec 2024 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970685;
	bh=PxjRoWHyQ66bQWifQkZ9B9uAkaq8O5xQc/if2pmi/Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/IgZfy6UB3wA7+v3yVE1WdPgO3b8MHIOUOO6+iWBzCeHx2uPYhkcYBfACnHMZYnh
	 UlS7Y9eCF1iErZQt+hzIRbNAiqiW2QEJ6fMy8cKUHAzUDW20cwQbc+fP8jV3rF36Wm
	 JC5lVOl/XGwRUl7guaLeS+NRIfRntKqGP+UHvqNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/83] net: mdiobus: fix an OF node reference leak
Date: Mon, 23 Dec 2024 16:59:10 +0100
Message-ID: <20241223155354.855533926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 572af9f284669d31d9175122bbef9bc62cea8ded ]

fwnode_find_mii_timestamper() calls of_parse_phandle_with_fixed_args()
but does not decrement the refcount of the obtained OF node. Add an
of_node_put() call before returning from the function.

This bug was detected by an experimental static analysis tool that I am
developing.

Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241218035106.1436405-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/fwnode_mdio.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b782c35c4ac1..8ada397bc357 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -38,6 +38,7 @@ fwnode_find_pse_control(struct fwnode_handle *fwnode)
 static struct mii_timestamper *
 fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 {
+	struct mii_timestamper *mii_ts;
 	struct of_phandle_args arg;
 	int err;
 
@@ -51,10 +52,16 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	else if (err)
 		return ERR_PTR(err);
 
-	if (arg.args_count != 1)
-		return ERR_PTR(-EINVAL);
+	if (arg.args_count != 1) {
+		mii_ts = ERR_PTR(-EINVAL);
+		goto put_node;
+	}
+
+	mii_ts = register_mii_timestamper(arg.np, arg.args[0]);
 
-	return register_mii_timestamper(arg.np, arg.args[0]);
+put_node:
+	of_node_put(arg.np);
+	return mii_ts;
 }
 
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
-- 
2.39.5



