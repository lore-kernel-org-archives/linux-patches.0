Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E1728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB936C433D2;
	Mon, 30 Jan 2023 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088022;
	bh=ps18Zd3wCBOuDn8FiObSAS7S3BfyvVMvklDAr41AKyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhYU9UeAz8Zt03hCx3gBGIaIXjyKybGSFLfpUzCTtcOAgN32u+u/9k2+Y6jO5wOFI
	 VYA1NwnJDQ7CncP0zdxrvmMCqzhOX02N3Av0Y4GZlCcFB/0lmCL5rrfYBiPpJ9MGYc
	 spYQCm7NOgukqSlABPIHXiNwvM6s5Kp3ju6neRyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/204] net: dsa: microchip: ksz9477: port map correction in ALU table entry register
Date: Mon, 30 Jan 2023 14:50:53 +0100
Message-Id: <20230130134320.210451815@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>

[ Upstream commit 6c977c5c2e4c5d8ad1b604724cc344e38f96fe9b ]

ALU table entry 2 register in KSZ9477 have bit positions reserved for
forwarding port map. This field is referred in ksz9477_fdb_del() for
clearing forward port map and alu table.

But current fdb_del refer ALU table entry 3 register for accessing forward
port map. Update ksz9477_fdb_del() to get forward port map from correct
alu table entry register.

With this bug, issue can be observed while deleting static MAC entries.
Delete any specific MAC entry using "bridge fdb del" command. This should
clear all the specified MAC entries. But it is observed that entries with
self static alone are retained.

Tested on LAN9370 EVB since ksz9477_fdb_del() is used common across
LAN937x and KSZ series.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20230118174735.702377-1-rakesh.sankaranarayanan@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 379b38c5844f..bf788e17f408 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -675,10 +675,10 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 		ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
 
 		/* clear forwarding port */
-		alu_table[2] &= ~BIT(port);
+		alu_table[1] &= ~BIT(port);
 
 		/* if there is no port to forward, clear table */
-		if ((alu_table[2] & ALU_V_PORT_MAP) == 0) {
+		if ((alu_table[1] & ALU_V_PORT_MAP) == 0) {
 			alu_table[0] = 0;
 			alu_table[1] = 0;
 			alu_table[2] = 0;
-- 
2.39.0



