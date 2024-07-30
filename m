Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5751A76A4;
	Tue, 30 Jul 2024 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359982; cv=none; b=YkTucvPBTm6Nh/rfyS1A5mnPPyshi8R6UmqhEU4cFpA87ZZ5OzQbYcbWScHq3jNJRxuCf4Yo3E3LthJy3nzqEvh06MRWTd7rQ8AR8JRke2VFK2GpbhBv8JjDvo1tNVnp53GoRwemjJo+mEnbk7klp2CLdevZqxUJHXWeG/n0k6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359982; c=relaxed/simple;
	bh=dLf63wSIvIu3rqqUwLKCVUQrCC8TfpKHKWU9QSlM0PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eESXF3k2WxplUck36XdxO41BOCdnMyyz/HN84jz76unnXVZNWmCfrD1E1DCmXhRXtfwvOKlmvN0+z7NV7VQdgKolYJTO4V/eV8oPENhoMkvoW3zJEVbANfsYWrZlHJ+FBpeQ57421qBsVyL3C4tIB4BnMIKdF+vXb9PbCiYXQdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrewbjBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrewbjBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9824EC32782;
	Tue, 30 Jul 2024 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359982;
	bh=dLf63wSIvIu3rqqUwLKCVUQrCC8TfpKHKWU9QSlM0PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrewbjBwI8p9eW/Az9P5iRgtvMg/epW6Pvq7jSmg+Qvlap+jqSml9JX6jpxjsxPq4
	 X6qadgjltmxA5lW0N9ErVv5Na3vY1Hn5fbs+aeebfNq7gfuCXTJ3ICX48sI06HHTbD
	 lDMGyChZ8VKe1t2pGLPhFsMYVyQ3anpLquPimzxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 541/568] net: stmmac: Correct byte order of perfect_match
Date: Tue, 30 Jul 2024 17:50:48 +0200
Message-ID: <20240730151701.304062331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ead0ddf43a7a..bf99495b51a9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -982,7 +982,7 @@ static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 }
 
 static void dwmac4_update_vlan_hash(struct mac_device_info *hw, u32 hash,
-				    __le16 perfect_match, bool is_double)
+				    u16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 8bc317d2f7a61..052566f5b7f36 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -615,7 +615,7 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 }
 
 static void dwxgmac2_update_vlan_hash(struct mac_device_info *hw, u32 hash,
-				      __le16 perfect_match, bool is_double)
+				      u16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 68aa2d5ca6e56..47fb8e1646c2e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -386,7 +386,7 @@ struct stmmac_ops {
 			     struct stmmac_rss *cfg, u32 num_rxq);
 	/* VLAN */
 	void (*update_vlan_hash)(struct mac_device_info *hw, u32 hash,
-				 __le16 perfect_match, bool is_double);
+				 u16 perfect_match, bool is_double);
 	void (*enable_vlan)(struct mac_device_info *hw, u32 type);
 	int (*add_hw_vlan_rx_fltr)(struct net_device *dev,
 				   struct mac_device_info *hw,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 19c58ad8df345..d6167a7b19f21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6473,7 +6473,7 @@ static u32 stmmac_vid_crc32_le(__le16 vid_le)
 static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 {
 	u32 crc, hash = 0;
-	__le16 pmatch = 0;
+	u16 pmatch = 0;
 	int count = 0;
 	u16 vid = 0;
 
@@ -6488,7 +6488,7 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 		if (count > 2) /* VID = 0 always passes filter */
 			return -EOPNOTSUPP;
 
-		pmatch = cpu_to_le16(vid);
+		pmatch = vid;
 		hash = 0;
 	}
 
-- 
2.43.0



