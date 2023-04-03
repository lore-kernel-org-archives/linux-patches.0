Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703F8612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC396C433EF;
	Mon,  3 Apr 2023 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531717;
	bh=rdiOb6aB6IMXNSRwUVLojaJ0MoxQY4JfMOqOQjjqpiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji7uYws04fMHsgI3GcM+H8IsA0ITC3YUT4iAhsdIuRRIijjVxxVkoHKEuSZomhOW/
	 ipf/zu9X95K1CWp3f6sfPZNZm7oHYm9CmfDYok4NfsgxfgyDLRiUwjvrlAnTCxNX+C
	 ajCtqK5FN4re8S36F59qJtKizwPC96tFzcaWHcB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
	Fabio Estevam <festevam@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/104] net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only
Date: Mon,  3 Apr 2023 16:09:16 +0200
Message-Id: <20230403140407.429960034@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steffen Bätz <steffen@innosonix.de>

[ Upstream commit 7bcad0f0e6fbc1d613e49e0ee35c8e5f2e685bb0 ]

Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.

This allows the host CPU port to be a regular IGMP listener by sending out
IGMP Membership Reports, which would otherwise not be forwarded by the
mv88exxx chip, but directly looped back to the CPU port itself.

Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230329150140.701559-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b336ed071fa89..ea32be579e7b1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2433,9 +2433,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
-- 
2.39.2



