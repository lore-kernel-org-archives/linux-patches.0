Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B7A78B4E;
	Mon, 15 Apr 2024 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191427; cv=none; b=HoOpkhwnrRVy9KGKe4De/CB24olhZymppHNyzS0q9jsI+MfqPfrrnnIVaf8E80Iw8LXxwD2FNg6RHfILcArpdWrH2W377MiHglA8C4w/ro+Mso+CfQ4de3q9Dzyyja3lkz+F/k0LCs99uKyoqxbA6PTPnNt1YYrGWc5CQ1QFjWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191427; c=relaxed/simple;
	bh=ITZlUpN05NMkit5qFN5IBivXAQQ0tqHigofUMIOVX84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QX1dbK880n1QoHBDMkcWCsihI6t43Xuo2KTdnwF8WO+64C+FfE+pPfkcfB+lxwwVpOJp6Oam3jM+GDF1Mw0VJhs//bZhGZ1Ws3c/rzS8OIn8lqgo+3L/0ZFS9TgikM2sBBIILK+xQxo0REiO1jXkuQ7oYIbQ6gGF8PUm+HPeEr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re9UALOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re9UALOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C40C2BD10;
	Mon, 15 Apr 2024 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191426;
	bh=ITZlUpN05NMkit5qFN5IBivXAQQ0tqHigofUMIOVX84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Re9UALOhAo36DXlf6KOx5Xj5vpaIkc2AC+0FIkh6jldSb1Buujra8HjOVOdC0aHye
	 CMZvXMN6Z6kAEE1jy4CER7Vdc/lI077DhWlpUt2sdlPjbSr+81gDbIm+oqp2ntBFCd
	 UPxx02gBHCBgFs6D6uc80aHWffkMVqTApqH6F4jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 099/172] net: ena: Set tx_info->xdpf value to NULL
Date: Mon, 15 Apr 2024 16:19:58 +0200
Message-ID: <20240415142003.406305483@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 36a1ca01f0452f2549420e7279c2588729bd94df ]

The patch mentioned in the `Fixes` tag removed the explicit assignment
of tx_info->xdpf to NULL with the justification that there's no need
to set tx_info->xdpf to NULL and tx_info->num_of_bufs to 0 in case
of a mapping error. Both values won't be used once the mapping function
returns an error, and their values would be overridden by the next
transmitted packet.

While both values do indeed get overridden in the next transmission
call, the value of tx_info->xdpf is also used to check whether a TX
descriptor's transmission has been completed (i.e. a completion for it
was polled).

An example scenario:
1. Mapping failed, tx_info->xdpf wasn't set to NULL
2. A VF reset occurred leading to IO resource destruction and
   a call to ena_free_tx_bufs() function
3. Although the descriptor whose mapping failed was freed by the
   transmission function, it still passes the check
     if (!tx_info->skb)

   (skb and xdp_frame are in a union)
4. The xdp_frame associated with the descriptor is freed twice

This patch returns the assignment of NULL to tx_info->xdpf to make the
cleaning function knows that the descriptor is already freed.

Fixes: 504fd6a5390c ("net: ena: fix DMA mapping function issues in XDP")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_xdp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_xdp.c b/drivers/net/ethernet/amazon/ena/ena_xdp.c
index fc1c4ef73ba32..34d73c72f7803 100644
--- a/drivers/net/ethernet/amazon/ena/ena_xdp.c
+++ b/drivers/net/ethernet/amazon/ena/ena_xdp.c
@@ -89,7 +89,7 @@ int ena_xdp_xmit_frame(struct ena_ring *tx_ring,
 
 	rc = ena_xdp_tx_map_frame(tx_ring, tx_info, xdpf, &ena_tx_ctx);
 	if (unlikely(rc))
-		return rc;
+		goto err;
 
 	ena_tx_ctx.req_id = req_id;
 
@@ -112,7 +112,9 @@ int ena_xdp_xmit_frame(struct ena_ring *tx_ring,
 
 error_unmap_dma:
 	ena_unmap_tx_buff(tx_ring, tx_info);
+err:
 	tx_info->xdpf = NULL;
+
 	return rc;
 }
 
-- 
2.43.0



