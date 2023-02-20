Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5DD63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFCEC433EF;
	Mon, 20 Feb 2023 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901624;
	bh=Wcg7d1RjQQjP0pw2pYB6z2Me/ssgPIJylH9P6+R40po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uo1At+w0pSIRFKclI7jGfGbRiU/2Ku3PA6zvhAh86FaM1LT4LxzcD9y/UN3v0jAfa
	 JJzUwahwR5qiQPkJbLTd0QjGnxl1wqQOQDIhoKGB/4I4/BuQOsJ4fPob3YU5OsjnIC
	 8SJru81KosRUVI5cxJzfXFZ1iFavERSQlUu6VBI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 088/118] ice: xsk: Fix cleaning of XDP_TX frames
Date: Mon, 20 Feb 2023 14:36:44 +0100
Message-Id: <20230220133603.928977838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Larysa Zaremba <larysa.zaremba@intel.com>

commit 1f090494170ea298530cf1285fb8d078e355b4c0 upstream.

Incrementation of xsk_frames inside the for-loop produces
infinite loop, if we have both normal AF_XDP-TX and XDP_TXed
buffers to complete.

Split xsk_frames into 2 variables (xsk_frames and completed_frames)
to eliminate this bug.

Fixes: 29322791bc8b ("ice: xsk: change batched Tx descriptor cleaning")
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230209160130.1779890-1-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -789,6 +789,7 @@ static void ice_clean_xdp_irq_zc(struct
 	struct ice_tx_desc *tx_desc;
 	u16 cnt = xdp_ring->count;
 	struct ice_tx_buf *tx_buf;
+	u16 completed_frames = 0;
 	u16 xsk_frames = 0;
 	u16 last_rs;
 	int i;
@@ -798,19 +799,21 @@ static void ice_clean_xdp_irq_zc(struct
 	if ((tx_desc->cmd_type_offset_bsz &
 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
 		if (last_rs >= ntc)
-			xsk_frames = last_rs - ntc + 1;
+			completed_frames = last_rs - ntc + 1;
 		else
-			xsk_frames = last_rs + cnt - ntc + 1;
+			completed_frames = last_rs + cnt - ntc + 1;
 	}
 
-	if (!xsk_frames)
+	if (!completed_frames)
 		return;
 
-	if (likely(!xdp_ring->xdp_tx_active))
+	if (likely(!xdp_ring->xdp_tx_active)) {
+		xsk_frames = completed_frames;
 		goto skip;
+	}
 
 	ntc = xdp_ring->next_to_clean;
-	for (i = 0; i < xsk_frames; i++) {
+	for (i = 0; i < completed_frames; i++) {
 		tx_buf = &xdp_ring->tx_buf[ntc];
 
 		if (tx_buf->raw_buf) {
@@ -826,7 +829,7 @@ static void ice_clean_xdp_irq_zc(struct
 	}
 skip:
 	tx_desc->cmd_type_offset_bsz = 0;
-	xdp_ring->next_to_clean += xsk_frames;
+	xdp_ring->next_to_clean += completed_frames;
 	if (xdp_ring->next_to_clean >= cnt)
 		xdp_ring->next_to_clean -= cnt;
 	if (xsk_frames)


