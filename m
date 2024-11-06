Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F381DF75A;
	Wed,  6 Nov 2024 12:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897112; cv=none; b=lJq0pER7SyHyHQFY3dXIwM4/DaMQ8fv/F697o6aFtPEcfmp5qjE8IrSfkl6Pve3KjklYaY/Klzw0UYR53rJAMpCI25YfE432Ce9QC2vtWFP1VXPf2e1qiACcJgMiIAAfjvlRwsJIe5UIpQ6NLy3NNObaFaaEK6v3x2HNmMJvQUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897112; c=relaxed/simple;
	bh=/ofLAKEF6d7iUnVpV37Ca5eS1ezefp9Re5gnnblDmEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqYKgQb9vPkq41rQHh1fHIuCXfayGe2DMHl7V861GrNwA5xWQ0RTLBiS9eeVHDqp+6mFAgjjgWFPdlIVnuWj2UYv2uzdftpXzAsyfUg79a9JgBuobEf0nPeSjITT5IsjSdNsxpJd+US+W54J1kZkEbTFsEkRKh2+MrYxs9OChog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmu/tKtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmu/tKtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4CBC4CECD;
	Wed,  6 Nov 2024 12:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897111;
	bh=/ofLAKEF6d7iUnVpV37Ca5eS1ezefp9Re5gnnblDmEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmu/tKtIN8NaG7iER5eZ7uL9epzJe93YXod4E9v3tpT3mSXfkJlFZdGE6JMoJHLCc
	 FA/Ic1CdLAMeXNEa+DqW5RkgpYH8qE40E7Bjf8PkovZKovzUuZMTvWWUx7qX7rNAHX
	 lOxRKfBBuM6ErmhSk3AYC5uY6xptf5m6Y2y5DnRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <quic_faisalh@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 069/126] xhci: Fix Link TRB DMA in command ring stopped completion event
Date: Wed,  6 Nov 2024 13:04:30 +0100
Message-ID: <20241106120307.955673477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1704,6 +1704,14 @@ static void handle_cmd_completion(struct
 
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
@@ -1720,14 +1728,6 @@ static void handle_cmd_completion(struct
 
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


