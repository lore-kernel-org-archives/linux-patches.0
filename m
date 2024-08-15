Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A204417BEA5;
	Thu, 15 Aug 2024 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730004; cv=none; b=gmx+QONl32dEWMBGcpNMVP0jZoizFS1NsKhM69cDliFkK7dKhqFs5Ftlp1faZEWBJUDQe6eER0+qnM4/51ZevOdRXsrMdhe7yl30UhrCtVbeZFXVkE+OF1caB/gRzlQ6oElmUvZT13rNfRsaN3L1ID7hjiBU12u0Bb2DsOJXli4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730004; c=relaxed/simple;
	bh=XL0+tSD6FvqPk4RWhehTwwUa0CUnbm797NVleGAl87I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7Swk0NFNNA9Cbu0T/xU7wwjhlwpeKhb0RFUTSbGLoPSfiNHk/whs5HUUd5+wcDo22EfcImoH4RW/Odbt9YowQ06u1wR3erTTOEWysS/Sss4BXdE9vi/Lz7nyCju/lFlZRK9irRyx3OAxA3rzxCDQs7QBxskEUBL6ZBtTcsOtZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rACcIWqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rACcIWqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD1EC4AF0C;
	Thu, 15 Aug 2024 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730004;
	bh=XL0+tSD6FvqPk4RWhehTwwUa0CUnbm797NVleGAl87I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rACcIWqSN1LOgL5ChEJZMgxrnc6Ya2gJnSbiU7obDIlneC/dZiVTJVznG8RpZSOWe
	 w0xjyJkoUcxCPMnYZxBubYfZx7NvqaC5bQjxcY6k4ALO1mTyYRfT85AjDPI08yGExG
	 SdrU+0/bmZnTYuFtRKDFrWESxab1PSO12/Xyzs0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/484] net: stmmac: Correct byte order of perfect_match
Date: Thu, 15 Aug 2024 15:22:13 +0200
Message-ID: <20240815131952.028172943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit e9dbebae2e3c338122716914fe105458f41e3a4a ]

The perfect_match parameter of the update_vlan_hash operation is __le16,
and is correctly converted from host byte-order in the lone caller,
stmmac_vlan_update().

However, the implementations of this caller, dwxgmac2_update_vlan_hash()
and dwxgmac2_update_vlan_hash(), both treat this parameter as host byte
order, using the following pattern:

	u32 value = ...
	...
	writel(value | perfect_match, ...);

This is not correct because both:
1) value is host byte order; and
2) writel expects a host byte order value as it's first argument

I believe that this will break on big endian systems. And I expect it
has gone unnoticed by only being exercised on little endian systems.

The approach taken by this patch is to update the callback, and it's
caller to simply use a host byte order value.

Flagged by Sparse.
Compile tested only.

Fixes: c7ab0b8088d7 ("net: stmmac: Fallback to VLAN Perfect filtering if HASH is not available")
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c   | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h          | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 026e3645e566a..e5c5a9c5389c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -972,7 +972,7 @@ static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 }
 
 static void dwmac4_update_vlan_hash(struct mac_device_info *hw, u32 hash,
-				    __le16 perfect_match, bool is_double)
+				    u16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index dd73f38ec08d8..813327d04c56f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -582,7 +582,7 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 }
 
 static void dwxgmac2_update_vlan_hash(struct mac_device_info *hw, u32 hash,
-				      __le16 perfect_match, bool is_double)
+				      u16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 58e5c6c428dc0..414b63d5b9ebe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -370,7 +370,7 @@ struct stmmac_ops {
 			     struct stmmac_rss *cfg, u32 num_rxq);
 	/* VLAN */
 	void (*update_vlan_hash)(struct mac_device_info *hw, u32 hash,
-				 __le16 perfect_match, bool is_double);
+				 u16 perfect_match, bool is_double);
 	void (*enable_vlan)(struct mac_device_info *hw, u32 type);
 	int (*add_hw_vlan_rx_fltr)(struct net_device *dev,
 				   struct mac_device_info *hw,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b0ab8f6986f8b..a5cbb495b5581 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6237,7 +6237,7 @@ static u32 stmmac_vid_crc32_le(__le16 vid_le)
 static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 {
 	u32 crc, hash = 0;
-	__le16 pmatch = 0;
+	u16 pmatch = 0;
 	int count = 0;
 	u16 vid = 0;
 
@@ -6252,7 +6252,7 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 		if (count > 2) /* VID = 0 always passes filter */
 			return -EOPNOTSUPP;
 
-		pmatch = cpu_to_le16(vid);
+		pmatch = vid;
 		hash = 0;
 	}
 
-- 
2.43.0



