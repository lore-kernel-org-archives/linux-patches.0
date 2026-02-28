Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D697E3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301175; cv=none; b=mq15CE8+wmX6LHlQkt1l6WT2q7jtXYq7DRHX24rpMfmOHCMJci+7/ufGdhdHtGEffEsZ+bOxyqCW4wVfKRPecN8sFU7FV70sIfVlwoFQl3pf0GrgfGfm7QZCiOuXkD9V26nEzIyam4z3kvW8hNt898TWHQP32F8lDJh7cFCExzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301175; c=relaxed/simple;
	bh=uB02P82FG2llshEYJ+80qIcj8UQiobQ13+TnUgGKNNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvSmqxuQAEiLy5NBBSFikYXNRk2jmgpUpyxc+grHdMotosdq60yooTDMIkqdMETpez6gVJ0nSmkDkFDe6erUt+wrJzpscz98qn3ZWOvO1dzfLyLYpiCr6zmkUkI+7RfaF0wIb8IWtDk6i6RnE/4RGhyfbwoTRIBafsd0Ubo/7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJM/2C9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJM/2C9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B43DC116D0;
	Sat, 28 Feb 2026 17:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301175;
	bh=uB02P82FG2llshEYJ+80qIcj8UQiobQ13+TnUgGKNNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJM/2C9p3tBM+TQy1Ty1kt00HEMbkliDDvxTJRGWMZztBJ4lp3X3IlVmfUtz1gqxq
	 +W7dso5fISiodOx9zSRZgE5P02o4KWN065WFwwwv5vYrbg+Vv27gHKlBkbIOgX20mI
	 tgDieDaw17M47XtbSWNZMqH53CL5u/WcegpN77j6npiKxOKUPcuExd0ENJrg+GUnzS
	 NbGMyY/2pGdDVwa8fJvE/FfcrcHG8XU9Y2R2g7N0biKpd/DnlpcJT51GAMUOoBB4gM
	 iA+HLwgH4NC2VCHZgYuK144juSdknIMjVK/Mdca5Y768Bu6SygQpdG5gYIIZTpcAAp
	 tM/19sOJgTryw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mario Peter <mario.peter@leica-geosystems.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/752] usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()
Date: Sat, 28 Feb 2026 12:40:54 -0500
Message-ID: <20260228174750.1542406-343-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mario Peter <mario.peter@leica-geosystems.com>

[ Upstream commit cea2a1257a3b5ea3e769a445b34af13e6aa5a123 ]

The ChipIdea UDC driver can encounter "not page aligned sg buffer"
errors when a USB device is reconnected after being disconnected
during an active transfer. This occurs because _ep_nuke() returns
requests to the gadget layer without properly unmapping DMA buffers
or cleaning up scatter-gather bounce buffers.

Root cause:
When a disconnect happens during a multi-segment DMA transfer, the
request's num_mapped_sgs field and sgt.sgl pointer remain set with
stale values. The request is returned to the gadget driver with status
-ESHUTDOWN but still has active DMA state. If the gadget driver reuses
this request on reconnect without reinitializing it, the stale DMA
state causes _hardware_enqueue() to skip DMA mapping (seeing non-zero
num_mapped_sgs) and attempt to use freed/invalid DMA addresses,
leading to alignment errors and potential memory corruption.

The normal completion path via _hardware_dequeue() properly calls
usb_gadget_unmap_request_by_dev() and sglist_do_debounce() before
returning the request. The _ep_nuke() path must do the same cleanup
to ensure requests are returned in a clean, reusable state.

Fix:
Add DMA unmapping and bounce buffer cleanup to _ep_nuke() to mirror
the cleanup sequence in _hardware_dequeue():
- Call usb_gadget_unmap_request_by_dev() if num_mapped_sgs is set
- Call sglist_do_debounce() with copy=false if bounce buffer exists

This ensures that when requests are returned due to endpoint shutdown,
they don't retain stale DMA mappings. The 'false' parameter to
sglist_do_debounce() prevents copying data back (appropriate for
shutdown path where transfer was aborted).

Signed-off-by: Mario Peter <mario.peter@leica-geosystems.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260108165902.795354-1-mario.peter@leica-geosystems.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 64a421ae0f05b..c8d931d9d4330 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -931,6 +931,13 @@ __acquires(hwep->lock)
 		list_del_init(&hwreq->queue);
 		hwreq->req.status = -ESHUTDOWN;
 
+		/* Unmap DMA and clean up bounce buffers before giving back */
+		usb_gadget_unmap_request_by_dev(hwep->ci->dev->parent,
+					&hwreq->req, hwep->dir);
+
+		if (hwreq->sgt.sgl)
+			sglist_do_debounce(hwreq, false);
+
 		if (hwreq->req.complete != NULL) {
 			spin_unlock(hwep->lock);
 			usb_gadget_giveback_request(&hwep->ep, &hwreq->req);
-- 
2.51.0

