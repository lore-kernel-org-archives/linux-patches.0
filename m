Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7881C44DB62;
	Tue, 16 Jun 2026 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625367; cv=none; b=QE3PBdhOwN9NeDtclstbH/flEwfeSm6984fOebGAeXD0ILo8XyCedpJOgXYGGDaqYc3ryHYelNVFVh5MPbhW0gtBC5DcqTutc7iuHAwl6DpW/Sx0Tf5Ps9Ene6IX3bgEGc92e5Pyocb1LlsWoFzkwKT0QA1PFweDCT2i7N/fgOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625367; c=relaxed/simple;
	bh=mnQTJo9EbzI6iFGdGt/pWSogav4PQHekqQghqqxaox4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIYNvaYzZZggiwdcuySRohEa+L8+CcFJwSNpE+3tJwWVnpaValUqQRDj8qfH2tnWXQANDPeNbT1R6MfxW+zYiwLuR1JbKFbpxPxI2oe/gAPSS4GU6m/g8gEtS78Bnj/bGnPzw9T6u2MkcvdahEDumQ7F+8vpEGnbJQDh9bAMEcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibX/T1Kn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibX/T1Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AD81F000E9;
	Tue, 16 Jun 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625366;
	bh=rzQzvLaA4KnxiFrjmf9bbMsF2OMqJ/QPAoN70U999y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibX/T1Kn/9PCH9covoHG54EPO1EiFAzZGUzh4Bfkvhay5C0KFBIwbMg/d5nMJu+m+
	 TiGgrGnnmrCNNocxkOvOrIiJy60DZSByDxXlrzpmGiyHrRNx+1sBdVs9ZnviGDGMP9
	 PLeBc3CF8tYCNdotCi3fVps+ZvzGWWX40x6Ieyek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/325] net: mvpp2: sync RX data at the hardware packet offset
Date: Tue, 16 Jun 2026 20:28:45 +0530
Message-ID: <20260616145104.153314724@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Til Kaiser <mail@tk154.de>

[ Upstream commit 180235600934bef6add3be637c296d6cf3272e67 ]

mvpp2 programs the RX queue packet offset, so hardware writes received
data at dma_addr + MVPP2_SKB_HEADROOM. The current CPU sync starts at
dma_addr and only covers rx_bytes + MVPP2_MH_SIZE bytes, which syncs the
unused headroom and misses the same number of bytes at the packet tail.

On non-coherent DMA systems this can leave the CPU reading stale cache
contents for the end of the received frame.

Use dma_sync_single_range_for_cpu() with MVPP2_SKB_HEADROOM as the range
offset so the sync covers the Marvell header and packet data actually
written by hardware.

Fixes: e1921168bbd4 ("mvpp2: sync only the received frame")
Signed-off-by: Til Kaiser <mail@tk154.de>
Link: https://patch.msgid.link/20260607134943.21996-2-mail@tk154.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 74d44510684bfb..5ef8637d408015 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3948,9 +3948,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			dma_dir = DMA_FROM_DEVICE;
 		}
 
-		dma_sync_single_for_cpu(dev->dev.parent, dma_addr,
-					rx_bytes + MVPP2_MH_SIZE,
-					dma_dir);
+		dma_sync_single_range_for_cpu(dev->dev.parent, dma_addr,
+					      MVPP2_SKB_HEADROOM,
+					      rx_bytes + MVPP2_MH_SIZE,
+					      dma_dir);
 
 		/* Buffer header not supported */
 		if (rx_status & MVPP2_RXD_BUF_HDR)
-- 
2.53.0



