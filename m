Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022314;
	b=UyTLppHwVJzRb2ZKELWiEaLacBT+e79Kl3v8wKo1foT1hL9XMrYct6t6j9Dt0aCh1qvN
	 h6OY4EBKfUysFNLpZF1xZF7irCTKVBH15whmbBKMh47KBXBV/T1bvZxGBoz50QrhxpFhc
	 XOyqzfm+FWpWH5ZX5acZzIm+8VhgV3GYe7s9o4aK+CsdeeSEENzSHQeDDB21gGxsb3Zv4
	 1fUu+qFDbxd8CCZdVl482H8hdNCnQ43T6UIBlA7iqbY9plHRcXTLtT97vIOohGkd0XoWQ
	 DxXBkNBTpd89Id1oNm7ZIjiwZ7f14AEqvFIntpGzPMxqoSYbkivmpDSdc/WxXk5wpdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwqJDrRV7CCsvMx8ewc3b5XyCK+G5XWHi8b3fb610T0=;
	b=oTsHm1K1Qq2hs/ZjfX4+dQhhQHjGHLtAvduGimno68+qKPSn+fmFalZ7OdroN4KNZbNF
	 RVBwc64NMQhRmilPiFyc1o8zO0RPDqgo7UKZnlcuy8uv5xpj05jFqVqS6BNDkSEvYW1Jx
	 pKNQ7NKf9GQKbqVW6tJEDvgPDXTEla1GqpFEbEcqfiqcPKuct3Hojyh6JgLB90vtWUEy+
	 9nOhk7O85+6ShObUFQn5beYCLGKtEYpcUJS0iPbZSuwbyDTucSiuObd6ydc99dJTpwsvg
	 5UCC6nC+UVAGNcki656wmTivdV0MeVLucI45MtfADgRpi0xz249loXClONFPJBSVaUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEJB42YS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54866606A31C;
	Wed, 18 Nov 2026 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEJB42YS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954D41F000C4;
	Wed, 18 Nov 2026 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022314;
	bh=kwqJDrRV7CCsvMx8ewc3b5XyCK+G5XWHi8b3fb610T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEJB42YSZYeT/C9iih6UZirMxMYC7tiGnEu9gAZm1K4hpXLlX7yhZRhW/BSZJFWfD
	 UsgqHRF9Db+k7Z2TR4uu4dytnvQSqvYqGSzTydYrFaEzhLE0FXSasC1h4TyRw74s+X
	 R2X2wGd5/oJpw69wMDC+7aTcNfCkTx0GGFSP8a9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2617/2651] eth: bnxt: free XDP frags when xdp_do_redirect() fails
Date: Wed, 18 Nov 2026 16:04:17 +0100
Message-ID: <20261118150418.441678273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c10f3420d59859df107838aa97b49357616d9b47 ]

When xdp_do_redirect() fails bnxt_rx_xdp() recycles the head page but
not the frags of a multi-buffer frame. Their agg ring slots have
already been refilled, so the pages leak, and the page pool can't be
destroyed until they are returned, which will never happen. Redirect
to an AF_XDP socket in copy mode fails this way with -ENOMEM whenever
the socket's fill ring runs out of buffers.
A socket bound without XDP_USE_SG also fails with -ENOSPC for every
frame that doesn't fit in a single chunk.

All the other drop paths in this function free the frags.

Pointed out in LLM review of the first patch of the series.
Tested on a BCM57504 at MTU 9000 by redirecting 60k 8000B ICMPv6
echo requests (a head and two agg buffers each) to lo, which can't
transmit XDP frames. The page pools' inflight count stayed flat
rather than growing by two pages per frame.

Fixes: a7559bc8c17c ("bnxt: support transmit and free of aggregation buffers")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 96845c8646e06..161e0dd62be60 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -307,6 +307,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
 		}
-- 
2.53.0



