Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B9619E992;
	Tue, 12 Nov 2024 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407672; cv=none; b=Tv3vMbMZjhU7ip89uIQXqpCnuOi9Sem+Lo/h0gUz4w/ALRrBHlaB2lsaoCBBMWnsSDmZuKRwh3z0tMR/yFTczzdBquloA+nhCvN7MvXCcbmbCbA38RWMOgpCBCPNatooAVYpVe46EAvoxWBH1ZMiE3AnstzZHTIh3tFgsJoV8to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407672; c=relaxed/simple;
	bh=20BQj+7Qw+x+3gGJYqBCXee8f0le+DSpxohzUzAuwkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojzVxfGbFigch5gHThUvDCjRoElinf3by0Vf9blO9KPmyGJrkXoMI9eMZMvvV133SJSAVUy9ymfwFKKygU1w+Pj0aiR82rjCPVBJT4kKr/S9RGoEDbsewNGMbBldnOjM4lmU/pzrMc9D/adQd0aZOVk+g+U7pZyxDGWurQ5Zzvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/b953Zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/b953Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1DFC4CECD;
	Tue, 12 Nov 2024 10:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407672;
	bh=20BQj+7Qw+x+3gGJYqBCXee8f0le+DSpxohzUzAuwkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/b953Zsw8qMbWZmr0HP5iDk7KU0opqPDoqxconSDYn8WH46tuaY4ppjrc5wWBahR
	 c1SHsEy0WquRunRCy0KxcjuXpnljUuot/F+zxevXumwDxVm17CI2mtjb5garMCLFOU
	 0ot7JCQyWm94/GrTGeFb0Aj5TlmRJlZoMuC30514=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Andy Yan <andyshrk@163.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/119] net: arc: rockchip: fix emac mdio node support
Date: Tue, 12 Nov 2024 11:20:55 +0100
Message-ID: <20241112101850.515345091@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 0a1c7a7b0adbf595ce7f218609db53749e966573 ]

The binding emac_rockchip.txt is converted to YAML.
Changed against the original binding is an added MDIO subnode.
This make the driver failed to find the PHY, and given the 'mdio
has invalid PHY address' it is probably looking in the wrong node.
Fix emac_mdio.c so that it can handle both old and new
device trees.

Fixes: 1dabb74971b3 ("ARM: dts: rockchip: restyle emac nodes")
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Tested-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20220603163539.537-3-jbx6244@gmail.com
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/arc/emac_mdio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 87f40c2ba9040..078b1a72c1613 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -133,6 +133,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	struct arc_emac_mdio_bus_data *data = &priv->bus_data;
 	struct device_node *np = priv->dev->of_node;
 	const char *name = "Synopsys MII Bus";
+	struct device_node *mdio_node;
 	struct mii_bus *bus;
 	int error;
 
@@ -164,7 +165,13 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", bus->name);
 
-	error = of_mdiobus_register(bus, priv->dev->of_node);
+	/* Backwards compatibility for EMAC nodes without MDIO subnode. */
+	mdio_node = of_get_child_by_name(np, "mdio");
+	if (!mdio_node)
+		mdio_node = of_node_get(np);
+
+	error = of_mdiobus_register(bus, mdio_node);
+	of_node_put(mdio_node);
 	if (error) {
 		mdiobus_free(bus);
 		return dev_err_probe(priv->dev, error,
-- 
2.43.0



