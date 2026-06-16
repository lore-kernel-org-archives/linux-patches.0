Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE77744CAF9;
	Tue, 16 Jun 2026 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625372; cv=none; b=sdqR9+kWhrecekXUxptjhURuiMaZVb0xQawnOmWZc4OlxclA63zzDn0xSX7eQLEX0F2KHdv+QvzMVevVpvvzGMl+5PW0yoTWWR3CVB+LDsDUH22iDbioArP5jZrYJmCjrOajFRAoETypO3UCV8SSjcAw/DJgYtIJIigQxB4eJsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625372; c=relaxed/simple;
	bh=IZ7GFdIo2VI5q6w8QD4NEe19ckuks7f3bjdBdb8NESM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxQod7qzUm8eFJNXuA4On7xNWCYCV0DfTiWCf4o/Gu9MZxhzGNXEnU123TuRej4PN9IWWYB4UHa856a75ESwo4PWnM0YjIpjbGsFBfybIYyxJHbbiSKIwMI0TTFLLfWUwPmV06YUkX8/ufDgG+i9//88soY4eG6jep10i7YH2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JayIVQJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JayIVQJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87D21F000E9;
	Tue, 16 Jun 2026 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625371;
	bh=6cncp2XO25urVt+2rD97ZuujWfrPNp9IRCTOheP6gPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JayIVQJbaV0TX9CT7h8JDaMb6wfPP2ArUr0KrgHcumSxbDx9S8BUM1+M9RshGPLNZ
	 sAN2whA4dgUacvpcHPx86cr5yJPaAPxDFshBTHOG3lW27hgXYL9NTMkKraXcjfq/2T
	 zzjuo6dW1HTDUiY/aFX9aY8pW9zLnVEE0TjrgXwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/325] net: mvpp2: limit XDP frame size to the RX buffer
Date: Tue, 16 Jun 2026 20:28:46 +0530
Message-ID: <20260616145104.203684813@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Til Kaiser <mail@tk154.de>

[ Upstream commit f3c6aa078927e6fe8121c9c591ddee8716c5305a ]

mvpp2 has short and long BM pools, and short pool buffers can be smaller
than PAGE_SIZE. The XDP path nevertheless initializes every xdp_buff with
PAGE_SIZE as frame size.

XDP helpers use frame_sz to validate tail growth and to derive the hard
end of the data area. Advertising PAGE_SIZE for short buffers can let
bpf_xdp_adjust_tail() grow a packet past the real allocation, corrupting
memory or later tripping skb tailroom checks.

Initialize the XDP buffer with bm_pool->frag_size so XDP tailroom matches
the actual buffer backing the packet.

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Signed-off-by: Til Kaiser <mail@tk154.de>
Link: https://patch.msgid.link/20260607134943.21996-3-mail@tk154.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5ef8637d408015..814b60b16a23dc 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3981,7 +3981,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			else
 				xdp_rxq = &rxq->xdp_rxq_long;
 
-			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
+			xdp_init_buff(&xdp, bm_pool->frag_size, xdp_rxq);
 			xdp_prepare_buff(&xdp, data,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
 					 rx_bytes, true);
-- 
2.53.0



