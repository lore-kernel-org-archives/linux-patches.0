Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3582810A1C;
	Sat,  3 Feb 2024 04:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933457; cv=none; b=dpIlsOBua6AyW7mq6E2x4CEcedQNa5jXsjvv2V7+86U6rfNk1HkG6aFREAXFUKJG/+qYJEfiAGZ7uyjEME3aD/18fRUTz5OLPOM7ap5AEt/WrMqWJycLLN95sb20ClwM1nkEFNf1HIAtsSGRDfqYcDr11PHUSjjI3Q5+G4vmYaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933457; c=relaxed/simple;
	bh=4YaUNYBhswLv8y82K7vfHQ/XI8egVMjer8OGZJS/eI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1UUI6PfEXzZsPmdbFkI028sEJH1uKwGJg6+SwNMZ2jJElr1NnD+WlrYhaJkcxN5KZeA/A3atjzWLB+q2mqRfKWTokahgnFwD79fioSIL5bawra6dyQHknFmW0ICWTWG+EV4Gj5WJ0gAHo1iY3GEwpJVjfwIMkU9pzhRvvzVFSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKlnOjMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKlnOjMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31A4C433A6;
	Sat,  3 Feb 2024 04:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933457;
	bh=4YaUNYBhswLv8y82K7vfHQ/XI8egVMjer8OGZJS/eI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKlnOjMy6Dd/UAwpBIxayHG8MAMffXXr4S9q1N2ABwJd2nYQndcRqmsazjP6vM47B
	 b4S3jiZCsT/PA03x7hDZ3Oz13TZTqfIslaaa6CtoF3+xCTsa1umyopT4hDNIM8ZR0t
	 /ToANKX4OIJsPj8pPITIC+1KByPbMfaAlVlRoB7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/219] net: lan966x: Fix port configuration when using SGMII interface
Date: Fri,  2 Feb 2024 20:06:06 -0800
Message-ID: <20240203035344.062555238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 62b4248105353e7d1debd30ca5c57ec5e5f28e35 ]

In case the interface between the MAC and the PHY is SGMII, then the bit
GIGA_MODE on the MAC side needs to be set regardless of the speed at
which it is running.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_port.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 0050fcb988b7..8cc5172833a9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -168,9 +168,10 @@ static void lan966x_port_link_up(struct lan966x_port *port)
 	lan966x_taprio_speed_set(port, config->speed);
 
 	/* Also the GIGA_MODE_ENA(1) needs to be set regardless of the
-	 * port speed for QSGMII ports.
+	 * port speed for QSGMII or SGMII ports.
 	 */
-	if (phy_interface_num_ports(config->portmode) == 4)
+	if (phy_interface_num_ports(config->portmode) == 4 ||
+	    config->portmode == PHY_INTERFACE_MODE_SGMII)
 		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA_SET(1);
 
 	lan_wr(config->duplex | mode,
-- 
2.43.0



