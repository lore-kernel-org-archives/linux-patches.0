Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05362594BD;
	Sat, 12 Sep 2026 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221300; cv=none; b=sANnnIFNiVDACiws4PCla3bk0MAzwKC6+lvShvEk5clL8Pwxshzs7eeuxxqzNBP32zdaNcSsnz1o1j/XwSi1D304vFlZsCQcuuq1VfVXHDqRsD2yJJg+SXj0iaRQB8XfG8ZoxVEDvMhsAx2FMp/o4o/lFQbTGZMu/Ilr9Y0SY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221300; c=relaxed/simple;
	bh=+blB3trMpgV1angv+EiXur9k2XF6/0BNgLD8FyzKf/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw00B87O2qwBgE9Bb34Yhac9y52OcF3mbL/gMcpT6nBhPBjpnwllfX7Ys+9RSmoRCipwk06bVFUkwoqMINe5a8jnMPoyZVojIkxiO8rGiT2iMAQ2tdGC9zCLI3cnMfd7pDrxilMr2l4BWUYazeJ6XQAq8jom5JuYk1xMWScayJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbQ4Abzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbQ4Abzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3261F000FF;
	Sat, 12 Sep 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221298;
	bh=MpEVvqo8S0qlbYDtM78qli2KdqA+VcA5KszrZ+gmuV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbQ4Abzsx2CG/zjjLGbFz/xloOmer/wRoR5l8ixWOHuuxCPXLNh9xSYUeBBWtO/fL
	 vcKTvJmLbMBzQ96ehGtceq1yri6SaRQBTZ6GO3r2O8hF/tS/XdXrgu5PlydQtSS3Zz
	 QqSwXNcPvMqRJZDNbsGO4ETqI7Qt/hmgad1Yu+EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 0355/1424] dmaengine: dw-edma: Complete descriptors before pausing
Date: Sat, 12 Sep 2026 08:46:27 +0200
Message-ID: <20260912065615.237666211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -271,7 +271,8 @@ static int dw_edma_device_resume(struct
 		err = -EPERM;
 	} else {
 		chan->status = EDMA_ST_BUSY;
-		dw_edma_start_transfer(chan);
+		if (!dw_edma_start_transfer(chan))
+			chan->status = EDMA_ST_IDLE;
 	}
 
 	return err;
@@ -621,10 +622,16 @@ static void dw_edma_done_interrupt(struc
 	unsigned long flags;
 
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
@@ -633,6 +640,12 @@ static void dw_edma_done_interrupt(struc
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
@@ -645,11 +658,6 @@ static void dw_edma_done_interrupt(struc
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


