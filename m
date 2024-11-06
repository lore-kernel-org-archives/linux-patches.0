Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90B41DE2CF;
	Wed,  6 Nov 2024 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899062; cv=none; b=E/Sh2kj5fTezVqnOwJSFSMDZ9FMHXb3xV2RvOqSRCL6wTf8lbWEAC3xl08ylskiWXnsrJgCthOM8/ikxLwwjNXoJlpmYe9CCGMbHTuc8RKyGRaCwiRZj4ruto+eL8KYtssgVvsA5fc5+OqM9bT2o7dx3K5aqcLMkA8KUXANRl5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899062; c=relaxed/simple;
	bh=1BaZe9iCIu4HKIEU3IkfdMBtHjj0KAVUUrM19re4n+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfSSV53CZANz56LoUALEbRhW1Pq1naPvUam7Xbd8tOc3xaicLyDwUN7X/kU4NT1hs1EpkU1jy5zZfaQnHc7+pF1NdGM4F9mAOCGADbO44GtywBhNnwqlekE9089CSzc0fX82PnONpkAkLK8lIH1itK0HMV8ASYYvHjDcYoJ1mCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOJfckuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOJfckuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE1C4CED5;
	Wed,  6 Nov 2024 13:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899061;
	bh=1BaZe9iCIu4HKIEU3IkfdMBtHjj0KAVUUrM19re4n+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOJfckukp0M42Kqyi6Xy+hj8l+Dndgdix+aZCMkxMm4zCK+oI1TT6DauBD36aIcV3
	 JvdrG/hLt62hOJtBudzclX1RKeS5/v8/nllkvaIz420GrcpSyXQNVlrpfMqmK6qKCc
	 8HmQCYVemQeUQGunTcqEaJY41kK6FSYuCsd0IwY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <quic_faisalh@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 448/462] xhci: Fix Link TRB DMA in command ring stopped completion event
Date: Wed,  6 Nov 2024 13:05:41 +0100
Message-ID: <20241106120342.571588524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faisal Hassan <quic_faisalh@quicinc.com>

commit 075919f6df5dd82ad0b1894898b315fbb3c29b84 upstream.

During the aborting of a command, the software receives a command
completion event for the command ring stopped, with the TRB pointing
to the next TRB after the aborted command.

If the command we abort is located just before the Link TRB in the
command ring, then during the 'command ring stopped' completion event,
the xHC gives the Link TRB in the event's cmd DMA, which causes a
mismatch in handling command completion event.

To address this situation, move the 'command ring stopped' completion
event check slightly earlier, since the specific command it stopped
on isn't of significant concern.

Fixes: 7f84eef0dafb ("USB: xhci: No-op command queueing and irq handler.")
Cc: stable@vger.kernel.org
Signed-off-by: Faisal Hassan <quic_faisalh@quicinc.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241022155631.1185-1-quic_faisalh@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1456,6 +1456,14 @@ static void handle_cmd_completion(struct
 
 	trace_xhci_handle_command(xhci->cmd_ring, &cmd_trb->generic);
 
+	cmd_comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
+
+	/* If CMD ring stopped we own the trbs between enqueue and dequeue */
+	if (cmd_comp_code == COMP_COMMAND_RING_STOPPED) {
+		complete_all(&xhci->cmd_ring_stop_completion);
+		return;
+	}
+
 	cmd_dequeue_dma = xhci_trb_virt_to_dma(xhci->cmd_ring->deq_seg,
 			cmd_trb);
 	/*
@@ -1472,14 +1480,6 @@ static void handle_cmd_completion(struct
 
 	cancel_delayed_work(&xhci->cmd_timer);
 
-	cmd_comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
-
-	/* If CMD ring stopped we own the trbs between enqueue and dequeue */
-	if (cmd_comp_code == COMP_COMMAND_RING_STOPPED) {
-		complete_all(&xhci->cmd_ring_stop_completion);
-		return;
-	}
-
 	if (cmd->command_trb != xhci->cmd_ring->dequeue) {
 		xhci_err(xhci,
 			 "Command completion event does not match command\n");


