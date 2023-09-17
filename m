Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E727461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC8C433C7;
	Sun, 17 Sep 2023 20:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981933;
	bh=IrCIMyGJqENalE/KJWq0Vs66S84g+l7xgRrOMJBD3N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvuCKRUEJyOPnK3o7x36n7/CCK68vBHTt/IIYXoV34dw/BQ+8ACiIiGWTOYGJ1m/d
	 3oOTnjWDfKlzj5u4GmFqlEApV/NSV7qHMTFoU6SGYOjZkig17CTu40p7pz8eBQMoS9
	 VbICByOnHyxjgSNR3ePyh6n8LRTu4PlxwVugYSvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciprian Regus <ciprian.regus@analog.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/219] net:ethernet:adi:adin1110: Fix forwarding offload
Date: Sun, 17 Sep 2023 21:15:22 +0200
Message-ID: <20230917191047.989785592@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Ciprian Regus <ciprian.regus@analog.com>

[ Upstream commit 32530dba1bd48da4437d18d9a8dbc9d2826938a6 ]

Currently, when a new fdb entry is added (with both ports of the
ADIN2111 bridged), the driver configures the MAC filters for the wrong
port, which results in the forwarding being done by the host, and not
actually hardware offloaded.

The ADIN2111 offloads the forwarding by setting filters on the
destination MAC address of incoming frames. Based on these, they may be
routed to the other port. Thus, if a frame has to be forwarded from port
1 to port 2, the required configuration for the ADDR_FILT_UPRn register
should set the APPLY2PORT1 bit (instead of APPLY2PORT2, as it's
currently the case).

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Ciprian Regus <ciprian.regus@analog.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index cc026780ee0e8..ed2863ed6a5bb 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1365,7 +1365,7 @@ static int adin1110_fdb_add(struct adin1110_port_priv *port_priv,
 		return -ENOMEM;
 
 	other_port = priv->ports[!port_priv->nr];
-	port_rules = adin1110_port_rules(port_priv, false, true);
+	port_rules = adin1110_port_rules(other_port, false, true);
 	eth_broadcast_addr(mask);
 
 	return adin1110_write_mac_address(other_port, mac_nr, (u8 *)fdb->addr,
-- 
2.40.1



