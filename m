Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A9932ED39;
	Wed,  3 Dec 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781152; cv=none; b=qucbyQFm+TZiby0W4h4i5n3lo53pR1Aub1YV/ASTLsTqp/gnzc2TZJ5vT5PzOs7RI0WE9sP4jdh9JP2DhfIycZWv8kO+N+Cj2mK737ohWUWRl0TBapnOG6muSPUJ2o9mNGi5Pyo+uDloHBydy3UTAOeqFgZs24N0VECsW94pE04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781152; c=relaxed/simple;
	bh=sQNLXABx1b1T2TdhxnceaDFcfsCoBApJRvghha7b6lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYrmeBj/U2UQLyMK3hmh+COqw9ri9J9zXKhAuLJDVZKB7CJYuArj/dN/Y/9D5WvqMvUAPkbMb6v4R0oHyYUND+dPrjvQrvkBdihVti4ClneiahHHlyCoCwRv/v4V1yKPRIm/o+Irs0q8Txty+tP8zkJO/NDQdiP2TK8fVcB/tGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugEh3HLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugEh3HLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6CFC4CEF5;
	Wed,  3 Dec 2025 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781151;
	bh=sQNLXABx1b1T2TdhxnceaDFcfsCoBApJRvghha7b6lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugEh3HLF7OPEoT/Rmyy+p34J5g1bbn7CBKmoTIdk7Qmy8Mmndq89aUzhyNjwIZ+J4
	 0dTasfOwZIqvPH1YBHT6rn/RYNZ9PzZ5j9oV5ZfWgKB/C4QPT2VhLHCQDZ7ogc3dCy
	 JnskJ/zb7P0ZX0/SrzSbXSTtPr3tluSGFuk5XPZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Manish Nagar <manish.nagar@oss.qualcomm.com>
Subject: [PATCH 6.6 66/93] usb: dwc3: Fix race condition between concurrent dwc3_remove_requests() call paths
Date: Wed,  3 Dec 2025 16:29:59 +0100
Message-ID: <20251203152338.965856437@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: Manish Nagar <manish.nagar@oss.qualcomm.com>

commit e4037689a366743c4233966f0e74bc455820d316 upstream.

This patch addresses a race condition caused by unsynchronized
execution of multiple call paths invoking `dwc3_remove_requests()`,
leading to premature freeing of USB requests and subsequent crashes.

Three distinct execution paths interact with `dwc3_remove_requests()`:
Path 1:
Triggered via `dwc3_gadget_reset_interrupt()` during USB reset
handling. The call stack includes:
- `dwc3_ep0_reset_state()`
- `dwc3_ep0_stall_and_restart()`
- `dwc3_ep0_out_start()`
- `dwc3_remove_requests()`
- `dwc3_gadget_del_and_unmap_request()`

Path 2:
Also initiated from `dwc3_gadget_reset_interrupt()`, but through
`dwc3_stop_active_transfers()`. The call stack includes:
- `dwc3_stop_active_transfers()`
- `dwc3_remove_requests()`
- `dwc3_gadget_del_and_unmap_request()`

Path 3:
Occurs independently during `adb root` execution, which triggers
USB function unbind and bind operations. The sequence includes:
- `gserial_disconnect()`
- `usb_ep_disable()`
- `dwc3_gadget_ep_disable()`
- `dwc3_remove_requests()` with `-ESHUTDOWN` status

Path 3 operates asynchronously and lacks synchronization with Paths
1 and 2. When Path 3 completes, it disables endpoints and frees 'out'
requests. If Paths 1 or 2 are still processing these requests,
accessing freed memory leads to a crash due to use-after-free conditions.

To fix this added check for request completion and skip processing
if already completed and added the request status for ep0 while queue.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Manish Nagar <manish.nagar@oss.qualcomm.com>
Link: https://patch.msgid.link/20251120074435.1983091-1-manish.nagar@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c    |    1 +
 drivers/usb/dwc3/gadget.c |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -94,6 +94,7 @@ static int __dwc3_gadget_ep0_queue(struc
 	req->request.actual	= 0;
 	req->request.status	= -EINPROGRESS;
 	req->epnum		= dep->number;
+	req->status		= DWC3_REQUEST_STATUS_QUEUED;
 
 	list_add_tail(&req->list, &dep->pending_list);
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -229,6 +229,13 @@ void dwc3_gadget_giveback(struct dwc3_ep
 {
 	struct dwc3			*dwc = dep->dwc;
 
+	/*
+	 * The request might have been processed and completed while the
+	 * spinlock was released. Skip processing if already completed.
+	 */
+	if (req->status == DWC3_REQUEST_STATUS_COMPLETED)
+		return;
+
 	dwc3_gadget_del_and_unmap_request(dep, req, status);
 	req->status = DWC3_REQUEST_STATUS_COMPLETED;
 


