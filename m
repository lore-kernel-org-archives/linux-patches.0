Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A24BFE6D;
	Wed, 30 Sep 2026 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783067; cv=none; b=O47Giv2gpMWoF6iHGjZ8alzYp0A+wIt1NY40zm00I/wBnu4HPmBEU/vESajiMQ7t/c9efE4x/3ZwxPu2aG1s1oL4Tw9l7mrwtGSnWXngSGGUIHTtwwRJ6hZxTewo+zftq+2yCTVzKCybCk9rFpSKZKe1MSarYRrorfvFFGd2YiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783067; c=relaxed/simple;
	bh=OH3w0iENuQBreJl6Wl71sBKAuRSTEsO0Dqmb1ttC18s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD5JM9gHbYh5Z01i0TmA0BzjEg+4vJB8/dXNn4Pnr9GY8BGZKx8OHN9bu4J28RMsJRChxucltO7gP58ciampr/4zWXwP6bfwLYI2QRfpqH5okWjHLZk+pUATgV+4yu6CU+EJLGiMoa+VkU8LuncpX2BD9BA0BI2h6AO5Ls3UjYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGauZQpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGauZQpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BEF1F00898;
	Wed, 30 Sep 2026 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783063;
	bh=PYNw4rbnA/k//djbxeUSNjtCyKPtTQX9ytx7LBaMf48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGauZQpInAnNZAcGAT26qvyoF+gdlI4WE9IJpdKqdhuzpUcKgKhWvI6sU24ItVgBC
	 HbMBI9wc/XxEJWihZRZkmThw8aFEj5AGCMdDMNn30XMDLkNsGxuAdEAagD7t22cOHb
	 rAVsxX02QUptP/n9Cy2rk0n+4B6JYQsfO23dAxL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/595] net: ethernet: cortina: Count dropped frames as NAPI work
Date: Wed, 30 Sep 2026 17:22:41 +0200
Message-ID: <20260930152353.473618581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit b856c552f556bc0341c1dbe0bf88e630fd1dc4b7 ]

The RX loop only consumes budget when it successfully delivers a frame.
Error paths keep consuming descriptors without reducing the budget, so a
stream of bad frames can process the entire receive ring in one poll.

Move the budget accounting to a common end-of-frame path. This counts
each completed frame as NAPI work whether it was delivered or dropped,
matching the behavior of the vendor driver.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-3-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 96a899625288c..87be7b9f803be 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1471,7 +1471,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 				skb = NULL;
 				frag_nr = 0;
 			}
-			continue;
+			goto next_desc;
 		}
 		page = gpage->page;
 
@@ -1493,7 +1493,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 
 		} else if (!skb) {
 			put_page(page);
-			continue;
+			goto next_desc;
 		}
 
 		if (word3.bits32 & EOF_BIT)
@@ -1516,10 +1516,8 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			napi_gro_frags(&port->napi);
 			skb = NULL;
 			frag_nr = 0;
-			budget--;
-			received++;
 		}
-		continue;
+		goto next_desc;
 
 err_drop:
 		if (skb) {
@@ -1532,6 +1530,13 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			put_page(page);
 
 		port->stats.rx_dropped++;
+
+next_desc:
+		/* Final or single-descriptor fragment, advance things */
+		if (word3.bits32 & EOF_BIT) {
+			budget--;
+			received++;
+		}
 	}
 
 	port->rx_skb = skb;
-- 
2.53.0



