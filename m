Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063F21428EC;
	Thu, 13 Jun 2024 12:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282587; cv=none; b=sx40mZZ8hnEUfqsOMjzvytcfCBrhP0NiOUjjAAynXjtL7s47i685NpaP8npFFsb/K2+is1fPwVCoyu+t0fomaAL8HusNkXjWqErjhmwNV8e5/itt5UnPagFkUC1kU7nDwmG0+nouWQzV/lPTnL8CUlPD1p15hhjcfiRHGci9oFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282587; c=relaxed/simple;
	bh=lPuOTOwOKespks2pNa1tpA4iD+4dc6Borp+vxDK11jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3Z6NArk3208pK4k7ZM4hM/8zlTrQDd9VLUkRzMPo89m61HRE0nBkuYSt+kb27FWWi3Q/XVHxe+mWy1O64gswgZjuUEvOLIp6Xx4WsQNSqlgI777sg9qUFOkh6k+wQdQt/rw+j2uCmBnUs/9s5VVRrEovKfW4KWVaR83cK1NbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJjF5aT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJjF5aT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2C6C2BBFC;
	Thu, 13 Jun 2024 12:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282586;
	bh=lPuOTOwOKespks2pNa1tpA4iD+4dc6Borp+vxDK11jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJjF5aT6ieLAQuEshuJwyMcV/VlCV9Lf+GZOoM8QZuyPFrqmaB5uGn7zG055Aukn0
	 udzWrFp9AlG7mNU8yLhAZQsIG2Y9S5YAaV4FUTABNMt6ifV8YTMw7Jrt+sLH/+L+EV
	 TFQw3WdtMhiDPe/MOZ3KSWie9IREgnV/g3bUgh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Shay Agroskin <shayagr@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/402] net: ena: Do not waste napi skb cache
Date: Thu, 13 Jun 2024 13:34:45 +0200
Message-ID: <20240613113314.933163429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Hyeonggon Yoo <42.hyeyoo@gmail.com>

[ Upstream commit 7354a426e063e108c0a3590f13abc77573172576 ]

By profiling, discovered that ena device driver allocates skb by
build_skb() and frees by napi_skb_cache_put(). Because the driver
does not use napi skb cache in allocation path, napi skb cache is
periodically filled and flushed. This is waste of napi skb cache.

As ena_alloc_skb() is called only in napi, Use napi_build_skb()
and napi_alloc_skb() when allocating skb.

This patch was tested on aws a1.metal instance.

[ jwiedmann.dev@gmail.com: Use napi_alloc_skb() instead of
  netdev_alloc_skb_ip_align() to keep things consistent. ]

Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
Link: https://lore.kernel.org/r/YfUAkA9BhyOJRT4B@ip-172-31-19-208.ap-northeast-1.compute.internal
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2dc8b1e7177d ("net: ena: Fix redundant device NUMA node override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index cf8148a159ee0..e2b43d0f90784 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1418,10 +1418,9 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
 	struct sk_buff *skb;
 
 	if (!first_frag)
-		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
-						rx_ring->rx_copybreak);
+		skb = napi_alloc_skb(rx_ring->napi, rx_ring->rx_copybreak);
 	else
-		skb = build_skb(first_frag, ENA_PAGE_SIZE);
+		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
 
 	if (unlikely(!skb)) {
 		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,
-- 
2.43.0



