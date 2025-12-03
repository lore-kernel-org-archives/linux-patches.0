Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F8C317715;
	Wed,  3 Dec 2025 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777220; cv=none; b=KN2lc4tYwnx4mTYbZY2j8S1EakgOgSyCP1qN4uyLmnyvWJm1hqUDFZemIbfZpvbNzDd1e80lNeBYsPIemPcT0pynykJ6VdAFlZkCyK9GINTTPmFO83vf2N0DQQyfsEAAaUhKRdytG/5tNQ5+bxWBkxWHHELY3pedZCtVAa+pBiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777220; c=relaxed/simple;
	bh=RyC8OeKmKMHo2XbXVWRu26ChHXhRsV12jQmjmVy8QII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dbv5Ow1xd/Z5tKcZyF8mEey8c7iVX0PGue7K0gv65Ogol/pvzEdGViIFX5ME0v+3wKseR1i5NPQ/yozMqSPV6rsffXMZcMRMXvDfeY3Uz1nR4h4KumbP4AK5JZW9lJK4UiObxdrsGojc1TI2G0l8k5+ZraL1eMjQpqjIKx9Y6PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCPctvji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCPctvji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6422C4CEF5;
	Wed,  3 Dec 2025 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777220;
	bh=RyC8OeKmKMHo2XbXVWRu26ChHXhRsV12jQmjmVy8QII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCPctvjipziTJBYbwNj4kvSEi7fZdvl7O2V+fHo5pOUz8dWIyKnFhcR5NxBcXY6r8
	 wnrVCd7rYyM3x4dLdZMP5kljrt256B7Bi3MaoWQHb89U0g5C4SGx6X377UlAXBYZlv
	 Pn8QybOol+Qp2T7JDW5jsu1V9/pq2XFhxDfiFEEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Manish Nagar <manish.nagar@oss.qualcomm.com>
Subject: [PATCH 6.17 120/146] usb: dwc3: Fix race condition between concurrent dwc3_remove_requests() call paths
Date: Wed,  3 Dec 2025 16:28:18 +0100
Message-ID: <20251203152350.855303484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -228,6 +228,13 @@ void dwc3_gadget_giveback(struct dwc3_ep
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
 


