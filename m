Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9E3ACEFB;
	Sat, 12 Sep 2026 18:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237410; cv=none; b=P/0th4jLX2BMXjrD8wePU0hGNAv0FKEoEbNBMUBrs/OgJW49k3mzNlG3m/SsowojhR/SR2Bh8rUFRVQSc+m0Zo24Xp+JU4Y0CFF1/9h9TImUmEHEVkEOKtMNW4QMujpk8VxdaRLFMyl0ZDmnIgFWmP4/f3WnYdTrhRC6dahB4/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237410; c=relaxed/simple;
	bh=F1bG8Fi6FsZXbIHHqqfaPWkYGxQpN0Q+I19E2bdP6vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+E3YfckbvY4DaUTpzK2ubx07y8EHrCdPzjpFdDtBm7N459uVbjY3BT9piHvCRlhC13xioYEFGCB17BXWKsv8mwy63z961X3VkrGgJb3GzQrR+GO1a85kdhfIoGxmrLXixN1MOO/mgaSsL+njabZMCxmYca6soxFPN3O1WDVbkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9C7h3KN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9C7h3KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE501F000FF;
	Sat, 12 Sep 2026 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237408;
	bh=SYIf8WBqSYKGUPiM9F3NZu/5ZogyFICV5c72lfUPrpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9C7h3KNgVmXXay+7Bu1x+KB/v+aEoj+QAjnAudX7m/rgW8wtZb7FzKlopG4LmgD/
	 vx6iFd+Vxp9a1dvjL4qrDdQh2u6Ttkn31nex5DXW94TxuBT6/al1ngPGhYs5sohJ7U
	 5qcVIHPsiLw54EnjsCzvVqyiGB3+/CMYQ1VhS4A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 252/935] dmaengine: dw-edma: Complete descriptors before pausing
Date: Sat, 12 Sep 2026 08:54:42 +0200
Message-ID: <20260912065532.605684475@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

commit c154060016a9db2ac889bfdb0a3c1322f9be8ded upstream.

If PAUSE is requested while the final burst of a descriptor is in
flight, the DONE interrupt takes the PAUSE path without checking whether
the descriptor has been depleted. The depleted descriptor remains on the
issued list and the channel enters EDMA_ST_PAUSE.

On resume, dw_edma_start_transfer() can select that depleted descriptor
again even though no burst remains, leaving the channel in an invalid
busy state.

Check for descriptor completion before acknowledging PAUSE. If there is
no work to start on resume, leave the channel idle. Also ignore DONE
interrupts while the channel is paused so a stale or repeated interrupt
cannot change its state or start queued work.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-5-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-core.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -241,7 +241,8 @@ static int dw_edma_device_resume(struct
 		err = -EPERM;
 	} else {
 		chan->status = EDMA_ST_BUSY;
-		dw_edma_start_transfer(chan);
+		if (!dw_edma_start_transfer(chan))
+			chan->status = EDMA_ST_IDLE;
 	}
 
 	return err;
@@ -574,10 +575,16 @@ static void dw_edma_done_interrupt(struc
 	dw_edma_v0_core_clear_done_int(chan);
 
 	spin_lock_irqsave(&chan->vc.lock, flags);
+	if (chan->status == EDMA_ST_PAUSE) {
+		spin_unlock_irqrestore(&chan->vc.lock, flags);
+		return;
+	}
+
 	vd = vchan_next_desc(&chan->vc);
 	if (vd) {
 		switch (chan->request) {
 		case EDMA_REQ_NONE:
+		case EDMA_REQ_PAUSE:
 			desc = vd2dw_edma_desc(vd);
 			if (!desc->chunks_alloc) {
 				dw_hdma_set_callback_result(vd,
@@ -586,6 +593,12 @@ static void dw_edma_done_interrupt(struc
 				vchan_cookie_complete(vd);
 			}
 
+			if (chan->request == EDMA_REQ_PAUSE) {
+				chan->request = EDMA_REQ_NONE;
+				chan->status = EDMA_ST_PAUSE;
+				break;
+			}
+
 			/* Continue transferring if there are remaining chunks or issued requests.
 			 */
 			chan->status = dw_edma_start_transfer(chan) ? EDMA_ST_BUSY : EDMA_ST_IDLE;
@@ -598,11 +611,6 @@ static void dw_edma_done_interrupt(struc
 			chan->status = EDMA_ST_IDLE;
 			break;
 
-		case EDMA_REQ_PAUSE:
-			chan->request = EDMA_REQ_NONE;
-			chan->status = EDMA_ST_PAUSE;
-			break;
-
 		default:
 			break;
 		}


