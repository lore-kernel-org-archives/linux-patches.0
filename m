Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028163;
	b=li/CiysWYEuN/25TSbS1/lnpyaqUV/OfW3g5voXRQuyvK1H7q98dILhdBr9H6IjFYiHe
	 68WSmrb4G1Av9HCf/93L0f9azcRVa+Ig5ttMlrZQSGC6nGGOaWcfYEnxAuesx/YXruhYR
	 lR7rYrSG36QeEIf8loO8J6sWyNZfQQMrAVXhjJJUpWJt15IqvNeqiVfGKE8dNQjeb1jDS
	 JC8KZBOGGrSaOfPOXXOu+DsO0DqIZBGZia/8GNnRKzBsulCJYDMNSsVu3ZQKcyGKJLkC9
	 FjEQZQ2uV37BUTKNoMWwGsy5xPfD9qHwsplflZBLbL11FrnXT8fj7+9fvaE++Nu9grQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vYqeUCJFUfM9cPknGCoMRkJqwHsMVDvLyieZoTyoW8M=;
	b=1eJjuHLLCI9CxPjDhOxqarwagkw6YRb2XZp5dzOKaH+2jUU8b34wpx7eJqCGH3/sOwS7
	 4hoevbsTwWze5nf2xfCffnCI548VgI9qbAzKLtaJiF8/uJ6/1TZafMyj8b6RinPgHuQ9K
	 j+cvfKWvMSi0Z8ETd6QF91NRPrDlSTF2jT0o6vcP2+DTA5NSfHkNVYeJxiJjOBNBDzoW6
	 EN0EbjR0EvyWEaNySgnlSj2A/bUZC4ngM6W/jAkm3tClbpuu2gfGESn3PHg0kAGONPhv4
	 3KS/Eg6GA0F5gyv4XkQLTRWZ5OAaRgkwHcKT9smLvD46ec2NN7JhxiUiSm1jfswy0Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfzCr19Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E3606A32F;
	Wed, 18 Nov 2026 18:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfzCr19Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BA01F000C4;
	Wed, 18 Nov 2026 18:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028163;
	bh=vYqeUCJFUfM9cPknGCoMRkJqwHsMVDvLyieZoTyoW8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfzCr19ZBXQlsvCi9TajJQbQL8VzrhlXFH+4Xgf0D2aibOkxI0Yw9Afp/b2c4/9rB
	 2bOtFSnDUZfTgGwEH2+PoZ22uyk9Ziu0WniS7CTumeZFiV6eRazqeMQsqZl3o8qJRh
	 YAnm6+kS8NLyMhYmJZ/F9GKiLDXptWxmSOaAuUrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2006/2151] net: lan966x: fix the DB dataptr of frames from ndo_xdp_xmit
Date: Wed, 18 Nov 2026 16:02:21 +0100
Message-ID: <20261118150234.802365909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



