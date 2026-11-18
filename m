Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022095;
	b=bWLgG4hn/ZT1fptNRYmLcm5oqpOkEs5klpr66uBeL7CsXs+AnZe1v7SVAAoTimFVb9KY
	 KvbMpuP6aoa4co9woWEvbEQBXCW4f30Tgh2hOlHCMJqFEp2a6aTmPe2NsRBv+Ms42TRDt
	 l7lGs76S06TFT5p2A1kle0Wmt2JHj0/rGxE7+2/SJNTDLfV9IvNsWycDlNf5xviNoKnry
	 EgOnLILFsjc0ma2zna0/9KMfx0MlNagdY8UMKTh4Qky/sK1oHsNFyPM8NdCz5AaWp0eYD
	 VcrJYNszB+Y6KxjLX6aGl65FWhRIIEAyPJBnplmw5irZZdqedvyX8CSMwvESZXSSCKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BIkd3NkoY1asTKspyP2RTChgo7WL2FaN91DodeDh9NY=;
	b=Se5UmDM5AmpSnoo1Qlh4ez3mHtRMos9/kQRBqXa/aC8fBIVFg7mw+9ZZVm6T/zw4xl8V
	 05J+ykrF7V4Bh1SriflKjHgGb+MbI21Mtlhgb3ufC2W/DyOZo7Itrp/31l5Iz1PQgaacG
	 3s6sxOZw2D+xzR9ZzuGmOl8K5wInkuoGAsgcv2SLotnIe9S8TkRvFZWc8av8QWbqmHJUV
	 FxbYcHMP/HdwuqY9MwMILrEi6/LAIALOfpOGAqc84CaufFGHWfGhxVxoJ5lgEDeKrlOh/
	 OxWlSosQqTX7F8STrN346Ib9Uy9MGTOoNi5nfOpozggh6Eslxawl6kQJc3nPSqUoUxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxZi8ony;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1824606A31C;
	Wed, 18 Nov 2026 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxZi8ony
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF031F000C6;
	Wed, 18 Nov 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022095;
	bh=BIkd3NkoY1asTKspyP2RTChgo7WL2FaN91DodeDh9NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxZi8ony+X1xytL6sr2dcdDSoFi+IX61y7MRBOHGT5oQu9+tLHasaIKPtiBGFfZvW
	 atRtysddDXO9IT9Q6Hzqx3vEpRKEJEjyllArpl/Hz2DsP6eNmfuG9qTNDYqSocxNN5
	 +dmei6sU5YLPAAzrfzLX7cGPPYyag8Cr5BYTbZdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2500/2651] net: lan966x: fix the DB dataptr of frames from ndo_xdp_xmit
Date: Wed, 18 Nov 2026 16:02:20 +0100
Message-ID: <20261118150414.807746269@linuxfoundation.org>
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
index 41d4ec7f2f571..5c89f99286251 100644
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



