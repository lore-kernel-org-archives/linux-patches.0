Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C9E1F428D;
	Wed,  6 Nov 2024 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897536; cv=none; b=nAJG1liwZClcNZiDfa242KMDtijPVENxHsmZsVxjY5j4bx9t23pGsHx3vvocTNCUz9k4tlG/FvmPg1NW1JgVmj8vS6cUzG5AEk5c8FAigsCeWTu+RYGpZypMVH3+pZ7QdNo1+QQVyESxzA1KhMKc8r+PKKckMDDOxGpwi0DN1qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897536; c=relaxed/simple;
	bh=7Xm5soon2no+QF0kD6LCU+DwJEsIFlBHvOkfbLzHklA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djhLqPEo/gkVZRweOl3WSvv2HYEdO/GvzeVw6yw0tns1+BK6ay0OS5Nd5zwyjxA9jXWEN5pzYezufo9V/WLH58gWJkJATrac6P7k8ar28gD+oYwM02XbwZGqOLfb54TyQ1tlptLF28RjMcqN6LHoM4uI83Y/PRWxMh17fSY/9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcqKUAgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcqKUAgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBE7C4CED3;
	Wed,  6 Nov 2024 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897536;
	bh=7Xm5soon2no+QF0kD6LCU+DwJEsIFlBHvOkfbLzHklA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcqKUAgvI1ltSVk4Xv82OAbOaRkSs+RjQ24gh/Mw7CHqFP5MX8KjH1y/1LbvW+pdo
	 Wwd+ND001GxVyl/Sm9Tic2lOamFzEQmA/kQIrehWDD5ndiACeFeleaAZqRmtKpCLnY
	 O+zkIT94ie8RtkJe+4udJME6ph9Lh53hoCZ6rqpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <quic_faisalh@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 087/151] xhci: Fix Link TRB DMA in command ring stopped completion event
Date: Wed,  6 Nov 2024 13:04:35 +0100
Message-ID: <20241106120311.259680461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1734,6 +1734,14 @@ static void handle_cmd_completion(struct
 
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
@@ -1750,14 +1758,6 @@ static void handle_cmd_completion(struct
 
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


