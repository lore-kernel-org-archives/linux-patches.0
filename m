Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BC151993C;
	Wed, 30 Sep 2026 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793081; cv=none; b=tr4AhDWESVjqhV2l2I/t8Iw6qpDdrR5KZu+vjvSZeBoYy4SuCemGuLQzuqxAcTDPvKCW/UPok28Sv2K9TqrYt+rmYHqveWlq7nJl+/wpJ2yZYn3YtSu6GyMM6p+ZmTVte/OyB0pntPZBwa6qjiMo1rkUQY0hIDFScbpwkOt81No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793081; c=relaxed/simple;
	bh=aBMEVfgTj5FH0UAtMFkdkHv4LrzGd4x6HTGtuRLcXro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BagAIljFFuMnZkYCHecFkhMtqEFgyaY4PM0oz1MxIgsohZndtZH4AG4NNXYesfnV8zkqGZ9KXnFurwjqGrtyoqIks2ezCy2Q4I8RxPpm81S/1dQnYYMoiE7UZfFcsGoNcwXNRlx+Gk/oMlxHD789p6FOXsD5rsoPP12AZogO2AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gI3/X/k0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gI3/X/k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7719A1F000FF;
	Wed, 30 Sep 2026 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793079;
	bh=ztO2dMBDeAtnYT/4j9Qo4YVsLu6WULtuKA+ETsjY9jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gI3/X/k09o3ElP3Tr1R6ZFgMiD6AKe69HU6wEEV6oOImo7QTyOTqd9wgQTQHEfVZt
	 2wvVVb0FdA+BfgCPFpJH3gH+fqIbY/jnFgyMI3NG3Ekwbkxiv55o7aI2kN1YC6sibF
	 3IiDhRW0p4kV7zMxvNWdjRPak/UH1VpJ7zqvQOD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/395] eth: fbnic: Reuse RX mailbox pages
Date: Wed, 30 Sep 2026 17:25:45 +0200
Message-ID: <20260930152342.439245738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit 301ae0d5391a19d9897c342c874240b36f7bc85f ]

Currently, the RX mailbox frees and reallocates a page for each received
message. Since FW Rx messages are processed synchronously, and nothing
hold these pages (unlike skbs which we hand over to the stack), reuse
the pages and put them back on the Rx ring. Now that we ensure the ring
is always fully populated we don't have to worry about filling it up
after partial population during init, either. Update
fbnic_mbx_process_rx_msgs() to recycle pages after message processing.

Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Link: https://patch.msgid.link/20260115003353.4150771-4-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1b97a269a5bd ("eth: fbnic: Handle FW mailbox completions flagged with an error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 25 ++++++++++++++--------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 9e5de01698fc4..6edd01e58bf06 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -1598,7 +1598,7 @@ static const struct fbnic_tlv_parser fbnic_fw_tlv_parser[] = {
 static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 {
 	struct fbnic_fw_mbx *rx_mbx = &fbd->mbx[FBNIC_IPC_MBX_RX_IDX];
-	u8 head = rx_mbx->head;
+	u8 head = rx_mbx->head, tail = rx_mbx->tail;
 	u64 desc, length;
 
 	while (head != rx_mbx->tail) {
@@ -1609,8 +1609,8 @@ static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 		if (!(desc & FBNIC_IPC_MBX_DESC_FW_CMPL))
 			break;
 
-		dma_unmap_single(fbd->dev, rx_mbx->buf_info[head].addr,
-				 PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(fbd->dev, rx_mbx->buf_info[head].addr,
+					FBNIC_RX_PAGE_SIZE, DMA_FROM_DEVICE);
 
 		msg = rx_mbx->buf_info[head].msg;
 
@@ -1643,19 +1643,26 @@ static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 
 		dev_dbg(fbd->dev, "Parsed msg type %d\n", msg->hdr.type);
 next_page:
+		fw_wr32(fbd, FBNIC_IPC_MBX(FBNIC_IPC_MBX_RX_IDX, head), 0);
 
-		free_page((unsigned long)rx_mbx->buf_info[head].msg);
+		rx_mbx->buf_info[tail] = rx_mbx->buf_info[head];
 		rx_mbx->buf_info[head].msg = NULL;
+		rx_mbx->buf_info[head].addr = 0;
 
-		head++;
-		head %= FBNIC_IPC_MBX_DESC_LEN;
+		__fbnic_mbx_wr_desc(fbd, FBNIC_IPC_MBX_RX_IDX, tail,
+				    FIELD_PREP(FBNIC_IPC_MBX_DESC_LEN_MASK,
+					       FBNIC_RX_PAGE_SIZE) |
+				    (rx_mbx->buf_info[tail].addr &
+				     FBNIC_IPC_MBX_DESC_ADDR_MASK) |
+				    FBNIC_IPC_MBX_DESC_HOST_CMPL);
+
+		head = (head + 1) & (FBNIC_IPC_MBX_DESC_LEN - 1);
+		tail = (tail + 1) & (FBNIC_IPC_MBX_DESC_LEN - 1);
 	}
 
 	/* Record head for next interrupt */
 	rx_mbx->head = head;
-
-	/* Make sure we have at least one page for the FW to write to */
-	fbnic_mbx_alloc_rx_msgs(fbd);
+	rx_mbx->tail = tail;
 }
 
 void fbnic_mbx_poll(struct fbnic_dev *fbd)
-- 
2.53.0



