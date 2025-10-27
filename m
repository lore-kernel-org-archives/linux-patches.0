Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CF018A6A5;
	Mon, 27 Oct 2025 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592593; cv=none; b=f3N0oEIEqa1elCcauXiQR6gYtjysj0ZcSg1nilrc7J/Lo3h/aMzGvua5YwGWgUaUd53aWkTuFHp+2tM9YeZHeM6J49u0gVWN2ban/y8vmgpNRWZltaqDyx48+59Dg5OkDHdefR4McyzYhe97moCSW7Yhpr0EPHopSnkc4XO3fw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592593; c=relaxed/simple;
	bh=+/K9wBj83DiMypM7EUtZdHfYp8JEAcN/ZNXL/rH9Eec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6UgIQB86e9gCQgY1WjSGKFNGABR7Sg0r4lHufBlIoWwJs55E0xuDOrdcsaPDc1qXWEiW2gW2KyhDfAXwxULbnkcppe7T9lE1bQ0EsZnPP72+r83fWlifVmkmoT7HvQa4T0HfXSIllnkTIsnGlnfr45RZfJfpIxzBiTNhNFb1To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMxA71F4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMxA71F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DB4C4CEF1;
	Mon, 27 Oct 2025 19:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592593;
	bh=+/K9wBj83DiMypM7EUtZdHfYp8JEAcN/ZNXL/rH9Eec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMxA71F4h95lFdfKCC4nIZ0SrrMohrUCMeV6GAqzRIti4q7ea3YOGkE7bMadL+GvM
	 7DNUkzF7GbwbixSm+ZCnwA5N3T6doToExkpJvkKYxaJp/3LqVCVP0UFI6eshl2nsKe
	 rBH1010bSHOIGFnlc9QlGDwWm/snFrYme5QQsCuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Mathew McBride <matt@traverse.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/84] dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path
Date: Mon, 27 Oct 2025 19:36:11 +0100
Message-ID: <20251027183439.410206889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 902e81e679d86846a2404630d349709ad9372d0d ]

The blamed commit increased the needed headroom to account for
alignment. This means that the size required to always align a Tx buffer
was added inside the dpaa2_eth_needed_headroom() function. By doing
that, a manual adjustment of the pointer passed to PTR_ALIGN() was no
longer correct since the 'buffer_start' variable was already pointing
to the start of the skb's memory.

The behavior of the dpaa2-eth driver without this patch was to drop
frames on Tx even when the headroom was matching the 128 bytes
necessary. Fix this by removing the manual adjust of 'buffer_start' from
the PTR_MODE call.

Closes: https://lore.kernel.org/netdev/70f0dcd9-1906-4d13-82df-7bbbbe7194c6@app.fastmail.com/T/#u
Fixes: f422abe3f23d ("dpaa2-eth: increase the needed headroom to account for alignment")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Mathew McBride <matt@traverse.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251016135807.360978-1-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 81a99f4824d05..61bd2389ef4b5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1077,8 +1077,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	dma_addr_t addr;
 
 	buffer_start = skb->data - dpaa2_eth_needed_headroom(skb);
-	aligned_start = PTR_ALIGN(buffer_start - DPAA2_ETH_TX_BUF_ALIGN,
-				  DPAA2_ETH_TX_BUF_ALIGN);
+	aligned_start = PTR_ALIGN(buffer_start, DPAA2_ETH_TX_BUF_ALIGN);
 	if (aligned_start >= skb->head)
 		buffer_start = aligned_start;
 	else
-- 
2.51.0



