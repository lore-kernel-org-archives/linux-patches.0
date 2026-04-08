Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C547528C87C;
	Wed,  8 Apr 2026 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673343; cv=none; b=aI6olTo+X8rdpoWeW13l/+QiOL6L6XLczmOfgavh2fjBvOLMlETGe6vGiamKApKS91z7Mve6rJ61/utc3jFPA7nFsAqjmirHVYPh6UTY9Y/edKvJMjGB+dayPU0uwxOJLu7YixC1i2GjrSa4tkG1V48lXrc6wvzzCglrZURQC6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673343; c=relaxed/simple;
	bh=qCEUtC0tUhR5++ELVCVAKlkrLo8F6wQzlTXRA2Oq78o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOmnBKWStXhK/wQG/4kHEcplSzGYqmF4oGiwGWDoe5FyEzjNzC9WAmPWDfHWgICUvVnpuNmGaPIobhloqLiUiPvbKrc195AMEdwfadTzDMcIHS1FIh1Cmssw+def9nu8feyIQmlZqin8PmYYcmOsdNPRUsxVJnKQ+/UlW9HgXX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vruho8RZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vruho8RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AEFC19425;
	Wed,  8 Apr 2026 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673343;
	bh=qCEUtC0tUhR5++ELVCVAKlkrLo8F6wQzlTXRA2Oq78o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vruho8RZGQsJRL2TmtxtGzpz8NuBOdNc5GeCChwJfKyYsHd8T6JdTdWSINiB52C3Q
	 vUc6tkZN+MUMBVRy7ncRWqgsfqsTfPM3CPYiFsk0nG2apnAuaGFKNlVGeKnFBqR5lx
	 gK5waGX2+OsNoxEe1VbxoFHgrDCUNTDinAIJUGNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 196/277] gpib: lpvo_usb: fix memory leak on disconnect
Date: Wed,  8 Apr 2026 20:03:01 +0200
Message-ID: <20260408175941.183352517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5cefb52c1af6f69ea719e42788f6ec6a087eb74c upstream.

The driver iterates over the registered USB interfaces during GPIB
attach and takes a reference to their USB devices until a match is
found. These references are never released which leads to a memory leak
when devices are disconnected.

Fix the leak by dropping the unnecessary references.

Fixes: fce79512a96a ("staging: gpib: Add LPVO DIY USB GPIB driver")
Cc: stable <stable@kernel.org> # 6.13
Cc: Dave Penkler <dpenkler@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260310105127.17538-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c
+++ b/drivers/staging/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c
@@ -405,7 +405,7 @@ static int usb_gpib_attach(struct gpib_b
 		for (j = 0 ; j < MAX_DEV ; j++) {
 			if ((assigned_usb_minors & 1 << j) == 0)
 				continue;
-			udev =	usb_get_dev(interface_to_usbdev(lpvo_usb_interfaces[j]));
+			udev = interface_to_usbdev(lpvo_usb_interfaces[j]);
 			device_path = kobject_get_path(&udev->dev.kobj, GFP_KERNEL);
 			match = gpib_match_device_path(&lpvo_usb_interfaces[j]->dev,
 						       config->device_path);
@@ -420,7 +420,7 @@ static int usb_gpib_attach(struct gpib_b
 		for (j = 0 ; j < MAX_DEV ; j++) {
 			if ((assigned_usb_minors & 1 << j) == 0)
 				continue;
-			udev =	usb_get_dev(interface_to_usbdev(lpvo_usb_interfaces[j]));
+			udev = interface_to_usbdev(lpvo_usb_interfaces[j]);
 			DIA_LOG(1, "dev. %d: bus %d -> %d  dev: %d -> %d\n", j,
 				udev->bus->busnum, config->pci_bus, udev->devnum, config->pci_slot);
 			if (config->pci_bus == udev->bus->busnum &&


