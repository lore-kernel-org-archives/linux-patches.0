Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15F726299;
	Sat, 12 Sep 2026 19:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241897; cv=none; b=YC1oXpwA+RpuVkj15vqsHDgPa2PG14LjFwXkABVuO9viJ1eDriW/CmH1ToOErok4sYU/Wb1raCEcUWja3fpH9n26eWxRJSdqQO1s8UdzSGkoIaJMXRu3TxgDcJwuiQK/MfZ+6hgU5pcNAj9TiUyiUfpXx9h4qQkikGo16VNxER4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241897; c=relaxed/simple;
	bh=2Lu0DCP2QP5EgAOrdB5qE+kNRmf/FUPhZYxL1OY/5LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYqXNnWytPhIx0rioQkvLz4dTvwICVQEdVYEEjkqvBt0Cza9EW84kpSSfJuwh9NPn7oUi4I//VENHHS9GLJ0l6zigqOLpcgZkYyGXqz4pyu89PZ3UDDo4VV2yLQG4HRH5m2zG40A6QpX+JxUIbdcvylkvijCh3ytK06KVWnBWKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9jliVrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9jliVrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89511F000FF;
	Sat, 12 Sep 2026 19:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241896;
	bh=un0HVn44hkNON5df55z59rD54k8zyWDHuMWs5Z7IU9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9jliVrKIucZiEGorPRyxcNQL+TJEQ7U74MfCII8wnonoud9E2dbtqzwkkx2CjnBT
	 DyOgNbRzlqjoFN32ElbGgH2mhp7WIFlardjviJLwgz82FO7/020YQPH42oZBfU8nrS
	 KZENZNpgavMPvnqOvzlJ2x6e+kYTUjYkGBRldBxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 229/798] dmaengine: dw-edma: Complete descriptors before pausing
Date: Sat, 12 Sep 2026 08:57:37 +0200
Message-ID: <20260912065522.390131999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -521,10 +522,16 @@ static void dw_edma_done_interrupt(struc
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
@@ -533,6 +540,12 @@ static void dw_edma_done_interrupt(struc
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
@@ -545,11 +558,6 @@ static void dw_edma_done_interrupt(struc
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


