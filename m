Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027728;
	b=dsRqP/aZJgaB+R4BbKmXftDD/6/mJI+WBC/0mnz1GAwvyiRTfCQfaKtvhCCwkWyD1i/v
	 OEXKlWAML74wnBDSGrgTjnvil0OqSrrhkpW+hjLeSjyEG4UyvPmwPtTXVezuiMbAHFcV/
	 3a1bYFVrtMGNFxCBTGCBca/Cx8t7OjG43LuIsJrwcWQ96bionhFvF5k5lItlek+M3CqJp
	 lBeoRbH5gjMXVNvuWTkBZaj+2Ib6DTGwFJQlPcTrTI9A39wO6LezDUR6/DyqXfJ1DcFL0
	 FqZaqeAw//fjDTruzgM0wauWAEqgE6TdAjpOXOyem2v2FAA/mFD6vtQwfL6E6AGqPRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lkENZVCWZUmkiwahnbkKVdy9sYcbOgjFZc0UZIWgghU=;
	b=rh/ChHhLPDpJ2XK39YynkfjaAu454A++MXyoacyoFK6t+lR4hB0Kyq1AQmKBethRTOVE
	 QWFH/uBxOA8q9u8ICsUHJLYYYdNfp3VkgA0948EVEfQD0sUhPLkfRZPPScB92+tA1UaZV
	 ajVedAdRpqRIut+291hlUUgkEdxHzNhZi5nOtUvCDHwllmayVk4I0qRStlmHaZ8hlsHa0
	 poZTmgCLOdS8vm45zV9073ZNJ0ZPzeGgxY04McKVJi1ULuF8JzT1r7tEGotDOYL6CZ3xy
	 fYnfIgIZMejWL9aGz81BlvANDzx9DoyBsI5b73B7Es7U7eY6836FnSgtNnut+aIsHYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SWEc1qni;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0A4606A338;
	Wed, 18 Nov 2026 18:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SWEc1qni
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5507A1F000C4;
	Wed, 18 Nov 2026 18:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027727;
	bh=lkENZVCWZUmkiwahnbkKVdy9sYcbOgjFZc0UZIWgghU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWEc1qnirueAXauVbGvzSoM8n9AzOoVnnGm5WSiJOU4Fc3+/s5C3Xnc3KJYEbvCmV
	 nKfgRYFjOZ0OdLTLNOPiG6OnJPVvyAfZAz+pP235hDV/3FStgLt9dPElYeQbWHTccz
	 TLIZGy1QExRQIlQ5uX9qk8NbaGT9v2A2zt4h2NF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1892/2151] net: lan969x: dont disable hardirqs in fdma tx clear
Date: Wed, 18 Nov 2026 16:00:27 +0100
Message-ID: <20261118150230.715469564@linuxfoundation.org>
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
index 1282f5c3ee6d9..f8edc077bdd40 100644
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



