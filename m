Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20616F8E9;
	Wed,  5 Feb 2025 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766587; cv=none; b=GHnILI9f5SS1niNEAfcHX82GjM5VpkYh0+s/n3buXTA/8qzGweSxibkIPXfKrKJnZD2yL6l///vIPFyxjZ+F3cMPCDaLxyrHAKZ4qBm+Y5D43Mw5eZwkT3L5GzZi0/DUrGwsu0gDVEG2osxzWzD5qzwwprvAW7dR2QFIA+SynJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766587; c=relaxed/simple;
	bh=83ysKGG1SapOo4zMn7yRNc7+Adjv7MpOsJMJlbFenHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajcfLwLxmvnJiFgUvHqp/h+el8MQ6zkwsLtFCrZzpUy3prkKlozRETqFUef/T4wmZnOiOgQ82gbIyLqMeLSzqM5PVC7rdtyBFx9eCs0HY0tgCS1EKCQG2nhEewHt6CiCYSdL1oksqmPQOL38+YOO80To8Bb3cBKgkz09o199kVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDSRaM8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDSRaM8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3795C4CED6;
	Wed,  5 Feb 2025 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766587;
	bh=83ysKGG1SapOo4zMn7yRNc7+Adjv7MpOsJMJlbFenHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDSRaM8W1yXueHL+MiMy5R+ze9S9/zUPM8iTiDcbRvxY3GUoPAhPQgCDtLFyRS6m/
	 3zrTMhrEFs2Zga1N1PRhD/Mo0qVG3jUemB7ivwlub4Z8yKMNGKUbbhLBnlQ9fzFK1s
	 m/1Jcc3kUroIq/0gjzStx/9vvQW39kaUA/42TmgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 376/393] usb: xhci: Fix NULL pointer dereference on certain command aborts
Date: Wed,  5 Feb 2025 14:44:55 +0100
Message-ID: <20250205134434.680142810@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Pecio <michal.pecio@gmail.com>

commit 1e0a19912adb68a4b2b74fd77001c96cd83eb073 upstream.

If a command is queued to the final usable TRB of a ring segment, the
enqueue pointer is advanced to the subsequent link TRB and no further.
If the command is later aborted, when the abort completion is handled
the dequeue pointer is advanced to the first TRB of the next segment.

If no further commands are queued, xhci_handle_stopped_cmd_ring() sees
the ring pointers unequal and assumes that there is a pending command,
so it calls xhci_mod_cmd_timer() which crashes if cur_cmd was NULL.

Don't attempt timer setup if cur_cmd is NULL. The subsequent doorbell
ring likely is unnecessary too, but it's harmless. Leave it alone.

This is probably Bug 219532, but no confirmation has been received.

The issue has been independently reproduced and confirmed fixed using
a USB MCU programmed to NAK the Status stage of SET_ADDRESS forever.
Everything continued working normally after several prevented crashes.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219532
Fixes: c311e391a7ef ("xhci: rework command timeout and cancellation,")
CC: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241227120142.1035206-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -420,7 +420,8 @@ static void xhci_handle_stopped_cmd_ring
 	if ((xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue) &&
 	    !(xhci->xhc_state & XHCI_STATE_DYING)) {
 		xhci->current_cmd = cur_cmd;
-		xhci_mod_cmd_timer(xhci);
+		if (cur_cmd)
+			xhci_mod_cmd_timer(xhci);
 		xhci_ring_cmd_db(xhci);
 	}
 }


