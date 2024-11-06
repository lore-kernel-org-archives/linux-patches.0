Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B81F582A;
	Wed,  6 Nov 2024 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896834; cv=none; b=KIWhAaDyfFIeH2ndUrxMXi0EuMYr87hl2UpSJ9shspNaDOFv8qBxsWJ7qZ66Uo/33tuvErbw/KV/xYcNzfwzDB0mS5rpv0dMMz0+yEITrCLwdnITKlyOaGIZBPZdTd5ucd1jvafvF/B+QndCQzW7IPc0Gwo3ao64s14z3EtWqes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896834; c=relaxed/simple;
	bh=QNOjQSmVQKBEJufq+zElo3UtBFIVSBDX9IR2nYYUdRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1rgTiWjJ6T5O7n/27yjDX+XIRD6IV7nKZzWSvAwO6rcgtchSvkpwnjotdSKUJZcOgeINDKWpo9ZSN9GSW0ymNypfYkWEbRRYLNASr91/0A/nzGUbGZtW6bPzECHp7yua1DKiwob9k9FGvP2EKq2s9dd4skGXZVhISb+zXU8BJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFinDaJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFinDaJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34DFC4CECD;
	Wed,  6 Nov 2024 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896833;
	bh=QNOjQSmVQKBEJufq+zElo3UtBFIVSBDX9IR2nYYUdRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFinDaJXYfoQdVltt8a4CSyHthKNfUIasOfmytNyi0iTyRCPyuWOE6UwgqpFGVlpZ
	 b2Y9/jksn7npYaqBQb4g+BXXfZEjcCe0LCTVHS/q49p4gIuPiUCVn0kgb6AtF6PsNC
	 XJz/pDBFDEowBWCownm+rmJqpPkOarHvH8AULyhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <quic_faisalh@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 087/110] xhci: Fix Link TRB DMA in command ring stopped completion event
Date: Wed,  6 Nov 2024 13:04:53 +0100
Message-ID: <20241106120305.592682763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1582,6 +1582,14 @@ static void handle_cmd_completion(struct
 
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
@@ -1598,14 +1606,6 @@ static void handle_cmd_completion(struct
 
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


