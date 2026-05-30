Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8F22367DF;
	Sat, 30 May 2026 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167171; cv=none; b=JdhFadZ/lnN+OASo/dzmVLy8X5yYVubN9RlwmXcz4C5mp2p/oFrGsrAyxy6DIXKHp0fLQwyl0F7HLV0MF92SB0cqaW0t2QKU/Nvmmuzt1UE+A0iLWqhjP2it7NplXLm5txHXJu3RGMmSkR7Jvq9sdwJ1FzUBgvYAPAPw4TQvkQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167171; c=relaxed/simple;
	bh=zEGL+DyYwle50YuZB0f+00c01aeR512oJTvoXXYiuNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmlvpQ8SNEHXT8SdQ0pFlPlE2hc66MUP6RCVur+kA3gGVUJNGlGG9hkCu5cS8yVfloSwZYREkTwTJGSnmvl9ymbtJHmXYHtzM33Ptz3VpAvyOR94tckYIDTKLn2jOsNvd1NI5dD+0BmdCN4+Uc1AXLedDeOMpj8pCQ7eDMYFx/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsYuyio/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsYuyio/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EE01F00893;
	Sat, 30 May 2026 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167168;
	bh=BiMgWx7ZkCETncGHImSDCe3UdeL4g9QBsQvZCZ2MVS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsYuyio/UJWBAxkp2/IaEgq8PEVyijiTfkm8WnG7y4lTYS9q9FAjMeWu9drDegdVF
	 2nNNnHa2PkdEgYuI464glGk3WmsmY4BHDjYozkQ6qNe4U6CS2BUkh5FyKTLgX+OqS/
	 b34iNOc6NFXeOGcx+LYBbzOGk/E4a7BU1Rh7FK5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haarmann-Thiemann <eitschman@nebelreich.de>,
	Linus Walleij <linusw@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 576/589] net: ethernet: cortina: Drop half-assembled SKB
Date: Sat, 30 May 2026 18:07:37 +0200
Message-ID: <20260530160239.746969162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Haarmann-Thiemann <eitschman@nebelreich.de>

[ Upstream commit b266bacba796ff5c4dcd2ae2fc08aacf7ab39153 ]

In gmac_rx() (drivers/net/ethernet/cortina/gemini.c), when
gmac_get_queue_page() returns NULL for the second page of a multi-page
fragment, the driver logs an error and continues — but does not free the
partially assembled skb that was being assembled via napi_build_skb() /
napi_get_frags().

Free the in-progress partially assembled skb via napi_free_frags()
and increase the number of dropped frames appropriately
and assign the skb pointer NULL to make sure it is not lingering
around, matching the pattern already used elsewhere in the driver.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Andreas Haarmann-Thiemann <eitschman@nebelreich.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260505-gemini-ethernet-fix-v2-1-997c31d06079@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ee51367df6488..642ef6b3eebaf 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1463,6 +1463,11 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			if (skb) {
+				napi_free_frags(&port->napi);
+				port->stats.rx_dropped++;
+				skb = NULL;
+			}
 			continue;
 		}
 		page = gpage->page;
-- 
2.53.0



