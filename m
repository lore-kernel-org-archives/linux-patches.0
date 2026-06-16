Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD45C26B0A9;
	Tue, 16 Jun 2026 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623601; cv=none; b=ENfe5/fc4rORz2uN9hZG066a0TmlngKusAuphzP5GBMQaKdD3JJBBhxPBvrvNmkVy+ep/LtELrBT0mMUIDgxMPLcvK/Cy7T1VSWPrSjOm9sTTVnxO+DeVRuLdNHYUZkijHYNDRSErs/K6oZCvVMYPKWMHVc2i2Nu0gQQJ2h/rZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623601; c=relaxed/simple;
	bh=+xWk6FTjgerstzGsB2IUWcmPMNgnWDbTCZm6IpyWDfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhtHRylU3STjG1/mkB/90mmIU8dNzbDlbPV3mmaG9vY5dOqMGwXmHV4H+AwwRlznQtVMxnR82nYWU/xxZHuY+qYiF0qd58KkCAYjP6k5dO7H57S5TN5C1co4fwZ9/AinwIvRlDCPXtpYdTALdUSqAhZtpQZBHSc4wgXwEepnrSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaYr+QdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaYr+QdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BF11F00A3A;
	Tue, 16 Jun 2026 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623599;
	bh=aTS/yeVNLoKy9N6AgFtGyxA9r3bphkvyhSvqSpbExts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaYr+QdCHOUCEU3WySlFb3KjD1G4xZzjTIY6qmD3VO+kgC+BYUkR2fKyZwPe19VWy
	 mALcnXRfE+ne3X+sMA+fJU1uHreLwSpmzP5ehKuSQnh5c6HWejLrJNmpElWoaTL3+C
	 sQHyvika2oHC2KNSHPKF+4mGsCFP5oRVqElYPQ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 146/378] net: mvpp2: sync RX data at the hardware packet offset
Date: Tue, 16 Jun 2026 20:26:17 +0530
Message-ID: <20260616145117.949508023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f442b874bb5933..92a701f4fe3f57 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3946,9 +3946,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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



