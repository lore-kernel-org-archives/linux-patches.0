Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DB72FFDE1;
	Thu, 16 Jul 2026 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210667; cv=none; b=BST8YAA2fhickOKRbONxNxM7ZL2mWRidVlO/vq2NPEWIhqhyK4MYNBJ/nkUoCzDzswOsnl7FsoGNjendRyPMKrC2mE6deMhsdfWqX28WfEwE6jdTHcCsS4qVF5iAeLHiz/YnaQCn31Ms8GpcKJImG+JQRmzlFuLouudL288Mcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210667; c=relaxed/simple;
	bh=XgMjKK7cXkZn/n6cl5orxNPQr7o9SSnzxXdNQxYq5Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6gKQUnjH+hEGzdtrjZg+r1X4wIrmhcoF6f7zsS5YC9D8WPa1p9qclb8j8HbyFqROPqfoNi7w2k9t51rE8tl0Qq/ZGy/EIrnuqepPsbapbMm2KAEyIaUwKEltMBP/tY0aWde5XHm4ZEzkZqM+QM5Zd4wuj4TDTSV+kg9cZTUVUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzw5L6so; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzw5L6so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2A61F000E9;
	Thu, 16 Jul 2026 14:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210666;
	bh=mFgPB+WIBPcgKfcoG6Z0IozAcVgn1zgGU3HiztS8cyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzw5L6soTfbIUAvqwo8M7tqLxFPqbzicUqYTGQfvAca+UYqO6xqQeg8atIe6qyxOK
	 iQjNb4gdkPEn/hKOhsa+DDAzjCqK2eLf1WMHkiwVTp7OjzHUE80TWinYe5KNmq2Sup
	 gBd6OW+R5E+SuPEGShrOpElP/MmGwl8aBLkiK0lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 132/480] usb: xhci: Fix sleep in atomic context in xhci_free_streams()
Date: Thu, 16 Jul 2026 15:27:59 +0200
Message-ID: <20260716133047.566299282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3774,6 +3774,7 @@ static int xhci_free_streams(struct usb_
 	struct xhci_virt_device *vdev;
 	struct xhci_command *command;
 	struct xhci_input_control_ctx *ctrl_ctx;
+	struct xhci_stream_info *stream_info[EP_CTX_PER_DEV];
 	unsigned int ep_index;
 	unsigned long flags;
 	u32 changed_ep_bitmask;
@@ -3834,10 +3835,15 @@ static int xhci_free_streams(struct usb_
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
@@ -3847,6 +3853,9 @@ static int xhci_free_streams(struct usb_
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	for (i = 0; i < num_eps; i++)
+		xhci_free_stream_info(xhci, stream_info[i]);
+
 	return 0;
 }
 


