Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2061E0DD8;
	Wed, 30 Sep 2026 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787372; cv=none; b=MOf+S5hzQJlCUKm3mgNwam31wlwIWkkVZydgNhrCHW/AMO6SKTJm7Mda3lsQlvhDOGcT05D4nvafdZI0NoIYqKG+L9DYCnvfSjDPw3XWT8RtQkHQsHb/GpTj7jJT5iJNazKYtT36/SLTTm1FcM8WhO5Cm0iE/7Ry8zgo6zQz4Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787372; c=relaxed/simple;
	bh=1Ad9Nn//2Prxe9VIPAyBr5n6Aoz+t5KnrivL6CLzUXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgTKN5pUbxNKqnRP2xTkh1ZRZkAzZ08+Vz4SRCqtdXrxbL+HqZRd9RLCujBjkuJ/xAaVfKxiMiQACQl4RO0NlZtczVWdg5ytsUUJUBEXa/2Roe9l+RPaPovHqzo3fevglJWBg8o3iUOiGSWvDWLpN48eohLxm6I80hEL+MOqPSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLBSzpj6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLBSzpj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6D31F000FF;
	Wed, 30 Sep 2026 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787371;
	bh=O4AheYDsF+SZN5rWz8mY6QO1gr19no9+sGz76q0Uw74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLBSzpj6J3haJPdn12D7G9cokdt0vuz9TgOBSwOHDUCEBRsXqdsiLboUBbFesKXQZ
	 N/prSeQg8kblzuBq0UI80lBN4wuqqhN8OGj1Q8U0g/R5YtfoX9mqlE0KBb/bBXWURZ
	 wtfiuexitZeepng9oEqEclcE12r8ndq4n9Un6lsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 162/457] net: stmmac: size the RX buffers from the frame length, not the MTU
Date: Wed, 30 Sep 2026 17:24:27 +0200
Message-ID: <20260930152349.547030659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit b8a26d46c0a4254f8bfe143681adb9d18d020299 ]

When picking the buffsize to use based on the MTU, we shouldn't check
only the MTU value, but also :
 - ETH_HLEN for the L2 header,
 - up to 2 VLAN tags,
 - the FCS,

The default bufsize is 1536 bytes, which is enough to contain all the
above so this hasn't surfaced before, but the addition of NET_IP_ALIGN
to the start of buffer address tripped the Jumbo selftest, leading to
this discovery.

With that, we don't need the '>=' checks on the buffer len, we can use
more consistent comparison operators in stmmac_set_bfsize.

Fixes: 286a83721720 ("stmmac: add CHAINED descriptor mode support (V4)")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260917215339.2022523-7-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5f717f02c3c01..9c4d92a19f2c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1536,17 +1536,17 @@ static unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 	return NET_SKB_PAD + NET_IP_ALIGN;
 }
 
-static int stmmac_set_bfsize(int mtu)
+static int stmmac_set_bfsize(int len)
 {
 	int ret;
 
-	if (mtu >= BUF_SIZE_8KiB)
+	if (len > BUF_SIZE_8KiB)
 		ret = BUF_SIZE_16KiB;
-	else if (mtu >= BUF_SIZE_4KiB)
+	else if (len > BUF_SIZE_4KiB)
 		ret = BUF_SIZE_8KiB;
-	else if (mtu >= BUF_SIZE_2KiB)
+	else if (len > BUF_SIZE_2KiB)
 		ret = BUF_SIZE_4KiB;
-	else if (mtu > DEFAULT_BUFSIZE)
+	else if (len > DEFAULT_BUFSIZE)
 		ret = BUF_SIZE_2KiB;
 	else
 		ret = DEFAULT_BUFSIZE;
@@ -4063,7 +4063,7 @@ static struct stmmac_dma_conf *
 stmmac_setup_dma_desc(struct stmmac_priv *priv, unsigned int mtu)
 {
 	struct stmmac_dma_conf *dma_conf;
-	int bfsize, ret;
+	int bfsize, len, ret;
 	u8 chan;
 
 	dma_conf = kzalloc_obj(*dma_conf);
@@ -4073,13 +4073,15 @@ stmmac_setup_dma_desc(struct stmmac_priv *priv, unsigned int mtu)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* Returns 0 or BUF_SIZE_16KiB if mtu > 8KiB and dwmac4 or ring mode */
-	bfsize = stmmac_set_16kib_bfsize(priv, mtu);
+	len = mtu + ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN;
+
+	/* Returns 0 or BUF_SIZE_16KiB if len > 8KiB and dwmac4 or ring mode */
+	bfsize = stmmac_set_16kib_bfsize(priv, len);
 	if (bfsize < 0)
 		bfsize = 0;
 
 	if (bfsize < BUF_SIZE_16KiB)
-		bfsize = stmmac_set_bfsize(mtu);
+		bfsize = stmmac_set_bfsize(len);
 
 	dma_conf->dma_buf_sz = bfsize;
 	/* Chose the tx/rx size from the already defined one in the
-- 
2.53.0



