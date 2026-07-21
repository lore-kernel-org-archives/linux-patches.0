Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF2384CC4;
	Tue, 21 Jul 2026 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662138; cv=none; b=u/5vppJsOHYsWqXBbm0DKDmjsXOGkxfZwFu5eBrhAT4a4/0933p7ACxKKGoA529h73A11SVakOOoCftg6RU/G9e8pfZQoBs6AsBqsSWQLZNlcwX+NoDPYPIxWKHOio0DPmUHAMkPEJkCy4twNM2Kfn3Jjv3gq197WOw/nrVsc+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662138; c=relaxed/simple;
	bh=G1a+xzTotRdB4d3J9yDKJ3dn0I52EpPW04xx4X1tc9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqL6iuEn4O81YXVODu4jHhpiPGN4eD/eMwtY+PijviaEZt7bT+hcsIrbKvO27aDnQeJcIOnND/wHieZIqbodhuKdAceTULloJA/sKb5u3zDZ+614+jNwdK+LkANB9aWvSREN/0rcqgFXFp1Ujfn/F5pYQdx8/7GB5jmKjOv5x8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+JbLfwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+JbLfwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AC51F000E9;
	Tue, 21 Jul 2026 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662137;
	bh=PnCm+QeYu9gnhmz7DiwRLhd1KjwWguaaKG4r/cDhNF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+JbLfwZh5xnu/alJ6I/+IcwIdlh7idAm7ftiPlECEn7wDz981IP1SnrMLxF3g///
	 0JTOfnwchCTbdq8lEqQR7z+ca2qHHHWwOowmxkOi7jwxfZPw5kc4VXGA5P8faHBDZc
	 +h1QQU/FmRy3+OZcvVlrE4RqmxiDMvh14gAnsuWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0332/1276] net: dsa: qca8k: fix led devicename when using external mdio bus
Date: Tue, 21 Jul 2026 17:12:55 +0200
Message-ID: <20260721152453.533118232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 0b7b378ce6cafbb948786cb6f17f406d94016c8c ]

The qca8k dsa switch can use either an external or internal mdio bus.
This depends on whether the mdio node is defined under the switch node
itself. Upon registering the internal mdio bus, the internal_mdio_bus
of the dsa switch is assigned to this bus. When an external mdio bus is
used, the driver still uses the internal_mdio_bus id which is used to
create the device names of the leds.
This leads to the leds being prefixed with '(efault)' as the
internal_mii_bus is null. So let's fix this by adding a null check and
use the devicename of the external bus instead when an external bus is
configured.

Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260608-qca8k-leds-fix-v3-1-a915bb2f37ae@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-leds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 43ac68052baf9f..ef496e345a4e7d 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -429,7 +429,8 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		init_data.fwnode = led;
 		init_data.devname_mandatory = true;
 		init_data.devicename = kasprintf(GFP_KERNEL, "%s:0%d",
-						 priv->internal_mdio_bus->id,
+						 priv->internal_mdio_bus ?
+						 priv->internal_mdio_bus->id : priv->bus->id,
 						 port_num);
 		if (!init_data.devicename) {
 			fwnode_handle_put(led);
-- 
2.53.0



