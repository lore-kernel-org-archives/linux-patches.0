Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F3742A15E;
	Thu, 16 Jul 2026 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211909; cv=none; b=auPrWbJLsTtsAErOHjvBdFAcNh1UgA/FCItDBeJXzsAzQdIkGMXhljnbIn31bg+zWMQJrteY6xq2LT1DaQ7PB9JhWdL9SkA5vtAffhHAeVfwJ1vES8xxFG686ffwbkMgZCVdPxqSBgL8Jtw5PcL30hYt3iUQjSkxlJL+K06bQP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211909; c=relaxed/simple;
	bh=Ff1l7VJiNflVrEhKDYbtDFYs35M8mrXPGFr46GSWhYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VbDJ7pIIOxxHjt0NQ5rRAJDl5GYE1YjauaKiAHLP9WsQPT7s3GBHlrHYuCIBwuRjrhH8zirklnf5KWIWeaWxX+2/sT3cu8TdyK/55UkDuINazM6dabsKFL618XCMklyh4RveanBYi6RZtKzu9R5OMiRDh8fCn5a5kjp7C9M6Mes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGghrsED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGghrsED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A71F000E9;
	Thu, 16 Jul 2026 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211908;
	bh=awOw2b8JJfyBlDZ+jQKMVhzV1JmtmTl6pUJ9Jarns9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGghrsED8fJyRO5So+L91ul/yn1T/2azOpSBCTnzNt3uSGo/WaH1h1/MtCf9+nh+s
	 SRyIt+GJvWJnd6aBXFYTz27CFDZ3Omu7CpF5wnMSj0mp7AFdkMDJsvyrsaLSu9g6pu
	 i2X8H9IXffKGlXsmUPO6ym6mKmm6sypxhIh5lt0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 099/349] usb: xhci: Fix sleep in atomic context in xhci_free_streams()
Date: Thu, 16 Jul 2026 15:30:33 +0200
Message-ID: <20260716133035.530487461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 胡连勤 <hulianqin@vivo.com>

commit 42c37c4b75d38b51d84f31a8e29427f5e06a7c2a upstream.

When a USB device with active stream endpoints is disconnected,
xhci_free_streams() is called from the hub_event workqueue to
free the stream resources.  It calls xhci_free_stream_info()
while holding xhci->lock with irqs disabled.

xhci_free_stream_info() invokes xhci_free_stream_ctx(), which
calls dma_free_coherent() for large stream context arrays.

dma_free_coherent() can sleep (e.g. via vunmap), triggering
a BUG when called from atomic context.

Call trace:
 dma_free_attrs+0x174/0x220
 xhci_free_stream_info+0xd0/0x11c
 xhci_free_streams+0x278/0x37c
 usb_free_streams+0x98/0xc0
 usb_unbind_interface+0x1b8/0x2f8
 device_release_driver_internal+0x1d4/0x2cc
 device_release_driver+0x18/0x28
 bus_remove_device+0x160/0x1a4
 device_del+0x1ec/0x350
 usb_disable_device+0x98/0x214
 usb_disconnect+0xf0/0x35c
 hub_event+0xab4/0x19ec
 process_one_work+0x278/0x63c

Fix this by saving the stream_info pointers and clearing the
ep references under the lock, then calling xhci_free_stream_info()
outside the lock where sleeping is allowed.

Fixes: 8df75f42f8e6 ("USB: xhci: Add memory allocation for USB3 bulk streams.")
Cc: stable <stable@kernel.org>
Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260703144033.483286-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3576,6 +3576,7 @@ static int xhci_free_streams(struct usb_
 	struct xhci_virt_device *vdev;
 	struct xhci_command *command;
 	struct xhci_input_control_ctx *ctrl_ctx;
+	struct xhci_stream_info *stream_info[EP_CTX_PER_DEV];
 	unsigned int ep_index;
 	unsigned long flags;
 	u32 changed_ep_bitmask;
@@ -3636,10 +3637,15 @@ static int xhci_free_streams(struct usb_
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * dma_free_coherent() called by xhci_free_stream_info() may sleep,
+	 * so save stream_info pointers and clear references under lock,
+	 * then free the memory outside lock.
+	 */
 	spin_lock_irqsave(&xhci->lock, flags);
 	for (i = 0; i < num_eps; i++) {
 		ep_index = xhci_get_endpoint_index(&eps[i]->desc);
-		xhci_free_stream_info(xhci, vdev->eps[ep_index].stream_info);
+		stream_info[i] = vdev->eps[ep_index].stream_info;
 		vdev->eps[ep_index].stream_info = NULL;
 		/* FIXME Unset maxPstreams in endpoint context and
 		 * update deq ptr to point to normal string ring.
@@ -3649,6 +3655,9 @@ static int xhci_free_streams(struct usb_
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	for (i = 0; i < num_eps; i++)
+		xhci_free_stream_info(xhci, stream_info[i]);
+
 	return 0;
 }
 


