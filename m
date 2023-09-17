Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4A7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAB8C433C8;
	Sun, 17 Sep 2023 19:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980694;
	bh=AhU7LtrBHg72XaDGIf+LuFusXWOUnhZKgskNOJg62Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwrU+RbWAqbax1IyWgGT28E/6ofS5H/TBPsJy89Zb3gVcrIZOvGfO8Us8goSQk5zq
	 5IhDadySk9Axw1wX/JOOMONvbO22ORPgJXTn0+R9bZMeL20GH5RKF7LUMwRZGoDjbc
	 UGZWq1vXMS6pl914gXCbhGTk0Kp1bIw7GEyhDZSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciprian Regus <ciprian.regus@analog.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 259/285] net:ethernet:adi:adin1110: Fix forwarding offload
Date: Sun, 17 Sep 2023 21:14:19 +0200
Message-ID: <20230917191100.222135649@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 1c009b485188d..ca66b747b7c5d 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1385,7 +1385,7 @@ static int adin1110_fdb_add(struct adin1110_port_priv *port_priv,
 		return -ENOMEM;
 
 	other_port = priv->ports[!port_priv->nr];
-	port_rules = adin1110_port_rules(port_priv, false, true);
+	port_rules = adin1110_port_rules(other_port, false, true);
 	eth_broadcast_addr(mask);
 
 	return adin1110_write_mac_address(other_port, mac_nr, (u8 *)fdb->addr,
-- 
2.40.1



