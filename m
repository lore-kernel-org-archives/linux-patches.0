Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022003;
	b=yuUAflTLrMZX0ym9gp2yVHR+qGlV6NSklJYKxX+hRG77DhnerPMrB+4M6CsgwvSD2C3E
	 Nxb/iZOkLxGHu+3DhkaoPIoN8HuEpaDE48yiUxyu8WDiZsKEl2Kn+KIom2SkK4Y635eTS
	 rK0cOQZsMgNKwN0REja7MjwIu69qBuYFFIhMt1RhRy8pFsNN8DCrvyljgZnkqi0b/6s15
	 L7THqCrA0ESKMehgCpFS+7PEPI85J05T6BCknfgdd9WPUujb8eOc4Jb0iR0iyIudgPtNc
	 SX7oLPGnCabEku9ZULer2sFDA0ACl0NHXUh0e++ZPQgqINrxWvE0qyc/d4lUuRJ81sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z8O1FI8vMYI03JU4SxSIVHUoS5DVFpZGU/HIVju2wUk=;
	b=uOjOy8sG5/D9diuPiNzc8lh6wkHoX621liRIbL7Hbiq0ddhDMsjvL4YPhlC5OF1QE6hI
	 t5QnqxkLLGFVxf8Tdm5RCQph81TG1fwZjXhzwNiwMZncwDF33zg4axLfAUXVMLkyaWBqq
	 d+4CY5FNkf/6ISfCie75lpXmSF50ubbhk009OblPngCKhq8tmjxYkFPdrORzCG/gzroZX
	 9DHtKq3gemuSDe1vgKv0wHSeGdI8KpMyS3ePTqTNGz7n5nSggCQ0OCM79J85xH0tLmXBQ
	 1ZfkdB8d8RhlQOEDpBCE4z6C+E06s++aEXa8IL0JvhRMlnWmjDQReaxQzAXgvgNStnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shKMdmgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E7F606A31C;
	Wed, 18 Nov 2026 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shKMdmgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362061F000C4;
	Wed, 18 Nov 2026 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022003;
	bh=z8O1FI8vMYI03JU4SxSIVHUoS5DVFpZGU/HIVju2wUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shKMdmgBwmFyhwU9E77lD/i0uqXYbx3LgYQ6acHpH39sWkPxlu4QpaJxHZW7vGsZb
	 rWM3u5W4w57nmAKEpiezMAryDwyqXYQg6TIWJJLknZmARhexi3raZgngySpntsAzR6
	 iS4s05QWh2kZPBf5TOhmTfajjpQGU8NCpKCKl+14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2509/2651] net: lan966x: dont disable hardirqs in fdma tx clear path
Date: Wed, 18 Nov 2026 16:02:29 +0100
Message-ID: <20261118150415.079310061@linuxfoundation.org>
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

[ Upstream commit b2e17432e7ee75997657f99862eb83be0c78a6c1 ]

lan966x_fdma_tx_clear_buf() runs from the NAPI poll and frees the
buffers of completed tx DCBs with napi_consume_skb(),
page_pool_recycle_direct() and xdp_return_frame_bulk(), under
lan966x->tx_lock.

Before this patch, the lock is taken with spin_lock_irqsave(), so the
buffers are freed with hardirqs disabled. RX skbs are marked for
page_pool recycling, so when such an skb is forwarded back out and its
tx completion frees it here, the free path reaches __page_pool_put_page(),
which warns via lockdep_assert_no_hardirq().

Take tx_lock with a plain spin_lock(), as the other tx_lock users,
lan966x_port_xmit() and lan966x_fdma_xmit_xdpf(), already do.
tx_clear_buf() runs from the NAPI poll, so disabling hardirqs there is
not needed.

Found with lockdep enabled (CONFIG_PROVE_LOCKING), which the assert
depends on. Reproduced on a lan9668 board by redirecting received frames
out of another port with tc mirred.

Fixes: 11871aba1974 ("net: lan96x: Use page_pool API")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026-lan966x-fdma-tx-clear-hardirq-v1-1-5f70f026a2e4@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index b66bd1cfea10d..5cc9b2321dad5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -337,14 +337,13 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 	struct lan966x_tx_dcb_buf *dcb_buf;
 	struct fdma *fdma = &tx->fdma;
 	struct xdp_frame_bulk bq;
-	unsigned long flags;
 	bool clear = false;
 	struct fdma_db *db;
 	int i;
 
 	xdp_frame_bulk_init(&bq);
 
-	spin_lock_irqsave(&lan966x->tx_lock, flags);
+	spin_lock(&lan966x->tx_lock);
 	for (i = 0; i < fdma->n_dcbs; ++i) {
 		dcb_buf = &tx->dcbs_buf[i];
 
@@ -389,7 +388,7 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 	if (clear)
 		lan966x_fdma_wakeup_netdev(lan966x);
 
-	spin_unlock_irqrestore(&lan966x->tx_lock, flags);
+	spin_unlock(&lan966x->tx_lock);
 }
 
 static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
-- 
2.53.0



