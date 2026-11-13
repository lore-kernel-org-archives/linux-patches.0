Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591177;
	b=sTZ8noXrOgiTP/aYnAsjFZv4uGJnLQHouyg/2IizSw4o3qJ27KZMCbyCRxGHZWhfpBpT
	 eVwXtkyFCM14XHMN4fWUPCuI8TrQiYs5dV2ZWRYpB95ZIdoLV9DGWiq44w2Rk9MoWGtil
	 bbZuLAuXzd/quIguy3lZa0drRy7P9lcQIa+PiBBRgtSCw9bmP5IUTCCBAaqM57OdNXBy3
	 vb9OyO3ewix3IkSMxBeQsEZGjuehxRgt3DdgNeh20zDhZSdanFNpN45cnVVIk8dfa5J5e
	 2p01oyH0LvG8Sc+KnY549HRNwWLJ6gLfFzt163IJWaLSYR2XK6r3ludFXQbsNdAyuDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5pl7l6iNS6sHKlEcctWultJG3MVIKxYypaF66SidoBk=;
	b=Ly1z/a8nrwrA6xVeUaE5vZxFVM6eZjRPRtm6o/tGZdB5pcOYbQSLXHLUdlV4qopqw2JI
	 1xsL+cmECCm4yClNah2SG4Li2WBI+XwX1Zl0/yT58S9gH1q+dAYy1iVAHebQ5Jx35ODlH
	 HV760Sm7mnQYeSM0PhZHqzm4R59kCJi/DDybc9daA+weXOzRGRJwO77c/e48t1xOIJGSI
	 mRwX+xmsPKwLxlO/VlY1ElFI0CQY6ny5rSAskLOpD0rfH6Yf+8tRQiNUh6GfcSp+lTeYm
	 UEEwldRIqRXhbGEz8J6w9NrDMliSOiyxRftCRH8fAsyWO4k+nDWhbQntIbiJdf3p2zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8hvhDFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1336073FE2;
	Fri, 13 Nov 2026 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8hvhDFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A822A1F000C5;
	Fri, 13 Nov 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591176;
	bh=5pl7l6iNS6sHKlEcctWultJG3MVIKxYypaF66SidoBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8hvhDFhSVMGL1KTvuozMgGonsMofH51o49jlvYTmHmW7uAzDEemns3stSqcWH7Z7
	 Uq3oSDyD9LJ+ktcn+PCt0AihhXMukOXqd9nw1OHDSR8gfvWiz9TT1DSY48nYWJUnF+
	 r+hMq3B7gLvXdth8RWBxuXC1Ntgthhs99SwCMezk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Quchaosheng <quchaosheng000406@163.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/670] can: isotp: check the frame type, not just the length
Date: Fri, 13 Nov 2026 10:48:00 -0500
Message-ID: <20261113153822.611214741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Kaixuan Li <kaixuanli0131@gmail.com>

[ Upstream commit 933bf0fcb325e67b19c86c9c4da7f029878d5170 ]

isotp_rcv() separates Classic CAN from CAN FD by skb->len alone:

	if (skb->len != so->ll.mtu)
		return;

	cf = (struct canfd_frame *)skb->data;

A CAN XL frame with cxl->len 4 is CAN_MTU bytes, so it passes, and is then
read as a canfd_frame whose len comes out of canxl_frame.flags: at least
0x80.

Of the paths that follow, only the flow control one uses that length
without bounding it first, so check_pad() walks to 255 over a 16-byte
frame and the caller reports EBADMSG on an unrelated socket.

bcm_rx_handler(), j1939_can_recv(), can_can_gw_rcv() and raw_rcv() check
the frame type here, and can_dropped_invalid_skb() switches on
skb->protocol on the transmit side. isotp_rcv() is the gap.

Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reviewed-by: Quchaosheng <quchaosheng000406@163.com>
Link: https://patch.msgid.link/20260920035626.2581040-1-kaixuanli0131@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 4c65fa4057a09..9e0901dbcc971 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -747,6 +747,14 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
 	if (skb->len != so->ll.mtu)
 		return;
 
+	/* check for correct CAN CC/FD frame content */
+	if (so->ll.mtu == CAN_MTU) {
+		if (!can_is_can_skb(skb))
+			return;
+	} else if (!can_is_canfd_skb(skb)) {
+		return;
+	}
+
 	cf = (struct canfd_frame *)skb->data;
 
 	/* if enabled: check reception of my configured extended address */
-- 
2.53.0



