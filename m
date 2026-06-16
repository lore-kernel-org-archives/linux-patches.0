Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4383735675A;
	Tue, 16 Jun 2026 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629431; cv=none; b=j+KH+Cxy/uzFay8Tt9GuUFsXNOYUhmWQ+1SJbXb0rY4SWlG655zD+Q+/Zk3QuV3a0JurYfWpGVArbpk/RsDOgri1tKdKYtHp9u9kKvPRTs+P3xmzRp2TMIZXUxC8thLg3IpfIGh5f32t2pxN/kr2VVGQ0znF4ZMeuclX8Kiq/yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629431; c=relaxed/simple;
	bh=FJBaLj6Af6ma6FHC7J0WuNJ9E+zzm39NdGVgBXYQhUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFbKnfFPLVi2qwK8RrZAwxamBytiS8T7Ck10Fri5hdqytLP0VdbQJaz5wNlWQLaXXq46oNs4DGpJZWUqdJPuWzoiq+fidAk8CqbOW4kxldheUDjUIeiy4Ktd5oEX3Oi/aXH+aa2vu+yGUOaGuNvpiA30idCJVneiYeo+SPjMOok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuSb1u/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuSb1u/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A01F000E9;
	Tue, 16 Jun 2026 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629430;
	bh=GNp34bn7GmmPq1sUAfvym0oukyTR5CJUb6luwq8Vehg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuSb1u/6uKBDWy3znUb6awUgV4k2TYtE59bQpZy/6Zv9jIZUdUWcalIJykxBaHLVa
	 dbLmG+thAN/s45fT5ufeAjyNkTnVbtcZB/bG8ib9AOeh9nuO/K3JyVnldhdbXqtiQs
	 pv6auPvnm4fDkoGl2rTVLRfBWTTMQjsEppy8D1XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/452] net: mvpp2: limit XDP frame size to the RX buffer
Date: Tue, 16 Jun 2026 20:28:29 +0530
Message-ID: <20260616145132.434064439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index af10654f655674..9221ee209a309b 100644
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



