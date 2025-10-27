Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1665230F526;
	Mon, 27 Oct 2025 19:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592429; cv=none; b=bmwaoZ1wjXCh93zxsZkYCnQ5F0d2fK4f2JoQp8fR13kHDUbM0b8HMHCz0lXqW1JExcBBuT3X5WF7nWTOiFMeaLqGmVDwEAksd+Kqzcl4Jkn5gtxco5DlU2Tqg9/F0R27le2TooEmWnMi7PFd31Uvtd10Q7ALZsTGcmLxp0DSQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592429; c=relaxed/simple;
	bh=z9LLTJCLhInpL3RnrLtGZjAfqeQ5f227wMm0RFccz7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVi+9faMWQCjBSYHqq4HR6nyaXtVjwoOvjw47Z45dSVVKNt00bY97SAJUiUhuqfJdjDPqNpf5ytSqTZ+VhqFsNqphlQUN7D2YkpdAijXqPo6WYZ852toQe92h6KacpruKSyWJWL8JzAd/pEl3kfEb6zNZzLEJwcfTL6FY2leYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+R7Vu5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+R7Vu5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FADAC4CEF1;
	Mon, 27 Oct 2025 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592429;
	bh=z9LLTJCLhInpL3RnrLtGZjAfqeQ5f227wMm0RFccz7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+R7Vu5QsZkzuJKavTawdxzr2yGODwbh15arZLDqj9+aOCHxzs+xx+6htytKZt+I1
	 s+bvqPLKlrM1Gsyk8F96pUQmwVtlo8L5Tahu5cRM+I3JkmJ1y2p0mNs68ptxNrjcqw
	 bUV17PipYW+zAQCEo5wNd311gR0lgVTF0/sOqCEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Mathew McBride <matt@traverse.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/157] dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path
Date: Mon, 27 Oct 2025 19:35:45 +0100
Message-ID: <20251027183503.525564565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dbc40e4514f0a..3c19be56af22e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1046,8 +1046,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
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



