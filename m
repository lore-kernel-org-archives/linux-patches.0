Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975EE28505A;
	Tue, 12 Aug 2025 19:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026607; cv=none; b=mKRdL3q9svXWzp4IS6nH7RyR4tRxkk4ZzI7r3v6MvCkK32kO1tpA+kvXdUnztgclK7VR1LLGOMNUwpNid49TG611GCjUD1cgWRB41r+huStNKfk2XOL3YZVmoeGURtCeaFp8lYfOQEKFPeFHENOG5uqfqfUhPLIjAxdpcRMGn4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026607; c=relaxed/simple;
	bh=7CC87HteXyE+yOO9rY8FIVVU5TWfgk2afTCzgGLsMeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy4ArLBQyj87TXuAMNZyMZ86/3j5rh07vmH/5RTOIL/in0OOKDwdqm9JnfV8o5GMsfBvXI8bvO4gPDVsMjLq8Il4miFOHMsneT/EhHqR2RproHSgBDwixOmrAjuqxJztS4uJgdKjwPyBcHL0T9J8nTNZceTi+SHLeSZUmwKrN5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBY2H2u1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBY2H2u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D78C4CEF4;
	Tue, 12 Aug 2025 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026607;
	bh=7CC87HteXyE+yOO9rY8FIVVU5TWfgk2afTCzgGLsMeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBY2H2u1zhjJakFKFqUFhK+7kU0ccxog3St2LCpsxrXheorRYwBuWyx7U4X9+kbAK
	 sEt/S4c9GmPmgXPH2WOZXQwYIk5q4AfsY4uhFepytu8RCWzydVgCStymcwiCszTq6n
	 hdGjFTONgZn801tccP/9r6VOkHHYdHGO6YA/cTDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 387/480] phy: mscc: Fix parsing of unicast frames
Date: Tue, 12 Aug 2025 19:49:55 +0200
Message-ID: <20250812174413.398507608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 6fb5ff63b35b7e849cc8510957f25753f87f63d2 ]

According to the 1588 standard, it is possible to use both unicast and
multicast frames to send the PTP information. It was noticed that if the
frames were unicast they were not processed by the analyzer meaning that
they were not timestamped. Therefore fix this to match also these
unicast frames.

Fixes: ab2bf9339357 ("net: phy: mscc: 1588 block initialization")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250726140307.3039694-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 1 +
 drivers/net/phy/mscc/mscc_ptp.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 6b800081eed5..275706de5847 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -900,6 +900,7 @@ static int vsc85xx_eth1_conf(struct phy_device *phydev, enum ts_blk blk,
 				     get_unaligned_be32(ptp_multicast));
 	} else {
 		val |= ANA_ETH1_FLOW_ADDR_MATCH2_ANY_MULTICAST;
+		val |= ANA_ETH1_FLOW_ADDR_MATCH2_ANY_UNICAST;
 		vsc85xx_ts_write_csr(phydev, blk,
 				     MSCC_ANA_ETH1_FLOW_ADDR_MATCH2(0), val);
 		vsc85xx_ts_write_csr(phydev, blk,
diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_ptp.h
index da3465360e90..ae9ad925bfa8 100644
--- a/drivers/net/phy/mscc/mscc_ptp.h
+++ b/drivers/net/phy/mscc/mscc_ptp.h
@@ -98,6 +98,7 @@
 #define MSCC_ANA_ETH1_FLOW_ADDR_MATCH2(x) (MSCC_ANA_ETH1_FLOW_ENA(x) + 3)
 #define ANA_ETH1_FLOW_ADDR_MATCH2_MASK_MASK	GENMASK(22, 20)
 #define ANA_ETH1_FLOW_ADDR_MATCH2_ANY_MULTICAST	0x400000
+#define ANA_ETH1_FLOW_ADDR_MATCH2_ANY_UNICAST	0x200000
 #define ANA_ETH1_FLOW_ADDR_MATCH2_FULL_ADDR	0x100000
 #define ANA_ETH1_FLOW_ADDR_MATCH2_SRC_DEST_MASK	GENMASK(17, 16)
 #define ANA_ETH1_FLOW_ADDR_MATCH2_SRC_DEST	0x020000
-- 
2.39.5



