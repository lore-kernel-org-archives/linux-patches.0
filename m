Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B03C4178;
	Tue, 16 Jun 2026 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631650; cv=none; b=PLAVipVUOXwdFuUYDW/oxCkSmElYUnFuTNUAtM7WJfFMN4VTz0PscP1OSynkwOxxp8laVdC8lLzoIqtZcCgBC3ZTm6Ao9o1REWmToJ9MIErW4PY4OegDL3eWWAVBrU3RBPCgwa6q6wI53m0ra6hkdfz/T/sBxzd3xcCM/IUqy0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631650; c=relaxed/simple;
	bh=z0LSPMcZBO/1FeXpyZNhV/LYnBqHx/nvJuuZ2ZAM89o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDVXFnHhzh8lyDZ8rdpLCUSRqG/sGxkmKPdWtWe8EUWN5Wt8OgMOBakvnTtnqU2v6sLdtD1B9Qc/jfeEtX5ixlJFFAcI7yEeWkeNjr1qMST3lZhV82sQbDWNy5VK1E93XaWaAgTRkpHdfo/oeD45tj3NrY50qmgxeUHnJSitopQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYzURsjA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYzURsjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57461F000E9;
	Tue, 16 Jun 2026 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631648;
	bh=UZoeNewoRkb9zJiRMYYtMIbuugoZohcEHIu7HZVhPgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYzURsjAe80pjHXMH9GRg7n8vNqiOGX2AOsWsmIjui1Ldh7VeAqhOrBdmnBzMl2Wp
	 pevJeJAvBRQQdF/UUKst1NJzHM+i0nna83jDgdCZLCLjxY4lBcW+VNDgr7eYBoDvl7
	 wDVKvfbgmWwHEp1jU6BDPRYG4GtuWaGJoVvsF7B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/522] net: mvpp2: limit XDP frame size to the RX buffer
Date: Tue, 16 Jun 2026 20:26:48 +0530
Message-ID: <20260616145138.154965069@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
index 62d72f5ed01295..8403fc4e9e7176 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3981,7 +3981,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			else
 				xdp_rxq = &rxq->xdp_rxq_long;
 
-			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
+			xdp_init_buff(&xdp, bm_pool->frag_size, xdp_rxq);
 			xdp_prepare_buff(&xdp, data,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
 					 rx_bytes, false);
-- 
2.53.0



