Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211D32D0F3;
	Mon, 27 Oct 2025 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592853; cv=none; b=oUH3QHaV1fmEn9TYXXhCI0QnPSyKeXr1KSAe9K6TZmyEjYYNZBfsLm/rJoNL0Ov76kn69Ls9k+DWFIQWjOc0T12dJudCxsIiF3X0+2ux08u5F3WHykiZ0l8jaQq8d6FcSshlAY9pA1P/r0dP6lZF0QoOnuzBR1KlQBCLWXPF0p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592853; c=relaxed/simple;
	bh=292B6WWz/2szK09Jnn/U3OjRosl6WSgXzEErJ1YSbjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUXzoiKaliaOLf7lEzhuGf9OuXHIaW1DeJWHSfsohgQOzvSXJixMN9f6BX7v7oNNK98oTKGr26xrrLliqIIxbyMLfLb7pDDxjjIdmmwo1+hp2A+cvYa7bYh4CeXbZmHPdEWdTcQYOgvTEkhZt/7DknG16r/rYoLStzxk/H1a6rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhL3hIMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhL3hIMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0379C4CEF1;
	Mon, 27 Oct 2025 19:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592852;
	bh=292B6WWz/2szK09Jnn/U3OjRosl6WSgXzEErJ1YSbjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhL3hIMBZglVltyeippifFD+3EWYk5eWCOLQlzMaFDPSP+c3pm1+cUTXF+OIoqpEI
	 moWQ6zKcFCrZuy6Pv6eBABAYlHlkcNpN95xmAWU3x5K2YVbrZ8+vydM5HvD23h3pP7
	 /WoKavXDUzHhsbXch5yUu0aULw+3n7zR4wII2Ro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Mathew McBride <matt@traverse.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/117] dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path
Date: Mon, 27 Oct 2025 19:35:55 +0100
Message-ID: <20251027183454.755499544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c744e10e64033..f56a14e09d4a3 100644
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



