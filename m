Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE266FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68212C433EF;
	Mon, 19 Dec 2022 19:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671478002;
	bh=DnfjpCyE+1/eoJXeQxrHdCZw0FdF96blYvDk7+L7bdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2d7b0bMrqGbREHSY4Nhlm+E00nW1CkpDQiOQ/Ov4K7gO+WLKH0qNA+kDqGyzeV3UM
	 6/afLEGd6+SE1ZW/w9Cv7td2+E83yM5ihoxYB+QbtywPgW82bfJwHsZnKaQq6mM+38
	 gPR2VcPG74k/BiHM73/TKbY2somAhpBkMLN8W5Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 26/28] Bluetooth: L2CAP: Fix u8 overflow
Date: Mon, 19 Dec 2022 20:23:13 +0100
Message-Id: <20221219182945.304537194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit bcd70260ef56e0aee8a4fc6cd214a419900b0765 ]

By keep sending L2CAP_CONF_REQ packets, chan->num_conf_rsp increases
multiple times and eventually it will wrap around the maximum number
(i.e., 255).
This patch prevents this by adding a boundary check with
L2CAP_MAX_CONF_RSP

Btmon log:
Bluetooth monitor ver 5.64
= Note: Linux version 6.1.0-rc2 (x86_64)                               0.264594
= Note: Bluetooth subsystem version 2.22                               0.264636
@ MGMT Open: btmon (privileged) version 1.22                  {0x0001} 0.272191
= New Index: 00:00:00:00:00:00 (Primary,Virtual,hci0)          [hci0] 13.877604
@ RAW Open: 9496 (privileged) version 2.22                   {0x0002} 13.890741
= Open Index: 00:00:00:00:00:00                                [hci0] 13.900426
(...)
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #32 [hci0] 14.273106
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............
> ACL Data RX: Handle 200 flags 0x00 dlen 1547             #33 [hci0] 14.273561
        invalid packet size (14 != 1547)
        0a 00 01 00 04 01 06 00 40 00 00 00 00 00        ........@.....
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #34 [hci0] 14.274390
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 00 00 00 04  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061             #35 [hci0] 14.274932
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 07 00 03 00  ........@.......
= bluetoothd: Bluetooth daemon 5.43                                   14.401828
> ACL Data RX: Handle 200 flags 0x00 dlen 1033             #36 [hci0] 14.275753
        invalid packet size (12 != 1033)
        08 00 01 00 04 01 04 00 40 00 00 00              ........@...

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9c24947aa41e..9fdede5fe71c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4453,7 +4453,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	chan->ident = cmd->ident;
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP, len, rsp);
-	chan->num_conf_rsp++;
+	if (chan->num_conf_rsp < L2CAP_CONF_MAX_CONF_RSP)
+		chan->num_conf_rsp++;
 
 	/* Reset config buffer. */
 	chan->conf_len = 0;
-- 
2.35.1



