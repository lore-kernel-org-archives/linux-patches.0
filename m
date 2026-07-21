Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFD545A29F;
	Tue, 21 Jul 2026 21:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671077; cv=none; b=KD7R3j7+jNTTtBP8NuwsMkXIHHqgkPPaFJaCrHyPUcMxMKIDOfHFV2Ro2aD85BxUmqSG8jE8zyNu3XyylY/8aB9gt28+z9jYn+n30bC1O2aRz4xlRkDIahQXQoYNMWyvLrNt3RtpTtbNNWOoUhh+ZrcpVEPjwRXdfo4Uf8pLtBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671077; c=relaxed/simple;
	bh=blJxiBtVv1Q/fNTjA4FxdaSKuDUhckkZAwSifGjL49c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oktA7GqmMx5tpJxKXflx1eFAeAB/eqRzkSMTG0f38nMRtkFd2As2/6LSgB15PRHtr9EaMXkWVWoxcu5LfvbFroADGH20Mzd0Mh3KsAKMrTaGSU5HF3f1ABRziWaCI6Y9Ud4uvbXRGj7v5IgkXheuiJO/Ww+RxJ6MRzlhHImH5zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GP4LKJiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GP4LKJiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F031F000E9;
	Tue, 21 Jul 2026 21:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671071;
	bh=HCaKnJfQn4+0DzWaENf5BftJOJJK+nZyRGOpMfUKLOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GP4LKJiHZvuf1feWDs0paaDhTnnGgB3FYJUXjLzXj87GGM0tQQNCkl/D8bMt0XmVE
	 Z8PJnDZJ7P22Cp61mS5lq+ms7mBtRsnFbL8k6s4hcCAVo7QjPgxkRcdmx6j4ra0ObS
	 Qj7ICGjIyDJWuL/GWJYpdceFwOjricKR1QubOc1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lianqin Hu <hulianqin@vivo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 081/843] usb: xhci: Fix sleep in atomic context in xhci_free_streams()
Date: Tue, 21 Jul 2026 17:15:16 +0200
Message-ID: <20260721152407.822019781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3710,6 +3710,7 @@ static int xhci_free_streams(struct usb_
 	struct xhci_virt_device *vdev;
 	struct xhci_command *command;
 	struct xhci_input_control_ctx *ctrl_ctx;
+	struct xhci_stream_info *stream_info[EP_CTX_PER_DEV];
 	unsigned int ep_index;
 	unsigned long flags;
 	u32 changed_ep_bitmask;
@@ -3770,10 +3771,15 @@ static int xhci_free_streams(struct usb_
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
@@ -3783,6 +3789,9 @@ static int xhci_free_streams(struct usb_
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	for (i = 0; i < num_eps; i++)
+		xhci_free_stream_info(xhci, stream_info[i]);
+
 	return 0;
 }
 


