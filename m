Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6FB19503
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E60EC433D2;
	Mon, 12 Jun 2023 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565815;
	bh=WG8YRsDnKF5Jsf6Vv3V61WWIhFLUiIsvpfcrCShqzzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJXhyMmQDilTTjPFJmNty4UC/GCV7+SzDmsIW/VEAhHEgZdT9Hmxkz7IRtbUQCA7t
	 zgHoalA1C/btpijipVBUWjsVzCYpLkS8jqNx+GQiYUqkoz+H8AWgqap/hr0QU6L+hb
	 tUIdnvjFDWnfxLkrh6oMpAePJlq1OOGTXRmamkkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/23] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del} methods
Date: Mon, 12 Jun 2023 12:26:05 +0200
Message-ID: <20230612101651.299809161@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>
References: <20230612101651.138592130@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 5a59a58ec25d44f853c26bdbfda47d73b3067435 ]

LAN9303 doesn't associate FDB (ALR) entries with VLANs, it has just one
global Address Logic Resolution table [1].

Ignore VID in port_fdb_{add|del} methods, go on with the global table. This
is the same semantics as hellcreek or RZ/N1 implement.

Visible symptoms:
LAN9303_MDIO 5b050000.ethernet-1:00: port 2 failed to delete 00:xx:xx:xx:xx:cf vid 1 from fdb: -2
LAN9303_MDIO 5b050000.ethernet-1:00: port 2 failed to add 00:xx:xx:xx:xx:cf vid 1 to fdb: -95

[1] https://ww1.microchip.com/downloads/en/DeviceDoc/00002308A.pdf

Fixes: 0620427ea0d6 ("net: dsa: lan9303: Add fdb/mdb manipulation")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20230531143826.477267-1-alexander.sverdlin@siemens.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index f976b3d64593a..80ac5efb0a7a9 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1191,8 +1191,6 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 	struct lan9303 *chip = ds->priv;
 
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
-	if (vid)
-		return -EOPNOTSUPP;
 
 	return lan9303_alr_add_port(chip, addr, port, false);
 }
@@ -1204,8 +1202,6 @@ static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
 	struct lan9303 *chip = ds->priv;
 
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
-	if (vid)
-		return -EOPNOTSUPP;
 	lan9303_alr_del_port(chip, addr, port);
 
 	return 0;
-- 
2.39.2



