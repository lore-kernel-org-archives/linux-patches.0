Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032995;
	b=hVBCMg/LnZli5C+UUI2zCYakCxUr2/pcD5vv1+PRLs0skfjeKGDsgDFlYBHpOUcPCZ7g
	 CJHIKou2ld6IhdgXo+AoXRg1joiBlRcKku0HhSNxWj7KHIidPH585+WmHwyMw6tR4ifR1
	 4tZkPXQOjinx1Q4g45N3/1PrLUQ4xePO5mM1hw/ZkQWjs5z5EzLVIwO71aR6VBC/AeMsQ
	 bujB2qhuUrARUDFZoEVJjAQOqMTfPlGQd0TA4pGvHQS2gqxt9bDMVqqoEX6kYi5zGsg/x
	 DlTrlJsFqFKUBmGzluEbVOviss5s+pvG+olNmM0X5lVyNGMI+FleKfFp6tp//yQsdWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3NX4cvcZSvZlmmOm7xaam4d62dWJ7pxE8VKP8roRgds=;
	b=VOfQTw1TZGhchqwrRkgBixo6nV6yiOcpezMnN0UyOnRuTtErjV//kLmUO/kFG5C/YEXi
	 2g9Rd2tTnMMepqjRLRKsI06TBSgGRxX+Zb5P/Bk/FAx/6OCv78BVAnBX8wzzitXiSLfd5
	 CD607fwP4upLybyN0Qb83GTLBasjT7+vuucMU6RgJuBuGbNk/c0ESKlBpjDqOJEyG5TZi
	 mWQmtLBs8QoRn+cXIVlPjg3/b8CjP+Ibomw/+hNwLk09PimRqOKzFqrNXvMmB4HoQxRB4
	 G+1POjILCvgP28TFYk6v/AikhWXeM5c9dEEL0Z7Sd5OuLJkbDbi1gty3kEYMFbn2oRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuMXPQtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE15606A325;
	Wed, 18 Nov 2026 20:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuMXPQtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966CE1F000C4;
	Wed, 18 Nov 2026 20:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032995;
	bh=3NX4cvcZSvZlmmOm7xaam4d62dWJ7pxE8VKP8roRgds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuMXPQtkjjIZ/8ERJAxkPPo0YmewlUkTfMs6brl/FIzH+4wizhzSPhlYm2QBEGpXe
	 1UYjZwFmGl3WPRlQS9ACgXIvvwbSu/4jK1mOAYyOB2AedEwLWJtKNNhs1jOpr5fyn4
	 2GuBeOcNNcVrb7gtDtEKzkV9uimBZ3dOtRNcwj00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1611/1756] net: lan966x: fix the DB dataptr of frames from ndo_xdp_xmit
Date: Wed, 18 Nov 2026 16:02:18 +0100
Message-ID: <20261118150113.994668129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit ce3192e0dafa829e76edefecc16a32589b53c875 ]

lan966x_fdma_xmit_xdpf() transmits both XDP_TX frames and xdp_frames
from ndo_xdp_xmit, and builds the DB with
lan966x_fdma_xdp_tx_dataptr_cb(), which adds XDP_PACKET_HEADROOM to the
stored DMA address.

Before this patch, the headroom is also added for xdp_frames. For
XDP_TX the stored address is the start of the page pool page, but for an
xdp_frame it is the mapping of the IFH placed in front of the frame
data, so frames from ndo_xdp_xmit are read from XDP_PACKET_HEADROOM
bytes after their IFH.

Use the plain tx dataptr callback for xdp_frames.

Found by an AI code review agent. Reproduced on a lan9668 board with an
XDP program redirecting frames from one port to another: none of the 20
frames arrived intact on the link partner. With the fix all 20 did.

Fixes: 29cc3a66a81d ("net: lan966x: use FDMA library for adding DCB's in the tx path")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026-lan966x-xdp-xmit-dataptr-v1-1-d0dd068324de@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index b13c60438b978..4e9f347a1387c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -686,7 +686,8 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port, void *ptr, u32 len)
 		       FDMA_DCB_STATUS_BLOCKO(0) |
 		       FDMA_DCB_STATUS_BLOCKL(next_dcb_buf->len),
 		       &fdma_nextptr_cb,
-		       &lan966x_fdma_xdp_tx_dataptr_cb);
+		       len ? &lan966x_fdma_xdp_tx_dataptr_cb :
+			     &lan966x_fdma_tx_dataptr_cb);
 
 	/* Start the transmission */
 	lan966x_fdma_tx_start(tx);
-- 
2.53.0



