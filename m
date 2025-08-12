Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF141268C73;
	Tue, 12 Aug 2025 17:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021135; cv=none; b=Nw2JACBPQ/gUs8BEceVtaTUUZRQTkLNgR9jcd1IZoeM6hPvfzNfjLfI4UiX+cg7FvkEUJMYd1cnuUspEIHlgRZ/OMhwaDut9TY5CDOkbPjlKKj1KCIEl4R70Jfo3aQaqDS2+h8WgSZd8GNJc6Qf68HZdd8pN0foAefo7IIC9JQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021135; c=relaxed/simple;
	bh=UwqpBYWoJiZ+dGM+atPHE4JUiK9AbTYWPtJvKnDYO6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJeCm62WXn5cY5EvyzlfGgL0PsUx8D0TCq6PP6tneIByCPa7iwuzLnhN9t7XxaxAyTh4RQreG4Vp6rIkvYEhoPcw0UeZ9KvuXzu3SYd6UelBdUME6nkYcZB4sZezPTWwYla/GnfYuRX3apu091Tik2lWzxOgj1MYKVIhQN52L+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/kMnenO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/kMnenO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D967C4CEF0;
	Tue, 12 Aug 2025 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021134;
	bh=UwqpBYWoJiZ+dGM+atPHE4JUiK9AbTYWPtJvKnDYO6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/kMnenOkIELI7FcjHihs1lh4ZgUJouRl50pLIgF4WQ+4sqs2JWqK6iXFRGKEEzZ0
	 YP0fgXJS7A3W7mLCR/3+BP/B/ORUHvibEVw6ziiigCCS1qxGfBVyZaOdPeDbEA0WpB
	 VY2fVJGi7+ZoldfIu/anPvWZ4hu+Au1IzgW4R96M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/253] phy: mscc: Fix parsing of unicast frames
Date: Tue, 12 Aug 2025 19:30:07 +0200
Message-ID: <20250812172958.158262958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e7ce79eadff..d0bd6ab45ebe 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -897,6 +897,7 @@ static int vsc85xx_eth1_conf(struct phy_device *phydev, enum ts_blk blk,
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



