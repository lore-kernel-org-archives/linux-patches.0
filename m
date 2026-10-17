Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A1B1F16B;
	Sat, 17 Oct 2026 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258625; cv=none; b=K0en0LelzxrWHemF4pvApO0rnksJw0aFE14TZRY3GxMi8MKLA0+I42mXd8hxJ3AuRF04YwIuyC3QvuOxhQs33xQqKuq3p51ve6SwY/1PeJcLGBFIPxCNePnrbUqtvpd2NvGQv5rdn/1Dwt17pU+MRa4G3rxEpQPsOy5RnSV7/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258625; c=relaxed/simple;
	bh=dOeG+axqM25niQzYTkoSA7B3Aa3hRzJrhlFCa9apdBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaUmLHtAWN6gy08bnoyrG0g+f1/2qMRVRQaFJNfp6Y6KFnvLxOD9aNEGeccDU91awTKzAWvXVyk2yU+/YNtmpm3/860Pmho2WAJHlK3IRydBkFEidoOb6iyLjT4wOpqcv1n4nctisEp+A3mvIs7JRjvbTRJAURdXrWFiudmz58A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVEZpISF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVEZpISF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557431F000C4;
	Sat, 17 Oct 2026 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258623;
	bh=93yblc5aPpSRJSMyfj0PHXNtTiICJHt4n4SnYISx1aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVEZpISFiDUsfw9bHEua0aHoRGWGUzIlhsG8jf4OgHXyqRd+euhaGe2VP5jgqnGMk
	 Z2+mw2s8A8hpDkYgbHeGfUpSFce1RBeg/PvC/SV3J7sWXYJYYeFtlvUUgwopgX4Z2S
	 vH25cjHRV1tFigl2tuDHcAFNWn/fERoZGWC2VdPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Peter <mario.peter@leica-geosystems.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0929/1674] usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()
Date: Sat, 17 Oct 2026 17:53:21 +0200
Message-ID: <20261017160454.980375786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/usb/chipidea/udc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 0bee561420af2..301eba2758aa6 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -773,6 +773,10 @@ __acquires(hwep->lock)
 		list_del_init(&hwreq->queue);
 		hwreq->req.status = -ESHUTDOWN;
 
+		/* Unmap DMA and clean up bounce buffers before giving back */
+		usb_gadget_unmap_request_by_dev(hwep->ci->dev->parent,
+					&hwreq->req, hwep->dir);
+
 		if (hwreq->req.complete != NULL) {
 			spin_unlock(hwep->lock);
 			usb_gadget_giveback_request(&hwep->ep, &hwreq->req);
-- 
2.53.0



