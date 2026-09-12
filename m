Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6E04BEE5E;
	Sat, 12 Sep 2026 18:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238404; cv=none; b=kV77RExQ82Nht0okrPCkUahZaKzfPaO+I6Xf28pd8whuCsqLqBwwRpkti8U5ME+Zz9qoZ49W5qH0NWrkaPuDEPmnoXPUK3VpV7V2QfFUCU6XG32UsAHoyU/vYBrlgWet2uep0N8xweKDFSNfE+WyW5ucWTmotI2XdzYTlXmQFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238404; c=relaxed/simple;
	bh=wKjH6NtHt8tZXxrmEE7DPDC9apR+mUK6vqHmVdqrchE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoV0JbmGb2DjtywL5GY7ROJpe1qIzAgBtggWrwOoq/WG7SzzjFHYrv4PyZR8okK/aHJg2/Rn3wp7tOJubwLLe13Evo3EDD7dwkJ5CHP8vgSRQ/wgSuWfxNhl01YpwwNdNqhWRNCm8sw2az8RxKid5mlajY1Cv4gZX1bIRBAzjKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEap1mmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEap1mmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CBD1F000FF;
	Sat, 12 Sep 2026 18:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238399;
	bh=m3yu8CG2VQCbrs1cksCPwYl5B77qMoQUpYclfMUxIi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEap1mmjrqnKO+krXBFHVbkW8elR2Yavk1B0O4+rk2hZ4NFzFNdKY42oouotHrjAs
	 1PeKWx8GAm0h4rX9VsNfxcUPifdWeo+bDhTevBAx69KxiD47GgrPbGLDllNmNYrxUU
	 QjckJhMUKHxdRxAlJQs4Ss+vzRsv6hHWNNfaoQLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/935] staging: switch to netif_napi_add_weight()
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065537.263397713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 60c85e23bed17b4e5074cb2695837244cecc827a ]

netif_napi_add() will soon default to weight of 64 instead of
requiring the user to specify that parameter. Most users already
pass or should pass 64. Move the callers in staging to
netif_napi_add_weight() which will keep the argument.
This way we'll avoid a huge cross-tree conversion when
argument is removed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20220705225801.923601-1-kuba@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 4 ++--
 drivers/staging/qlge/qlge_main.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 9ebd665e5d427..965330eec80a8 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -469,8 +469,8 @@ void cvm_oct_rx_initialize(void)
 		if (!(pow_receive_groups & BIT(i)))
 			continue;
 
-		netif_napi_add(dev_for_napi, &oct_rx_group[i].napi,
-			       cvm_oct_napi_poll, rx_napi_weight);
+		netif_napi_add_weight(dev_for_napi, &oct_rx_group[i].napi,
+				      cvm_oct_napi_poll, rx_napi_weight);
 		napi_enable(&oct_rx_group[i].napi);
 
 		oct_rx_group[i].irq = OCTEON_IRQ_WORKQ0 + i;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 8fcdf89da8aa9..309ef712c971f 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3045,8 +3045,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		/* Inbound completion handling rx_rings run in
 		 * separate NAPI contexts.
 		 */
-		netif_napi_add(qdev->ndev, &rx_ring->napi, qlge_napi_poll_msix,
-			       64);
+		netif_napi_add_weight(qdev->ndev, &rx_ring->napi,
+				      qlge_napi_poll_msix, 64);
 		cqicb->irq_delay = cpu_to_le16(qdev->rx_coalesce_usecs);
 		cqicb->pkt_delay = cpu_to_le16(qdev->rx_max_coalesced_frames);
 	} else {
-- 
2.53.0



