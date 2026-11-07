Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063263;
	b=1CWWYltP4aeLqWs3eUNWhyKVs2F6yXnQGaPkWwcOhSnIbpbvRUgvTr34Qjk/dGeS0Tq5
	 z+xbvlw0liOeY+hf7WAycjwziyqszdGzC6DtDtq+mSeeTRosTbZmqMDYX548j46WYibuc
	 bkeQmPFUI2KUIaJh/WQAOo6cjvPxRqqbDqDhlEORgYQuOKVgwBYZLfxktjOnKGo9GBEyA
	 LFVeNXQaMcPJkqpFlejHa8hFLzre/Grtxc7NzytZV0/6q5eWv09Or8Wl9QUdggXmZusIz
	 95HoFsCVCHcr3XaGSM2rnAtA/bqSPCSJtR9f+MiLictJvMByMXa+MYiS8rF34wHWqZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=24gU/KgfGj8QeJAz0ZStW064iZpc+XW34zBhP7nLStQ=;
	b=APhqtv4rnSnlc0n521bLHSgP5Qn1j88iymKukHAH1D9NDov1sds1jLx4c5zEiUTx9xoz
	 r/0gITMqmTOHpbwdzHqmz7ki1vNBOMlJSSYrUYN6/K7wxWX+O1WgCnDk5XoQDLSAaXQJd
	 /iFoimAhP1FsG5UsRZxFBgp4T0aFygT/ZKZRHD8W1iOd5sWpTZGu26Y+fbsaWfhBSn0PX
	 kow+JArob6lTYN3+P4G9fUJI7s49+7kcUTGTRNraPaedX9/II7B4OayX6aMAXMOoZTiNW
	 LBVVDNmuo+Mc1gp6rEl3o1D5v/nUul4kN4nIebvs6m92U/aguMb9qRkAy9d+/DszJ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUiwfoYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE871606A331;
	Sat,  7 Nov 2026 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUiwfoYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C061F0089F;
	Sat,  7 Nov 2026 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063262;
	bh=24gU/KgfGj8QeJAz0ZStW064iZpc+XW34zBhP7nLStQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUiwfoYWkmRoPGPK0WmZ1NySQhJItUdrfJ00QX5vuNXptXR5qnO/KGnI8c6Jc7HnZ
	 0Jz+MKJz3W3ExPF5933bDo/DEnwH4yzK7wZq/Qv4vEJ9qDIKarIfgcYrrjGGzFI+G3
	 7GlN7XQi0QdCB+IOW57yZW0n1H7P6xpIaYGrYqkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 462/869] xhci: Prevent invalid vdev dereference during sideband unregister
Date: Sat,  7 Nov 2026 08:52:24 -0500
Message-ID: <20261107134909.338568420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit fd616dc74e8f58f351f2b295620027116cd6e92e ]

Offloaded USB audio devices using the xhci-sideband API store a pointer to
the xhci virtual device (vdev) in the sideband structure when registering.

This pointer typically remains valid throughout the lifetime of the USB
device. If a configured offloaded device requires a reset, the USB core
usually unbinds or notifies the audio driver beforehand, ensuring that the
sideband is unregistered before the vdev is freed.

An exception occurs when the USB core resets a device to recover from a
failed resume, but a subsequent 'address device' request also fails. To
recover in this specific scenario, the xHCI driver disables and re-enables
the slot, which frees and re-allocates the vdev.

xhci_sideband_unregister() later dereferences the stale, previously freed
vdev pointer during disconnect, triggering a kernel oops:

 Unable to handle kernel paging request at virtual address dead000000000122
 Call trace:
  xhci_get_ep_ctx+0x0/0x38
  xhci_sideband_unregister+0x68/0xf0
  uaudio_disconnect+0x70/0x144
  usb_audio_disconnect+0x7c/0x268
  usb_unbind_interface+0x13c/0x340
  device_release_driver_internal+0x1c4/0x2bc
  usb_disable_device+0x84/0x190
  usb_disconnect+0xe8/0x338
  hub_event+0xbd8/0x19ac

Fix this by preventing the reallocation of the vdev in this specific error
path if the device is registered for sideband use.

Just propagate the error directly to the USB core. It should either retry
enumeration or detect the disconnected device, and handle it accordingly.

Debugging this issue to the dangling vdev pointer, reporting it, testing,
and initial patch with different solution by Lianqin Hu

Reported-by: Lianqin Hu <hulianqin@vivo.com>
Closes: https://lore.kernel.org/linux-usb/TYUPR06MB6217000B59003EDF233D7246D2B22@TYUPR06MB6217.apcprd06.prod.outlook.com/
Tested-by: Lianqin Hu <hulianqin@vivo.com>
Fixes: de66754e9f80 ("xhci: sideband: add initial api to register a secondary interrupter entity")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-12-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a4fab82da76b6..b894ba988a3d9 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4435,10 +4435,13 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 		dev_warn(&udev->dev, "Device not responding to setup %s.\n", act);
 
 		mutex_unlock(&xhci->mutex);
-		ret = xhci_disable_and_free_slot(xhci, udev->slot_id);
-		if (!ret) {
-			if (xhci_alloc_dev(hcd, udev) == 1)
-				xhci_setup_addressable_virt_dev(xhci, udev);
+
+		if (!virt_dev->sideband) {
+			ret = xhci_disable_and_free_slot(xhci, udev->slot_id);
+			if (!ret) {
+				if (xhci_alloc_dev(hcd, udev) == 1)
+					xhci_setup_addressable_virt_dev(xhci, udev);
+			}
 		}
 		kfree(command->completion);
 		kfree(command);
-- 
2.53.0



