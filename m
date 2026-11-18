Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021533;
	b=mew7D/oh1eh5J+tsh4/dVhCYnXjx3bPghBsAgeaRq7eNDz9adioKI/iRSJMTgtb56hih
	 utKwe5jH7/T/E5BfHUnQ3YgexZbLLYITI0JJbUJr2fnudajoAdjkgPuholWXAZGi767FJ
	 xsB9MK6guF5Z3xRsvKlaXc8IUgyYdCEOT7D8WTMoJumEy8rScVNab/lkhH74K9ekZhubZ
	 6FWKOW1kBXmy6A10mtXRQ3Jy1ifMOQpMym9k+GKyS/Db2WYTs43EDc8lXYUS9gQUSji+k
	 HTIYi0BYQcLCXs6f62NwuPXCXP/N/qohiYqgQP7OQT6/BZa6uL1YJKGawZQM/vnahZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSHi23SJqj6FpReDpbRyBri3r42neY5jz6Zuc5xJMqQ=;
	b=uyt53terDJKJNCq02gFtSoGgqwl5em+TRfIkUowIwC7lRaCWPBYwCS8LHPupRWFLF7YU
	 HmPpjwd8scyFgi2P/74Dxq6n1iyxjauncJeWqhzPFvVSJxOXM5tnQku82G8iIxcBuRdPZ
	 bpXCA4PRz8g6iJBY/EggB3MiebNSpzZhniTuBi5nWMZj+TETX9Oq/z6vAtjU4Qi+Sev4s
	 t0AhSVWEThCr1y1wiJHMMYGrNTpDGl6hAm0xTG4I8SfADSM5dLzF2x0Hj+S7N2GXTI2ya
	 UotByQgnW+LbNggKnuQ6Y1tkuZqDK/VlFTu6E3/i78XAt7UMCJhesI0PZfddexVvtyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2LGsYPTf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A4360A2607;
	Wed, 18 Nov 2026 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2LGsYPTf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161AF1F000C6;
	Wed, 18 Nov 2026 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021533;
	bh=hSHi23SJqj6FpReDpbRyBri3r42neY5jz6Zuc5xJMqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2LGsYPTf5HRZvQOCKzxEB+8B36ZBBv31mv9SJooH48Oi+xQpf4qFgg8L1F7VrDz0y
	 JsiT6xYZwBuP97IofB8bC7evhVV+XZTblRjQ2rQhYNWBihXJ1R2CcU8r7aw4AFcjhB
	 Zh+g6hNGmysmQrW5+h40j0eIKKKA1H8ZqHw7KDPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2341/2651] net: lan969x: dont disable hardirqs in fdma tx clear
Date: Wed, 18 Nov 2026 15:59:41 +0100
Message-ID: <20261118150409.370314642@linuxfoundation.org>
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

[ Upstream commit 9770818b8a92fb5fb77725bd5055f165eee3f52e ]

lan969x_fdma_tx_clear_buf() runs from the NAPI poll and frees the skbs
of completed tx DCBs with napi_consume_skb(), under sparx5->tx_lock.

Before this patch, the lock is taken with spin_lock_irqsave(), so the
skbs are freed with hardirqs disabled. RX skbs are marked for page_pool
recycling, so when such an skb is forwarded back out and its tx
completion frees it here, the free path reaches __page_pool_put_page(),
which warns via lockdep_assert_no_hardirq().

Take tx_lock with a plain spin_lock(), as the only other tx_lock user,
sparx5_port_xmit_impl(), already does. tx_clear_buf() is only called
from softirq context, so disabling hardirqs is not needed.

Found with lockdep enabled (CONFIG_PROVE_LOCKING), which the assert
depends on. Reproduced on lan969x by redirecting received frames out of
another port with tc mirred.

Fixes: d84ad2c0d80c ("net: lan969x: add FDMA implementation")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261020-lan969x-fdma-tx-clear-irq-v1-1-b9f9d1eda317@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c b/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c
index c7e0e58ff0f7b..053d125eda658 100644
--- a/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c
@@ -54,10 +54,9 @@ static void lan969x_fdma_tx_clear_buf(struct sparx5 *sparx5, int weight)
 {
 	struct fdma *fdma = &sparx5->tx.fdma;
 	struct sparx5_tx_buf *db;
-	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&sparx5->tx_lock, flags);
+	spin_lock(&sparx5->tx_lock);
 
 	for (i = 0; i < fdma->n_dcbs; ++i) {
 		db = &sparx5->tx.dbs[i];
@@ -83,7 +82,7 @@ static void lan969x_fdma_tx_clear_buf(struct sparx5 *sparx5, int weight)
 		db->used = false;
 	}
 
-	spin_unlock_irqrestore(&sparx5->tx_lock, flags);
+	spin_unlock(&sparx5->tx_lock);
 }
 
 static void lan969x_fdma_free_pages(struct sparx5_rx *rx)
-- 
2.53.0



