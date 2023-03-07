Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86965BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71D1C433AF;
	Tue,  7 Mar 2023 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213736;
	bh=Gt5RttRD2uzBUsNCm618cpLLtdUwX0697o/p2YGOFh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRhrb1yp8ES+5m0qMpEppDQZ995qeAi2vimnWx8ro4C0Fuk/B1fv3eipE/jN7J3cY
	 CrARaZYm4aZ68PsFVdurrTh4x+ZyqcXeGBbWNAikOGNojnG7lz5YwrIOx07k0XRqIb
	 HNofkKPdDMzGZhfiEt5y+UIbRIt9ytb3z+0ojo4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 572/885] can: isotp: check CAN address family in isotp_bind()
Date: Tue,  7 Mar 2023 17:58:26 +0100
Message-Id: <20230307170027.265096406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit c6adf659a8ba85913e16a571d5a9bcd17d3d1234 ]

Add missing check to block non-AF_CAN binds.

Syzbot created some code which matched the right sockaddr struct size
but used AF_XDP (0x2C) instead of AF_CAN (0x1D) in the address family
field:

bind$xdp(r2, &(0x7f0000000540)={0x2c, 0x0, r4, 0x0, r2}, 0x10)
                                ^^^^
This has no funtional impact but the userspace should be notified about
the wrong address family field content.

Link: https://syzkaller.appspot.com/text?tag=CrashLog&x=11ff9d8c480000
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104201844.13168-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index fc81d77724a13..9bc344851704e 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1220,6 +1220,9 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_family != AF_CAN)
+		return -EINVAL;
+
 	/* sanitize tx CAN identifier */
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
-- 
2.39.2



